Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C71190CB5
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 12:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCXLrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 07:47:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:54856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbgCXLrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 07:47:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 82BECAD5D;
        Tue, 24 Mar 2020 11:47:20 +0000 (UTC)
Subject: Re: patch "vt: fix use after free in function "vc_do_resize"" added
 to tty-testing
To:     gregkh@linuxfoundation.org, yebin10@huawei.com,
        stable@vger.kernel.org
References: <1585049515157141@kroah.com>
From:   Jiri Slaby <jslaby@suse.com>
Autocrypt: addr=jslaby@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2770bbb6-f49b-f0a4-b7ee-7615609f3724@suse.com>
Date:   Tue, 24 Mar 2020 12:47:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1585049515157141@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24. 03. 20, 12:31, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     vt: fix use after free in function "vc_do_resize"

I lost track about this one, but isn't this the patch which was
withdrawn in favor of another patch really fixing the problem?

> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-testing branch.
> 
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
> 
> The patch will be merged to the tty-next branch sometime soon,
> after it passes testing, and the merge window is open.
> 
> If you have any questions about this process, please let me know.
> 
> 
> From 313a7425f23320844169046d83d8996c98fd8b1d Mon Sep 17 00:00:00 2001
> From: Ye Bin <yebin10@huawei.com>
> Date: Mon, 2 Mar 2020 19:28:56 +0800
> Subject: vt: fix use after free in function "vc_do_resize"
> 
> Fix CVE-2020-8647 (https://nvd.nist.gov/vuln/detail/CVE-2020-8647),
> detail description about this CVE is in bugzilla
> "https://bugzilla.kernel.org/show_bug.cgi?id=206359".
> 
> error information:
> BUG: KASan: use after free in vc_do_resize+0x49e/0xb30 at addr ffff88000016b9c0
> Read of size 2 by task syz-executor.3/24164
> page:ffffea0000005ac0 count:0 mapcount:0 mapping:          (null) index:0x0
> page flags: 0xfffff00000000()
> page dumped because: kasan: bad access detected
> CPU: 0 PID: 24164 Comm: syz-executor.3 Not tainted 3.10.0-862.14.2.1.x86_64+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
> Call Trace:
>  [<ffffffffb059f309>] dump_stack+0x1e/0x20
>  [<ffffffffaf8af957>] kasan_report+0x577/0x950
>  [<ffffffffaf8ae652>] __asan_load2+0x62/0x80
>  [<ffffffffafe3728e>] vc_do_resize+0x49e/0xb30
>  [<ffffffffafe3795c>] vc_resize+0x3c/0x60
>  [<ffffffffafe1d80d>] vt_ioctl+0x16ed/0x2670
>  [<ffffffffafe0089a>] tty_ioctl+0x46a/0x1a10
>  [<ffffffffaf92db3d>] do_vfs_ioctl+0x5bd/0xc40
>  [<ffffffffaf92e2f2>] SyS_ioctl+0x132/0x170
>  [<ffffffffb05c9b1b>] system_call_fastpath+0x22/0x27
> 
> In function vc_do_resize:
> ......
> if (vc->vc_y > new_rows) {
> 	.......
> 	old_origin += first_copied_row * old_row_size;
> } else
> 	first_copied_row = 0;
> end = old_origin + old_row_size * min(old_rows, new_rows);
> ......
> while (old_origin < end) {
> 	scr_memcpyw((unsigned short *) new_origin,
> 		    (unsigned short *) old_origin, rlth);
> 	if (rrem)
> 		scr_memsetw((void *)(new_origin + rlth),
> 			    vc->vc_video_erase_char, rrem);
> 	old_origin += old_row_size;
> 	new_origin += new_row_size;
> }
> ......
> 
> We can see that before calculate variable "end" may update variable
> "old_origin" with "old_origin += first_copied_row * old_row_size",
> variable "end" is equal to "old_origin + (first_copied_row +
> min(old_rows, new_rows))* old_row_size", it's possible that
> "first_copied_row + min(old_rows, new_rows)" large than "old_rows".  So
> when call scr_memcpyw function cpoy data from origin buffer to new
> buffer in "while" loop, which "old_origin" may large than real old
> buffer end. Now, we calculate origin buffer end before update
> "old_origin" to avoid illegal memory access.
> 
> Cc: Jiri Slaby <jslaby@suse.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=206359
> Link: https://lore.kernel.org/r/20200302112856.1101-1-yebin10@huawei.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/vt/vt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index bbc26d73209a..60e60611141a 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -1231,6 +1231,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
>  	old_origin = vc->vc_origin;
>  	new_origin = (long) newscreen;
>  	new_scr_end = new_origin + new_screen_size;
> +	end = old_origin + old_row_size * min(old_rows, new_rows);
>  
>  	if (vc->vc_y > new_rows) {
>  		if (old_rows - vc->vc_y < new_rows) {
> @@ -1249,7 +1250,6 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
>  		old_origin += first_copied_row * old_row_size;
>  	} else
>  		first_copied_row = 0;
> -	end = old_origin + old_row_size * min(old_rows, new_rows);
>  
>  	vc_uniscr_copy_area(new_uniscr, new_cols, new_rows,
>  			    get_vc_uniscr(vc), rlth/2, first_copied_row,
> 


-- 
js
suse labs
