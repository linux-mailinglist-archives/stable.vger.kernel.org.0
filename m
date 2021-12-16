Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C604766F1
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 01:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhLPAh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 19:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbhLPAh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 19:37:56 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027B8C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 16:37:56 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id o14so18006429plg.5
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 16:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bHLCXYWEwj90A7eXdrEJY/KABGPEfNlzjuxmQktD9Fw=;
        b=y8DlV91vL3hLf1nDi30EgAjuUBqS9STPX5RHZW9KTtswC+3SplzI/jaJns2dWh+VX3
         bx2yHdsqlnxHBzGHdTLmPg+Vy5vFcHuf9neej3edYIdmjH3/5gg7o3DOrsZypCeCe8iC
         xynefiLxeLsTsaAtjxJk/2yUm+Ok65aQ/jbxsq298wjXBwQBUbyC1tbMrXs8V68BuxAh
         D+ORTi+QOt9K6ZE2+APLD2Rp/Nen8hQdXzs4W5uVG1vsVMPSBjOgsU+vkzt2zYL1CStz
         Ep//Bs1oQp1VVQJ0c02fE+tNHHFvE/8jfUObgoO+6PPQCwlh9PoFR6lK6g3KFyIouTVA
         7hQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bHLCXYWEwj90A7eXdrEJY/KABGPEfNlzjuxmQktD9Fw=;
        b=eRWZxpRA/WiwMu8me7JUv+jUHTd0gzVMX9SXG70EHxpN7Tj7RnnQpDKdQ39B44eEne
         edTXNGTR6ErL//oV9a2h6PBDZDKiUs4nmhm2JlU7hF5NNbNFJkv3JeRAxph0Un6gMVrs
         vhG9WGg52hqyGPtqidpMVXu3HPYHLKZu/JhcLYPchwuWyrkBLfHcwOU6cc2z3FYB0Xj6
         sD1VQa7xKUZJvdYbx20Yy75vviVpgqyZTTibzss4Kq4i/cJBcKN6VhJO5WPR9wAqWd9d
         SIrMBQIMlY8m2Lx4kRF6fFpFroWHg6nu4fmgfI/rYY8H5NncdOF0gEmjdIyvEMmei+B0
         OvgA==
X-Gm-Message-State: AOAM530oQoJJDZ7fOgRibENaABSSHkDXhilKpBTxZIfIaQIsip+dPeV1
        bzP8+AwXHpTqO5Obeb/FtrJzIpvOFNo79mWX
X-Google-Smtp-Source: ABdhPJxh1TnDd/t/+ighCNcfd21j47aF3P6arIr5Rc3QYRgPWuO2WwldzW4iMVzBYSQM2X+1u2Zmhg==
X-Received: by 2002:a17:902:e74d:b0:148:a2e8:277c with SMTP id p13-20020a170902e74d00b00148a2e8277cmr7260838plf.131.1639615075408;
        Wed, 15 Dec 2021 16:37:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm3716488pfv.84.2021.12.15.16.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 16:37:55 -0800 (PST)
Message-ID: <61ba8a63.1c69fb81.9552b.ac18@mx.google.com>
Date:   Wed, 15 Dec 2021 16:37:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-10-gc8f53fff7dfe
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 134 runs,
 2 regressions (v4.14.258-10-gc8f53fff7dfe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 134 runs, 2 regressions (v4.14.258-10-gc8f=
53fff7dfe)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.258-10-gc8f53fff7dfe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.258-10-gc8f53fff7dfe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8f53fff7dfefe4ac819c4bdbe583b31cd0acf82 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba52e7bc611695cc397128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58-10-gc8f53fff7dfe/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58-10-gc8f53fff7dfe/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba52e7bc611695cc397=
129
        failing since 2 days (last pass: v4.14.257-34-g5ece874a0959, first =
fail: v4.14.257-54-gcca31a2a7082) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba534978b62e801e39713d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58-10-gc8f53fff7dfe/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58-10-gc8f53fff7dfe/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ba534978b62e8=
01e397140
        new failure (last pass: v4.14.258)
        2 lines

    2021-12-15T20:42:31.594968  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-12-15T20:42:31.606310  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-15T20:42:31.620276  [   20.283477] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
