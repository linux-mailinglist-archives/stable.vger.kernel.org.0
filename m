Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AC7394E30
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 22:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhE2U4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 16:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhE2U4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 16:56:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C25C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 13:54:37 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id i5so5318590pgm.0
        for <stable@vger.kernel.org>; Sat, 29 May 2021 13:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p21RK794AKefkmcxkpbo++uw6F6AYEx5/iQSb8tCFo0=;
        b=RGdDPWHl/AP7UR6F++AMffu8jKdydDgXB7deOpJ6joNFlEQhyp91LZOO90T/la3eB9
         JKF29km+vYyqyssaBv1Gfo18iRHdlZ2AAEAMofiDphf3TUQnsNyZyA9pXZ84xjARS4yY
         mz6mWipAhGXTuHCYftCHrrvjh9nQy8ZLRqdsY6QW5w1JeKmLdezHR2o35e0J26lom2PS
         wByn8zOe672XRyN1e65ts3kotvMX4uf4vcKDHfUu+svH7xh3Q6metxhMXo0JMr7J/dZ6
         ED4OYlnKC8X6zrmH80BC9kZsQRBFLgCFl9b6y2TxDY0pwS6cBxz2ykHZYvijc/9XA0Od
         eclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p21RK794AKefkmcxkpbo++uw6F6AYEx5/iQSb8tCFo0=;
        b=cxDz5HieKGu31MZDi+GWwyB4rK/iGwCzK9aNUlDERwBpR9Bk97LovXRVipqiIxiFzf
         12ACsxmShg7CNglrmL435CFi6ix3oFITygmpvmba17fKqYhf2dywPZmBDqb4vU0IwQSO
         1EdPV9lLszAc3tTkEDEwYP16yPLHiCFSwlH4OuP+iUN9oq20U/8VusxuZ+WQ/ui9znOA
         IyS/we50uToDSjsOmxj7Ay2/DWS7UDfyuzNVCAMXSZ15vNcIJ4KKa6sg5Sk1fBBXa5tn
         WESf3dEl/0GmT9OPAwqmUtIOUGuM2GmtBolCHZMj49l5+hd4SItYbCwMQqYdw7XBk9s0
         Wjtw==
X-Gm-Message-State: AOAM533gjie+tPmhLcoekHkpWEu3LvV2Kq/tPos+tBSx9IO5KvOmEtYD
        4QgiECDv5I76436A6tEb/0RCNQi6xovmk1WD
X-Google-Smtp-Source: ABdhPJzzSibNP//8m79a4+QyQxtsqb2p8kxwEcrgvHcz0JFV17i0ilQqVFq0Rk+vv8wS03/M5JBaVQ==
X-Received: by 2002:a63:9316:: with SMTP id b22mr15675092pge.70.1622321676835;
        Sat, 29 May 2021 13:54:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm7198719pfw.202.2021.05.29.13.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 13:54:36 -0700 (PDT)
Message-ID: <60b2aa0c.1c69fb81.93fec.7920@mx.google.com>
Date:   Sat, 29 May 2021 13:54:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-59-gdb37b08608f7
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 1 regressions (v5.10.40-59-gdb37b08608f7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 1 regressions (v5.10.40-59-gdb37b0=
8608f7)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-59-gdb37b08608f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-59-gdb37b08608f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db37b08608f7db3ccdad307ba1f574697a72e969 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60b271f5dfc9058637b3af97

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
59-gdb37b08608f7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
59-gdb37b08608f7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60b271f5dfc9058=
637b3af9d
        new failure (last pass: v5.10.40-13-g6de4069bb3a3)
        28 lines

    2021-05-29 16:54:56.680000+00:00  kern  :alert : addr:b6ef90<8>[   15.0=
37603] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlin=
es MEASUREMENT=3D28>
    2021-05-29 16:54:56.681000+00:00  00 vm_flags:00100071 anon_vma:c422021=
0 mapping:c1be00f0 index:3c   =

 =20
