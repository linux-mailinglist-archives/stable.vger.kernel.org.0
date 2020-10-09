Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7489228904C
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 19:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgJIRxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 13:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388603AbgJIRxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 13:53:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D20DC0613D2
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 10:53:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f19so7469318pfj.11
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 10:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AgAEZ7sWItuVnIb9ynJJNs8FX8xEsZgoQcQEgt74eD0=;
        b=w5zZXePXDabWvLxyjT2tmEFwS7y4hGLJ5Oh10UWk6L++QuqbZfrrV+htMTH66D9KIl
         8K9hkxfj2g5o7djIr53Odv4tyHzejdPizeCwSwgnPkDXDVnM67Z4vda/4mph/duzLQzC
         TV8Pj2mGCsmoKXnxgbP9hTHgmIO9Qe6V20MsthEvuxRTZX8AJUbmlZ6GQOOWpxBcAJha
         Tz2biVfI2fjjuyuA5TzAS1P1ACEiy5sEnWpQN2biJiiq2Wv22/iAUHNDOd+NT4d1H4c3
         vI4lasS85pW7t4t609tXKDOzd1i5KpwqDhoVRxcf/ksrgdTSonFDrUhwWalGqBcw1L5z
         04Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AgAEZ7sWItuVnIb9ynJJNs8FX8xEsZgoQcQEgt74eD0=;
        b=PnU8TgjdiPeCx36oSMjn77XGEqmfwR7cm4fzZ9bKbRtdqgYRB10OPZGT5MsVmiTFdo
         6ju9HcDNFV4zCmqBYKiVYg1fKOIaplRXKTSK/fU17UP5q4UifxbLrYKR+fVP6BIFGfae
         HS0bwSmD0/LW9rMb6WWIiUh59ARCSLGWO1W4NUaMPsWOn0tLpHPQ2d1wgW0BLVWnvrHQ
         Ub6GY3KogiwidqguGaOsqx6WMWO0UrAE4gu+NBoYvairHBGX4C+5wPXaqm1rekmizSll
         IHEAdQMTFRuwPzlqwM5eBFDjU2thm0h35uDdcGRv8zBnVDcKPhQU7KXQtd53HLgHzpUN
         ePNQ==
X-Gm-Message-State: AOAM531Xtc3fYqGcgXE0f8o4NTHowWcEMgvV+PRzj04sbA+1pNFKBZ1Z
        3fh+PIE2tgp8bHI64YJGgu4raOn3s6NupQ==
X-Google-Smtp-Source: ABdhPJzmO5+R3PCk2mjvFHzA74kv/bBMunDW8FnBml/nH9+j3zZ5w7/QgGa30qc5oKb4C3XPbQBylg==
X-Received: by 2002:a63:ab07:: with SMTP id p7mr1089852pgf.326.1602265981576;
        Fri, 09 Oct 2020 10:53:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6sm12036681pfg.12.2020.10.09.10.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:53:00 -0700 (PDT)
Message-ID: <5f80a37c.1c69fb81.91619.6887@mx.google.com>
Date:   Fri, 09 Oct 2020 10:53:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-21-g648f1d360c17
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 134 runs,
 3 regressions (v5.4.70-21-g648f1d360c17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 134 runs, 3 regressions (v5.4.70-21-g648f1d36=
0c17)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-21-g648f1d360c17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-21-g648f1d360c17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      648f1d360c17ad3bdf2643db30e942f3aaed6348 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f804122bf98b8bfa94ff411

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-21=
-g648f1d360c17/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-21=
-g648f1d360c17/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f804122bf98b8bfa94ff425
      failing since 9 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-09 10:53:13.815000  <8>[   23.208737] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f804122bf98b8bfa94ff426
      failing since 9 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-gyro0-probe=
d: https://kernelci.org/test/case/id/5f804122bf98b8bfa94ff427
      failing since 9 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-09 10:53:15.849000  /lava-2707298/1/../bin/lava-test-case
      =20
