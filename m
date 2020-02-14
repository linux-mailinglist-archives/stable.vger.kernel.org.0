Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3615CF4E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 01:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBNA7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 19:59:39 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39732 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgBNA7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 19:59:38 -0500
Received: by mail-pg1-f194.google.com with SMTP id j15so4048716pgm.6;
        Thu, 13 Feb 2020 16:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KGAkAQN7UKD5cp5rcXQafG6Fvog7EeESwkHMX9lCD3o=;
        b=eOrZP//+hYGOHpRTmEPOl8lB7epeRUlIhwq1ycrWLnyaXspPa/9EkJkU19Ly11yz/f
         0qJGPxL/ZtF6MCOfqjdKumFef/5lkzsbiqhO3gQDjEGIGNHp2ZMNfHarP9lnhN9asiIY
         h52ln5EG3Z012upEl0QHRPoLL+i+QAricEuc0Ntc71Sya4Udpn52KAOL+E3bpt2mFFSm
         FrqoZpjZNak60/75Cxb5SsoNPCMelbZtbhW+XVERfCNIjK9Go+qm9ItBExtFzT0JZ2KG
         KUeQXjJVw9keQgN1KHUb07mo+p7Cgy5ptf3R0TYKxOZVrzPGzqUIWohHa0w5qVm3QIBN
         rhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KGAkAQN7UKD5cp5rcXQafG6Fvog7EeESwkHMX9lCD3o=;
        b=ZITn4oLpLS+reO26WHg1MZNrDk7vhDbolaC8X5y188UdBd1lLGn3PBwRWuYVp9EQvN
         5RdCqiWgsqBjClpwQ0N7xx5WzdZzgL+Yo6vJSts3YXvqJmovhMILanaY34r4ZOJ1Gh2A
         YgFXMvXxRztlrxdkcIdQm3Nd0pHm70IMn396Jw5C1SYm3rh0gHKxL20zpzCBnIa6TDkU
         F2gj1/3Fd/p/cFtjl3b6+j5oRhKiyF8kf1npGvCRJD5vIssw7/RYB8Kxs1CwQ4ikcId8
         9CaopwRIXdTEis1tGum1vOwYZNtFSzbz/j0Jy9aIjoFJZRFaIoULfj6fomkG8OOLOqCR
         ru0A==
X-Gm-Message-State: APjAAAVtj+up6ziy3qpAkW7XaZa3NDVQP+Re3oNXo2wNF4xHPwx/WMok
        Q68E6zzfZRIqiDfb2bki7Z0=
X-Google-Smtp-Source: APXvYqz3rzlEXrJDf7CQded5MdtkRlN2emOaI6bqFSOZS/alxtCarlY/O4U9KrjccY/Vhpg0/vBS3w==
X-Received: by 2002:a63:fc51:: with SMTP id r17mr696678pgk.292.1581641978078;
        Thu, 13 Feb 2020 16:59:38 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id z5sm4431022pfq.3.2020.02.13.16.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 16:59:37 -0800 (PST)
Date:   Thu, 13 Feb 2020 16:59:35 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Enrico Weigelt <info@metux.net>, Joe Perches <joe@perches.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nick Black <dankamongmen@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - switch T470s to RMI4 by default
Message-ID: <20200214005935.GC183709@dtor-ws>
References: <20200204194322.112638-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204194322.112638-1-lyude@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 02:43:21PM -0500, Lyude Paul wrote:
> This supports RMI4 and everything seems to work, including the touchpad
> buttons. So, let's enable this by default.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/mouse/synaptics.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 1ae6f8bba9ae..8cb8475657ca 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -169,6 +169,7 @@ static const char * const smbus_pnp_ids[] = {
>  	"LEN004a", /* W541 */
>  	"LEN005b", /* P50 */
>  	"LEN005e", /* T560 */
> +	"LEN006c", /* T470s */
>  	"LEN0071", /* T480 */
>  	"LEN0072", /* X1 Carbon Gen 5 (2017) - Elan/ALPS trackpoint */
>  	"LEN0073", /* X1 Carbon G5 (Elantech) */
> -- 
> 2.24.1
> 

-- 
Dmitry
