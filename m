Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B892AAEE2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 03:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgKICAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 21:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgKICAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 21:00:37 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C17C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 18:00:37 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c66so822798pfa.4
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 18:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZK10yjcQmOJbmyPRGLUtdP/OgmwTFe3vfKykJLlXWgo=;
        b=Bw0vtFokwy8Bc3xyQMZDi3I2JmkmXhZYPmqimaCUedxHjkecoM7yS1HNUFoSW0lyjk
         gcq/kZkDgtvaQpA8/N6oyEhef9JMdDX9YuA7F6SVQBy3wjYh8Sqh8tH1IMSoxincl6mY
         EdTQhUHnHEAl0ZgpFNJZvd4im9sVtJs2onZaUUH7E2JKGjOKwOicnCkGVLCB700R2M45
         VwGWZjUXC2vA/8wlR7vE0mbZxdsyD0mbmFJ6AI6SY4umuCmJ8u4sCgoapdKtdkRG6+ef
         PI35dR0TqoNb4OPAj4NkcqorEMfHyhnoNm0GqnEKuWA2ZxAno6gqyUqsxL4vmDK651g0
         Yxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZK10yjcQmOJbmyPRGLUtdP/OgmwTFe3vfKykJLlXWgo=;
        b=YogC7WYrHbjQipw5JUhVZzhaBhkdHZ/nVpXfuuNZ9IJoirreuCQBG7x51BluQEbif/
         EDVgzTy6RnTv0lG3DF2ay6oHp1dpZljVmDxVp0wBRhYY91ss5lBLLephcvysSGs4bJab
         kfioMBrI7K/kWtoAxqFY+twhZmS6ahXfVCuwt7eEvnYSaUeExv1MXe9GM7xyVAlVc9Ys
         yCtglf+9BAMXnXlaLUNo0YYRSrcSSM/WHFignMTMVoTQZZgu6tDt7r8i/Td2/WB02vgZ
         QZWjtclCNq4Dj9V8FOJGczVFlraQj7mOq4y31mtM4ofaAQZg/k6SWvoImjqweW+cfQec
         YYug==
X-Gm-Message-State: AOAM530daDYErW2/SV5wz93Bn1YEtOQwWWI8h5o1YdaG8fkX6Ndbq7Nn
        lyFTMkEnVtIQM/DhTaUvRV+GJXUza0+Rgw==
X-Google-Smtp-Source: ABdhPJxidFB4BHw07EeX+U5MdtpvOt/9n8/w2O+wFLIQ7/JXjtDt+qzHUKj77LVkcWtG/qRPUDlv/A==
X-Received: by 2002:a62:cd85:0:b029:18b:36c7:382d with SMTP id o127-20020a62cd850000b029018b36c7382dmr8597289pfg.14.1604887236780;
        Sun, 08 Nov 2020 18:00:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm9280701pfu.160.2020.11.08.18.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 18:00:35 -0800 (PST)
Message-ID: <5fa8a2c3.1c69fb81.f36e6.3e60@mx.google.com>
Date:   Sun, 08 Nov 2020 18:00:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.204-26-gf4d6c3384055
Subject: stable-rc/linux-4.14.y baseline: 168 runs,
 3 regressions (v4.14.204-26-gf4d6c3384055)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 168 runs, 3 regressions (v4.14.204-26-gf4d=
6c3384055)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig      | 1     =
     =

qemu_i386       | i386  | lab-baylibre | gcc-8    | i386_defconfig | 1     =
     =

qemu_i386-uefi  | i386  | lab-baylibre | gcc-8    | i386_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.204-26-gf4d6c3384055/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.204-26-gf4d6c3384055
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4d6c338405502dcf1b63b25695634accf40395b =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig      | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/5fa86dbf2feedede3bdb8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-26-gf4d6c3384055/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-26-gf4d6c3384055/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa86dbf2feedede3bdb8=
854
        failing since 222 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
qemu_i386       | i386  | lab-baylibre | gcc-8    | i386_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/5fa8699ee3756646a7db8886

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-26-gf4d6c3384055/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-26-gf4d6c3384055/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa8699ee3756646a7db8=
887
        new failure (last pass: v4.14.204-22-gc61fb0fa5762) =

 =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
qemu_i386-uefi  | i386  | lab-baylibre | gcc-8    | i386_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/5fa869b94a7e0f467bdb8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-26-gf4d6c3384055/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-26-gf4d6c3384055/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa869b94a7e0f467bdb8=
854
        new failure (last pass: v4.14.204-22-gc61fb0fa5762) =

 =20
