Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095C548DDA8
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 19:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiAMS1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 13:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiAMS1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 13:27:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E369C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:27:55 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s15so630670pfk.6
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c2Mzw+l55bEyln3H/FnZuIaoO59DgZDc3tf5ebVVr+o=;
        b=SIQy1ykYalXn1p/8Xb4Wmj/ABTmohla2k9EMDUouTOcNQ38Pi+LZfnMDzeAt85+eqv
         s/fZyrqdgxboEofzcO1ykJ6eODc9RHRUaIU0vvOXEval2zzsn1ogbiEiBrYSK6/LzlHJ
         FIc3BaL0dyA57PHSie6253mvR8jl4XUNxu9+ISUbMxZPHn83oPJKkNys9ocNuJBrtL4d
         qx66mtB/a8DpWSqoStg+8QbHPRlP83v2ueCv85wQ6eaw0RoFwbPNnKrxIfCem5t/J/bz
         gCA5Pd02RoCsw70lccdZh//GJm0TyPQ1yc2eCVUafRYT0g09Srd++/lGOY9+owM5ewpY
         ECJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c2Mzw+l55bEyln3H/FnZuIaoO59DgZDc3tf5ebVVr+o=;
        b=HSrq2X5qqSjTmGTOMWcVFcrvTbQWRZ2D8HyZmGhxQI8nrBx7byKwfOFTF4NlwP5Hs8
         XXJthDBO6w8aoNIp69aJ0yCtRkJCfX1Ya1UugS2pNz6Wc+mNLW2mGTyzMt24xtPbO16d
         wSYUC4QRxljEhWQdko3rV0m5mt8pZVaLUPAVP2H4ttvXbbP7gc8ysg0ksWQUxvxRLZ7j
         5KQ70FugIyrpl4YkmCSPXJQfyODGsyCmUdJI1AFAmXyn+yL+cn77DBhVlu4ZHKPvRIq8
         LHcZNHLm6ovd5jywbBtDolG4eqkEocbUgaqcNOtEdzXnjocnxnDy0wGbp/dAyGMVjPrJ
         5iHQ==
X-Gm-Message-State: AOAM532WBA1ZLs+Nn4YdNt/07/okkw8M+1oHNaXUq6b/3z2V03S2Wyw6
        tSWVRIbRe7rMfh/11zNKfX3QTnJfCyvBQFTu1R4=
X-Google-Smtp-Source: ABdhPJzJTiriQS2NsCs6vEwulyc9if+UdRO2lzwuCQ13Ozx2dNebnVYsrvjLMxErgDXVFxa0cUSz/w==
X-Received: by 2002:a05:6a00:1707:b0:4bc:c640:b19f with SMTP id h7-20020a056a00170700b004bcc640b19fmr5382882pfc.69.1642098474474;
        Thu, 13 Jan 2022 10:27:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e29sm2766525pge.14.2022.01.13.10.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 10:27:54 -0800 (PST)
Message-ID: <61e06f2a.1c69fb81.8f997.7c11@mx.google.com>
Date:   Thu, 13 Jan 2022 10:27:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-6-gfdcb326e027a
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 174 runs,
 1 regressions (v4.19.225-6-gfdcb326e027a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 174 runs, 1 regressions (v4.19.225-6-gfdcb32=
6e027a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-6-gfdcb326e027a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-6-gfdcb326e027a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fdcb326e027a06bbeeb095e0f17f21be95635bd0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e03bcad14072bf7bef6747

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-6-gfdcb326e027a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-6-gfdcb326e027a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e03bcad14072b=
f7bef674c
        failing since 1 day (last pass: v4.19.224-21-gaa8492ba4fad, first f=
ail: v4.19.225)
        2 lines

    2022-01-13T14:48:25.826405  <8>[   21.098663] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T14:48:25.871454  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-01-13T14:48:25.880668  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
