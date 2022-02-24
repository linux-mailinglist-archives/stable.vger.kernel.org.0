Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABF34C2287
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 04:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiBXDnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 22:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBXDnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 22:43:17 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A2A1BA92E
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 19:42:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so893877pjw.5
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 19:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aKobEToEMSzVQFegbYwuXfLNF6y+0JVJ13v5B0HTC20=;
        b=kPVerRbvhuBd8ePTu5BRTI5fMsDdJUoJNZ1yx5SacIzaWBe4uCNPKPQnnp688exwLq
         HauyyvL4CDMUuKpcPeb9N/NEyGU0Dr2Wcwe3UOZFOx31O2BMQ2WgiE5MtdF5P15/IP4i
         qjC4tIE48QcmZgCtwyo1tdIVsokWZGafFbtVKHSrjEsC9Jcc0cqZoyEjnJmEEpyXHhdO
         eqSju71j+cZQ2OHFzUysiYux36BqlRE56j6P2VrHV4GXbdKKrUTtvJjTjqMI0fXLyTHE
         12AFDQRRSlBPhj+whWiT9rhdiWKxrGkwhtiN7Q3oe9S+e5ZhdfqdXAzm6PJ17QXfF49X
         jwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aKobEToEMSzVQFegbYwuXfLNF6y+0JVJ13v5B0HTC20=;
        b=jQ1AfSEZ2XWltM+TJJIztCtOv252XKhbz+Gvk0hPuMUglFOJ1CbP37MnJs+nL759KC
         SQCuUjOT1LCpDF8BnQjC18Ds6+9PPwb5fGZ0m2ZH9BiPpJBnItoBWuk+BwInHorftG/U
         KRfKVRi/2jybSML6emcgCVtHy5Nm5dkW/5czoq+PpTrALmFLQnz9Fev35F51LejpRQ9e
         Jfoso/7YzmVjLUPAw6xURNKYnI0xTLC5/lR2klNPxB8NXo+XRdIj9flGhCbVxZaSue0w
         szhdVt1FIh9wI6fwmhZLe1Wgu3mUjttfBIlBSZsY6xLS572+YICtX7LtbF4nJ4sknMi/
         x1Cg==
X-Gm-Message-State: AOAM530MI/qe7xfPQ1YA/xS3xv1LCBLgKau/neZJUNEUxWlrXUyZlJas
        3I9DleKTuZPiE7W41Kl6C/nsF+CWKIyIcqkxil0=
X-Google-Smtp-Source: ABdhPJwglu9/kacnkWKiR4zmab3mE2CqCCFITp32xTFvI4CArzAIorj3Y6IlJEJC3f1n5dZnaKMHvA==
X-Received: by 2002:a17:902:b08e:b0:14f:11f7:db14 with SMTP id p14-20020a170902b08e00b0014f11f7db14mr696170plr.106.1645674168330;
        Wed, 23 Feb 2022 19:42:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9sm1055532pfv.135.2022.02.23.19.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 19:42:48 -0800 (PST)
Message-ID: <6216feb8.1c69fb81.35560.49a4@mx.google.com>
Date:   Wed, 23 Feb 2022 19:42:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.181
Subject: stable-rc/linux-5.4.y baseline: 87 runs, 2 regressions (v5.4.181)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 87 runs, 2 regressions (v5.4.181)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.181/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.181
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6e8856b8a5f7fb8b2fc10636aa05cffed1781b9 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6216c4b0ed17a12f02c629a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6216c4b0ed17a12f02c62=
9a5
        failing since 70 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6216c4b1bfd5c9cd6ec62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6216c4b1bfd5c9cd6ec62=
969
        failing since 70 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
