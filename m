Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E749931EDE5
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBRSDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhBRPUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 10:20:04 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1237BC061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 07:19:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n10so1325641pgl.10
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 07:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5KS13ZnkhX/TA/HarPpVM4z69Jwk1nEMMrvaMcZ0ANw=;
        b=vPUTvKFhJ7jTFcZ7ARFRRx932QUy5Orf9fH5euR7G4KkBTz6ussgoq8Xt021fz3xvg
         HJLiqUM5Em3BoBrzf5dNkHkO0bTMf9NY/d4Pd9FlmR41MyccPskw85jyCx535u1pXVmC
         7/+FcX3s+vr1Js440cl5g74VXCi38ad5C1XgyUKjyNK21kT8y4/lCUp3HBO2bmpW9MBI
         +Qx4xZu0+SHmePbWX6+S5l4gSTgDJ29qFKbgEIwehbS5FvyrUcZXAMYoeVttdAHHfWuk
         rxS18vzAmsfEkRCQic4ZexsukVm3ZOozYg8t0DlQivtTXM662PDKx8FI3USK0iAt8Yrw
         vhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5KS13ZnkhX/TA/HarPpVM4z69Jwk1nEMMrvaMcZ0ANw=;
        b=WMvIZGfh4Vbn/l8HYB6H4LPNaIZR6Z357Ptjr3LSXr97vUfkb/LCibxve5pYvuSYQ/
         MCHZmBhdVqFxv60bq4hV4c+Wnm6TmENxc9JXRSUdqlbQSv5BJXcAj8yAWQ8yYH6nWRMk
         pP1NtfXsLIYFkoshYjDEcAclr3hDcUx2aK5c5Lp3sMLltCA+RM8FGr/Y4EYtUfo/r6nO
         hUq6xIQCVjD98tZDGWoCFMMgLQ+3CxfkQaGSGoqgd96ho50gmBs3rCuMPW4tKN+Ux67u
         pQutQ31NXGxmZ6RDW+kOvFcLQaOOqh3yUcbrLcTSZgS9+tfVk9uFrj9BTcTePGsXcgPf
         f78A==
X-Gm-Message-State: AOAM5317YWOvVxV0DzePbpAycOnNZ/5v0UnplhLHQ/uUxOPwkBTZCm2z
        62TgI/YEDAfB057OBT2Uk2vOcqtUzd0GFw==
X-Google-Smtp-Source: ABdhPJxq/Rhy8+C8K/BYCZCQ1gE7PIzTi7wYEd+O6eoDklSEPyXnjTH1FLSBwGWDQx9a5pHImukRug==
X-Received: by 2002:a63:ec0e:: with SMTP id j14mr4464662pgh.62.1613661562195;
        Thu, 18 Feb 2021 07:19:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 68sm6369139pfe.33.2021.02.18.07.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 07:19:21 -0800 (PST)
Message-ID: <602e8579.1c69fb81.a25df.d8cf@mx.google.com>
Date:   Thu, 18 Feb 2021 07:19:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-5-g6fd05caf3e1e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 127 runs,
 2 regressions (v5.10.17-5-g6fd05caf3e1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 127 runs, 2 regressions (v5.10.17-5-g6fd05ca=
f3e1e)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-5-g6fd05caf3e1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-5-g6fd05caf3e1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fd05caf3e1e58a91f5f85ed1a748dd71b613ddb =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/602e51896426e030bbaddcd0

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
5-g6fd05caf3e1e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
5-g6fd05caf3e1e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/602e51896426e03=
0bbaddcd4
        new failure (last pass: v5.10.17-5-gb45e0e2bf813)
        4 lines

    2021-02-18 11:36:31.038000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address 0006531c
    2021-02-18 11:36:31.039000+00:00  kern  :ale<8>[   43.692100] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-02-18 11:36:31.040000+00:00  rt : pgd =3D 7517a6d1   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602e51896426e03=
0bbaddcd5
        new failure (last pass: v5.10.17-5-gb45e0e2bf813)
        45 lines

    2021-02-18 11:36:31.084000+00:00  kern  :emerg : Internal error: Oops: =
817 [#1] ARM
    2021-02-18 11:36:31.086000+00:00  kern  :emerg : Process udevd (pid: 10=
6, stack limit =3D 0xf102def8)
    2021-02-18 11:36:31.087000+00:00  ke<8>[   43.736019] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D45>   =

 =20
