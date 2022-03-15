Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7B14DA42A
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 21:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbiCOUo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 16:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiCOUo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 16:44:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4503111155
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:43:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p17so114517plo.9
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yxjdn/ayAL1ZNC9PTR76WcRnTWR3CwOriUZbgMnWU+U=;
        b=lmVmzH8nQjPClIr7NARwegUE/AlrOFSyr79d8C/1eWI78fcJoImXS0IpAREafhWIeG
         v3vuayRXSwMLiXNBa4hMhudVp7ygAJYTJ/Nbxp2pLbq+fnWlGa4X3Gfi0lXQT3VRoiPz
         Y3Sp/MRGLwjO0k94K7EuryQVVJOYezJccDwlLaP4YAIM1MpJ6Ima3KlR/7PBXKeN3iWJ
         yfYctTRyC2zt0I5w2ocznWawwFGIWIMVZpq4ypIvM8cPaT6R3B5CUkdG5rroaLZBhI3w
         lGiZkNuxLDu26F6ri5NJ80ns1aIXyAMWDEdQowLaZQVHwOLNgJ40ZJo/arVBqOLLInbh
         fSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yxjdn/ayAL1ZNC9PTR76WcRnTWR3CwOriUZbgMnWU+U=;
        b=Lz/XHvS1am2qZsrXypC2Ah7RchpiVvcR6ZgdY++tgi01iwkqespmx+WbKAjx8v/Kwi
         z80bL+YdUj/d19Hd5OjhKF7JaC36oh7fCm6K7uuRV+HndfQWBf9t3u43EkU97mZSFIa1
         qZI+zOp8/crJO18ITwR5aZwbyfruOKb4ZJ5h/UpjRUO4/RqcONMPxEQ1saL6dJNQKIqR
         w4ewkyJhGnOeEOLxHJJc9msJnkc/2B7TCQZmVeQH2sU39ONdJM9JVO+vutwy7yKh4Bbs
         KHV7Dp5hzOzRIwNfQ2ykKO2ajczA3sBQLNq5qzNZWsNxzz/2I4c/4TDdQp8JZ2EKUihg
         328w==
X-Gm-Message-State: AOAM532w3chZgc5lBuabpUXwBdzpnu19YYWgvoKx03+VbKK5ncY8Ng8J
        2RZAFrqEqSkW3vpuPkl4D0gPiMTselB+q39Ijvo=
X-Google-Smtp-Source: ABdhPJw9Tvs59i9Eb8x7Qa39ciLD0b1GFO0NiDEl7RKqcfBcWiA/oaqL5pYOABlZ0iuW78sUwdMTlw==
X-Received: by 2002:a17:90a:2c0b:b0:1be:da5a:b294 with SMTP id m11-20020a17090a2c0b00b001beda5ab294mr6616629pjd.9.1647376994572;
        Tue, 15 Mar 2022 13:43:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hk1-20020a17090b224100b001b8cff17f89sm84428pjb.12.2022.03.15.13.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 13:43:14 -0700 (PDT)
Message-ID: <6230fa62.1c69fb81.679fc.0529@mx.google.com>
Date:   Tue, 15 Mar 2022 13:43:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.105-71-gc7516cfcad00
Subject: stable-rc/queue/5.10 baseline: 100 runs,
 1 regressions (v5.10.105-71-gc7516cfcad00)
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

stable-rc/queue/5.10 baseline: 100 runs, 1 regressions (v5.10.105-71-gc7516=
cfcad00)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.105-71-gc7516cfcad00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.105-71-gc7516cfcad00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7516cfcad009215a2372e61271b68dcb7c87801 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6230c97db2c8e0e25dc62976

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.105=
-71-gc7516cfcad00/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.105=
-71-gc7516cfcad00/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6230c97db2c8e0e25dc6299c
        failing since 7 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-15T17:14:23.479246  <8>[   60.191419] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-15T17:14:24.501287  /lava-5884294/1/../bin/lava-test-case
    2022-03-15T17:14:24.511888  <8>[   61.225342] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
