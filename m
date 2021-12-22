Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5B247D855
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 21:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhLVUii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 15:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhLVUih (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 15:38:37 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D15C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:38:37 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id a23so3061336pgm.4
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LxVt4g5j6un6GL3ICxsTh+taH/HHtOdRVvceMZKRv6g=;
        b=3Cici6Z4G74FBn80Etz/ImUanP8rAXMitowXTi0RmVUXFF+vINaOnYFXlENVZwZRo8
         /z+H1dh3TAT582DeOXHCVYvLRuZVfK1ZErYdUT+UhMwrh9qbLChPqqL8E8dEsOG8ic77
         zFlm0q3B/l9tyZrWT+rFhZOVaf4X/uNCbtIVIUvt1XM7YIL02/iRWycrp4LuRjcl7Zt9
         Z2xHJaElGw1qj05k9HLsUCfJeOXfCjwkG93jRX27fuiAJ5+/JdYCS1d45T7s7hKnuXmI
         WBmmRVix5QyVB6BTEiW4b9XR8ppG0n4GgWHhWsxb6y1nVMSSBAt+mR1gJ6MzqXQACxTK
         oH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LxVt4g5j6un6GL3ICxsTh+taH/HHtOdRVvceMZKRv6g=;
        b=cFup2cZY+PZR+9eGfEnq6blVJ0ibEGYSH4J8KFvEBpe4RPmG/W63YW06sFA4z+6La5
         7TF4xWnQ3dIQ6ahYDq0DmvHsBxgtgGgquEb7+d+ONX044HS+RZp7Rh/LtrW7a9mLHHKi
         aNlWyOf5X1GpZBATYMY4wgUnBXjmMYPsEUHYoz9t8KWgrV//DbjsVjovGd6C9NlJTGr1
         pLTnNa1WP6ytUgsVWASCfLgXX10UVCbFtnUx5S+ZkTXRZDKuQVhNPK+TXXqEu4H00wal
         cwtwF40l11teymqrtudN31d3gtFQCzjX+mcJi1iQhKS04LKP1J5PIn7YJ7EHtzUp8xrd
         U3VA==
X-Gm-Message-State: AOAM532hxBJn9LjGHL0JTo+aSSpHXzHxA7RhS4VTEOKfzenb2rzecOlM
        U5GajJ9CENOotbRb3zTeZFRLuCUW3YfdoIdO2Gs=
X-Google-Smtp-Source: ABdhPJzgc8xon/uIeq+J9HpBQWaqOGxhE/vYj/8H7Wt6zdoHDvIXMv7iTP4ugZz0qqIZrAESdACSKA==
X-Received: by 2002:a63:d054:: with SMTP id s20mr4098832pgi.565.1640205516859;
        Wed, 22 Dec 2021 12:38:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm2764474pgb.31.2021.12.22.12.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 12:38:36 -0800 (PST)
Message-ID: <61c38ccc.1c69fb81.2787c.7b43@mx.google.com>
Date:   Wed, 22 Dec 2021 12:38:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.222
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 160 runs, 2 regressions (v4.19.222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 160 runs, 2 regressions (v4.19.222)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.222/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      508a321e02f2cc9dfb1f226f7b10dd889887d249 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c352562a22f657bd39711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c352562a22f657bd397=
11f
        new failure (last pass: v4.19.221-10-g1d60913d545c) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c35282cbc8cb33dc39713f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c35282cbc8cb3=
3dc397142
        failing since 7 days (last pass: v4.19.220-75-gc65e8cddade7, first =
fail: v4.19.221)
        2 lines

    2021-12-22T16:29:34.681548  <8>[   21.264587] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-22T16:29:34.733180  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-12-22T16:29:34.744577  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-22T16:29:34.761907  <8>[   21.346618] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
