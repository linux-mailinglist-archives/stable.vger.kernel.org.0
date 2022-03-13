Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE84D77E4
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 20:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiCMTJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 15:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbiCMTJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 15:09:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55355FD1E
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 12:08:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 27so11949118pgk.10
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 12:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pe+r/asFl92dTzAgXBKch4JFy85Aulgk999wg2cE9g4=;
        b=atXpEQ8hEMvOQwlpOQPDjTasuv92E34NOlW3TA8yu4EJeM+5vqJM+NWKiuWhhJM7CL
         PrYyfnNA8FQ+Oom/jmbGEW6oBBnSmUefB0HrCFR+7OQKedfb66+4RXdAWSGPdqGmwayX
         kmtedCu5TLbpCnwfhn3zeq8nnyMGpiGtS4a3l50oq1X3c2GQY+gNi9cdryA2Iccexb3l
         HvobKQ+alv0UeQm8Bi2SA7WxJ9tAyuxOywFAdAuGZUPI0ryTWm6htvEgTQjpCogLRr5/
         uw+wpgFVdv69Mzh2udmdhvKxnlZIQTqa6giBIqt4whh7Cy0/A7ZAmJuUR7sJM7A8ok+E
         X0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pe+r/asFl92dTzAgXBKch4JFy85Aulgk999wg2cE9g4=;
        b=yWE9Wjgm9r/zI8poDla40rPo8U5EBpN22HFI83ctmauSBsFALicbsq1POOA1PVutx2
         if5bvFSez0q7FwLYnclNKdDysCEHJAtJJ6Ig6WA4oJOPwARBL7hLXVRCC1wjqBGeox0f
         ybBzRlXFC/KKrTIT/h1LYe/D+CeWLGv9fz8WXJo3NhJJbpVu6ljpatUMF4nWqgYGGVYY
         Vh2ESIn9CR3eca+LYAj7thIzcr5N7g3apXSuZV/5kNVPOL0lbffo0VCcKD+kAsrQuI0q
         M3+KPkUC5yu/1nxGPxRJNgu8UNitFMcNXzV2WNxtA5J3xpYjJPozGUqt087oKm6SNLoV
         H24A==
X-Gm-Message-State: AOAM533f0EgWb0zeUI9CDybElD/jJx/ir0o+pBoaqpawyCtWXyszVuJ4
        ijT9/aLLLwFyvtPDmDMYX6f5pIIWNGgePxsKr0s=
X-Google-Smtp-Source: ABdhPJxOVuMDNmKMr87InSW4WqFgEjVO09byNTyC8xdjxNeN+9BxD6/+sgmc1t4hRjx2EMkp+YjLrQ==
X-Received: by 2002:a62:1d48:0:b0:4f6:b805:4bad with SMTP id d69-20020a621d48000000b004f6b8054badmr20621213pfd.67.1647198495666;
        Sun, 13 Mar 2022 12:08:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2-20020a17090a380200b001bf46846c09sm14799964pjb.36.2022.03.13.12.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 12:08:15 -0700 (PDT)
Message-ID: <622e411f.1c69fb81.bf06c.5d14@mx.google.com>
Date:   Sun, 13 Mar 2022 12:08:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.184
Subject: stable/linux-5.4.y baseline: 100 runs, 2 regressions (v5.4.184)
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

stable/linux-5.4.y baseline: 100 runs, 2 regressions (v5.4.184)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.184/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.184
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1346e17653a52c2042a486c7726f92e81481c8ec =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622e0d0fa85ab46614c6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.184/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.184/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622e0d0fa85ab46614c62=
96d
        failing since 86 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622e0d0ea85ab46614c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.184/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.184/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622e0d0ea85ab46614c62=
969
        failing since 86 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
