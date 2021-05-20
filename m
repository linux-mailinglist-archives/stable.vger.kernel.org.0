Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB12038BA4D
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 01:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhETXMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 19:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhETXMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 19:12:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870BEC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 16:10:54 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t21so9981932plo.2
        for <stable@vger.kernel.org>; Thu, 20 May 2021 16:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JQZJbypySz+yT5+0M9rf7v1woxQq9PfvFwfhDSLVYeM=;
        b=QjM52zy2fJ31fdWz93U1j2gxExRLrsUOngMBAtfN42SdQC7XYzUBu6kY47JbeGpSpg
         MElljmhZSqqtrNnFkl1WxCDdzbKM/l9BWnpfqUz7XQfeLf2kHe+VIR0NMYHOUeGhdruZ
         rV4oSs+cNrC1+gZbeOhtFVWPaiQUfjxQtfh9CSzFSTo6dVWzgCj18IaSFIy7QuaoJFpa
         T9Up2v/wrCXGFkCZHomhbcQ388wY02PrStDoQwerYIzhXjlcFmJvUiQhNEv0E4UhAWE/
         vLtsrcxRGRQEzFMzO8oqE/zEfaisJfk1VgyCUmgMZfyGTG04IAGWLDcH9zDhuBkfSRf4
         Onug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JQZJbypySz+yT5+0M9rf7v1woxQq9PfvFwfhDSLVYeM=;
        b=ZWtgq5bXHlYLj8jByrFGIhd+QbDCzgDGiOS2n/4scH0JenogJKmt50X+yv+GAhfIac
         ACgyq9Sy1F3j1Fv6+E3/WdTZMNnkdsEY8NkOX59X4P4qpX1bA6DU2ky9Y5z3UhjhcXyZ
         k1mE8h9paQsAiAFPyCYeBV4pJtKj50KJp9Ws6qlwS16Z3jhB7rmhlbToGG+U7FpBLjLY
         4bc68hWMyIEvbEZbFze5fKf2ccvDUjPt1F69PyS9/029xArX9Pur9zW6F3GkclNCVD/E
         rPK7DNEOwQxYeMIE8Ggs60Gj0tzsVdkSV4zjMLSWxxXsubzt9e9+Bj83v4dCN4JWQO8b
         GG/A==
X-Gm-Message-State: AOAM533lR0FhZfIanBsI3hQBDnzqH6V3QAqd8N/Shc+lMnPVoEmMBy3M
        cw+n15NRsfMO5dCN94RSeC+hWz913nw0C3M/
X-Google-Smtp-Source: ABdhPJwK2j6qh6UTxrLIhfKHxqjByjJF9w7ZmUqYyTSUCQILqLG9Nf6pMnZNvmXjSB2im5vP1W+Xdg==
X-Received: by 2002:a17:902:d4cd:b029:f5:4ec0:d593 with SMTP id o13-20020a170902d4cdb02900f54ec0d593mr8629133plg.19.1621552253848;
        Thu, 20 May 2021 16:10:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm2465251pfv.60.2021.05.20.16.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 16:10:53 -0700 (PDT)
Message-ID: <60a6ec7d.1c69fb81.84f34.9564@mx.google.com>
Date:   Thu, 20 May 2021 16:10:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5-44-gcb074cc567ee
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 154 runs,
 2 regressions (v5.12.5-44-gcb074cc567ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 154 runs, 2 regressions (v5.12.5-44-gcb074cc=
567ee)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.5-44-gcb074cc567ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.5-44-gcb074cc567ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb074cc567eef7b8b8cf3e23f7a689c5a7c1ced5 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a6baf0a571f91307b3b022

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
4-gcb074cc567ee/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
4-gcb074cc567ee/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6baf0a571f91307b3b=
023
        failing since 0 day (last pass: v5.12.5-45-gd771f12f8049, first fai=
l: v5.12.5-43-g6d16d79b1eab) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a6bb28545a27538bb3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
4-gcb074cc567ee/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
4-gcb074cc567ee/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6bb28545a27538bb3a=
f9d
        failing since 0 day (last pass: v5.12.5-45-gd771f12f8049, first fai=
l: v5.12.5-43-g6d16d79b1eab) =

 =20
