Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4038BD7D
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 06:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhEUEk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 00:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbhEUEk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 00:40:58 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75080C061574;
        Thu, 20 May 2021 21:39:35 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m190so13323026pga.2;
        Thu, 20 May 2021 21:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WMlfn7jCWC8uSlnjdUmlRN+3U2RJWHOMYptYT8aMe8s=;
        b=vFltrxqHPSlifCxKqNQd4J9ckpdmU6CvxQc+0KZA7guDwur/K2OMIL/b1VtWtprmdn
         foH46K1+2RwPXi36Ev/+AUtKKAndQVRT+ZNlu9mDq7T32gFTI8c5tjrAbsvNCiRUXkjg
         xVYWM4AmmnqWpAZqBmn5xUhZNRuXohrTa7UmFfPKyGaAt9m7aAREExXOj9C0hbP1LtJZ
         KlzwHfkhDBKMqB5W0E/XWFroWLwzzO4y3Te6HcTY3U1V3rgua+1aQJzA5/4SQ031jSmd
         r5LIqRIbrMdzPtJYKGFtHsAmq2dpvUqeBGsnjjzZP3T3Jmah4hv4tJuAXhENFxE0bny0
         1w5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WMlfn7jCWC8uSlnjdUmlRN+3U2RJWHOMYptYT8aMe8s=;
        b=iyyq8qCgw6mNXLUUFB3c4z7xwq4V+P1NswbXUjuKIRg3iwQoS94cyDAoiy6VG7prRI
         sdNav7vBbfiIX8nkt9c7iwcHs2DtYrEexqPI7w+9vxrEWRrCIrDEdqBpDChexdbK49EO
         9iKeVtWLMrRDgX3D40OFwVVunoHyOULL9AcPq+/NUQGZ3r45z3O3dWOjBcVyHQCBko8q
         mncp3LSLF2J9besu7/H5AyTphqkMuYAP7PgYAwmilhSWV6zMDKhXcCMe81CxoHrSvsxU
         /H5bf4ClbZ/HIdF+QxAvMqXazpXFRvlxOj825+BGRJSpps/ZaLm/ChaOUWb3OvZv+AEG
         rjJw==
X-Gm-Message-State: AOAM530m7GR1fuh2OdfeUZx9OCH5pru34rw3y+wgcpsLyMk973MocZ53
        usp4oL5fM331hR5YF5wyawn//cxqOW0=
X-Google-Smtp-Source: ABdhPJw8ASuiQXs+PfwCh82sPMwGttzC8Ll5KGjRsuKwloF5dxXQbB66WJOjuDgFkZvMFh8w4U6Neg==
X-Received: by 2002:a62:d083:0:b029:2e3:c8be:14b1 with SMTP id p125-20020a62d0830000b02902e3c8be14b1mr4838246pfg.41.1621571974416;
        Thu, 20 May 2021 21:39:34 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj21sm7565114pjb.49.2021.05.20.21.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 21:39:33 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210520092052.265851579@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0a9f8458-60a4-e87a-04cb-ed2840d15bbf@gmail.com>
Date:   Thu, 20 May 2021 21:39:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/20/2021 2:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Was not able to bisect yet since the nightly tests were running but one
of our boards caught the following running an ARM 32-bit kernel. The
same board did not reproduce that warning a second time around, I will
keep an eye on it. Other than that, everything went well.

There are no change to RCU, scheduler or kthreads but we do make SMC
calls for SCMI (power management) so my guess would be that "ARM:
9075/1: kernel: Fix interrupted SMC calls" would trigger that. We have
15 other boards that run the same configuration but did not catch that.

# sleep 5
[   16.864190] bcmgenet 47d580000.ethernet eth0: Link is Up - 1Gbps/Full
- flow control off
[   17.568981] ------------[ cut here ]------------
[   17.573669] WARNING: CPU: 0 PID: 10 at kernel/kthread.c:75
kthread_is_per_cpu+0x4c/0x50
[   17.581669] Modules linked in:
[   17.584726] CPU: 0 PID: 10 Comm: rcu_sched Not tainted
5.4.121-1.1pre-g5cdf7521a963 #2
[   17.592638] Hardware name: Broadcom STB (Flattened Device Tree)
[   17.598553] Backtrace:
[   17.601014] [<c0bf79f0>] (dump_backtrace) from [<c0bf7c90>]
(show_stack+0x20/0x24)
[   17.608581]  r7:0000004b r6:600b0093 r5:00000000 r4:c20a99d0
[   17.614244] [<c0bf7c70>] (show_stack) from [<c0c04f48>]
(dump_stack+0x9c/0xb0)
[   17.621477] [<c0c04eac>] (dump_stack) from [<c0224b58>]
(__warn+0xe0/0x108)
[   17.628432]  r7:0000004b r6:00000009 r5:c0248f64 r4:c0f429cc
[   17.634087] [<c0224a78>] (__warn) from [<c0bf83b8>]
(warn_slowpath_fmt+0x70/0xc0)
[   17.641564]  r7:0000004b r6:c0f429cc r5:c2004c88 r4:00000000
[   17.647219] [<c0bf834c>] (warn_slowpath_fmt) from [<c0248f64>]
(kthread_is_per_cpu+0x4c/0x50)
[   17.655739]  r9:00000000 r8:ceff4200 r7:ceff4200 r6:d05dca5c
r5:d05dc480 r4:ceff4200
[   17.663485] [<c0248f18>] (kthread_is_per_cpu) from [<c0259a34>]
(can_migrate_task+0x1ec/0x24c)
[   17.672091]  r5:d05dc480 r4:ced25d14
[   17.675661] [<c0259848>] (can_migrate_task) from [<c025e820>]
(load_balance+0x394/0xa64)
[   17.683747]  r10:d05dc480 r9:00000000 r8:d05dca5c r7:ceff4200
r6:d05dca5c r5:d05dc480
[   17.691571]  r4:ceff4298 r3:00000200
[   17.695140] [<c025e48c>] (load_balance) from [<c025fa60>]
(newidle_balance+0x214/0x508)
[   17.703140]  r10:d05a3b50 r9:17309672 r8:00000000 r7:c2004cf8
r6:fffbb4a9 r5:d05a3480
[   17.710963]  r4:cee6d100
[   17.713491] [<c025f84c>] (newidle_balance) from [<c025fdc0>]
(pick_next_task_fair+0x30/0x338)
[   17.722011]  r10:c0e02774 r9:ced25e54 r8:d059c440 r7:c1f3f480
r6:ced03600 r5:ced25e54
[   17.729834]  r4:d05a3480
[   17.732364] [<c025fd90>] (pick_next_task_fair) from [<c0c08e20>]
(__schedule+0x120/0x5f8)
[   17.740537]  r7:c1f3f480 r6:c0e027d4 r5:ced03600 r4:d05a3480
[   17.746190] [<c0c08d00>] (__schedule) from [<c0c09350>]
(schedule+0x58/0xd4)
[   17.753233]  r10:fffbb0c1 r9:d059c440 r8:d059c440 r7:ced25eac
r6:c2003d00 r5:ced03600
[   17.761057]  r4:ffffe000
[   17.763586] [<c0c092f8>] (schedule) from [<c0c0d77c>]
(schedule_timeout+0x194/0x3a0)
[   17.771323]  r5:c2004c88 r4:fffbb0c4
[   17.774901] [<c0c0d5e8>] (schedule_timeout) from [<c0297de4>]
(rcu_gp_kthread+0x650/0x1300)
[   17.783247]  r10:c2015900 r9:c2015c64 r8:00000005 r7:c2003d00
r6:c2015a40 r5:00000000
[   17.791071]  r4:00000003
[   17.793598] [<c0297794>] (rcu_gp_kthread) from [<c0248890>]
(kthread+0x170/0x174)
[   17.801075]  r7:ced24000
[   17.803606] [<c0248720>] (kthread) from [<c02010d8>]
(ret_from_fork+0x14/0x3c)
[   17.810823] Exception stack(0xced25fb0 to 0xced25ff8)
[   17.815868] 5fa0:                                     00000000
00000000 00000000 00000000
[   17.824042] 5fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   17.832214] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   17.838822]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
r6:00000000 r5:c0248720
[   17.846646]  r4:cece8980
[   17.849171] ---[ end trace ccac79dc167b02d7 ]---
# ping -c 2 192.168.1.254
PING 192.168.1.254 (192.168.1.254): 56 data bytes
64 bytes from 192.168.1.254: seq=0 ttl=64 time=0.636 ms
64 bytes from 192.168.1.254: seq=1 ttl=64 time=0.310 ms

-- 
Florian
