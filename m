Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35255CB54
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiF0FmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 01:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiF0FmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 01:42:14 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A4726D8
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 22:42:10 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31838c41186so70630707b3.23
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 22:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6ugrU1MGXLeENUAWeA/v71NxEcqwADvXjmhMwZVOVq8=;
        b=OHHdWU/2lhPxL/k5W1dwQn2iMqr/+UvuVDchlcbajoyfFB7Ka/cgjeSp5XY68+mLWT
         0H/pvZs9BGIFGofZgdsrskUhcjkI/g5RMoeiWkEKWYXXYhHmITfqADrjgSz+yX6ObglL
         uviDshZcYc4XokwjOkjfB6LT1pka0mUc6GJR1031umZVDbYBmHdsPQ/dwjdRWWg57Bvx
         9t1Yldjww5fEwlj6W1MTaUohLurlr2Z2jjnut/2lFg2HdRYGSKV/FK3Q6TVrCBxIOw7H
         Qes3VzXMCvHdxupr5E5lvwT0XxqL54IL4B+XSmSxtCMFIQI80QqjHzJqpYQRWNTcEsx5
         AYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6ugrU1MGXLeENUAWeA/v71NxEcqwADvXjmhMwZVOVq8=;
        b=aVVlRhcgMw9tB1l+TRNgx4P6wMxJ6E9PKbvu+ID9xEwi7cwCi9R6R+eQLXzZwiw21e
         +tA+cbxdkn6lbSYr7qvvq++p78x/zrlMuwEQpJjkd0TDP/Mb0KKJchRT0VTGH3CW6UKP
         aejQ49XdpJmO9X2fK6bXSeC8FOowQlWFoyZjaG3RYRrBvM/t22AevEYPOSn3A3n4MPyT
         +xMyqJmFEIoTDIHCaSK0mdu5gZl6oWJcSMAKEo9AzWxFPVsYeO2LgVpuPNfXNUve8bIo
         03ruyLU2ZwkZ7jCTQjC838iGpD7PfffxKyjLq0bEAQYdDGfr8jf6mznxkUSEFSi3Yvg6
         cjew==
X-Gm-Message-State: AJIora/RYR5iVtAU8Nd/Gmb1fS9BQgkVE8e83hdFx2LVTiW5vH+W4pUT
        rYz5bv+GxWfU+v1/jDK/BgaTzVr4lHgT
X-Google-Smtp-Source: AGRyM1txBZUNVDIF9L2rRwBsk+bVepzTvUIy0qAiT+hxTSJnD4A1Z7vKbZz/EVc/NI2W6EFy+JZFN+Q8aJjU
X-Received: from gthelen-ubiquity2.mtv.corp.google.com ([2620:0:1000:868b:b395:8c1b:8c90:79f5])
 (user=gthelen job=sendgmr) by 2002:a5b:98c:0:b0:64a:d5c3:4422 with SMTP id
 c12-20020a5b098c000000b0064ad5c34422mr12005685ybq.638.1656308529848; Sun, 26
 Jun 2022 22:42:09 -0700 (PDT)
Date:   Sun, 26 Jun 2022 22:42:06 -0700
In-Reply-To: <6bc6ae48-b569-2002-118a-d3468b0278cd@kernel.dk>
Message-Id: <xr93czeu64sx.fsf@gthelen-ubiquity2.mtv.corp.google.com>
Mime-Version: 1.0
References: <1656164548242121@kroah.com> <xr93fsjr5901.fsf@gthelen-ubiquity2.mtv.corp.google.com>
 <ea9b3819-418a-5b79-8bcd-0b28ead70a61@kernel.dk> <6bc6ae48-b569-2002-118a-d3468b0278cd@kernel.dk>
Subject: Re: Linux 5.10.125
From:   Greg Thelen <gthelen@google.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jens Axboe <axboe@kernel.dk> wrote:

> On 6/26/22 6:04 PM, Jens Axboe wrote:
>> On 6/26/22 4:56 PM, Greg Thelen wrote:
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>
>>>> I'm announcing the release of the 5.10.125 kernel.
>>>>
>>>> All users of the 5.10 kernel series must upgrade.
>>>>
>>>> The updated 5.10.y git tree can be found at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
>>>> and can be browsed at the normal kernel.org git web browser:
>>>> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> ------------
>>>>
>>>>  Makefile                              |    2 
>>>>  arch/arm64/mm/cache.S                 |    2 
>>>>  arch/s390/mm/pgtable.c                |    2 
>>>>  drivers/tty/serial/serial_core.c      |   34 ++++--------
>>>>  drivers/usb/gadget/function/u_ether.c |   11 +++-
>>>>  fs/io_uring.c                         |   23 +++++---
>>>>  fs/zonefs/super.c                     |   92 ++++++++++++++++++++++------------
>>>>  net/ipv4/inet_hashtables.c            |   31 ++++++++---
>>>>  8 files changed, 122 insertions(+), 75 deletions(-)
>>>>
>>>> Christian Borntraeger (1):
>>>>       s390/mm: use non-quiescing sske for KVM switch to keyed guest
>>>>
>>>> Damien Le Moal (1):
>>>>       zonefs: fix zonefs_iomap_begin() for reads
>>>>
>>>> Eric Dumazet (1):
>>>>       tcp: add some entropy in __inet_hash_connect()
>>>>
>>>> Greg Kroah-Hartman (1):
>>>>       Linux 5.10.125
>>>>
>>>> Jens Axboe (1):
>>>>       io_uring: add missing item types for various requests
>>>>
>>>> Lukas Wunner (1):
>>>>       serial: core: Initialize rs485 RTS polarity already on probe
>>>>
>>>> Marian Postevca (1):
>>>>       usb: gadget: u_ether: fix regression in setting fixed MAC address
>>>>
>>>> Will Deacon (1):
>>>>       arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer
>>>>
>>>> Willy Tarreau (5):
>>>>       tcp: use different parts of the port_offset for index and offset
>>>>       tcp: add small random increments to the source port
>>>>       tcp: dynamically allocate the perturb table used by source ports
>>>>       tcp: increase source port perturb table to 2^16
>>>>       tcp: drop the hash_32() part from the index calculation
>>>
>>> 5.10.125 commit df3f3bb5059d20ef094d6b2f0256c4bf4127a859 ("io_uring: add
>>> missing item types for various requests") causes panic when running
>>> test/iopoll.t from https://github.com/axboe/liburing commit
>>> dda4848a9911120a903bef6284fb88286f4464c9 (liburing-2.2).
>>>
>>> Here's a manually annotated panic message:
>>> [  359.047161] list_del corruption, ffffa42098824f80->next is LIST_POISON1 (dead000000000100)
>>> [  359.055393] kernel BUG at lib/list_debug.c:47!
>>> [  359.059786] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
>>> [  359.065463] CPU: 11 PID: 15862 Comm: iopoll.t Tainted: G S        I       5.10.124 #1
>>> [  359.081804] RIP: 0010:__list_del_entry_valid+0x49/0x80
>>> [  359.086880] Code: c2 22 48 39 d1 74 25 48 8b 11 48 39 f2 75 2d 48 8b 50 08 48 39 f2 75 34 b0 01 5d c3 48 c7 c7 68 15 79 b1 31 c0 e8 c5 a2 5a 00 <0f> 0b 48 c7 c7 d8 8e 76 b1 31 c0 e8 b5 a2 5a 00 0f 0b 48 c7 c7 69
>>> [  359.105431] RSP: 0018:ffffb6b66785bd58 EFLAGS: 00010046
>>> [  359.110592] RAX: 000000000000004e RBX: ffffa42098824f00 RCX: d07284ea1fbba400
>>> [  359.117642] RDX: ffffa43f7f4f05b8 RSI: ffffa43f7f4dff48 RDI: ffffa43f7f4dff48
>>> [  359.124691] RBP: ffffb6b66785bd58 R08: 0000000000000000 R09: ffffffffb1f38540
>>> [  359.131740] R10: 00000000ffff7fff R11: 0000000000000000 R12: 0000000000000282
>>> [  359.138789] R13: ffffb6b66785beb8 R14: ffffa42095d33e00 R15: ffffa420937e3d20
>>> [  359.145836] FS:  00000000004f8380(0000) GS:ffffa43f7f4c0000(0000) knlGS:0000000000000000
>>> [  359.153830] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  359.159506] CR2: 0000000000539388 CR3: 000000027b57c006 CR4: 00000000003706e0
>>> [  359.166552] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [  359.173600] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> [  359.180647] Call Trace:
>>> [  359.183064]  io_dismantle_req+0x1da/0x2b0
>>>                     __list_del_entry [include/linux/list.h:132]
>>>                     list_del [include/linux/list.h:146]
>>>                     io_req_drop_files [fs/io_uring.c:5934]
>>>                     io_req_clean_work [fs/io_uring.c:1315]
>>>                     io_dismantle_req [fs/io_uring.c:1911]
>>> [  359.187023]  io_do_iopoll+0x4e5/0x790
>>> [  359.194602]  __se_sys_io_uring_enter+0x39b/0x6f0
>>> [  359.208318]  __x64_sys_io_uring_enter+0x29/0x30
>>> [  359.212793]  do_syscall_64+0x31/0x40
>>> [  359.216324]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> 
>> Well that sucks, I wonder why mine didn't fail like that. I'll see if I
>> can hit this and send a fix. Thanks for reporting!
>
> Below should do it, I apologize for that. I think my test box booted the
> previous kernel which is why it didn't hit it in my regression tests :-(
>
> Greg, can you add this to 5.10-stable? Verified it ran tests with the
> right kernel now...
>
>
> commit d2aaf8fdc544a3edf44820a07294d693dedd12e3
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sun Jun 26 18:16:17 2022 -0600
>
>     io_uring: use separate list entry for iopoll requests
>     
>     A previous commit ended up enabling file tracking for iopoll requests,
>     which conflicts with both of them using the same list entry for tracking.
>     Add a separate list entry just for iopoll requests, avoid this issue.
>     
>     No upstream commit exists for this issue.
>     
>     Reported-by: Greg Thelen <gthelen@google.com>
>     Fixes: df3f3bb5059d ("io_uring: add missing item types for various requests")
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>

Confirmed. This patch fixes the error I saw.

Tested-by: Greg Thelen <gthelen@google.com>

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 40ac37beca47..2e12dcbc7b0f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -696,6 +696,8 @@ struct io_kiocb {
>  	 */
>  	struct list_head		inflight_entry;
>  
> +	struct list_head		iopoll_entry;
> +
>  	struct percpu_ref		*fixed_file_refs;
>  	struct callback_head		task_work;
>  	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
> @@ -2350,8 +2352,8 @@ static void io_iopoll_queue(struct list_head *again)
>  	struct io_kiocb *req;
>  
>  	do {
> -		req = list_first_entry(again, struct io_kiocb, inflight_entry);
> -		list_del(&req->inflight_entry);
> +		req = list_first_entry(again, struct io_kiocb, iopoll_entry);
> +		list_del(&req->iopoll_entry);
>  		__io_complete_rw(req, -EAGAIN, 0, NULL);
>  	} while (!list_empty(again));
>  }
> @@ -2373,14 +2375,14 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  	while (!list_empty(done)) {
>  		int cflags = 0;
>  
> -		req = list_first_entry(done, struct io_kiocb, inflight_entry);
> +		req = list_first_entry(done, struct io_kiocb, iopoll_entry);
>  		if (READ_ONCE(req->result) == -EAGAIN) {
>  			req->result = 0;
>  			req->iopoll_completed = 0;
> -			list_move_tail(&req->inflight_entry, &again);
> +			list_move_tail(&req->iopoll_entry, &again);
>  			continue;
>  		}
> -		list_del(&req->inflight_entry);
> +		list_del(&req->iopoll_entry);
>  
>  		if (req->flags & REQ_F_BUFFER_SELECTED)
>  			cflags = io_put_rw_kbuf(req);
> @@ -2416,7 +2418,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  	spin = !ctx->poll_multi_file && *nr_events < min;
>  
>  	ret = 0;
> -	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
> +	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_entry) {
>  		struct kiocb *kiocb = &req->rw.kiocb;
>  
>  		/*
> @@ -2425,7 +2427,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  		 * and complete those lists first, if we have entries there.
>  		 */
>  		if (READ_ONCE(req->iopoll_completed)) {
> -			list_move_tail(&req->inflight_entry, &done);
> +			list_move_tail(&req->iopoll_entry, &done);
>  			continue;
>  		}
>  		if (!list_empty(&done))
> @@ -2437,7 +2439,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  
>  		/* iopoll may have completed current req */
>  		if (READ_ONCE(req->iopoll_completed))
> -			list_move_tail(&req->inflight_entry, &done);
> +			list_move_tail(&req->iopoll_entry, &done);
>  
>  		if (ret && spin)
>  			spin = false;
> @@ -2670,7 +2672,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>  		struct io_kiocb *list_req;
>  
>  		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
> -						inflight_entry);
> +						iopoll_entry);
>  		if (list_req->file != req->file)
>  			ctx->poll_multi_file = true;
>  	}
> @@ -2680,9 +2682,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>  	 * it to the front so we find it first.
>  	 */
>  	if (READ_ONCE(req->iopoll_completed))
> -		list_add(&req->inflight_entry, &ctx->iopoll_list);
> +		list_add(&req->iopoll_entry, &ctx->iopoll_list);
>  	else
> -		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
> +		list_add_tail(&req->iopoll_entry, &ctx->iopoll_list);
>  
>  	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
>  	    wq_has_sleeper(&ctx->sq_data->wait))
