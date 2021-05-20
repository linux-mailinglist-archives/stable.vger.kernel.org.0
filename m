Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930D3389C62
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 06:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhETEVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 00:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhETEVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 00:21:30 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2627C061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 21:20:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t21so8278293plo.2
        for <stable@vger.kernel.org>; Wed, 19 May 2021 21:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wO/q0DSgcxc38NYlTggX6n+pdfWeeR3y9MRm9/0jjO0=;
        b=cMjWea+rhPrzoC60dSH4AKA8JwcmFP3x6iJS6GH882wQRJ2lIbukowPBK7han8In09
         S2FbkLqPon90qxqmk4sjBs+p+QW1fhNabyEGXcCzsGELNHPPa0UVFK7tE7HXzmDkob4U
         ZwU+dZaQL6w8UEY27kt7i1ZrJ3tqE0jPLXDk9Ud6o17c20/jPGaoyvO5mFiBX6nNwLFH
         bzh3EZ122Ak5rvrzB0ibHXNGJmoSq4RQbb/d75UFbMgFMv5MFN7Ew6A1dakpi3q5iuOw
         NRODEyqZoZyLzcFbQWnf1APxBHW19gGk7/E4cP0gO0JQGUfglDVUhDOq6t8cPd1Bdliz
         MaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wO/q0DSgcxc38NYlTggX6n+pdfWeeR3y9MRm9/0jjO0=;
        b=n0LCnDoTEpP/EufniGElD6kefuF99t2FBYO/SCfpQPNKfnFVg2kEhihslHXsi+eEYq
         ZajajOBwWkKRriQMtTyreUgQb/4yXlPADtTFG4+RZnz9R8eCPtAdPS0jet3nGZbEB7kB
         qRYKL2SrYZwGnJMSBTLyz+4Wac/DWiYyoX07UrKwtKnhw9sf5rY+xHERqFZJ/3L8Ry6d
         uavjxEJ25T+unl7QlTJeG1AfspsxGCXT1CZ4foSxwplPEI2G+CGH+CkOQN4WNTUvGyXt
         lte2lUlNZGTeCI3sCweAczEslM8+bHlj1PlW5Dv/vJWBcDNfKdp5FIfIrOMyLlrAJ52H
         STGQ==
X-Gm-Message-State: AOAM532XmwNt8MkzUKKePrbimz4Cj2ZSMgfy+7quSEbrtEph/NTw+kkR
        +X8gLpePB/TAVyJxLBkDt6jchPfaZ14xNcIp
X-Google-Smtp-Source: ABdhPJzI7/iPISGZKQdcmXfVKq9RbK0vgQu4VFw+jsC3zD3ONMPMzSl/Nij1IUaqZBY+ufigiBDFmg==
X-Received: by 2002:a17:902:ed82:b029:ef:48c8:128e with SMTP id e2-20020a170902ed82b02900ef48c8128emr3379466plj.72.1621484409073;
        Wed, 19 May 2021 21:20:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l7sm5254541pjh.8.2021.05.19.21.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 21:20:08 -0700 (PDT)
Message-ID: <60a5e378.1c69fb81.2b558.3bc7@mx.google.com>
Date:   Wed, 19 May 2021 21:20:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.12.5
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.12.y baseline: 173 runs, 1 regressions (v5.12.5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 173 runs, 1 regressions (v5.12.5)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.5/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      761ea31e416adf1291edf31c8daa0f9b1b94f03d =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60a5ae6233eb727af4b3afa0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.5/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.5/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a5ae6233eb727=
af4b3afa6
        new failure (last pass: v5.12.4)
        1 lines

    2021-05-20 00:33:11.511000+00:00  <8>[   14.586112] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
