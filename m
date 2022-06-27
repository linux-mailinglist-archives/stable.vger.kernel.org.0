Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E055B48D
	for <lists+stable@lfdr.de>; Mon, 27 Jun 2022 02:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiF0AEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jun 2022 20:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiF0AEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jun 2022 20:04:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EC22BC4
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 17:04:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id k14so6728835plh.4
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 17:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6JULXCbJoBht9KmD5lTvCvsKCigckFdBsjqJiarx+Gs=;
        b=UFQnsrvdhet4IupZ3K+DNFEG2q71nd4aSKNYWfC0JRXKij1U4KDIBRoTf5gMyLRpQM
         zAvuc7sMI19kLiZ+GBGKhXNCFlkuvhIm0RUEE65HXOT3YRgtKxvtK4ktvTkyS9gNVsI6
         Ert8nVDzbxJHaavqaBFJuqdRkN5E5kytywLWhk3tZPeiNjBco3r5aIk1sThMpNZddQHz
         XvL3VAPQgTJ9usnRMeafpY1kmmhtmh/xW1HH82ifWutTcLIO36Jj8NIzJmaR6lAJJ5vh
         9YOAXrNO3zxvB3a8b4GzPY9LvJoD3poRz+0GHoquFO+j5EqMlqNX8MZb20mTdVp1zkFp
         AQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6JULXCbJoBht9KmD5lTvCvsKCigckFdBsjqJiarx+Gs=;
        b=DvBd66di3rqaG4PJhok+wbx84/ZwWxictwsfMJVZYwGPb6C1uBLJlGo3eLVSsM1PV6
         MO/zFIgkPZJeyT+KRfrM/3D4ebqyWL8vDjmHy5s6L9dobkrr/zbFDmZZoXbTIIgCSFL5
         +ogx6IXEBdjaL13AhXvWloJDkhPum9849n+KjnvEDp2vkeS3sAXaYYsajBnp8/nCer7H
         uMEhZRgVX4ORwTt+6J5CYqfjnwTEN5PVRh5Qncxwb91lRGW8cSB2TspkniLRzc8TvvtN
         VnJeWEdqb/M206Nq04m/b7AFfifpM6S2Ob32gs2YxAjBcew0NGCnnKV+75s3NplstTHv
         gIsg==
X-Gm-Message-State: AJIora/rwLInabhlovF84hGFNMAyTgryBZN1IRvRcJG8aqbykaB2di1D
        AJa8/3X1GbzfTF7hwfLX2gUxHw==
X-Google-Smtp-Source: AGRyM1uLcwlBqXn4TfbTsIjo2+PKQcgGixV7Ln0RZmtCBBdlLJ7hc1c5yAF/7OgcrtWPoPuz/XPLwg==
X-Received: by 2002:a17:90b:380c:b0:1ed:2071:e6b with SMTP id mq12-20020a17090b380c00b001ed20710e6bmr12464689pjb.82.1656288251695;
        Sun, 26 Jun 2022 17:04:11 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902d58500b0016a1096bc95sm5741255plh.12.2022.06.26.17.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 17:04:11 -0700 (PDT)
Message-ID: <ea9b3819-418a-5b79-8bcd-0b28ead70a61@kernel.dk>
Date:   Sun, 26 Jun 2022 18:04:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Linux 5.10.125
Content-Language: en-US
To:     Greg Thelen <gthelen@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
References: <1656164548242121@kroah.com>
 <xr93fsjr5901.fsf@gthelen-ubiquity2.mtv.corp.google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <xr93fsjr5901.fsf@gthelen-ubiquity2.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/26/22 4:56 PM, Greg Thelen wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
>> I'm announcing the release of the 5.10.125 kernel.
>>
>> All users of the 5.10 kernel series must upgrade.
>>
>> The updated 5.10.y git tree can be found at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
>> and can be browsed at the normal kernel.org git web browser:
>> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------
>>
>>  Makefile                              |    2 
>>  arch/arm64/mm/cache.S                 |    2 
>>  arch/s390/mm/pgtable.c                |    2 
>>  drivers/tty/serial/serial_core.c      |   34 ++++--------
>>  drivers/usb/gadget/function/u_ether.c |   11 +++-
>>  fs/io_uring.c                         |   23 +++++---
>>  fs/zonefs/super.c                     |   92 ++++++++++++++++++++++------------
>>  net/ipv4/inet_hashtables.c            |   31 ++++++++---
>>  8 files changed, 122 insertions(+), 75 deletions(-)
>>
>> Christian Borntraeger (1):
>>       s390/mm: use non-quiescing sske for KVM switch to keyed guest
>>
>> Damien Le Moal (1):
>>       zonefs: fix zonefs_iomap_begin() for reads
>>
>> Eric Dumazet (1):
>>       tcp: add some entropy in __inet_hash_connect()
>>
>> Greg Kroah-Hartman (1):
>>       Linux 5.10.125
>>
>> Jens Axboe (1):
>>       io_uring: add missing item types for various requests
>>
>> Lukas Wunner (1):
>>       serial: core: Initialize rs485 RTS polarity already on probe
>>
>> Marian Postevca (1):
>>       usb: gadget: u_ether: fix regression in setting fixed MAC address
>>
>> Will Deacon (1):
>>       arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer
>>
>> Willy Tarreau (5):
>>       tcp: use different parts of the port_offset for index and offset
>>       tcp: add small random increments to the source port
>>       tcp: dynamically allocate the perturb table used by source ports
>>       tcp: increase source port perturb table to 2^16
>>       tcp: drop the hash_32() part from the index calculation
> 
> 5.10.125 commit df3f3bb5059d20ef094d6b2f0256c4bf4127a859 ("io_uring: add
> missing item types for various requests") causes panic when running
> test/iopoll.t from https://github.com/axboe/liburing commit
> dda4848a9911120a903bef6284fb88286f4464c9 (liburing-2.2).
> 
> Here's a manually annotated panic message:
> [  359.047161] list_del corruption, ffffa42098824f80->next is LIST_POISON1 (dead000000000100)
> [  359.055393] kernel BUG at lib/list_debug.c:47!
> [  359.059786] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
> [  359.065463] CPU: 11 PID: 15862 Comm: iopoll.t Tainted: G S        I       5.10.124 #1
> [  359.081804] RIP: 0010:__list_del_entry_valid+0x49/0x80
> [  359.086880] Code: c2 22 48 39 d1 74 25 48 8b 11 48 39 f2 75 2d 48 8b 50 08 48 39 f2 75 34 b0 01 5d c3 48 c7 c7 68 15 79 b1 31 c0 e8 c5 a2 5a 00 <0f> 0b 48 c7 c7 d8 8e 76 b1 31 c0 e8 b5 a2 5a 00 0f 0b 48 c7 c7 69
> [  359.105431] RSP: 0018:ffffb6b66785bd58 EFLAGS: 00010046
> [  359.110592] RAX: 000000000000004e RBX: ffffa42098824f00 RCX: d07284ea1fbba400
> [  359.117642] RDX: ffffa43f7f4f05b8 RSI: ffffa43f7f4dff48 RDI: ffffa43f7f4dff48
> [  359.124691] RBP: ffffb6b66785bd58 R08: 0000000000000000 R09: ffffffffb1f38540
> [  359.131740] R10: 00000000ffff7fff R11: 0000000000000000 R12: 0000000000000282
> [  359.138789] R13: ffffb6b66785beb8 R14: ffffa42095d33e00 R15: ffffa420937e3d20
> [  359.145836] FS:  00000000004f8380(0000) GS:ffffa43f7f4c0000(0000) knlGS:0000000000000000
> [  359.153830] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  359.159506] CR2: 0000000000539388 CR3: 000000027b57c006 CR4: 00000000003706e0
> [  359.166552] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  359.173600] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  359.180647] Call Trace:
> [  359.183064]  io_dismantle_req+0x1da/0x2b0
>                     __list_del_entry [include/linux/list.h:132]
>                     list_del [include/linux/list.h:146]
>                     io_req_drop_files [fs/io_uring.c:5934]
>                     io_req_clean_work [fs/io_uring.c:1315]
>                     io_dismantle_req [fs/io_uring.c:1911]
> [  359.187023]  io_do_iopoll+0x4e5/0x790
> [  359.194602]  __se_sys_io_uring_enter+0x39b/0x6f0
> [  359.208318]  __x64_sys_io_uring_enter+0x29/0x30
> [  359.212793]  do_syscall_64+0x31/0x40
> [  359.216324]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Well that sucks, I wonder why mine didn't fail like that. I'll see if I
can hit this and send a fix. Thanks for reporting!

-- 
Jens Axboe

