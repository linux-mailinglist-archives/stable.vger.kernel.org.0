Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9C361205
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 20:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhDOSVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 14:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhDOSVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 14:21:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DD7C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 11:21:22 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w8so13147004pfn.9
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 11:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ob56genv4AH5yR/MP7P5ReliOZCXcn3fwXxZqZ3KEC4=;
        b=mO/55IERUgoPRJq0TKh6tuIaObD94L3y+7fGNeI0QlWYRZY0aZKbcqV+BaWm1gyUVn
         9XFL/KdzwE5zXwftfEypfQC2WljZ9F+Xi+HQVyDU5Xsfqdt1uoZ7D2V1iyqQv8+NmGMD
         Vdu4QMJNCoJti6SVMV3hxyAVLx5mdvxpxhz7leU7ErB5fRF3gquexbJpBUdCvLVaH/MB
         MXOzi83heaHLrk6JMTa8f2lesSzW3Q5ZioZ7ucjTeVPrMSvG9v4U4a69Zwk4+WnRcWMW
         mz1m0drjfTZGQGjhV+b8ax3IeXF/eUYlZ33yMsYTt0mtJdLCOQibZXA3NY5RLKgZppjl
         nmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ob56genv4AH5yR/MP7P5ReliOZCXcn3fwXxZqZ3KEC4=;
        b=QyQQntREpxVClwtDmKaMPJWCnjx/pGm37x42EpOFDl7A1AytpQotLOeGkF8WvLc7sr
         GGY7afJHh+P0/VyB31gI863motbyKJyC7HqNoYbzL3VhWUejOZBjExUU5OShXS+4G04u
         u7hgLM7nud4yf2Qs6PRry2/U4woUoUhhhLRAPNZyCoE2IjXh8F5TDeYKeYPZiYGZksEv
         qeVZZX1Oo5lxjpdaUOvt5D7mbY6Qh25riCGSP5ilaKO3cY/j7g74Q8k95b332hg46lhc
         iyMx31e4AJFc2fNklXb1s570LPBlLm5y6CehRkC9oWxzykFPvZnlgA4ZB1+x/Z7uBUFk
         6koQ==
X-Gm-Message-State: AOAM533dMbh1KHML/Kb6q4+dySiApv32k0Afg32Y7sjWj/cUwvrX7pTp
        SVhPnn6mBotmKaPF5s9/yTp26Dzsppfj8Czs
X-Google-Smtp-Source: ABdhPJx0+P4z0MMk6SGoXdraUiGwIprRYQ3NVBZyN/nJ0rZw+4tgNHjGS8nTJdHZcvixTiaAQABlEA==
X-Received: by 2002:a63:aa06:: with SMTP id e6mr4532398pgf.178.1618510882026;
        Thu, 15 Apr 2021 11:21:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r26sm2885402pfq.17.2021.04.15.11.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 11:21:21 -0700 (PDT)
Message-ID: <60788421.1c69fb81.9e06.80fe@mx.google.com>
Date:   Thu, 15 Apr 2021 11:21:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.112-13-g51e09bcd216e
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 148 runs,
 1 regressions (v5.4.112-13-g51e09bcd216e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 148 runs, 1 regressions (v5.4.112-13-g51e09bc=
d216e)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.112-13-g51e09bcd216e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.112-13-g51e09bcd216e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51e09bcd216ed1f65062aa8f41353c1363125058 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60784ca50088821aaadac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.112-1=
3-g51e09bcd216e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.112-1=
3-g51e09bcd216e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60784ca50088821aaadac=
6b7
        new failure (last pass: v5.4.112-12-ged8d92bd8985) =

 =20
