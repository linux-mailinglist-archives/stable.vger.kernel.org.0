Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1B339230D
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 01:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhEZXMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 19:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbhEZXMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 19:12:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B38C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 16:11:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s4so1373118plg.12
        for <stable@vger.kernel.org>; Wed, 26 May 2021 16:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jk/0VNLA+agCqOqjuYOxKx6OtgzIVJc21TFBEHQiayU=;
        b=Q+lfgimqaldl/UKG7gYONI7FDWZQ63xrnGRyr0mIMylJqXErpMwBpZ7v72xTtzo7Iz
         pmhJTlGEjTnZdStxMSFPffsIOaTvp+ZjdB0dTuQrP6BsfOcbEifNy9sI17eLGEHbBwHO
         D75hG6MgqUgS9Pmk5upXGjfDTv1VWlN1VPLTwnGtZBtNNGyEotc1BHQODcHOOhNunsPu
         UQLqr0la+KArKyrhjinXsKZiCnzRcwkiENiaMl9BMSSG1ApN5wYl5RUeYEGkw7PSrWoi
         KtVgdd+ph6JeHF9aaCdTzJgJ4v9Eh2FTb96SocrRoSf4/YXAFb+kXvWU+WTIAOKehmDM
         wIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jk/0VNLA+agCqOqjuYOxKx6OtgzIVJc21TFBEHQiayU=;
        b=pr1V1z/jny3XzsMERzwKipwzZ6yRCRZVKSFq8HFzmPf5OkalKhi61+9MUYWaPttVt4
         Nt6bo97XrBObwa9VLFYSAoTlst68zVd0wrbXqhaxv84tdxYhVSFUI1nj6kAQKtaPyt8z
         ME7WbOXxBRgsbqQCbYFrU8f0gT06GC9pcfqgSMaNhcCGOUZ1IinMLLcuDemk5ckwoRIL
         lo49+SJtpjNYGK6Tp57KU30afFTb/rZiV+yewQ4yF+sbBEy8dcHrDgqSASDaD2HmaAfK
         zEHRDWZYqYT5/0ejg8e8hBsEVAxdkoq6h6ukKBLfbwXvLxN1jfHqZS1ieupoSfCLSwKK
         GqFw==
X-Gm-Message-State: AOAM533PzUJfCboJqLISYYTRYzS0WBsKWDQEq4iLCr56ITBwbl5TVbl1
        WuhAk2cbzAkcHz6L6EAUzhOybEOsV2rYiCax
X-Google-Smtp-Source: ABdhPJxJ+o3YhDP5kzOF7m+dD8b2PL0jTJRhIYXLyeVsXQN8a+D+gCN/gus+TjCRjLCPD8+9oB04vA==
X-Received: by 2002:a17:90a:fc8f:: with SMTP id ci15mr529377pjb.147.1622070680367;
        Wed, 26 May 2021 16:11:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 93sm20519pjo.2.2021.05.26.16.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 16:11:20 -0700 (PDT)
Message-ID: <60aed598.1c69fb81.b1fbd.0247@mx.google.com>
Date:   Wed, 26 May 2021 16:11:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 95 runs, 3 regressions (v4.19.192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 95 runs, 3 regressions (v4.19.192)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.192/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b7b0056defc6eb5c87bbe4690ccda547b2891aa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60aea0b474a8ebff9db3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aea0b474a8ebff9db3a=
faf
        failing since 189 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60aea04e2f4a0ccee9b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aea04e2f4a0ccee9b3a=
fbf
        failing since 189 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60aea05f92f9056b75b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aea05f92f9056b75b3a=
f9c
        failing since 189 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
