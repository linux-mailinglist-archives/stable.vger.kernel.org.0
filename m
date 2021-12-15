Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E03F476506
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 22:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhLOV6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 16:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhLOV6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 16:58:19 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E259FC061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:58:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso20613425pjl.3
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C+rRzMpxXDTCXyLqxzZ/L+gPDzXG+3ezghZnHYpv1Fw=;
        b=5bEiyrngUqGwBcSL8pNCkssDs2iqocsNni2z+CWnxTiugS71lhr82hdjzLwLMzT/HB
         ksb+i0/6t3KGaeVjdr5jEUkyM46uJ3fn/Uspb2wVijaQeRq8AM93nI0BI9yFqoZaKSuU
         HdEf9GY2JRCPFCbb46a2y2gl6M3HLwc/kjlUFzTtDbogsSF9Kng6VRgzESJIKxJVKtGb
         sUY6rEZrfXpb/T+NaCUv21no5qhQygMPUYOfGIv4MAGnQru1YUd6Elxg9YTT+WxDb2u9
         sb7ArL7RBNhD3do2mDJqy691Bro5WC6XYNy1a6JGkeBWewqr7GgP0+/9WnWdqegdul5u
         /c2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C+rRzMpxXDTCXyLqxzZ/L+gPDzXG+3ezghZnHYpv1Fw=;
        b=v9CnT2rxxh7F1VECwNv/RhvxOWPe6DrsvZDsQTKc07SFh0poG+gqSOMvyxmWyEyHz+
         qWPd/0MhN4s+sG7qCSSZz4NX2JCPJ1SCqLKaO/MoVgJ+SaT5Ti4UIStInaHNZDHVKnea
         Fkr01mq/FELX7FUQ/VWp1ISq3zZZra/NORGg9n1dWA57ydMoOfQx4/aKYuwKLb5Ci6qG
         iRT+I8KRXpi+WRHRbOytlRnyuKbJ5Bn5zUr16BeE0949hXiw2/a5dJcV9n8MxSYdQyW9
         ho0fIKCrVNXjKVIq90kcxxPR+l7oTzvLJAGpWDGTzh5RLVK7VdzlUMYGo+IyVaIhxKMv
         12bg==
X-Gm-Message-State: AOAM530/ya7uEU1Qg2UXtEBD3Iyj3IxdZjtf3+T53oJcdjS2DjExj75Z
        hSjBKSzRTMaYwkjKz07QqNwitUeC3lBEfh1r
X-Google-Smtp-Source: ABdhPJyE+6neDKK8GfI/qHwgMYURjEhw0mK79UxOAFTEbr8umd7xrAEIQ0HvfjyN33G/bdrIcDhUmg==
X-Received: by 2002:a17:902:ea03:b0:148:a2e8:277f with SMTP id s3-20020a170902ea0300b00148a2e8277fmr6506658plg.134.1639605498205;
        Wed, 15 Dec 2021 13:58:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm3603046pfv.89.2021.12.15.13.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 13:58:17 -0800 (PST)
Message-ID: <61ba64f9.1c69fb81.140eb.99e7@mx.google.com>
Date:   Wed, 15 Dec 2021 13:58:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-10-g1d60913d545c
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 133 runs,
 2 regressions (v4.19.221-10-g1d60913d545c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 133 runs, 2 regressions (v4.19.221-10-g1d6=
0913d545c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.221-10-g1d60913d545c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.221-10-g1d60913d545c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d60913d545c332b38a844cb14e8ffa53498528f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba2edad1b9168ec339714e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21-10-g1d60913d545c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21-10-g1d60913d545c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba2edad1b9168ec3397=
14f
        failing since 2 days (last pass: v4.19.219-49-g36bf297d8737, first =
fail: v4.19.220-51-gab7df26443b3) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba2ed74de747cce639711f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21-10-g1d60913d545c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21-10-g1d60913d545c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ba2ed74de747c=
ce6397122
        failing since 0 day (last pass: v4.19.220-75-gc65e8cddade7, first f=
ail: v4.19.221)
        2 lines

    2021-12-15T18:07:04.111225  <8>[   21.369323] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-15T18:07:04.161719  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-15T18:07:04.170976  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
