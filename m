Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7066D4596F2
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 22:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhKVVxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 16:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhKVVxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 16:53:40 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F66C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 13:50:33 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p18so15246953plf.13
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 13:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DAOixMuzPEfrqkJovoJXXw3/3ZVmacpGLxtSDvH8y24=;
        b=mdzm1N00/esw3wXmBVvaxWk5HYsBERbvhMXsPbxhX0OIF5TLc16kmCdpvbgck/9UBr
         XJmuI1YMnDdI5s/ez8MJv3jV3aeCT07wjffJrhun02Gm9y6qQes3pW+l3Y8J7h8XZ8N1
         MPn+AzHpWJ7VZN2xw+uJQkrdrUO5b8jA0+F2F2VsBJ2gHA44yJHLoH+KPJWb8Nmu37Rw
         okVjahNe6Wy+XY6OXiD/aCWrqtL12khiWV4MP6gDToUJBg9y6R5WEvms4BG31klGzP9L
         r66eB7Q8LKbeCUmrDkWnVrjuo50nW/xoOtmYmsGj87aiVKkS7sfn2lBwNHUDm2Yyttt/
         TKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DAOixMuzPEfrqkJovoJXXw3/3ZVmacpGLxtSDvH8y24=;
        b=iywf7p8vTXuo6RDtytcXuNSZFkFj3IiI7jJCcY3rjBgD49VAVhTFUy8sl0wrEbxBN3
         G47NzGlFBT3PrOfX0zaMHuCXLCzPzfvLsASOWU0BJz+iV7Rghh5HMs0srv2hx0+42ZPw
         IFrNePxG4ZFHIUertkF8q/G4wRQnKGA6lZ0lRDp4tgCu5K6PWcheuHGaVrjEhH6LA9Ai
         aDxO7q7KVyPK1Q9Z+/D2+Bc+TVWiNTo1YyGa+7ow1FXH53/eS0q+ovgeH+jeiiNsDtrA
         gzKMAltetLudUv32IAGGcjMgBx7C3dCGOqebiWVUvcWJs5mgteWSbhwGEkzGTinmhX8D
         G7RA==
X-Gm-Message-State: AOAM532qNODiwjTJ2OxuAXu4jXjuQeuXCp4K/yvoT5b3NYZ204AzvTFJ
        Pt8PPx6dGdhxTEoqHl9pKLc7mwC5xnNTH9IT
X-Google-Smtp-Source: ABdhPJwf2zyefqpSSFMZw0uOmxTpODNXwF436aMtT3ubco1x0GI/cTZXaNJjXEOyF+N60sEdpEdlcA==
X-Received: by 2002:a17:90b:4c0d:: with SMTP id na13mr35625pjb.206.1637617833068;
        Mon, 22 Nov 2021 13:50:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm10324083pfl.60.2021.11.22.13.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 13:50:32 -0800 (PST)
Message-ID: <619c10a8.1c69fb81.fe397.d7f1@mx.google.com>
Date:   Mon, 22 Nov 2021 13:50:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-309-gfbdc7d8c6144
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 142 runs,
 1 regressions (v4.19.217-309-gfbdc7d8c6144)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 142 runs, 1 regressions (v4.19.217-309-gfbdc=
7d8c6144)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-309-gfbdc7d8c6144/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-309-gfbdc7d8c6144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbdc7d8c614403556b4838ed9ec2b38d8ee9a386 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619bd5b7e609399310f2efb2

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-309-gfbdc7d8c6144/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-309-gfbdc7d8c6144/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619bd5b7e609399=
310f2efb5
        failing since 0 day (last pass: v4.19.217-258-g500386e5fa6f, first =
fail: v4.19.217-301-g59e657d57c9d)
        2 lines

    2021-11-22T17:38:48.842251  <8>[   21.256896] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T17:38:48.888472  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-22T17:38:48.897757  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
