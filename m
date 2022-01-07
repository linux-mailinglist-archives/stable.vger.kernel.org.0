Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751D3487F63
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 00:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiAGXbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 18:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiAGXbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 18:31:53 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293A3C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 15:31:53 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 200so6977326pgg.3
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 15:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lu7RzWmI6aDebmtpdskAzkE5+S0lACLEBAhWks+2u2g=;
        b=UtSh5ecn/J095evzY9AXEY03X9Vp7lg+j8ocqs9eGWZaouWliZ1WxrXx71CwOtD0FP
         TsSSEBUx2nFLbmv+K0P28cTrQMMebZ/vEvVYimWd4RLVe/miXAc9olxRQ07QPMVNRqN9
         TClX81MB+Pwvm7eGW4QmRPA2lih4fKXoGoqwWhNJhjll70IsdBDplCD+npgNoZJKf5af
         kebwtfdiFP6ukbjFI6LdNcn5UA23PEqUrRlHfq5ibSOQE6s2pFzqaedqCmBouOd2YoDr
         aHYA8jBSIo2AIAVz6h2YlPTpq8VQM84oSNfgq0nvhSrjxZvq73sRiYIUJGuMnzSE1kVy
         Mpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lu7RzWmI6aDebmtpdskAzkE5+S0lACLEBAhWks+2u2g=;
        b=dZRwVx627nCZKEeieutVKX2x+lItuSyGn/L2byTsqIon4LB/5x25ZcnA5OdTFnt3Jl
         AN8uMnQbM4O8IRI84SdkGi7u+2EsBAgaes4jl9jxYv6fYwwYRczFm9BCXhEAWefEy06X
         9qw++T/NVC48tpaPmc8h/PdeM2PkmbRGEmteknxxNmydV1YXb2PTM8133Xw0Mz4ZO310
         NQK42hulcY5SgOSAZy12unoi+Ys/XQdoZz18qdfASDwqg29/afFJusb/ECkCN0QR1bMZ
         OxN3M1IevYdh3Q9pleqB+Lc8XtZKkowbMTBBgLtzIPBdT3+2AT9CsCIcpiQrsBemH5qD
         A3sg==
X-Gm-Message-State: AOAM532PoDEC50Z0FuCJk/McKXcUPh8tjbqBvkMnKjz2gnYUIMjFv34t
        Y+vawKsOjRdIMwLQyF2WAsmDdsn3D5u0y8uL
X-Google-Smtp-Source: ABdhPJz8lPf1sLXXAbigOgrj5CBbyR00aBcxBWZ1AYf9Whd+wSchZL0/PyOpTgHIU744HqSA4Pophg==
X-Received: by 2002:a63:4b0c:: with SMTP id y12mr58902273pga.526.1641598312589;
        Fri, 07 Jan 2022 15:31:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm30691pfm.122.2022.01.07.15.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 15:31:52 -0800 (PST)
Message-ID: <61d8cd68.1c69fb81.cd40b.029b@mx.google.com>
Date:   Fri, 07 Jan 2022 15:31:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-12-gbe57a558dd09
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.261-12-gbe57a558dd09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.261-12-gbe57a=
558dd09)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-12-gbe57a558dd09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-12-gbe57a558dd09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be57a558dd09eee92ed91076c55458d2bfd95ffb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d89c0f380a34604fef6755

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-gbe57a558dd09/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-gbe57a558dd09/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d89c0f380a346=
04fef6758
        failing since 4 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-07T20:01:01.979072  [   20.090301] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T20:01:02.022829  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2022-01-07T20:01:02.031805  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
