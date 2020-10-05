Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273222833DC
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 12:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJEKMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 06:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJEKMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 06:12:52 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B42C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 03:12:51 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 7so5687822pgm.11
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 03:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=slcmBax7hy2UDH3m6kY/MwgvkdcIMJxJhsvgHSQbrr0=;
        b=ZaLl7gCnJnihoeMVcI5zIhrq0iJLxhslc068um/8HURmgBGExkdtwE0iqhxGdm/3iF
         V/MyWzv9FtGjexxgJSl9/G7wBfXVMHrmKDFeC075yaOQMvnbu17Cn1AsuXHjcNaRtPRm
         87LQNJ7+jf+3X6P8dAtXCHQdooZMv3zcEkYWsDO+iCg+ReZoJ4dKEQ1Z1GgFQyTzetSx
         opG9ZUZ8DqB6swmpv71v4H7eOhmLC1g+0rpuX9OLp9LsNpzkCU8wv9749M0dgNhihmG/
         yorc+nj26Pd/047iihPUoy20s3uG5dLSBWD3Mt5jCO+DA7478QSbECTgg9r/GINFEDD2
         ktyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=slcmBax7hy2UDH3m6kY/MwgvkdcIMJxJhsvgHSQbrr0=;
        b=BNQimh1Bpi2iETYzzk5W9GcTJsNUmIqdHzGFf6y5emKPtfFYgn1/QX+pGhi+A2T3vn
         qb/FzjZK6XVE2rgUCRQDJ8duHJBJITW0Wh63CimPhqMuLIg1eoUbz/inslfJY3EtZ3oy
         OHW54pSzl+MfKH1Vc6G3QEcIvkf/WN6Fv3FBR9GdE2cfpiWRqeM2JktMGj6cifR2QhNZ
         6ME3ab9g1WfIoEYUVU155f+OVlTdcg02tiuXeooktwyaS2EnrFl4aFdKGoy5Qd6eYVjM
         0FHOPBMPgz+kMTj2lqQGcE88DC63Mnz4LP319qk2pVH1YPzDqtFz4Kcx1n/RT18Ulei4
         Nrzw==
X-Gm-Message-State: AOAM533SpnE/eNc/kdUvHaFz3zbeVmIpwYiRlggLNAXueIwIsH/D/+PB
        QIEPEJe/JlF2UEowftS59/rEM/kO/JIUhg==
X-Google-Smtp-Source: ABdhPJyDU6ewFwcaAT1rLr8oeE3LWr4FeQcR1/RNmmGsRSCmBJK51gyDQjFBmf2yvNAyJKAuHUHq1A==
X-Received: by 2002:a63:4f45:: with SMTP id p5mr13583767pgl.341.1601892770652;
        Mon, 05 Oct 2020 03:12:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n19sm2591972pfu.24.2020.10.05.03.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 03:12:49 -0700 (PDT)
Message-ID: <5f7af1a1.1c69fb81.270d8.5908@mx.google.com>
Date:   Mon, 05 Oct 2020 03:12:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-46-gcda98bef2fcc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 65 runs,
 3 regressions (v5.4.69-46-gcda98bef2fcc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 65 runs, 3 regressions (v5.4.69-46-gcda98bef2=
fcc)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-46-gcda98bef2fcc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-46-gcda98bef2fcc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cda98bef2fcc68a2ffc1ddc187a241d476489a08 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7ab8ca3081251dcb4ff3f0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-46=
-gcda98bef2fcc/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-46=
-gcda98bef2fcc/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7ab8ca3081251dcb4ff404
      failing since 5 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-05 06:10:09.940000  /lava-2690345/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7ab8ca3081251dcb4ff405
      failing since 5 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-05 06:10:10.961000  /lava-2690345/1/../bin/lava-test-case
    2020-10-05 06:10:10.971000  <8>[   24.321862] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7ab8ca3081251dcb4ff406
      failing since 5 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-05 06:10:11.993000  <8>[   25.343717] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
