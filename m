Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6E45AA98
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 18:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhKWR5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 12:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbhKWR5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 12:57:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09A2C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 09:54:42 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id iq11so45748pjb.3
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 09:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uN6I/U1r9d3XMC0Jj942E1mBswN/p7ErDBCgO36Yk44=;
        b=gysuHmX249RdMa2lFwymqQjxZuYaO0ZzQM1NVEnC0yuxYV78lsVEeVdjvR/YOz2Upn
         HeyriHgXi+8frHlp43+UGbmjACffPNj3TwYOEJFcJn23mT/kztbtqDvLHAL94PLD40eQ
         /BD4BsdwB6o9jYm3lls7Ltd8n/83fGJKgSXYG43tYlCkiiJ+k8bqYguHoXRgssJtSv+H
         TTgAYVJ3YXUv1eMd97AyLZ1CFVqt3WlN1m8YjgPbyuXkIQTKzlsIfZpM/bSJ1fgCuTFJ
         0CgaWv0PoOogw6FAnCqIeapVCqdFnuAXmYK/upTms549GVKcJ0MPRyso4bg58tksiql2
         C7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uN6I/U1r9d3XMC0Jj942E1mBswN/p7ErDBCgO36Yk44=;
        b=sCLMpXdvMsyY783r+pPB2Ex5aZWyq9boX+knlmY3SPBXzDXzAPaWR4FSATCDWSrrve
         UL7ZF1bs/MXt1efyPhRu2yLm0cY/cFHsQNHOnmECb9xG6zb73dlCMy+G3FhiPELmeUhA
         LnNTaVLwu4LEz/YPcOexZjjZiAmQeLEBctR2gUI73CGr+w3fJSj9jpJOtCh8QwQPkFD/
         RFRfNr+RglS31prHTL40M9L2cPhsoo4Tvrr9wu3FP4zMfGwNPUofGuy3GD7Io9gswUWv
         iYBdl/r4I0QjWU1usCqGTjiFAJCe+OsbfB9NWgetZoXNF1t2y7RCIZ69dOvFnWjw4Fbt
         JsIQ==
X-Gm-Message-State: AOAM533er0u97qO7XVmxHDOtO+4mPL0+7ixkslgy5PrgzXv66eG10vNs
        MXn3oNGRaFLXAgBnjfpxSOKB5aNf4GwYf8+J
X-Google-Smtp-Source: ABdhPJyP0GIUthDbqCqWeGFeH9NfTU+hxPv/p/nzQn4Jc1fodwBqZEuTO7O4Lj7hnp+PZjKsmdvoNg==
X-Received: by 2002:a17:902:8e87:b0:143:759c:6a2d with SMTP id bg7-20020a1709028e8700b00143759c6a2dmr8935599plb.59.1637690082057;
        Tue, 23 Nov 2021 09:54:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm13834262pfj.215.2021.11.23.09.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 09:54:41 -0800 (PST)
Message-ID: <619d2ae1.1c69fb81.7c575.62b2@mx.google.com>
Date:   Tue, 23 Nov 2021 09:54:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-g4ba1793245b0
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 109 runs,
 1 regressions (v4.4.292-160-g4ba1793245b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 109 runs, 1 regressions (v4.4.292-160-g4ba1=
793245b0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-160-g4ba1793245b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-160-g4ba1793245b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ba1793245b09e18bc43d9fa0f0cfbdb95e6e25a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619cf2d100e66329b4f2efdc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g4ba1793245b0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g4ba1793245b0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619cf2d100e6632=
9b4f2efdf
        new failure (last pass: v4.4.292)
        2 lines

    2021-11-23T13:55:20.196145  [   19.177490] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T13:55:20.246110  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-23T13:55:20.255327  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
