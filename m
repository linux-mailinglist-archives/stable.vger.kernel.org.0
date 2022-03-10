Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955D24D44AA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbiCJKdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241453AbiCJKdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:33:36 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DED1039
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 02:32:35 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p17so4458642plo.9
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 02:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3kHPeSWZye02uNdw8VokCO5nuEz5DMpLh2CFMS9symQ=;
        b=s8yfm+jUzwvvt9MBU1TqpNYVPFJkgL527/jf31niVXrQMjQYaon+4FjfAVFCwWfzV8
         Z4EtFcKkoNqDh4pKazjXJpObyy44Gz7QJ8uPQwpi3fUoruWBltvRw1XcaT/pQ7ZF+qkS
         PXqfgCqArDZ6eEKcWW02sKaB3/6xm9dcALpH581ODeilqmhF16PZaYNxHIr7vwGhI9+w
         V/u15LoKk/pFwdeWxnsd9Rr0TZTv+KDZLh/UL/pXjX0uVAAnKC0G+KHS3Ng89WKyCwFW
         YMsUNIXHfs94vzHCLRsd3CSBVRqo5u/iou2h52h0ujE+pjOINHCPpUXWpHjc1Hjsigl/
         fZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3kHPeSWZye02uNdw8VokCO5nuEz5DMpLh2CFMS9symQ=;
        b=xDUb9p7Z/4Bt+0B/ZZp4tfM0+9qEUVPNB6ma+B0HGzk7uR6rxrIABwUGZsF52C3y41
         7sxAhNXiS04X4tplruud/2H5aX7ZFRC+fw5rj43WN5jp5XHiEBdpJLa+UC3iF3fTP0Go
         /yJ3cXuMRYcfcqEkwqcg/TVDp1cUMxs7WHuxZ67HQ2R29EiKdcQUfchkgIivmW4Kjptp
         v/FTQ9a0cm8zzME9l3qiwXOxGO5E8rkIC9MnoIudr0iNoVVQMmi0RH6icDEnDZ2l8+1g
         gRcGcO7ZjSaQXOe8c1SoyobzRb1i88Ts7TKpxEQ0DLCttbj2/yABip1RhpanOfV+hkCx
         f9Mg==
X-Gm-Message-State: AOAM533DEuH6A1mrB222h8+6y1mQTeU2SNbh9qocDl0ZMjow9OaU9JFE
        Pbl2BqfqszVaztBXAHnNQltUrw4wnf/27gBE9OM=
X-Google-Smtp-Source: ABdhPJxRkJpD86Csxqd9ShIMSS+SYSnQFdISOKg5Eo1d8Pxn7Ztrouc9QoszPWj8iMXo8Ryu0gBJOw==
X-Received: by 2002:a17:90a:6001:b0:1bb:83e8:1694 with SMTP id y1-20020a17090a600100b001bb83e81694mr15179908pji.127.1646908354537;
        Thu, 10 Mar 2022 02:32:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14-20020a056a001a8e00b004f75cf1ab6csm5765960pfv.206.2022.03.10.02.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 02:32:34 -0800 (PST)
Message-ID: <6229d3c2.1c69fb81.67df8.d7d2@mx.google.com>
Date:   Thu, 10 Mar 2022 02:32:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-40-gfeaa4f8b8a32
Subject: stable-rc/queue/5.16 baseline: 100 runs,
 2 regressions (v5.16.13-40-gfeaa4f8b8a32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 100 runs, 2 regressions (v5.16.13-40-gfeaa4f=
8b8a32)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-40-gfeaa4f8b8a32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-40-gfeaa4f8b8a32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      feaa4f8b8a32fa375834f45014eacef7c1a47fa3 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62299d606d5346108dc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
40-gfeaa4f8b8a32/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
40-gfeaa4f8b8a32/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62299d606d5346108dc62=
969
        new failure (last pass: v5.16.13-38-ge6347addcf77) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6229a2d32c4dae1ff3c629cc

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
40-gfeaa4f8b8a32/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
40-gfeaa4f8b8a32/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6229a2d32c4dae1ff3c629f1
        failing since 2 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-10T07:03:29.792045  /lava-5849911/1/../bin/lava-test-case
    2022-03-10T07:03:29.802790  <8>[   33.442859] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
