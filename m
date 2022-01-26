Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8350E49CCC1
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiAZOwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242382AbiAZOwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:52:18 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B03C06173B
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 06:52:17 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o64so16389pjo.2
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 06:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IUALqCX+t0VtTLOJHuZfVixHeKru96L9Un3bLN8YILo=;
        b=PIGKXH1jUYt3QgaCjJJ54OFXYcobygh+0LVgpdkwYWNPsk9sLBUTXVgm3rYPIlPS01
         mriLZvzKMi7ztlakNRstH5+PNEF+ZNHsSrFjWB/otu8tYnkTiY2Y2APlAzqPsmS1saJm
         W+h4LT/yLvz+yQIAojH/P/jbcJ16cdMDcv1Zez2O9M6qHFtCP3y51fxgyl90xoxOvuTk
         Kv0JCTVr35G77JDnGfK7kxt61ND8qmV+ktmeCSBUv5nBRepjxPWfYcfWBhoOD+3+4A4j
         vla8QZyx2ABSf8MMSeFXGiKTiwAmYCEHlZTG7i5Oe0q9yUOr3MN/hpNqQB0FPiSkNm18
         YU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IUALqCX+t0VtTLOJHuZfVixHeKru96L9Un3bLN8YILo=;
        b=ZNN6qMSscvmC4Y6imx2C2ynCdxN60c6iIsHaukgcywgVyZS2y9jJH+ycaoBXdW26Gy
         PY4gIAbBCm6jmH3beyqpCRT8dhhx+WqaKuIwykPxX8e5k0KWtB2q4PowBiqn0v9RuJcu
         giI8hIlX+FCVR5RgE52oAanfa7SrOogbCGvuGmxULDDY8UNnAN/1olEuoCr+JgMEleSK
         UwPqbx5pF8Ip+zmkuchaILPHZoOntI17QoXZ1kFPRmd3zzmwjrb5lOFnlijdi6F3f0FI
         72Vd9OH2mHFgNzz+ilEaK9ydlrvB91vOxdWCDSiNCUFKEVhDTDsxWpBj9aRi7YLm2cHH
         sRXw==
X-Gm-Message-State: AOAM531Vcip2fyBzwzOJF3lxmcueBOfNY9UyBhtGC2RNj67sIpTYyk+G
        3Ddk4yBoeNqaVCM0rqBLfGy7qyvAEPxL9at3
X-Google-Smtp-Source: ABdhPJxRp75ei8/poT1IcUQGevySrmRXRLd/McmqDX5VquARnCkVcOiZYFRjrNrm+l1UHVZOdrCIdg==
X-Received: by 2002:a17:902:8494:b0:149:8a72:98bb with SMTP id c20-20020a170902849400b001498a7298bbmr22674738plo.0.1643208737314;
        Wed, 26 Jan 2022 06:52:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm7561564pgq.38.2022.01.26.06.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 06:52:17 -0800 (PST)
Message-ID: <61f16021.1c69fb81.331be.4b60@mx.google.com>
Date:   Wed, 26 Jan 2022 06:52:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-237-gef98dd754721
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 163 runs,
 2 regressions (v4.19.225-237-gef98dd754721)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 163 runs, 2 regressions (v4.19.225-237-gef98=
dd754721)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-237-gef98dd754721/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-237-gef98dd754721
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef98dd754721e6d4cad6b7951fa773205625f2af =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/61f129bb09c9641eaaabbd36

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-237-gef98dd754721/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-237-gef98dd754721/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f129bb09c9641=
eaaabbd3c
        failing since 1 day (last pass: v4.19.225-239-g087a7512e40c, first =
fail: v4.19.225-239-gdd903a45b8a3)
        2 lines

    2022-01-26T10:59:57.039347  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2022-01-26T10:59:57.048551  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61f129bb09c9641=
eaaabbd3d
        new failure (last pass: v4.19.225-238-g456be8ad4573)
        3 lines

    2022-01-26T10:59:56.919407  <8>[   21.879669] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcrit RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-26T10:59:56.975043  kern  :alert : Unhandled fault: imprecise e=
xternal abort (0x1406) at 0x73f65ef9
    2022-01-26T10:59:56.975340  kern  :alert : pgd =3D (ptrval)
    2022-01-26T10:59:56.975504  kern  :alert : [73f65ef9] *pgd=3D00000000
    2022-01-26T10:59:56.993479  <8>[   21.953735] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =

 =20
