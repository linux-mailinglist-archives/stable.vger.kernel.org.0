Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF12948CD6
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfFQSpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:45:47 -0400
Received: from [195.159.176.226] ([195.159.176.226]:39728 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfFQSpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 14:45:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <glks-stable4@m.gmane.org>)
        id 1hcwdS-000qPG-U9
        for stable@vger.kernel.org; Mon, 17 Jun 2019 20:45:42 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     stable@vger.kernel.org
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Subject: Re: Linux 5.1.11
Date:   Mon, 17 Jun 2019 20:45:36 +0200
Message-ID: <qe8n4h$649b$1@blaine.gmane.org>
References: <20190617180944.GA16975@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
Openpgp: preference=signencrypt
Autocrypt: addr=francoisvalenduc@gmail.com; keydata=
 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
In-Reply-To: <20190617180944.GA16975@kroah.com>
Content-Language: fr-moderne
Cc:     linux-kernel@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 17/06/19 à 20:09, Greg KH a écrit :
> I'm announcing the release of the 5.1.11 kernel.
> 
> All users of the 5.1 kernel series must upgrade.
> 
> The updated 5.1.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.1.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
>  Documentation/networking/ip-sysctl.txt |    8 ++++++++
>  Makefile                               |    2 +-
>  include/linux/tcp.h                    |    4 ++++
>  include/net/netns/ipv4.h               |    1 +
>  include/net/tcp.h                      |    2 ++
>  include/uapi/linux/snmp.h              |    1 +
>  net/ipv4/proc.c                        |    1 +
>  net/ipv4/sysctl_net_ipv4.c             |   11 +++++++++++
>  net/ipv4/tcp.c                         |    1 +
>  net/ipv4/tcp_input.c                   |   26 ++++++++++++++++++++------
>  net/ipv4/tcp_ipv4.c                    |    1 +
>  net/ipv4/tcp_output.c                  |   10 +++++++---
>  net/ipv4/tcp_timer.c                   |    1 +
>  13 files changed, 59 insertions(+), 10 deletions(-)
> 
> Eric Dumazet (4):
>       tcp: limit payload size of sacked skbs
>       tcp: tcp_fragment() should apply sane memory limits
>       tcp: add tcp_min_snd_mss sysctl
>       tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
> 
> Greg Kroah-Hartman (1):
>       Linux 5.1.11
> 

It seems a bit strange, it contains only 4 patches, and there was no
review or I didn't find it. Is this some kind of urgent bugfix release ?

François Valenduc

