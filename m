Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F334899A7
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiAJNPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 08:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiAJNO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 08:14:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9655AC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 05:14:58 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p14so11856604plf.3
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 05:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F6qy+NH/OJoBDMlKGMclyfnnuqWUguOPNjS3OTK4JKw=;
        b=D/wfg0k4V+J5PiWgDv1aakqi6xhrrQ0LP4lhhRTwI1PAGmGe4p3i0VGKsF7ytMQUUz
         JF7qtLnikE75DmHx2zX58v53h+tHmsVxn565QeaTOVN1d7FWHMClAXyhLU15CI5krKYs
         TtwEQOhlpkB4lYo9CetDO5AxV9kH7Z3uuG4Fv7gs/mR0tswJVTE8lTGem/aIjgZN8Jpl
         otknx4p4WUX+InBkicMDF3Bi7LhJsiunCmyWhhkcB3KAKvZvYscWKm49sAYun5JxD6Ev
         kqi0yXq2x4zGs7iABEdzm4+pR7QM73mFyniu7BIR+bcsqnu4JBOEfio42VzV83/0MBNq
         I2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F6qy+NH/OJoBDMlKGMclyfnnuqWUguOPNjS3OTK4JKw=;
        b=p2o2fRBUWEhiCKNXVQ3EYif+8JonY8IX08bVix3VDff/7uzJdilBHYbLCWAnf1t6mg
         ioleuzctiOLAhcUdy8zOPhvxW1efos763NLWoN0UrF3TWfmTFiIEsiIsDKjmS+Qxm0uE
         wlTaIq+GBLJU/vIVIaXLhQ1+6uJZldm0WQsP29mDQp0Dmedb38Mk5tZJg2BQXAH+Mx6O
         L1zhT75PZg2Qgbeu0jlqqYycmRVKVJQGVGcTdcF5I08/y6vbN+857gU5CdwA1yGMwJ5F
         gCKHjOWCnRCZy4iaurhuDgxjRE1BhcSnIlCDL/gdJNWEG/KnUwO+KQMAUZc4KBxl/4LW
         KxEg==
X-Gm-Message-State: AOAM5320wD4fOsue6sIPin5FaRoNkA5kptGKiWscNANTgc/KaDXfBhY4
        CsqEQ6nFUXl/JVYfvvBvwqeyFm3NLz4SQv7T
X-Google-Smtp-Source: ABdhPJxlgftVeILZjM/8sGWpqy5yyL/SR0wZHn4Mcpy23Tof7a6AUWSSlm08vVz1NPsVrxrGM7t4/A==
X-Received: by 2002:a05:6a00:8cb:b0:4bc:3def:b616 with SMTP id s11-20020a056a0008cb00b004bc3defb616mr51101559pfu.18.1641820497988;
        Mon, 10 Jan 2022 05:14:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kt19sm1294217pjb.50.2022.01.10.05.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:14:57 -0800 (PST)
Message-ID: <61dc3151.1c69fb81.a067f.247c@mx.google.com>
Date:   Mon, 10 Jan 2022 05:14:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.90-43-g08564451eca2
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 144 runs,
 1 regressions (v5.10.90-43-g08564451eca2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 144 runs, 1 regressions (v5.10.90-43-g085644=
51eca2)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.90-43-g08564451eca2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.90-43-g08564451eca2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08564451eca2d5fbe28bb52be02a372cf91165b0 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61dbfc8d950ff4d603ef678d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
43-g08564451eca2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
43-g08564451eca2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbfc8d950ff4d603ef6=
78e
        new failure (last pass: v5.10.90-42-g2497db683e3d) =

 =20
