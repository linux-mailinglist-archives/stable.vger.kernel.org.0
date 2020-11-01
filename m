Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78B2A1E5F
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 14:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgKANqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 08:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgKANqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 08:46:36 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EC4C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 05:46:36 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id mp12so1896500pjb.2
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 05:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DpExKsVfe4Rca7TDneQ/HWOXtZxfnwjNgWRcGDD9OJA=;
        b=IeAdQ6XLHJz+pgiInFYgoPTwPAq9Mi4cWizdnVrmX8ICVSLDEiIETvM2lZXckDQOW2
         /08g61Y05Zume4jrxX2JpYycCmyEc5Ji1itygsW5OWZ5M5u1az2Bh2VitsqOGBpDJQbg
         nFZE6ZLIIirz3Hjqk16cJ0H5zEyKLKnEcbAIS5M6FvX3LereIn9k200AGSalDqLZ9Dcy
         VCsq819yCw2xf3WBuR9cc5X79cZGKDVzt+9/yrPYJOGfM5YxLa9GB0g3+EDCHyQ6q+mh
         iuW7rwVGaFZgJFTTNlajIX/thay4IzHrDDEmaTdbbe/AVmOgapdNKbcLaem7MsVNw+Vu
         CskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DpExKsVfe4Rca7TDneQ/HWOXtZxfnwjNgWRcGDD9OJA=;
        b=lVdrwO64t4kyzGqf983v5hj/cmTYmYOCNeuladhk3dMvXGdNiDysParHKJpf6xmoYd
         RxwflkCf/6bb5N4ro5W8IAvUzxbp96ggar0DMQuUa6ho0rKHbgPpyya5XFtQvLXFkXJ9
         SfMFSIZeoXaCj8MUzorFaQ5jB9othmbbqdJf7/ttgWV4bAYZ0VrBpr/bRdXw9JQv7iU1
         p3UdDWA9ZR+xhtMbaGSBnMw0/fhBwCDREI4xH3e8jxumAzykoDq1Np5ad6Sbk9ii419W
         LLx10RzmhHHqWqzEuttueaWEBQadbJmMLxMSlS66MELpMDx9J89xGC58tfss6PmXCqxF
         ehKw==
X-Gm-Message-State: AOAM533ymQERvd/XFGTLGcZg9JnuhuUOgFBRWQN+szYETUioe8LA+vwi
        tLFGjlrwyjs3qFRVPNp4haPhhg==
X-Google-Smtp-Source: ABdhPJxVrYR31/vnQ3O5h3ZeOFbmuheGC49G+prvd6Af2S4h1VFmUE+CuwfOn0SNn1RTYa5eEvKxTA==
X-Received: by 2002:a17:902:bf43:b029:d6:8b99:3ca2 with SMTP id u3-20020a170902bf43b02900d68b993ca2mr15582608pls.43.1604238395736;
        Sun, 01 Nov 2020 05:46:35 -0800 (PST)
Received: from debian ([122.164.203.196])
        by smtp.gmail.com with ESMTPSA id b6sm8886017pjq.42.2020.11.01.05.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 05:46:35 -0800 (PST)
Message-ID: <f6a12a75822cfc71d495d29dab1eab8fa1e4e3bb.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Date:   Sun, 01 Nov 2020 19:16:30 +0530
In-Reply-To: <20201101104121.GB2689688@kroah.com>
References: <20201031113500.031279088@linuxfoundation.org>
         <ca2501e512973270c6b7b7cc05c7f50791541a66.camel@rajagiritech.edu.in>
         <20201101104121.GB2689688@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-11-01 at 11:41 +0100, Greg Kroah-Hartman wrote:
> On Sat, Oct 31, 2020 at 10:41:38PM +0530, Jeffrin Jose T wrote:
> > On Sat, 2020-10-31 at 12:35 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.9.3
> > > release.
> > > There are 74 patches in this series, all will be posted as a
> > > response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > > 
> > > Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	
> > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.3-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > > stable-rc.git linux-5.9.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > hello,
> > i have build using ktest. but then i did the normal compile.
> > compiled and booted 5.9.3-rc1+ . dmesg -l err is clear.
> > 
> > some lines from dmesg output related  
> > ----------x------------------x---------------------------x---
> > video: module verification failed: signature and/or required key
> > missing - tainting kernel
> > sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
> > --------x-------------------------------x-----------------x---
> > 
> > 
> > Now something related to kernel build and install..
> > ----------x---------------------x--------------------------x-------
> > WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version
> > generation failed, symbol will not be versioned.
> > W: Possible missing firmware /lib/firmware/i915/rkl_dmc_ver2_01.bin
> > for
> > module i915
> > -------------x-------------------x-------------------------x-------
> > --
> > 
> > Now one thing during boot..
> > -----------x------------x---- 
> > unable to start nftables
> > -x-----------------------x---
> > 
> > iam attaching a file....please see...
> 
> Is this any different from 5.9.2?
according to dmesg,things are to  an extent ok.

the other stuff may be because of my system upgradation
and may be there is a change in kernel configuration

Overall i think there may be nothing serious in kernel space.

.

-- 
software engineer
rajagiri school of engineering and technology - autonomous

