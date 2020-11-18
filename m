Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172872B87E2
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 23:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgKRWmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 17:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKRWmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 17:42:40 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED851C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 14:42:38 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j19so2352855pgg.5
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 14:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FXZhDcNfdLdEjT802xwVn5DFrArf5guq73PhcN31fik=;
        b=0+6zhkZ3A7ckRxTtugqkhYk6wS8vHj8k6Bjwfoj8F7t1JBpyN3xoQ4YlG3B/m2B7e0
         UDDTxMr7I1jp2OzjFFm3RGiM6hgSNMnR8+0O5/bd7doFtMFvdBJs2OpQRPzEeqvcV/Bk
         qv/K4BGFnCuszQ1caaim46UdECzbWG3IZJjcw2mhBZ8vI2ZKoIBOCvC1jrEju6HSfV0y
         FrX60lPuAQtwNPNAV3uTk0/z64+Vrh/wmBXt17SwlABy9NPUo1MTCUrJHDMiuwbZQrtm
         kPP+FQ+35GwD5aSSPGDHkYA+CEI8DpNVFBivCGw2ZAsRwiukEwk8a7dPhbr8kfkPln0N
         ve9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FXZhDcNfdLdEjT802xwVn5DFrArf5guq73PhcN31fik=;
        b=J51ra1gB909lq9nVHrccvemxIwPw5tB4h/ngckoEFEE6rOZ2ANlNGva/EoB3onHlNK
         Nu/8/KVs58n52rXrVUZFJOGLf5FORgQmV1HhJxuR9dL204J8hweQ3Fs5izybbFUmelbJ
         /HJkQYXuUBEoNGkN4XJpNJR9RrqfLR7/uSH7TCizeFI7IQPGXJM6GhiuRnaq9GwXensu
         Is915fBFeQwHv64OiyQ2pjB9z+5OBtkO/dxJuy6O49gRnPOyExfmKuTp/B7Z71MhU8P9
         pCgJg/+wCnjm126ItJgu7NFTmo6Wbq35EbPZjhW1OVnAW3tVEjsb51VdgOmFr43zfopE
         HksA==
X-Gm-Message-State: AOAM533rSV3jsmrMiluNuXwvZaaqCI5VkBsg47l7zclg8kAbnDdQcRfm
        JGiQRkO3piHWL+dU1gslwi6t7exyJ/CGCQ==
X-Google-Smtp-Source: ABdhPJwHC4wIwnc4zzagMPixs92U/EOumapiMz6Ei/brt485uAc9RCKK2RKMSYU/Yc8q6sX5Ew5keQ==
X-Received: by 2002:a63:f91d:: with SMTP id h29mr9820626pgi.82.1605739358043;
        Wed, 18 Nov 2020 14:42:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm5456606pfb.45.2020.11.18.14.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 14:42:37 -0800 (PST)
Message-ID: <5fb5a35d.1c69fb81.d4f24.a9af@mx.google.com>
Date:   Wed, 18 Nov 2020 14:42:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.244
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 64 runs, 3 regressions (v4.4.244)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 64 runs, 3 regressions (v4.4.244)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.244/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.244
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b71e57af961fc0cc69998a13dea631ba2229333e =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fb56c6b00e0d60ff9d8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.244/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.244/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56c6b00e0d60ff9d8d=
919
        new failure (last pass: v4.4.243) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fb56c816de3ffe91cd8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.244/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.244/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56c816de3ffe91cd8d=
905
        new failure (last pass: v4.4.243) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fb56c886b9157ac84d8d8ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.244/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.244/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56c886b9157ac84d8d=
900
        failing since 8 days (last pass: v4.4.241, first fail: v4.4.242) =

 =20
