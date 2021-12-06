Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319F746AEB6
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 00:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbhLGABV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbhLGABU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:01:20 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA309C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 15:57:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id r130so11686706pfc.1
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 15:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z6lW5YoEyH49QSv1o8wTtYUBbXv02kDMNpVNrpmFUkg=;
        b=Vk1WWZkJbRN0yvIpCTgWG6BIE/CG2AbBWgkBktchIupFWE74/RsEtbk+5wzIuqMNR9
         MKXH3Ll7aCAfLZxOa4jBpDn3TDq0GHZsh+QAG6vaU2eL22zRPrgs675EQho5RVFdD0r0
         G9KPapp0X0NWcmwTSm5RANqosawsqS4ZvkLnbHsEO52e1YDKJ3ongLDnoXQ349uBO4qw
         Aqsdx+fFWOp3RZuyURpdrZEx/YoW1LfnfShhkIgjik05U05x2B4wT0VTXL2wAah8x12s
         8TMl+Dhih8piXEl0Kz2q1us0UfLA6Ve4xFRn9YwK+Mi585YpE4cs6f398Ri2PLukUxIy
         w33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z6lW5YoEyH49QSv1o8wTtYUBbXv02kDMNpVNrpmFUkg=;
        b=xX/az5TKzyUo6pfJuCNVHK3LB5HTFF6KXERUr/UX6JGo7OvNJeLJmR2WSSrNyIsPgh
         l4HsZnyskxp9eRC2JPfE986gBr7d2EOldOEbYfzppd0piLjWXgkCysRp8KU6UK+EL1ox
         KvCDTgFs5j386osIWTqjUih34GMAEl/vF2RfnT2SRC3E6ecZap+xiYtBk/gQiFN+eZ9m
         WlgwDsq5oFbNUILc1Ec2sP3Es/Q4kO3XAA+aQAgb4JUIzHH7CfdgbsKtLv5cRevDkBBq
         T2nEsKY+YlBWOCg6mKlUPxYfNqpPij7wgMl1CyqOpZbO0jlHUxXCWDEeAjSoAk4XRRIY
         MOYg==
X-Gm-Message-State: AOAM532LdrSd9MwB7il7AA1UDxIQ+kQ5mxZxL6jWmbzbY0vtbHZ+2Mrj
        VGyAbw/0nr87aQLURcVOxKisT1wqkz5pLDP8
X-Google-Smtp-Source: ABdhPJzKhTAJRJ5a1XeIgJR88Z9dYsjrfImKEDva6b5cNrwk/IHho4fkexBAK6XqrzdQAlCSgD10lg==
X-Received: by 2002:a05:6a00:15d6:b0:4ad:dea7:b5de with SMTP id o22-20020a056a0015d600b004addea7b5demr10696848pfu.35.1638835070188;
        Mon, 06 Dec 2021 15:57:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm14108138pfc.197.2021.12.06.15.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:57:49 -0800 (PST)
Message-ID: <61aea37d.1c69fb81.77e05.7f3f@mx.google.com>
Date:   Mon, 06 Dec 2021 15:57:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-49-g36bf297d8737
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 199 runs,
 1 regressions (v4.19.219-49-g36bf297d8737)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 199 runs, 1 regressions (v4.19.219-49-g36b=
f297d8737)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.219-49-g36bf297d8737/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.219-49-g36bf297d8737
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36bf297d873717a14e37c015e0e4947bd5a0b6fe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ae6a5005da9fc2461a94a5

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
19-49-g36bf297d8737/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
19-49-g36bf297d8737/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae6a5005da9fc=
2461a94a8
        failing since 10 days (last pass: v4.19.217-321-g616d1abb62383, fir=
st fail: v4.19.218)
        2 lines

    2021-12-06T19:53:37.463633  <8>[   21.232635] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-06T19:53:37.509053  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-12-06T19:53:37.518077  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
