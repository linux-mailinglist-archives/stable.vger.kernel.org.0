Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45254B757
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiFNRIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344573AbiFNRIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 13:08:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27981E3C2;
        Tue, 14 Jun 2022 10:08:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d13so8236304plh.13;
        Tue, 14 Jun 2022 10:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+q7XcfbO1YaiBI/d8Kqr7/LKDZW7QMBxm3U4FZYXHjk=;
        b=Hw8OSpfI+zfSlRpu92/tqX91tiDAt5Z/DAux2P2IbFiPcTQMGQafDPxjOj21ZzDGT2
         M/0IUSaltLZYeHLXg2wA4ku4quOKLIrr04ZIeRHJQk60oVKy8RSSf87XRdOi/JhLBVHl
         xEYpbWR+F0s8kjH7yGl8HAsFZQmubO80c8u6X1xyNLfNTg6FEZWBf+75v/zOUG9ZV73l
         CLdRrZQj5KaSJN4vN21p3RTvrs/ukFDZS9wFaJFD9ntmpQIQS/xg/OxBCEV2vB5PoGtp
         y9eoGotTWjoVzVNjdB7+1Refcf/hY3148gJeFNbwA34g6Kl6SK9CaQaAgByksU6oJFWD
         2Anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+q7XcfbO1YaiBI/d8Kqr7/LKDZW7QMBxm3U4FZYXHjk=;
        b=Ek79uDHWNpxJOavz8GqlTcL5g2yhSMiY/u8u6AzUGlai5Vbt4sXjHn6MDWP+6/6GOo
         ZaRt68fhi84z6SNWObewj8Wiys0J6+/8+c+198rSa1CdkOJ+/Hx5HpkxlGFFBFzsxkqi
         bWqe7Lm/49cbI/UjhtBUhVlsqY1oKMjTACCRzJ38BTagUUU1qX+7MqUU9pEnaqvIQaNv
         03p+lJF6RHDhuYtw7n1T52hcoj461/dswSN0ikkASSxGuzKu5EhCTyJxA88CG51ZnlLw
         Ei0buHVV3C4Bs8L4CxClQBDgK1v9cIyT3vNzJw5bAluyMEmZpySAcmUw0mye9phqmZXW
         KD6g==
X-Gm-Message-State: AJIora+3YT0/ygREmiphSymm6ygj9pLW1ZgLuvrramzYbjlkkaHrEqfn
        fWPDyhqwGMPPsdFi5aEDigw2W7tk02Q=
X-Google-Smtp-Source: AGRyM1sikbzEB3DipDCwsFSyK5HE8rrCNQRFue2XDD3nyL+25IKAAGHv3PYuoqrPnlg+evOvj1mNDA==
X-Received: by 2002:a17:90b:38d1:b0:1e8:70ed:1a47 with SMTP id nn17-20020a17090b38d100b001e870ed1a47mr5680807pjb.168.1655226509077;
        Tue, 14 Jun 2022 10:08:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 17-20020a17090a005100b001e87ae821f8sm7662173pjb.36.2022.06.14.10.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 10:08:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Jun 2022 10:08:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220614170827.GB3690098@roeck-us.net>
References: <20220613181847.216528857@linuxfoundation.org>
 <20220614153607.GB3088490@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614153607.GB3088490@roeck-us.net>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 08:36:08AM -0700, Guenter Roeck wrote:
> On Mon, Jun 13, 2022 at 08:19:49PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.47 release.
> > There are 251 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 488 pass: 488 fail: 0
> 

I spoke a bit too early. I see the following backtrace in some qemu arm
boot tests.

BUG: spinlock bad magic on CPU#0, kdevtmpfs/15
 lock: noop_backing_dev_info+0x6c/0x3b0, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 0 PID: 15 Comm: kdevtmpfs Not tainted 5.15.47-rc2-00252-g677f0128d0ed #1
Hardware name: ARM RealView Machine (Device Tree Support)
[<c01101d0>] (unwind_backtrace) from [<c010bc0c>] (show_stack+0x10/0x14)
[<c010bc0c>] (show_stack) from [<c0a10ae4>] (dump_stack_lvl+0x68/0x90)
[<c0a10ae4>] (dump_stack_lvl) from [<c0191250>] (do_raw_spin_lock+0xbc/0x124)
[<c0191250>] (do_raw_spin_lock) from [<c02eb578>] (__mark_inode_dirty+0x1cc/0x704)
[<c02eb578>] (__mark_inode_dirty) from [<c02e6a74>] (simple_setattr+0x44/0x5c)
[<c02e6a74>] (simple_setattr) from [<c02d7a18>] (notify_change+0x400/0x45c)
[<c02d7a18>] (notify_change) from [<c0a19ef8>] (devtmpfsd+0x1f8/0x2b8)
[<c0a19ef8>] (devtmpfsd) from [<c014cf3c>] (kthread+0x150/0x17c)
[<c014cf3c>] (kthread) from [<c0100120>] (ret_from_fork+0x14/0x34)
Exception stack(0xd00dbfb0 to 0xd00dbff8)
bfa0:                                     00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000

This bisects to commit bc5d960d4e58 ("writeback: Fix inode->i_io_list not
be protected by inode->i_lock error"). The problem is also seen in the
mainline kernel. v5.15.y.queue and later are affected. Reverting the patch
here and in mainline fixes the problem.

Guenter
