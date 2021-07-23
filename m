Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EC3D39D1
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhGWLQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbhGWLQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 07:16:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912F0C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 04:56:36 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id j2so538333edp.11
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 04:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CDKN2PTgoW3cqOVTQinhUhevH8jQpimum69eKmuOyZE=;
        b=iAmox1aVJQekzSPAs88nKjkSnxgBy6akxTvGpFIKEbXco4cprL4oU5hlbsk+4dGbtl
         76wYuy0crDrnfbXvqay7SYy2sQiDuuu3eVgDd+3hZYRcqXoVViBCsV6rKTC4mIUXchHv
         DwKaIKQeqkl+lH1rUQERUH/VEkTmXcnqesagQG/PlaWE4uYSVvMRMm85k7eeOr4oM3aM
         /Qtws+PLFrSEp2LuG8wQA4p3GVewthS4/RjgjqIEgwGxd9nrCH9Laq7Ld3GImJ1ZxzjW
         jcKSFruM7gnWpRidNa4wRurQlXaEwLHhZuhQkXzgKId0I4hBGWt6K4e2inpHeGvPWmKv
         z9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CDKN2PTgoW3cqOVTQinhUhevH8jQpimum69eKmuOyZE=;
        b=aZklAgJD8EetkB7eq/MkJ0kXvg9bjsOO22HouITPc7OSbPUyb4EOL3ECgVTNInp/ML
         dA4+STSdtC8Pb9rAzX/3DAjz+Z6WMLzaPF9pAO46fyYGUN7WeUGuuGyY/k9Hq7Mo1Jdp
         s8i+Jj49BSVR67MaeVvmsJ3zE4s6eC4LKOGwCUVe09zHJ+1cXyZe1Lnmu4ISJBOnKgI1
         vTpuCSoTkD8MWEy1gqg3dESCyv1/QZUCpcL5WWFEhQ4s1kk2gR16VtPeOGemBPuysnnf
         qWsdeNoEwxKN2GYcq8W/jv582WeSvnKgG1dSEaOSV4EskpF1mppOK2AWeLgGoxTD+Fbk
         2gKA==
X-Gm-Message-State: AOAM53176kVoc0+JMTOnHMonnGyZBS9TseRTrwYGpLwZ/ZqcvnT4Yq9K
        KQQ25NlSmz805G1bW1JiNLQIhvOoRelEMdF7myoang==
X-Google-Smtp-Source: ABdhPJzzQ6+RW6yQhz9LvWTHKmr0utRjVepk24WHjmXjGl+g58+5osezLr07TkgyJJX4pwHFZWxX9OKoxFsUEhgsfog=
X-Received: by 2002:aa7:cc83:: with SMTP id p3mr1200209edt.365.1627041394312;
 Fri, 23 Jul 2021 04:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210722155628.371356843@linuxfoundation.org>
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Jul 2021 17:26:22 +0530
Message-ID: <CA+G9fYt_9nfDcQzKm8SZtmQXzzrybutS9vD4GgUw_0o8UD1HOQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/156] 5.13.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, LTP List <ltp@lists.linux.it>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 at 22:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.5 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following error is due to SATA drive format failing with arm64 64k-page
size ( CONFIG_ARM64_64K_PAGES=y ) kernel.
while running LTP syscalls test suite on running 5.13.3 and 5.13.5-rc1 kernel.

First it was noticed on the stable-rc 5.13.3-rc2 kernel.

Whereas 64bit kernel and 32bit kernel pass with 4K page size.

Initially, I thought it could be a Hard drive fault but it is reproducible on
other devices but not always. Which is a blocker to bisect the problem.

The steps to reproduce:
 - Boot arm64 juno device with 64k page stable-rc 5.13 kernel Image [1]
   - CONFIG_ARM64_64K_PAGES=y
 - format connected SATA drives and mount /scratch
 - Use the mounted /scratch for LTP runs to create and delete files from this
 - cd /opt/ltp
 - ./runltp -d /scratch -f syscalls


error log:
-------------
tst_device.c:89: TINFO: Found free device 0 '/dev/loop0'
tst_test.c:889: TINFO: Formatting /dev/loop0 with ext2 opts='' extra opts=''
mke2fs 1.43.8 (1-Jan-2018)
[  776.850122] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  776.874645] ata1.00: configured for UDMA/100
[  776.879042] ata1: EH complete
[  776.912010] ata1.00: exception Emask 0x20 SAct 0xc0 SErr 0x0 action
0x6 frozen
[  776.919299] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  776.926983] ata1.00: failed command: WRITE FPDMA QUEUED
[  776.932263] ata1.00: cmd 61/08:30:00:10:84/00:00:06:00:00/40 tag 6
ncq dma 4096 out
[  776.932263]          res e6/ff:00:00:00:00/00:00:00:00:e6/00 Emask
0x22 (host bus error)
[  776.948089] ata1.00: status: { Busy }
[  776.951766] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  776.957042] ata1.00: failed command: WRITE FPDMA QUEUED
[  776.962311] ata1.00: cmd 61/10:38:a8:6f:c4/00:00:06:00:00/40 tag 7
ncq dma 8192 out
[  776.962311]          res e7/ff:00:00:00:00/00:00:00:00:e7/00 Emask
0x22 (host bus error)
[  776.978139] ata1.00: status: { Busy }
[  776.981843] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  776.987128] ata1: hard resetting link
[  779.158340] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  779.182864] ata1.00: configured for UDMA/100
[  779.187307] ata1: EH complete
[  779.204050] ata1.00: exception Emask 0x20 SAct 0x9000000 SErr 0x0
action 0x6 frozen
[  779.211764] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  779.219433] ata1.00: failed command: WRITE FPDMA QUEUED
[  779.224749] ata1.00: cmd 61/10:c0:a8:6f:c4/00:00:06:00:00/40 tag 24
ncq dma 8192 out
[  779.224749]          res f8/ff:00:00:00:00/00:00:00:00:f8/00 Emask
0x22 (host bus error)
[  779.240718] ata1.00: status: { Busy }
[  779.244430] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  779.249747] ata1.00: failed command: WRITE FPDMA QUEUED
[  779.255146] ata1.00: cmd 61/08:d8:00:10:84/00:00:06:00:00/40 tag 27
ncq dma 4096 out
[  779.255146]          res fb/ff:00:00:00:00/00:00:00:00:fb/00 Emask
0x22 (host bus error)
[  779.271056] ata1.00: status: { Busy }
[  779.274740] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  779.280000] ata1: hard resetting link
[  781.450339] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  781.474959] ata1.00: configured for UDMA/100
[  781.479351] ata1: EH complete
[  781.496155] ata1.00: NCQ disabled due to excessive errors
[  781.501604] ata1.00: exception Emask 0x20 SAct 0x300 SErr 0x0
action 0x6 frozen
[  781.508957] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  781.516561] ata1.00: failed command: WRITE FPDMA QUEUED
[  781.521812] ata1.00: cmd 61/10:40:a8:6f:c4/00:00:06:00:00/40 tag 8
ncq dma 8192 out
[  781.521812]          res e8/ff:00:00:00:00/00:00:00:00:e8/00 Emask
0x22 (host bus error)
[  781.537607] ata1.00: status: { Busy }
[  781.541287] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  781.546547] ata1.00: failed command: WRITE FPDMA QUEUED
[  781.551796] ata1.00: cmd 61/08:48:00:10:84/00:00:06:00:00/40 tag 9
ncq dma 4096 out
[  781.551796]          res e9/ff:00:00:00:00/00:00:00:00:e9/00 Emask
0x22 (host bus error)
[  781.567587] ata1.00: status: { Busy }
[  781.571270] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  781.576528] ata1: hard resetting link
[  783.750335] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  783.774957] ata1.00: configured for UDMA/100
[  783.779349] ata1: EH complete
[  783.796099] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  783.803199] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  783.810812] ata1.00: failed command: WRITE DMA
[  783.815281] ata1.00: cmd ca/00:10:a8:6f:c4/00:00:00:00:00/e6 tag 11
dma 8192 out
[  783.815281]          res eb/ff:00:00:00:00/00:00:00:00:eb/00 Emask
0x22 (host bus error)
[  783.830815] ata1.00: status: { Busy }
[  783.834497] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
<>
move_mount01.c:70: TPASS: Flag MO[  844.176510] EXT4-fs (loop0):
mounting ext3 file system using the ext4 subsystem
VE_MOUNT_F_AUTOMOUNTS: move_mount() passed
[  844.194668] EXT4-fs (loop0): mounted filesystem with ordered data
mode. Opts: (null). Quota mode: none.
[  844.236136] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  844.243226] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  844.250836] ata1.00: failed command: WRITE DMA
[  844.255310] ata1.00: cmd ca/00:10:a8:98:c4/00:00:00:00:00/e6 tag 19
dma 8192 out
[  844.255310]          res f3/ff:00:00:00:00/00:00:00:00:f3/00 Emask
0x22 (host bus error)
[  844.270844] ata1.00: status: { Busy }
[  844.274536] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  844.279797] ata1: hard resetting link
[  846.450150] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  846.474681] ata1.00: configured for UDMA/100
[  846.479031] ata1: EH complete
[  846.500082] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  846.507202] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  846.514840] ata1.00: failed command: WRITE DMA
[  846.519314] ata1.00: cmd ca/00:10:a8:98:c4/00:00:00:00:00/e6 tag 19
dma 8192 out
[  846.519314]          res f3/ff:00:00:00:00/00:00:00:00:f3/00 Emask
0x22 (host bus error)
[  846.534870] ata1.00: status: { Busy }
[  846.538563] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  846.543874] ata1: hard resetting link
[  848.717983] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  848.742568] ata1.00: configured for UDMA/100
[  848.746902] ata1: EH complete
[  848.768079] ata1: limiting SATA link speed to 1.5 Gbps
[  848.773279] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  848.780390] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  848.788015] ata1.00: failed command: WRITE DMA
[  848.792493] ata1.00: cmd ca/00:10:a8:98:c4/00:00:00:00:00/e6 tag 17
dma 8192 out
[  848.792493]          res f1/ff:00:00:00:00/00:00:00:00:f1/00 Emask
0x22 (host bus error)
[  848.808062] ata1.00: status: { Busy }
[  848.811731] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  848.817013] ata1: hard resetting link
[  850.989969] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  856.023974] ata1.00: qc timeout (cmd 0xec)
[  856.028112] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  856.034231] ata1.00: revalidation failed (errno=-5)
[  856.039143] ata1: hard resetting link
[  858.210059] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  858.234811] ata1.00: configured for UDMA/100
[  858.239135] ata1: EH complete
[  858.260066] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  858.267172] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  858.274799] ata1.00: failed command: WRITE DMA
[  858.279271] ata1.00: cmd ca/00:10:a8:98:c4/00:00:00:00:00/e6 tag 16
dma 8192 out
[  858.279271]          res f0/ff:00:00:00:00/00:00:00:00:f0/00 Emask
0x22 (host bus error)
[  858.294825] ata1.00: status: { Busy }
[  858.298519] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  858.303799] ata1: hard resetting link
[  860.473957] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  865.495874] ata1.00: qc timeout (cmd 0xec)
[  865.500007] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  865.506145] ata1.00: revalidation failed (errno=-5)
[  865.511061] ata1: hard resetting link
[  867.681960] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  867.706586] ata1.00: configured for UDMA/100
[  867.710921] ata1: EH complete
[  867.755977] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  867.763068] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  867.770697] ata1.00: failed command: WRITE DMA
[  867.775176] ata1.00: cmd ca/00:10:c0:98:c4/00:00:00:00:00/e6 tag 17
dma 8192 out
[  867.775176]          res f1/ff:00:00:00:00/00:00:00:00:f1/00 Emask
0x22 (host bus error)
[  867.790712] ata1.00: status: { Busy }
[  867.794397] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  867.799653] ata1: hard resetting link
[  869.970127] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  875.224033] ata1.00: qc timeout (cmd 0xec)
[  875.228193] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  875.234314] ata1.00: revalidation failed (errno=-5)
[  875.239227] ata1: hard resetting link
[  877.410117] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  877.434747] ata1.00: configured for UDMA/100
[  877.439076] ata1: EH complete
[  877.463959] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  877.471050] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  877.478680] ata1.00: failed command: WRITE DMA
[  877.483158] ata1.00: cmd ca/00:10:c0:98:c4/00:00:00:00:00/e6 tag 19
dma 8192 out
[  877.483158]          res f3/ff:00:00:00:00/00:00:00:00:f3/00 Emask
0x22 (host bus error)
[  877.498731] ata1.00: status: { Busy }
[  877.502425] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  877.507705] ata1: hard resetting link
[  879.677937] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  884.695839] ata1.00: qc timeout (cmd 0xec)
[  884.699994] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  884.706114] ata1.00: revalidation failed (errno=-5)
[  884.711046] ata1: hard resetting link
[  886.881932] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  886.906633] ata1.00: configured for UDMA/100
[  886.910979] ata1: EH complete
[  886.932038] ata1.00: limiting speed to UDMA/66:PIO4
[  886.936980] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  886.944092] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  886.951703] ata1.00: failed command: WRITE DMA
[  886.956193] ata1.00: cmd ca/00:10:c0:98:c4/00:00:00:00:00/e6 tag 19
dma 8192 out
[  886.956193]          res f3/ff:00:00:00:00/00:00:00:00:f3/00 Emask
0x22 (host bus error)
[  886.971753] ata1.00: status: { Busy }
[  886.975461] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  886.980745] ata1: hard resetting link
[  889.153927] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  894.167843] ata1.00: qc timeout (cmd 0xec)
[  894.171975] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  894.178115] ata1.00: revalidation failed (errno=-5)
[  894.183032] ata1: hard resetting link
[  896.353928] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  896.378602] ata1.00: configured for UDMA/66
[  896.382850] ata1: EH complete
[  896.404020] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  896.411126] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  896.418751] ata1.00: failed command: WRITE DMA
[  896.423222] ata1.00: cmd ca/00:10:c0:98:c4/00:00:00:00:00/e6 tag 19
dma 8192 out
[  896.423222]          res f3/ff:00:00:00:00/00:00:00:00:f3/00 Emask
0x22 (host bus error)
[  896.438775] ata1.00: status: { Busy }
[  896.442468] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  896.447747] ata1: hard resetting link
[  898.618002] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  903.639915] ata1.00: qc timeout (cmd 0xec)
[  903.644051] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  903.650170] ata1.00: revalidation failed (errno=-5)
[  903.655077] ata1: hard resetting link
[  905.826132] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  905.850829] ata1.00: configured for UDMA/66
[  905.855065] ata1: EH complete
[  905.872021] ata1.00: limiting speed to UDMA/33:PIO4
[  905.876930] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  905.884010] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  905.891610] ata1.00: failed command: WRITE DMA
[  905.896074] ata1.00: cmd ca/00:10:c0:98:c4/00:00:00:00:00/e6 tag 19
dma 8192 out
[  905.896074]          res f3/ff:00:00:00:00/00:00:00:00:f3/00 Emask
0x22 (host bus error)
[  905.911604] ata1.00: status: { Busy }
[  905.915284] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  905.920538] ata1: hard resetting link
[  908.102004] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  913.111903] ata1.00: qc timeout (cmd 0xec)
[  913.116038] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  913.122158] ata1.00: revalidation failed (errno=-5)
[  913.127078] ata1: hard resetting link
[  915.297988] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  915.322600] ata1.00: configured for UDMA/33
[  915.326836] ata1: EH complete
[  915.348105] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  915.355207] ata1.00: irq_stat 0x00020002, PCI target abort while
transferring data
[  915.362815] ata1.00: failed command: WRITE DMA
[  915.367279] ata1.00: cmd ca/00:10:c0:98:c4/00:00:00:00:00/e6 tag 20
dma 8192 out
[  915.367279]          res f4/ff:00:00:00:00/00:00:00:00:f4/00 Emask
0x22 (host bus error)
[  915.382810] ata1.00: status: { Busy }
[  915.386491] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
[  915.391744] ata1: hard resetting link
[  917.561987] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  922.583901] ata1.00: qc timeout (cmd 0xec)
[  922.588049] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  922.594169] ata1.00: revalidation failed (errno=-5)
[  922.599081] ata1: hard resetting link
[  924.769981] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  924.794681] ata1.00: configured for UDMA/33
[  924.798927] sd 0:0:0:0: [sda] tag#20 UNKNOWN(0x2003) Result:
hostbyte=0x00 driverbyte=0x08 cmd_age=57s
[  924.808281] sd 0:0:0:0: [sda] tag#20 Sense Key : 0xb [current]
[  924.814231] sd 0:0:0:0: [sda] tag#20 ASC=0x47 ASCQ=0x0
[  924.819483] sd 0:0:0:0: [sda] tag#20 CDB: opcode=0x2a 2a 00 06 c4
98 c0 00 00 10 00
[  924.827169] blk_update_request: I/O error, dev sda, sector
113547456 op 0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[  924.838018] Aborting journal on device sda-8.
[  924.838036] ata1: EH complete
[  924.846735] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  924.857024] Buffer I/O error on dev loop0, logical block 1, lost
sync page write
[  924.864473] EXT4-fs (loop0): I/O error while writing superblock
move_mount01.c:70: TPASS: Flag MO[  924.884049] EXT4-fs error (device
sda): ext4_journal_check_start:83: comm loop0: Detected aborted
journal
VE_MOUNT_F_EMPTY_PATH: move_moun[  924.897412] EXT4-fs (sda):
Remounting filesystem read-only
t() passed
[  924.904884] EXT4-fs (loop0): mounting ext3 file system using the
ext4 subsystem
[  924.915569] loop: Write error at byte offset 1024, length 1024.
[  924.921550] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  924.931855] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  924.942137] Buffer I/O error on dev loop0, logical block 1, lost
sync page write
[  924.949612] EXT4-fs (loop0): I/O error while writing superblock
[  924.955578] EXT4-fs (loop0): mount failed
move_mount01.c:47: TFAIL: fsconfi[  924.992560] EXT4-fs (loop0):
mounting ext3 file system using the ext4 subsystem
g(FSCONFIG_CMD_CREATE) failed: EIO (5)
[  925.004493] loop: Write error at byte offset 1024, length 1024.
[  925.011723] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  925.022022] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  925.032305] Buffer I/O error on dev loop0, logical block 1, lost
sync page write
[  925.039771] EXT4-fs (loop0): I/O error while writing superblock
[  925.045757] EXT4-fs (loop0): mount failed
move_mount01.c:47: TFAIL: fsconfi[  925.064332] EXT4-fs (loop0):
mounting ext3 file system using the ext4 subsystem
g(FSCONFIG_CMD_CREATE) failed: EIO (5)
[  925.076587] loop: Write error at byte offset 1024, length 1024.
[  925.083805] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  925.094103] blk_update_request: I/O error, dev loop0, sector 2 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  925.104386] Buffer I/O error on dev loop0, logical block 1, lost
sync page write
[  925.111838] EXT4-fs (loop0): I/O error while writing superblock
[  925.117801] EXT4-fs (loop0): mount failed
move_mount01.c:47: TFAIL: fsconfig(FSCONFIG_CMD_CREATE) failed: EIO (5)
tst_test.c:1379: TINFO: Testing on ext4
[  925.148096] loop: Write error at byte offset 0, length 65536.
[  925.155817] loop: Write error at byte offset 65536, length 65536.
[  925.162008] loop: Write error at byte offset 131072, length 65536.
[  925.168265] blk_update_request: I/O error, dev loop0, sector 0 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  925.168320] loop: Write error at byte offset 196608, length 65536.
[  925.178583] Buffer I/O error on dev loop0, logical block 0, lost
async page write
[  925.178641] blk_update_request: I/O error, dev loop0, sector 128 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  925.184810] loop: Write error at byte offset 262144, length 65536.
[  925.192314] Buffer I/O error on dev loop0, logical block 1, lost
async page write
[  925.216549] loop: Write error at byte offset 327680, length 65536.
[  925.216555] Buffer I/O error on dev loop0, logical block 4, lost
async page write
[  925.216567] Buffer I/O error on dev loop0, logical block 2, lost
async page write
[  925.216620] Buffer I/O error on dev loop0, logical block 3, lost
async page write
[  925.222854] loop: Write error at byte offset 393216, length 65536.
[  925.230315] Buffer I/O error on dev loop0, logical block 5, lost
async page write
tst_test.c:889: TINFO: Formatting /dev/loop0 with ext4 opts='' extra opts=''
mke2fs 1.43.8 (1-Jan-2018)
Warning, had trouble writing out superblocks.
tst_test.c:889: TBROK: mkfs.ext4 failed with exit code 5
tst_tmpdir.c:337: TWARN: tst_rmdir:
rmobj(/scratch/ltp-TGrC0Kijpg/Nyirgt) failed:
remove(/scratch/ltp-TGrC0Kijpg/Nyirgt/mntpoint) failed; errno=30:
EROFS
Summary:
passed   9
failed   3
broken   1
skipped  0
warnings 0
tst_tmpdir.c:271: TBROK: tst_tmpdir:
mkdtemp(/scratch/ltp-TGrC0Kijpg/OXQGCk) failed: EROFS (30)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Full test logs,
https://lkft.validation.linaro.org/scheduler/job/3097379#L9811
https://lkft.validation.linaro.org/scheduler/job/3146329#L7071

metadata:
  git branch: linux-5.13.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: 80f75a7443c5c9a01f54e3df71ccd23d13c70c44
  git describe: v5.13.3-508-g80f75a7443c5
  make_kernelversion: 5.13.5-rc1
  kernel-config: https://builds.tuxbuild.com/1vg96dRUTrTU7nl6sWV2iwTwnu5/config
  vmlinux: https://builds.tuxbuild.com/1vg96dRUTrTU7nl6sWV2iwTwnu5/vmlinux.xz
  System.map: https://builds.tuxbuild.com/1vg96dRUTrTU7nl6sWV2iwTwnu5/System.map

[1] kernel Image:
https://builds.tuxbuild.com/1vg96dRUTrTU7nl6sWV2iwTwnu5/Image.gz

--
Linaro LKFT
https://lkft.linaro.org
