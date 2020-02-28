Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB1172F94
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgB1D50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:57:26 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:52781 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730586AbgB1D50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 22:57:26 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id EB9B0182CED34;
        Fri, 28 Feb 2020 03:57:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:69:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1801:2393:2525:2561:2564:2682:2685:2691:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4049:4118:4321:4605:4823:5007:6119:7514:7576:7808:7903:8556:8957:9025:10004:10848:11026:11232:11473:11658:11914:12043:12294:12296:12297:12438:12555:12740:12760:12895:12986:13255:13439:13846:14659:21080:21433:21451:21611:21627:21939:21990:30046:30054:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: flock42_234bed6bf4754
X-Filterd-Recvd-Size: 7374
Received: from XPS-9350 (unknown [172.58.38.199])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri, 28 Feb 2020 03:57:22 +0000 (UTC)
Message-ID: <11c17de7c525997ddddab995223828bdec8e8e93.camel@perches.com>
Subject: Re: [PATCH 4.14 111/237] tty: synclinkmp: Adjust indentation in
 several functions
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Thu, 27 Feb 2020 19:55:49 -0800
In-Reply-To: <20200227132305.054909944@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
         <20200227132305.054909944@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-27 at 14:35 +0100, Greg Kroah-Hartman wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>

I believe these sorts of whitespace only changes should
not be applied to a stable branch unless it's useful for
porting other actual defect fixes.

> [ Upstream commit 1feedf61e7265128244f6993f23421f33dd93dbc ]
> 
> Clang warns:
> 
> ../drivers/tty/synclinkmp.c:1456:3: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>         if (C_CRTSCTS(tty)) {
>         ^
> ../drivers/tty/synclinkmp.c:1453:2: note: previous statement is here
>         if (I_IXOFF(tty))
>         ^
> ../drivers/tty/synclinkmp.c:2473:8: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>                                                 info->port.tty->hw_stopped = 0;
>                                                 ^
> ../drivers/tty/synclinkmp.c:2471:7: note: previous statement is here
>                                                 if ( debug_level >= DEBUG_LEVEL_ISR )
>                                                 ^
> ../drivers/tty/synclinkmp.c:2482:8: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>                                                 info->port.tty->hw_stopped = 1;
>                                                 ^
> ../drivers/tty/synclinkmp.c:2480:7: note: previous statement is here
>                                                 if ( debug_level >= DEBUG_LEVEL_ISR )
>                                                 ^
> ../drivers/tty/synclinkmp.c:2809:3: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>         if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
>         ^
> ../drivers/tty/synclinkmp.c:2807:2: note: previous statement is here
>         if (I_INPCK(info->port.tty))
>         ^
> ../drivers/tty/synclinkmp.c:3246:3: warning: misleading indentation;
> statement is not part of the previous 'else' [-Wmisleading-indentation]
>         set_signals(info);
>         ^
> ../drivers/tty/synclinkmp.c:3244:2: note: previous statement is here
>         else
>         ^
> 5 warnings generated.
> 
> The indentation on these lines is not at all consistent, tabs and spaces
> are mixed together. Convert to just using tabs to be consistent with the
> Linux kernel coding style and eliminate these warnings from clang.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/823
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://lore.kernel.org/r/20191218024720.3528-1-natechancellor@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/synclinkmp.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
> index 4fed9e7b281f0..3c9e314406b4e 100644
> --- a/drivers/tty/synclinkmp.c
> +++ b/drivers/tty/synclinkmp.c
> @@ -1467,10 +1467,10 @@ static void throttle(struct tty_struct * tty)
>  	if (I_IXOFF(tty))
>  		send_xchar(tty, STOP_CHAR(tty));
>  
> - 	if (C_CRTSCTS(tty)) {
> +	if (C_CRTSCTS(tty)) {
>  		spin_lock_irqsave(&info->lock,flags);
>  		info->serial_signals &= ~SerialSignal_RTS;
> -	 	set_signals(info);
> +		set_signals(info);
>  		spin_unlock_irqrestore(&info->lock,flags);
>  	}
>  }
> @@ -1496,10 +1496,10 @@ static void unthrottle(struct tty_struct * tty)
>  			send_xchar(tty, START_CHAR(tty));
>  	}
>  
> - 	if (C_CRTSCTS(tty)) {
> +	if (C_CRTSCTS(tty)) {
>  		spin_lock_irqsave(&info->lock,flags);
>  		info->serial_signals |= SerialSignal_RTS;
> -	 	set_signals(info);
> +		set_signals(info);
>  		spin_unlock_irqrestore(&info->lock,flags);
>  	}
>  }
> @@ -2484,7 +2484,7 @@ static void isr_io_pin( SLMP_INFO *info, u16 status )
>  					if (status & SerialSignal_CTS) {
>  						if ( debug_level >= DEBUG_LEVEL_ISR )
>  							printk("CTS tx start...");
> -			 			info->port.tty->hw_stopped = 0;
> +						info->port.tty->hw_stopped = 0;
>  						tx_start(info);
>  						info->pending_bh |= BH_TRANSMIT;
>  						return;
> @@ -2493,7 +2493,7 @@ static void isr_io_pin( SLMP_INFO *info, u16 status )
>  					if (!(status & SerialSignal_CTS)) {
>  						if ( debug_level >= DEBUG_LEVEL_ISR )
>  							printk("CTS tx stop...");
> -			 			info->port.tty->hw_stopped = 1;
> +						info->port.tty->hw_stopped = 1;
>  						tx_stop(info);
>  					}
>  				}
> @@ -2820,8 +2820,8 @@ static void change_params(SLMP_INFO *info)
>  	info->read_status_mask2 = OVRN;
>  	if (I_INPCK(info->port.tty))
>  		info->read_status_mask2 |= PE | FRME;
> - 	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
> - 		info->read_status_mask1 |= BRKD;
> +	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
> +		info->read_status_mask1 |= BRKD;
>  	if (I_IGNPAR(info->port.tty))
>  		info->ignore_status_mask2 |= PE | FRME;
>  	if (I_IGNBRK(info->port.tty)) {
> @@ -3191,7 +3191,7 @@ static int tiocmget(struct tty_struct *tty)
>   	unsigned long flags;
>  
>  	spin_lock_irqsave(&info->lock,flags);
> - 	get_signals(info);
> +	get_signals(info);
>  	spin_unlock_irqrestore(&info->lock,flags);
>  
>  	result = ((info->serial_signals & SerialSignal_RTS) ? TIOCM_RTS : 0) |
> @@ -3229,7 +3229,7 @@ static int tiocmset(struct tty_struct *tty,
>  		info->serial_signals &= ~SerialSignal_DTR;
>  
>  	spin_lock_irqsave(&info->lock,flags);
> - 	set_signals(info);
> +	set_signals(info);
>  	spin_unlock_irqrestore(&info->lock,flags);
>  
>  	return 0;
> @@ -3241,7 +3241,7 @@ static int carrier_raised(struct tty_port *port)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&info->lock,flags);
> - 	get_signals(info);
> +	get_signals(info);
>  	spin_unlock_irqrestore(&info->lock,flags);
>  
>  	return (info->serial_signals & SerialSignal_DCD) ? 1 : 0;
> @@ -3257,7 +3257,7 @@ static void dtr_rts(struct tty_port *port, int on)
>  		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
>  	else
>  		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
> - 	set_signals(info);
> +	set_signals(info);
>  	spin_unlock_irqrestore(&info->lock,flags);
>  }
>  

