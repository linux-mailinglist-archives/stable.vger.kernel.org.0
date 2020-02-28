Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7FA173167
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 07:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgB1Gyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 01:54:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45585 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgB1Gyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 01:54:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id v2so1630912wrp.12;
        Thu, 27 Feb 2020 22:54:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wG/x88u5BQhePySdycUg+x0l7CGaf+KQvLzv9rANuoM=;
        b=WJeg6ajdmXrdoao/ghHRZ7E2wHtBl2KOD6C0Q5gijSnwb6C2pKbnyG+CFaxOwy8gvk
         DS57MEfubHzCKe+8g1+p2FY5kONPj2dAL5cVJM1Vkp0L+/Nhj4fRnMXJ0FYhjQfwXRnb
         WZxCE30ZRbktRaw4l3SwCdDDXnbE7+zN97+80bGpOUnr2Yb9r3CRSFNnmXginM9ZXHBd
         sAyJOcIN5LyJsBodAndOhtA6IcW17YSItF3FZXRyeu+X5V5yQPweTPK/ooLLkV1YOXDR
         tLmDU5QKGs9RG9Q0/wx86Yo1yRIaFUseKTR59LxGdvEO4n82xdSgolBw+GRb/riI3lZl
         sdGg==
X-Gm-Message-State: APjAAAUlQN+DZ4PvBMtYkub5kCezwizOz2t5EHH5F5ODK2Ub4u9Ejr6J
        nqGwoUIlctJtlepJmaBdzFI=
X-Google-Smtp-Source: APXvYqzIN5ewls06gBATX43ziU8c+oq1g8e6xdp6lOxAs8O+lte8jdACEVOVBCXRXReOmSfxXRn2zg==
X-Received: by 2002:a5d:69d1:: with SMTP id s17mr3239004wrw.339.1582872877928;
        Thu, 27 Feb 2020 22:54:37 -0800 (PST)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id a5sm804137wmb.37.2020.02.27.22.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 22:54:37 -0800 (PST)
Subject: Re: [PATCH 5.5 027/150] vt: selection, close sel_buffer race
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+59997e8d5cbdc486e6f6@syzkaller.appspotmail.com
References: <20200227132232.815448360@linuxfoundation.org>
 <20200227132236.840520753@linuxfoundation.org>
From:   Jiri Slaby <jslaby@suse.cz>
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a9f43287-d504-170b-4444-503e4b0d59d5@suse.cz>
Date:   Fri, 28 Feb 2020 07:54:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200227132236.840520753@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27. 02. 20, 14:36, Greg Kroah-Hartman wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> 
> commit 07e6124a1a46b4b5a9b3cacc0c306b50da87abf5 upstream.
> 
> syzkaller reported this UAF:

With this patch, syzkaller reports possible circular locking dependency:
https://lore.kernel.org/lkml/000000000000be57bf059f8aa7b9@google.com/

Could you drop the patch from stable until this is resolved?

> BUG: KASAN: use-after-free in n_tty_receive_buf_common+0x2481/0x2940 drivers/tty/n_tty.c:1741
> Read of size 1 at addr ffff8880089e40e9 by task syz-executor.1/13184
> 
> CPU: 0 PID: 13184 Comm: syz-executor.1 Not tainted 5.4.7 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> Call Trace:
> ...
>  kasan_report+0xe/0x20 mm/kasan/common.c:634
>  n_tty_receive_buf_common+0x2481/0x2940 drivers/tty/n_tty.c:1741
>  tty_ldisc_receive_buf+0xac/0x190 drivers/tty/tty_buffer.c:461
>  paste_selection+0x297/0x400 drivers/tty/vt/selection.c:372
>  tioclinux+0x20d/0x4e0 drivers/tty/vt/vt.c:3044
>  vt_ioctl+0x1bcf/0x28d0 drivers/tty/vt/vt_ioctl.c:364
>  tty_ioctl+0x525/0x15a0 drivers/tty/tty_io.c:2657
>  vfs_ioctl fs/ioctl.c:47 [inline]
> 
> It is due to a race between parallel paste_selection (TIOCL_PASTESEL)
> and set_selection_user (TIOCL_SETSEL) invocations. One uses sel_buffer,
> while the other frees it and reallocates a new one for another
> selection. Add a mutex to close this race.
> 
> The mutex takes care properly of sel_buffer and sel_buffer_lth only. The
> other selection global variables (like sel_start, sel_end, and sel_cons)
> are protected only in set_selection_user. The other functions need quite
> some more work to close the races of the variables there. This is going
> to happen later.
> 
> This likely fixes (I am unsure as there is no reproducer provided) bug
> 206361 too. It was marked as CVE-2020-8648.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: syzbot+59997e8d5cbdc486e6f6@syzkaller.appspotmail.com
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20200210081131.23572-2-jslaby@suse.cz
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/tty/vt/selection.c |   23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> --- a/drivers/tty/vt/selection.c
> +++ b/drivers/tty/vt/selection.c
> @@ -16,6 +16,7 @@
>  #include <linux/tty.h>
>  #include <linux/sched.h>
>  #include <linux/mm.h>
> +#include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  
> @@ -45,6 +46,7 @@ static volatile int sel_start = -1; 	/*
>  static int sel_end;
>  static int sel_buffer_lth;
>  static char *sel_buffer;
> +static DEFINE_MUTEX(sel_lock);
>  
>  /* clear_selection, highlight and highlight_pointer can be called
>     from interrupt (via scrollback/front) */
> @@ -186,7 +188,7 @@ int set_selection_kernel(struct tiocl_se
>  	char *bp, *obp;
>  	int i, ps, pe, multiplier;
>  	u32 c;
> -	int mode;
> +	int mode, ret = 0;
>  
>  	poke_blanked_console();
>  
> @@ -212,6 +214,7 @@ int set_selection_kernel(struct tiocl_se
>  	if (ps > pe)	/* make sel_start <= sel_end */
>  		swap(ps, pe);
>  
> +	mutex_lock(&sel_lock);
>  	if (sel_cons != vc_cons[fg_console].d) {
>  		clear_selection();
>  		sel_cons = vc_cons[fg_console].d;
> @@ -257,9 +260,10 @@ int set_selection_kernel(struct tiocl_se
>  			break;
>  		case TIOCL_SELPOINTER:
>  			highlight_pointer(pe);
> -			return 0;
> +			goto unlock;
>  		default:
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto unlock;
>  	}
>  
>  	/* remove the pointer */
> @@ -281,7 +285,7 @@ int set_selection_kernel(struct tiocl_se
>  	else if (new_sel_start == sel_start)
>  	{
>  		if (new_sel_end == sel_end)	/* no action required */
> -			return 0;
> +			goto unlock;
>  		else if (new_sel_end > sel_end)	/* extend to right */
>  			highlight(sel_end + 2, new_sel_end);
>  		else				/* contract from right */
> @@ -309,7 +313,8 @@ int set_selection_kernel(struct tiocl_se
>  	if (!bp) {
>  		printk(KERN_WARNING "selection: kmalloc() failed\n");
>  		clear_selection();
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto unlock;
>  	}
>  	kfree(sel_buffer);
>  	sel_buffer = bp;
> @@ -334,7 +339,9 @@ int set_selection_kernel(struct tiocl_se
>  		}
>  	}
>  	sel_buffer_lth = bp - sel_buffer;
> -	return 0;
> +unlock:
> +	mutex_unlock(&sel_lock);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(set_selection_kernel);
>  
> @@ -364,6 +371,7 @@ int paste_selection(struct tty_struct *t
>  	tty_buffer_lock_exclusive(&vc->port);
>  
>  	add_wait_queue(&vc->paste_wait, &wait);
> +	mutex_lock(&sel_lock);
>  	while (sel_buffer && sel_buffer_lth > pasted) {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		if (signal_pending(current)) {
> @@ -371,7 +379,9 @@ int paste_selection(struct tty_struct *t
>  			break;
>  		}
>  		if (tty_throttled(tty)) {
> +			mutex_unlock(&sel_lock);
>  			schedule();
> +			mutex_lock(&sel_lock);
>  			continue;
>  		}
>  		__set_current_state(TASK_RUNNING);
> @@ -380,6 +390,7 @@ int paste_selection(struct tty_struct *t
>  					      count);
>  		pasted += count;
>  	}
> +	mutex_unlock(&sel_lock);
>  	remove_wait_queue(&vc->paste_wait, &wait);
>  	__set_current_state(TASK_RUNNING);
>  
> 
> 


-- 
js
suse labs
