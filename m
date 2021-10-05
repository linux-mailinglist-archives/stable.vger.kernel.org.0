Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFF422D2C
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhJEQBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJEQBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 12:01:03 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA41C061749;
        Tue,  5 Oct 2021 08:59:12 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id w206so26865205oiw.4;
        Tue, 05 Oct 2021 08:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GbrEqZ7dyz9hPPuoORW7wfM8IXr96v7NOPqUopADLMk=;
        b=UrblCc0EKPnQim0RHW2SPcr71rNsvtmAthLVD9URnnG7XMtk64O0moOE80S5LHsSN/
         eAlS2R2SjajcFn3hL+lhNHonmkZJQ7TRffwcWMMhgOgTQ1JrEUYKAvxEmGgrLK/cA+vV
         sfhJKGez6p9sDhiUVAn+FsmzJkCg2y2JuGR2iXYEr/FJOYWWrGZAWtMa1yTIeWqWl9ri
         3QzRtM5//joyo/WFX19oamwA4nInlr0tDQFYBXf3nkGB/JCKGMyIcktgwweyzGjeBIpI
         tz/QlMaNgNO/yZ8cJ1UOaklgb0+XFCv7WJBd9GMQHyq44uJDQ7T2gTC4+U0jwPTLtJCI
         k4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GbrEqZ7dyz9hPPuoORW7wfM8IXr96v7NOPqUopADLMk=;
        b=0XWEH9EZ6LyCgbJ0bSHJniqUdR+y3O59kyrlrUd3TrMWrpbZHk27wtV1RmjgLjpuqK
         T8YfBy5Oyd10OnMOERLOXjwY1XWj417fcMasYNjW5s0Gw05xXWurM70LCsm7jun3eBCB
         vsKuu5+eMYX5XDNQgGI91/nA6cquqaKeCiK7PAUFlMHudn5rmttRATe8Z2W+VcB9LkHJ
         hcyhTo8zwgpxDkGxzBlmuNkkMX1Z7QFdYWqtWamJzcMKvPjMFA+9qXutE2QPGXMJzudW
         JbTgA60oWZdDEhnWlni56u4AlIKf1cyrWLb8ZsnC6S36Lfq9yEssAbdYn6VIbsD6WEe8
         MmZA==
X-Gm-Message-State: AOAM533dX1Ly6fuDyKgyPBiA4DTSK7QA49NiyzJ512JUwekxvibFaZ9g
        wR96JhmnfU2aEFnTcw5fzjY=
X-Google-Smtp-Source: ABdhPJy/PWWd/G7HAacNqWJFVsN2zYiOXMBmZEY1I4QEKAmZDFyGiZM3/SdQxHV9JRlIAiu5J9X9DA==
X-Received: by 2002:a54:4f82:: with SMTP id g2mr3023204oiy.134.1633449551825;
        Tue, 05 Oct 2021 08:59:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u25sm3477807oof.48.2021.10.05.08.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 08:59:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 5 Oct 2021 08:59:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
Message-ID: <20211005155909.GA1386975@roeck-us.net>
References: <20211005083311.830861640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083311.830861640@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:38:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

AFAICS the warning problems are still seen. Unfortunately I won't be able
to bisect since I have limited internet access.

Guenter

=========================
WARNING: held lock freed!
5.14.10-rc2-00174-g355f3195d051 #1 Not tainted
-------------------------
ip/202 is freeing memory c000000009918900-c000000009918f7f, with a lock still held there!
c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
2 locks held by ip/202:
 #0: c00000000ae149d0 (&sb->s_type->i_mutex_key#5){+.+.}-{3:3}, at: .__sock_release+0x4c/0x150
 #1: c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0

stack backtrace:
CPU: 0 PID: 202 Comm: ip Not tainted 5.14.10-rc2-00174-g355f3195d051 #1
Call Trace:
[c000000009e27600] [c0000000008ddda8] .dump_stack_lvl+0xa4/0x100 (unreliable)
[c000000009e27690] [c000000000179b74] .debug_check_no_locks_freed+0x194/0x1b0
[c000000009e27730] [c0000000003b20e4] .kmem_cache_free+0x274/0x630
[c000000009e27800] [c000000000d04dcc] .__sk_destruct+0x18c/0x2c0
[c000000009e27890] [c000000000e67410] .udp_lib_close+0x10/0x30
[c000000009e27900] [c000000000e81628] .inet_release+0x68/0xb0
[c000000009e27980] [c000000000cf7a20] .__sock_release+0x70/0x150
[c000000009e27a10] [c000000000cf7b28] .sock_close+0x28/0x40
[c000000009e27a90] [c0000000003dbb74] .__fput+0xc4/0x310
[c000000009e27b30] [c000000000116604] .task_work_run+0xc4/0x130
[c000000009e27bd0] [c00000000001ba04] .do_notify_resume+0x414/0x4e0
[c000000009e27ce0] [c00000000002b0f4] .interrupt_exit_user_prepare_main+0x254/0x2d0
[c000000009e27d90] [c00000000002b4f4] .syscall_exit_prepare+0x74/0x120
[c000000009e27e10] [c00000000000c258] system_call_common+0xf8/0x250
--- interrupt: c00 at 0x3fff811c618c
NIP:  00003fff811c618c LR: 0000000010039e7c CTR: 0000000000000000
REGS: c000000009e27e80 TRAP: 0c00   Not tainted  (5.14.10-rc2-00174-g355f3195d051)
MSR:  800000000000f032 <SF,EE,PR,FP,ME,IR,DR,RI>  CR: 22000882  XER: 00000000
IRQMASK: 0
GPR00: 0000000000000006 00003fffcc4b33f0 00003fff812bf300 0000000000000000
GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000000000000 00003fff81335810 00000000101025a8 0000000000000000
GPR16: 0000000000000000 00003ffffcbd1e20 00000000100cbb46 00000000100cbb4e
GPR20: 00000000100c9139 00000000100cbadb 0000000000000000 0000000000000000
GPR24: ffffffffffffffff ffffffffffffffff ffffffffffffffff 00003fffcc4b3f7a
GPR28: 0000000000000000 0000000000000001 0000000000000009 0000000000000003
NIP [00003fff811c618c] 0x3fff811c618c
LR [0000000010039e7c] 0x10039e7c

