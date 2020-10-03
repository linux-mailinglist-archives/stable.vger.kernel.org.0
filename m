Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A4282292
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 10:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJCIn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 04:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJCIn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 04:43:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47681C0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 01:43:56 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id e10so2563580pfj.1
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 01:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H27pW0j6wv0Sr8eummAQjSXWsbmID0UjMvqEoSPkxIc=;
        b=fVZUwqLZUaz0x7bZvuc7yoQXLo7m7dZb9FVnNJnqAisyk+qvm347DM1wtQGrJGxuSO
         fBKVB11JGFasfiZ/vGXgzzQDyrq/7d8v7qq1CXoHbQhYFLgajzG+fukKYBRdqsZZNiUF
         R98e2ASYYsTQMEeKnzezhZEw2UsNS5HNIlWLEVruDsHZ8TopD9R7tEK+qeVxAE3ZoCbY
         rgdTz+ON83xq3UNraEmDy4c2AVJ01kyHT2eiYP7U6DzrDtMF6W29wXwmYNT2VLLUpOeG
         V2P/B+/S8ATah6zFxMq1hmtSfgUiREHlJAco6fR8aoQzX468kS9v85P8j0+yYBMK0Bpl
         7GOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H27pW0j6wv0Sr8eummAQjSXWsbmID0UjMvqEoSPkxIc=;
        b=e/ZMvPZQ9wDJjmngYh2qXRsJ8AluYX+KE65eyni4WAq+bpyK9j5xm70U52GeqwEqq8
         fcIQhcBtx3C+gZIiKhlLkCuyRj9CCqxMTPtGsBc6E1V0D91+XlJM9/HiIBcc/secxG2b
         7ChszcyrkL8+c5jKtq2n610z1a+wxeTkUyEDmn7n4XTW5LBTQ9rjtm4VuA2yQ6o0+HHK
         /w/qcy+oOaN61GtIrra74c2gwYvqktHBZQCDH+DnpuwsLPBYjA0K2wyyhfMTkdGKsNyB
         hh5c9pJDbggCV0A8zJI3Z1MSudHEP5eLp3I4FCnPkvcuBA+CzBskQSwgswiCgqqdwR47
         b0kw==
X-Gm-Message-State: AOAM533XFaBU7CrNu8cxgPFN1PXilbB/K+pq5cA2H20bInlKvx2GIlyF
        TKqOQukHc/yBTEEoBrQDRyz6N4rILE/Hug==
X-Google-Smtp-Source: ABdhPJx2/rA9mUJqd3py57pCMnwfH7aGye4MGEv3KQuAwWa2I2oq7AbXMyI5jxQsibKBcG2JSCV8rw==
X-Received: by 2002:a62:7a0a:0:b029:152:192d:9231 with SMTP id v10-20020a627a0a0000b0290152192d9231mr6663856pfc.61.1601714635332;
        Sat, 03 Oct 2020 01:43:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm4632966pfj.44.2020.10.03.01.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 01:43:54 -0700 (PDT)
Message-ID: <5f7839ca.1c69fb81.af565.94a8@mx.google.com>
Date:   Sat, 03 Oct 2020 01:43:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-3-g5db7987ad439
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 133 runs,
 3 regressions (v5.4.69-3-g5db7987ad439)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 133 runs, 3 regressions (v5.4.69-3-g5db7987ad=
439)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-3-g5db7987ad439/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-3-g5db7987ad439
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5db7987ad4394662c453210dcd84c8bab83bb2fa =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f77fec6d4c19642b74ff431

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-3-=
g5db7987ad439/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-3-=
g5db7987ad439/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f77fec6d4c19642b74ff445
      failing since 3 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-03 04:31:51.183000  <8>[   22.892976] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f77fec6d4c19642b74ff446
      failing since 3 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-gyro0-probe=
d: https://kernelci.org/test/case/id/5f77fec6d4c19642b74ff447
      failing since 3 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-03 04:31:53.217000  /lava-2684488/1/../bin/lava-test-case
      =20
