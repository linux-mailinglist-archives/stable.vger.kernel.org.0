Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD456483633
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiACRdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiACRcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:32:17 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49332C079798
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 09:31:30 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v16so29338928pjn.1
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 09:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lCVJs0VsjvPnpjoEd+i8zjezQHHoFivBW0yUHazzZDM=;
        b=irfk85hElQzjHfGnmibhvoiwl3qTlFSKFwtlfBdRl2t+Nbr3zvdkAmWf+qvrjLq4Eh
         ehrobOuh5fNeTzg+8fpWSxd/qkj74npBUhW1rbw5vhH5WJSHVoAQh44LqKcamVMBK+ZM
         NL89qUh9mQvNFcmOnHxWyCPSHc+19eVqm1vzgq9nPhGzkHLMswhMUNi/GF2lgwC9IrTB
         7Aymg7Sfg7Bckl+vPAnU8yrtl9D8pKw9MPqk8bfxOEw+6v2t4inHxfF9c391SuVk0rXA
         UTUyQhMzxumgrJc/r2uxocvNGlebGO8AtJSdkm4pnB2bXmKYE4qJ/JWWnC4jZwoZ6Rmj
         5ndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lCVJs0VsjvPnpjoEd+i8zjezQHHoFivBW0yUHazzZDM=;
        b=MibUa3UP4Afh4t0/+wSnXjdSiWtCyaHl16jqPSEECAJqD94ILclTEccCNmcpB0p9yR
         apc8xhVtYF86Zev66lBY59eAqw7WRpbMqDlrLCRiYLmSbCpj4p0YpUGsP2WG6taLpJSn
         wWZC9hgL9ESZ4i7eJcvrRMUtdidm33ODPbrETT2vRDwNGQb38309niTItABPlrJiQol3
         fcBDGdf+sFU8ZZJ2Qm+b2u6BSb4hvmvtpGUbWFFbqvfyLjg9IiPoN/MvG+hbA4DqVRXD
         8bV1lCNxs59YV2hdLLT88t/QucQdrz79FPNoVmzJRhZPjMWAXpulYWT2cIRoTkq3Ji/B
         1kAw==
X-Gm-Message-State: AOAM533zXSBKPFPMT9CYTMu35ZOvKTLaFFqVXobK1gyCBvRxAfSHz/GJ
        S6HojexwaOaeImyZHMECiTiJKmhp3QuY8Lcf
X-Google-Smtp-Source: ABdhPJxuNMLL2vc7782aRCYzqqzaghs8lHRgLNF3UfgKpHspH5VuRXybShF2a828vRp3bZIJHjPmNQ==
X-Received: by 2002:a17:90b:1d82:: with SMTP id pf2mr56658860pjb.96.1641231089697;
        Mon, 03 Jan 2022 09:31:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm39489267pfj.123.2022.01.03.09.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 09:31:29 -0800 (PST)
Message-ID: <61d332f1.1c69fb81.f86f6.8dd5@mx.google.com>
Date:   Mon, 03 Jan 2022 09:31:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-14-g584e15b1cb05
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 97 runs,
 1 regressions (v4.9.295-14-g584e15b1cb05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 97 runs, 1 regressions (v4.9.295-14-g584e15=
b1cb05)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.295-14-g584e15b1cb05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.295-14-g584e15b1cb05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      584e15b1cb056b405a979fe31376882197337962 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2fc6e027e19c63def6768

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-g584e15b1cb05/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-g584e15b1cb05/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2fc6e027e19c=
63def676b
        new failure (last pass: v4.9.295)
        2 lines

    2022-01-03T13:38:37.254778  [   22.299316] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T13:38:37.296408  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-03T13:38:37.306207  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
