Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F2745CC33
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244891AbhKXSkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbhKXSkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 13:40:43 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733BAC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 10:37:33 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g18so3497909pfk.5
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 10:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=huO/e1J06J/Gm6LIB1n+2Eqpa2NcP2xruGNrCYms8EQ=;
        b=JqiOAm/SLzX38TG8yDmp+TKNOlltkljRxq4UrGo0zGqCovVFz/dG9bBZjC7cxnoVyz
         MsE00wuMBRmPPRWMTdPhrgCannBhmRCOfhIseON0hy+JVDwPjnr77ubNEuTZakXdgJfj
         hgYTZdm+OQli6yqdZ0f8aV5XKA+mrIyzBmrmes/Ek4R6bbLN1sFb8D3FQOYpkDJv2mg2
         F1SdY40NuYRUPq0wD5ovbv8NeHWd3/LdL3a/Mub2Hz82U+U3CG6leGi1TBDbSomAYNyC
         VKvN/eaEZlZZlRKSOyid55nTS8Kiw2lveLj2wQiqqvJZLneG+KmDwPkuGgTRgp3p7rGL
         pNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=huO/e1J06J/Gm6LIB1n+2Eqpa2NcP2xruGNrCYms8EQ=;
        b=TFDPigPXd5LyN0sz0dgY7Fgm0nwEHv1GGJx1GoIJNCAglcOgRXEFlcP9f2lSov2eFS
         TN435j48gP3Yhsh9RCduca54zOG6Zugmy+cwz4BfjhUv5MmPdayMz0WWBx45+pkoREJC
         Z4gYXmJT0qMk588eQxEfB/EpPBXUrloUEf2uRCmHIoiEqMp1hWAtcSqnV0UUbfOh3zoy
         0utoUnOzn0HqCK02U2U9bpjYFbni0snGUieuejnPKV2UdI+W979oyD7xAMPR0m92+TAu
         HrDsxVgY7cUkBEStxkoKIdrqoagQ4q4B1nAo8pQrXkWEsa2K3grTUZDUmfix1VUQohm1
         gBCg==
X-Gm-Message-State: AOAM532O/5zFoH5PyD6cMowFisgXO3Wgy17pHLaM/H0pMssky++eZqJf
        hPqfFyd8LF/mr3NC59yXHyox44cHONsPuOPw1Gw=
X-Google-Smtp-Source: ABdhPJwTfb36QoECyfMqJe1IYqnXOfPd6wAL5DHEKYlmT+/C//t9AoCwtcTsgAV19F7idlGftEICQQ==
X-Received: by 2002:a63:5664:: with SMTP id g36mr11652315pgm.243.1637779052818;
        Wed, 24 Nov 2021 10:37:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13sm325195pgp.27.2021.11.24.10.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 10:37:32 -0800 (PST)
Message-ID: <619e866c.1c69fb81.ca69e.1360@mx.google.com>
Date:   Wed, 24 Nov 2021 10:37:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-249-gfe623ad09382
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 132 runs,
 1 regressions (v4.14.255-249-gfe623ad09382)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 132 runs, 1 regressions (v4.14.255-249-gfe62=
3ad09382)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-249-gfe623ad09382/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-249-gfe623ad09382
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe623ad093822d690d6f26ef33a60a717382f103 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e525d90d4bb36b9f2efb2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-249-gfe623ad09382/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-249-gfe623ad09382/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e525d90d4bb3=
6b9f2efb5
        failing since 5 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-24T14:55:03.942769  [   20.016418] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T14:55:03.985309  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-11-24T14:55:03.994581  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-24T14:55:04.009877  [   20.085540] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
