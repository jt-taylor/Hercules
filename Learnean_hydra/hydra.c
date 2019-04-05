/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   hydra.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jtaylor <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/03/09 11:56:34 by jtaylor           #+#    #+#             */
/*   Updated: 2019/03/09 18:12:05 by jtaylor          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "hydra.h"

/*
** INFO :
** 			use nc 0.0.0.0 port_number to test if it works
** 			so basically how it works is we grab the port we wantfrom argc
** 				then we make a socket that looks at that port
** 				then we check if it read ping in a loop;
** 		set settings in the struct ;
** 	bind = bind the struct to a specific port;
** 	listen = tells the socket to listen for data ;
** 	accept = accept a connection to the client socket ; where data is read from;
*/

static inline void	norm_is_lame(int s_fd, int c_fd, char str[100])
{
	bzero(str, 100);
	read(c_fd, str, 100);
	if (!strncmp("ping", str, 4))
		write(c_fd, "pong pong\n", 10);
	else if (!strncmp("exit", str, 4))
	{
		write(1, "exited the socket", 30);
		close(s_fd);
		exit(1);
	}
}

int					main(int ac, char **argv)
{
	char				str[100];
	int					s_fd;
	int					c_fd;
	struct sockaddr_in	s_server_addr;
	int					port_number;

	if (ac != 2 || (ac == 2 && (atoi(argv[1]) < 0 || atoi(argv[1]) > 65535)))
	{
		fprintf(stderr, "Please Use a Valid port-number (1024 - 65535) .\n");
		return (-1);
	}
	port_number = atoi(argv[1]);
	if ((s_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
		return (-1);
	bzero(&s_server_addr, sizeof(s_server_addr));
	s_server_addr.sin_family = AF_INET;
	s_server_addr.sin_addr.s_addr = htons(INADDR_ANY);
	s_server_addr.sin_port = htons(port_number);
	bind(s_fd, (struct sockaddr *)&s_server_addr, sizeof(s_server_addr));
	listen(s_fd, 10);
	c_fd = accept(s_fd, (struct sockaddr*)NULL, NULL);
	while (1)
		norm_is_lame(s_fd, c_fd, str);
	return (0);
}
