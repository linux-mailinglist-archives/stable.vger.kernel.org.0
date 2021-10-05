Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C3421C98
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhJEC3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhJEC3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:29:22 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C85C061745;
        Mon,  4 Oct 2021 19:27:32 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id o27-20020a9d411b000000b0054e0e86020aso1240336ote.0;
        Mon, 04 Oct 2021 19:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P3FFXCmHfFp9h0wRAVp3+9mJxykkHzqXsnUXXbVkLDY=;
        b=CKzjaab70WpY3Q9LyATnSqHT9vACgPCPmWDC//hSXsN4sh0E6osZF9oouQjEjCgyLb
         01jSe+YfFWT87h0ci9s/HZ+wDQW8oGc6YJi/Y4PZb3lramUCHdfnKNu/RldeTmg19F56
         v95H/k3fptDCJX1Zqq0Oji4qdSyOR4S1nXiMERNkJNDdN4QaFZH5AJdus4FydsNZwzBf
         k2/1iJIE9nlmurfqd36YjI3Pr+T9g8MNpw/lIKkb07hPnneKF0JkTwAi77WW/3ke7Qlt
         hRE7zy+XKb3qiQQzHMG4FfVNDlFPWanNHv0kOhL9jPrBOqT5eDO92jnBCpBQqksEZoiL
         m25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=P3FFXCmHfFp9h0wRAVp3+9mJxykkHzqXsnUXXbVkLDY=;
        b=rrLPLPBYJ0je0I13jHHBu1sm0cSGbZ8N9/qUQkMyZts3htD45eSusyQldzjIGi8Im8
         6Euq3y75kgaMIodbxgEEr9g/jT0foViqehdbLgHuWPK2K/Yc7O198bIaMIQCNMIQvtwW
         V2CBXdnhPx+FkLG8hEGnGz19rRlcDeiUihEPgNZrPCF2QyyDpxS8WPYROOTFlRIQ9q1+
         uxN1sBDfI5PgnFcz1d6GSsoyf6t4tsJxEzMc4Mhxdx5Ben8HGGBD9hoWlELJgOs0KisT
         wO3BFk8ceBO1YjD4z6wKidPOb3YQiqPE4WkuCzWcBDCLSpvxsePHncDKfhNoYmsKYDp6
         bkbg==
X-Gm-Message-State: AOAM531YCNKgI7IspvcuBpFSOCVLn4dWglYrZoETDqhAW43RfAo9cRNQ
        ymaHi7Yx4JIYXFV0HXxSXfU=
X-Google-Smtp-Source: ABdhPJwwgsEGLTO0eyBx42g1qm1AlVQtuxh3RZceswLcuwKqjuGi6pGVp0EEeoomYUE2TJ7cvkiFuw==
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr12653765otr.162.1633400852178;
        Mon, 04 Oct 2021 19:27:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n73sm3092362oig.20.2021.10.04.19.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:27:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:27:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
Message-ID: <20211005022730.GA1390735@roeck-us.net>
References: <20211004125044.945314266@linuxfoundation.org>
 <20211005022011.GF1388923@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005022011.GF1388923@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 07:20:13PM -0700, Guenter Roeck wrote:
> On Mon, Oct 04, 2021 at 02:50:50PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.10 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 480 pass: 480 fail: 0
> 

I spoke too early. A large number of boot tests report the following
warning tracebacks in this rc.

Guenter

====================================
WARNING: ip/134 still has locks held!
5.14.10-rc1-00173-gcda15f9c69e0 #1 Not tainted
------------------------------------
1 lock held by ip/134:
 #0: c17acf0c (sk_lock-AF_INET){+.+.}-{0:0}, at: 0xc17c561c

stack backtrace:
CPU: 0 PID: 134 Comm: ip Not tainted 5.14.10-rc1-00173-gcda15f9c69e0 #1
Call trace:
[<(ptrval)>] dump_stack+0x34/0x48
[<(ptrval)>] debug_check_no_locks_held+0xc8/0xd0
[<(ptrval)>] do_exit+0x6a8/0xc2c
[<(ptrval)>] do_group_exit+0x68/0x114
[<(ptrval)>] __wake_up_parent+0x0/0x34
[<(ptrval)>] _syscall_return+0x0/0x4

=========================
WARNING: held lock freed!
5.14.10-rc1-00173-gcda15f9c69e0 #1 Not tainted
-------------------------
ip/182 is freeing memory 9000000002400040-90000000024006bf, with a lock still held there!
9000000002400160 (sk_lock-AF_INET){+.+.}-{0:0}, at: sk_common_release+0x28/0x118
2 locks held by ip/182:
 #0: 90000000036a0280 (&sb->s_type->i_mutex_key#4){+.+.}-{3:3}, at: __sock_release+0x34/0xd8
 #1: 9000000002400160 (sk_lock-AF_INET){+.+.}-{0:0}, at: sk_common_release+0x28/0x118

stack backtrace:
CPU: 0 PID: 182 Comm: ip Not tainted 5.14.10-rc1-00173-gcda15f9c69e0 #1
Stack : 0000000000000000 0000000000000000 0000000000000008 627881c1d8d1d123
        90000000021453c0 0000000000000000 90000000026cbb58 ffffffff80f3b950
        ffffffff81088f80 0000000000000001 90000000026cb9a8 0000000000000000
        0000000000000000 0000000000000010 ffffffff8071ee00 0000000000000000
        0000000000000000 ffffffff81060000 0000000000000001 ffffffff80f3b950
        9000000002ab2940 000000001000a4e0 000000007fe10f68 ffffffffffffffff
        0000000000000000 0000000000000000 ffffffff807a51a0 0000000000052798
        ffffffff81220000 90000000026c8000 90000000026cbb50 0000000000000000
        ffffffff80c7b6f0 0000000000000000 90000000026cbc88 ffffffff8121e440
        00000000000000b6 0000000000000000 ffffffff8010b304 627881c1d8d1d123
        ...
Call Trace:
[<ffffffff8010b304>] show_stack+0x3c/0x120
[<ffffffff80c7b6f0>] dump_stack_lvl+0xa0/0xec
[<ffffffff801a8228>] debug_check_no_locks_freed+0x168/0x1a0
[<ffffffff802d679c>] kmem_cache_free.part.0+0xf4/0x2b8
[<ffffffff809eb5d0>] __sk_destruct+0x150/0x230
[<ffffffff80b22094>] inet_release+0x4c/0x88
[<ffffffff809e2744>] __sock_release+0x44/0xd8
[<ffffffff809e27ec>] sock_close+0x14/0x28
[<ffffffff802e4d84>] __fput+0xac/0x2d8
[<ffffffff80163500>] task_work_run+0x90/0xf0
[<ffffffff8010a6e8>] do_notify_resume+0x348/0x360
[<ffffffff801039e8>] work_notifysig+0x10/0x18

