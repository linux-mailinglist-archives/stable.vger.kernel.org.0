Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C17042C164
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhJMN3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 09:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhJMN3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 09:29:30 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA1AC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 06:27:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s75so2339023pgs.5
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 06:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zr6GSWmrOUlAvT81+mNCi+lJnNdIOLdK8Wdhcfwapc0=;
        b=GoFpRCY7lYDG0d2j08bT71438cAMeRlwZ0Klu0imCM1DpEyC/jv5KR7QZZSS6Mv7MB
         YwWIdGINak92Cn8V3vd/YSEG/5tPc9MmellVV9cWcm08e+lZLyjAaH9t14/XW23yhxCP
         865ILlYO1qGQCEbBGq6UBERdEaczBPL4dlf+efZdserJP/t7LayX6GEuSo/L02pUEGFm
         ikqsrxViNNaqGEIAYJqdmhDLXwoB/KTl4obsa35ZgH0EMWdjdoVhnF7cwqrnBZXWFj7p
         vgH+sTHz8lLDT7MFar781ENtnR+QoFDmFjSSQcw45Nd2rm9/vmlBLssM7ar4T5+0NMXX
         ZN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zr6GSWmrOUlAvT81+mNCi+lJnNdIOLdK8Wdhcfwapc0=;
        b=uQ2Dj/d1kK3ScitVGy3T91tmvvQ/ortJTdUpbtN/xvdNPB0P8mMb4gArUTBptwmYDQ
         A+ru6FD1QTzqX5V63mTAuqMM4EHUX+yVjKe7s5N0Ws1m8vGgDTLHBVAjVi1kjOei8lGi
         T1TSYVK1fBeYPEGuyONoQp1SNo+39xcg9fP0D0lK7iKErinZ/8H3syZuhs1S4/iCYfeH
         VtfQa5IxJe9YfheDNaQXbjATP1jd1VwkPDEMpnJpYuhkQCokafMMCyv+fxbTChjZZYPd
         o54KAa4Jmr9gSzV2ju6H70OY6NX2XUDMbYJa6coXRgZ5QlO/ghdnzW4AzblVN5fSzCGk
         TgSQ==
X-Gm-Message-State: AOAM530Eh2Cl5iTmklLSEJ0bhzzEVFEx3AMPckuPj+y9ElBnuEzvGlYU
        COMGopBucOQzFusjOJTDiqev65rcYSBJCr03
X-Google-Smtp-Source: ABdhPJyhOfN2k3R7ZMiKuIcgrZk75/Y3DBwFjMIo+pqzQvcACYo4XUspRHIoniCJ13bBhDC77whLMQ==
X-Received: by 2002:a63:f30c:: with SMTP id l12mr27806882pgh.360.1634131646899;
        Wed, 13 Oct 2021 06:27:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x27sm14282753pfr.181.2021.10.13.06.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:27:26 -0700 (PDT)
Message-ID: <6166debe.1c69fb81.7727e.7719@mx.google.com>
Date:   Wed, 13 Oct 2021 06:27:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.250-23-g0fa274aa5a91
Subject: stable-rc/queue/4.14 baseline: 36 runs,
 1 regressions (v4.14.250-23-g0fa274aa5a91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 36 runs, 1 regressions (v4.14.250-23-g0fa274=
aa5a91)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.250-23-g0fa274aa5a91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.250-23-g0fa274aa5a91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fa274aa5a910956562959c200c6dd904641ebcd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6166a852db4bf973f708faa6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-23-g0fa274aa5a91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-23-g0fa274aa5a91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6166a853db4bf97=
3f708faab
        failing since 1 day (last pass: v4.14.250-10-g360a25ea0f96, first f=
ail: v4.14.250-24-g0c04723a59cf)
        2 lines

    2021-10-13T09:34:58.045756  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-10-13T09:34:58.054971  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
