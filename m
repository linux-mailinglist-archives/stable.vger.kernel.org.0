Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B3028B27
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 22:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfEWT7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:59:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33785 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfEWT7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 15:59:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id g21so3189045plq.0;
        Thu, 23 May 2019 12:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FXeIpaG8QnYlsSvuBQzheROLRc/6og0gZQUNXCzHPnk=;
        b=Qq/CotHfAPTLaqNYoNEM5nBi1kWmhBbet+h8+zbYI46Ur6+z78dgVzQhii8rnPUhN8
         W2GOA0p+4iYAScMo723GXFTwetRwemzSpBZuVs8DZjnkCLQJGV0MADAvmP93MoJFJ0mn
         tCU+MZ1f0GGj8P3uIYzQuI0CSIRrllM/iqgjF7KhbLybinPua8ZZk1eJRT3p693fUrfG
         dw3u89Lmhl0A9pCqotCXB4Qf5R5l+gmobgqyGKQKRL+nsxbDXhVUvvBde1sFStbv0dym
         YOWHz00RiedElnYrPhFNukcf+IL9lrFW58RGB23cqXQL9yJHoy00X7zRAQjs5NVWnzSm
         QnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FXeIpaG8QnYlsSvuBQzheROLRc/6og0gZQUNXCzHPnk=;
        b=TmbRK16zaUaoIToH1laetDQHKBPKDZEy/ZCbEbf4+zG2MJZ5VJNZOFCkFQGDwcCeCG
         VzRymEc4+BoEtWDOHMAjf83743c+W/qvZYTxbaM5VN3gY2FrdhvdUFSGiHcePnNeWBJb
         Qs6tFBEt593xFDn5XwqsGrhk4Ufk4WGp1z8CtRJOp3kAFBB4Fyowl3VFs6BXJmAuJYK5
         tcOgt4qZaxT4OmhIKnsTHcsw859OtI4c6M+/oy7vYglLW7W6RV/1WsPgSxA29xLYvcz+
         r4MWrcFtB/POF3azS6SqyKzeyqE5aoQlqP6zm6dVDUbD0scnqyTMbIUEKUC4MSQ3Hq9Z
         DTFg==
X-Gm-Message-State: APjAAAU8LCVF611VXPTIskYX7bgY3NKNBTmBsp3wEkvekv3DUkXMut+j
        TZuH9rP8AQ5ySTjwXXoEZoE=
X-Google-Smtp-Source: APXvYqxdnt94P55UH/jYCSg1yplsBpHn60EwfHrpsiXriEm/8u63ix04lQplJk5iK8HBMK6U1zd7nA==
X-Received: by 2002:a17:902:4283:: with SMTP id h3mr78509603pld.214.1558641554938;
        Thu, 23 May 2019 12:59:14 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id x16sm260695pff.30.2019.05.23.12.59.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 12:59:14 -0700 (PDT)
Date:   Thu, 23 May 2019 12:59:12 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-input@vger.kernel.org,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: uinput - add compat ioctl number translation for
 UI_*_FF_UPLOAD
Message-ID: <20190523195912.GB176265@dtor-ws>
References: <20190522013922.25538-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522013922.25538-1-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 06:39:22PM -0700, Andrey Smirnov wrote:
> In the case of compat syscall ioctl numbers for UI_BEGIN_FF_UPLOAD and
> UI_END_FF_UPLOAD need to be adjusted before being passed on
> uinput_ioctl_handler() since code built with -m32 will be passing
> slightly different values. Extend the code already covering
> UI_SET_PHYS to cover UI_BEGIN_FF_UPLOAD and UI_END_FF_UPLOAD as well.
> 
> Reported-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/misc/uinput.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 1a6762fc38f9..1116d4cd5695 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -1051,13 +1051,24 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  
>  #ifdef CONFIG_COMPAT
>  
> -#define UI_SET_PHYS_COMPAT	_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
> +#define UI_SET_PHYS_COMPAT		_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
> +#define UI_BEGIN_FF_UPLOAD_COMPAT	_IOWR(UINPUT_IOCTL_BASE, 200, struct uinput_ff_upload_compat)
> +#define UI_END_FF_UPLOAD_COMPAT		_IOW(UINPUT_IOCTL_BASE, 201, struct uinput_ff_upload_compat)
>  
>  static long uinput_compat_ioctl(struct file *file,
>  				unsigned int cmd, unsigned long arg)
>  {
> -	if (cmd == UI_SET_PHYS_COMPAT)
> +	switch (cmd) {
> +	case UI_SET_PHYS_COMPAT:
>  		cmd = UI_SET_PHYS;
> +		break;
> +	case UI_BEGIN_FF_UPLOAD_COMPAT:
> +		cmd = UI_BEGIN_FF_UPLOAD;
> +		break;
> +	case UI_END_FF_UPLOAD_COMPAT:
> +		cmd = UI_END_FF_UPLOAD;
> +		break;
> +	}
>  
>  	return uinput_ioctl_handler(file, cmd, arg, compat_ptr(arg));
>  }
> -- 
> 2.21.0
> 

-- 
Dmitry
