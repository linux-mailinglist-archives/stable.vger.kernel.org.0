Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D125107432
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 15:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVOrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 09:47:09 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39620 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVOrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 09:47:09 -0500
Received: by mail-ot1-f65.google.com with SMTP id w24so6373435otk.6;
        Fri, 22 Nov 2019 06:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9f6cq4rm9aA0SuwofQTBDnGD9GrUbHvOntsNdYUyhrU=;
        b=mcZSmqAFjwjKDSi4mVWBvta/V9bGUM5ValVi2/PmDrb7pL/amm4ZtkZsz04HmV3dmK
         5/f6CPqXghr0P/KwHB9qROg/0dGHMONisYQLXS6t+6VeKN37LBTbLQJC1nMMBsD43J/C
         RvRYhxQOplMbXNJktofUO4CtCfh5xld8+GY84MVNFTpCAGWEYlpDUYGx3TTWLk7Bvpoy
         dZujUlujcXyjCVpUH12mT9N9V/zDX8VVS581qYHh6YNu/1/c5xXdhAynMIPi92S4YVyE
         PRvSlwolaXJe4fLQ7DsQFVyuaNqFEKQYKZ8L9Tj3uaI+vkNdfJRYQCbQptrPFWnBYdf6
         A8zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9f6cq4rm9aA0SuwofQTBDnGD9GrUbHvOntsNdYUyhrU=;
        b=nlNX5uG8PozCWC1uMU1dL5E5ZHGNrBi1RVovVAWrkiTLapGZUcwh//cxIhZkaxOT/a
         WdYSfYfAv8Qhlq1hxh/fo2Kbi+PRZXxjnpx7m5gPnRiPLqRNqFQ13pf2SzoPu6JwZgae
         2yyQdc8dl0jevnNlv1qIT/b1orvqXETzOyWcCJoOAcJA711CoI6UQPsD4MCr8A9cBesj
         FjLSwcDnd29BAV5oflzNfP79dpDMQGN4FDBp4L5vk185QP9vRishRLnmcmyggpxkZbCa
         LGN2qnzk5x+6J7sBtew85LV2laxZSSeEbC5wkpfVfCcPlK3PQ/kpUhAQ5xrmR5oHYsq6
         NNWA==
X-Gm-Message-State: APjAAAXi0A42O05lQubHnONV0A5OwDIEuuAhmWa8KNbUEt5ZX3c8+hYa
        YWNWo8shwSSNJC1I8/1ahyy+ySeA
X-Google-Smtp-Source: APXvYqzdeDTNgziw7znKOU6pTk2yQBnmnotl8mQJEap648LFwAVvTYi8Ar0a69GyMQL9MKpwflwufg==
X-Received: by 2002:a05:6830:15a:: with SMTP id j26mr10751249otp.342.1574434028508;
        Fri, 22 Nov 2019 06:47:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p3sm2225091oti.22.2019.11.22.06.47.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 06:47:07 -0800 (PST)
Subject: Re: [PATCH 4.19 000/220] 4.19.86-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191122100912.732983531@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ae3d804f-594b-80f9-048b-7da45806278c@roeck-us.net>
Date:   Fri, 22 Nov 2019 06:47:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/19 2:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.86 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 

I see the following warning (at least for arm64, ppc64, and x86_64).
This seems to be caused by "idr: Fix idr_get_next race with idr_remove".
v4.14.y is also affected. Mainline and v5.3.y are not affected.

Guenter

---
[    3.897800] NetLabel: Initializing
[    3.897944] NetLabel:  domain hash size = 128
[    3.898044] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    3.898995]
[    3.899135] =============================
[    3.899235] WARNING: suspicious RCU usage
[    3.899479] 4.19.86-rc1+ #1 Not tainted
[    3.899595] -----------------------------
[    3.899772] include/linux/radix-tree.h:241 suspicious rcu_dereference_check() usage!
[    3.899939]
[    3.899939] other info that might help us debug this:
[    3.899939]
[    3.900159]
[    3.900159] rcu_scheduler_active = 2, debug_locks = 1
[    3.900347] 2 locks held by swapper/0/1:
[    3.900479]  #0: (____ptrval____) (cb_lock){+.+.}, at: genl_register_family+0xab/0x717
[    3.901498]  #1: (____ptrval____) (genl_mutex){+.+.}, at: genl_register_family+0xb9/0x717
[    3.901860]
[    3.901860] stack backtrace:
[    3.902136] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.19.86-rc1+ #1
[    3.902295] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[    3.902633] Call Trace:
[    3.902633]  dump_stack+0x71/0xa0
[    3.902633]  idr_get_next+0x133/0x160
[    3.902633]  ? genl_register_family+0xab/0x717
[    3.902633]  ? do_early_param+0x89/0x89
[    3.902633]  genl_family_find_byname+0x4e/0x80
[    3.902633]  genl_register_family+0xc1/0x717
[    3.902633]  ? do_early_param+0x89/0x89
[    3.902633]  ? netlbl_netlink_init+0x21/0x21
[    3.902633]  netlbl_netlink_init+0x5/0x21
[    3.902633]  netlbl_init+0x4a/0x74
[    3.902633]  do_one_initcall+0x58/0x2ae
[    3.902633]  ? do_early_param+0x89/0x89
[    3.902633]  ? rcu_read_lock_sched_held+0x6f/0x80
[    3.902633]  ? do_early_param+0x89/0x89
[    3.902633]  kernel_init_freeable+0x1bc/0x24b
[    3.902633]  ? rest_init+0x176/0x176
[    3.902633]  kernel_init+0x5/0x101
[    3.902633]  ret_from_fork+0x3a/0x50

