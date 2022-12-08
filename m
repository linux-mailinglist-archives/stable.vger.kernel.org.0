Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD564748D
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiLHQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiLHQq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:46:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14AFAD990
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 08:46:27 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k7so2034110pll.6
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 08:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz9br7CCmYdaRVra/T+VWbq/ow/DXjTJf6Dvdo3pC8s=;
        b=a08uMU7Eis98qZvgpbYizvpjUZKrgvwNcwZwtfIiiOyyKnxuKURpl6RqcWH2hdR5kb
         X9owL7BovKsTqVdso6Q/U38kbTVe2GpLA/VNrn7/7hTir0DAIjMQgiWE3CHN0bP495bb
         tSPeV+R6YnbbnVExZw/Upb14CpKgZTxyHgYW9Syqjr4XxECNhMRb9q2CxNUb6me0tT9f
         I4zBdi5zsSZM+pCkFPOcdpbBO599bL7p0ZAgRDksUzFguHnf3Oia49u2XF95eWH2zx5u
         bPOn3bb0Jj9zU173TxDx3AOpf6WDrP4y3DDagOmyHZG+AEDePR8UVVl2jzng5NWQUsQn
         qF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sz9br7CCmYdaRVra/T+VWbq/ow/DXjTJf6Dvdo3pC8s=;
        b=31p3RCcyft5bgEAy3rLHCF1T7PV+d8uo+SUddb0Etk+kdgGY0nlO536IOCCfi7m3XQ
         rCNdWRIJJQp4u7Y6sYtthqXCuuXvy7OnawL584xiFYkmIg7KM/LfM/Et3tDJWok6VEXM
         qDuAyYLD4CNkXKsVEap/81kidFlu4an+36QMQIy+pPjlvaDNh52hJjXwPNJKsNwgQKaG
         Q1bHTtQN5VBl6oNYDZvzr9a7InJf6S/L92ecQn/1112Gx/GsuSgFIi6aZHEyp5jTQtIo
         K/Fjjm58SHjFjlit4Dz+fjg+MmrH2xiI8TOrkMPCmIIK5M3jZenSf0uPcCsVN4BOIfoG
         uunw==
X-Gm-Message-State: ANoB5pnXWgNZ0Rsi3uEe/hLk52DnuDEK2JyNhpjpnH/cPcLtmS1zRQbv
        kulWLzaTjCLE5+ir7oKMVRszi/DDXUckBsJuHdx08Q==
X-Google-Smtp-Source: AA0mqf4sj7Uw3OY+Y8FKahyw4tm87WzjAWWX7B4Q55K24LNydiQM8WlMPHYr5vltUW7UEPXjYUcVAg==
X-Received: by 2002:a17:902:9891:b0:189:2688:c97f with SMTP id s17-20020a170902989100b001892688c97fmr2541448plp.50.1670517987093;
        Thu, 08 Dec 2022 08:46:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709027ec100b00172973d3cd9sm1416880plb.55.2022.12.08.08.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:46:26 -0800 (PST)
Message-ID: <639214e2.170a0220.555e6.2902@mx.google.com>
Date:   Thu, 08 Dec 2022 08:46:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.158
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 162 runs, 2 regressions (v5.10.158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 162 runs, 2 regressions (v5.10.158)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

r8a7743-iwg20d-q7    | arm   | lab-cip      | gcc-10   | shmobile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.158/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      592346d5dc9b61e7fb4a3876ec498aa96ee11ac8 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6391e528510aec6d2c2abd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
58/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
58/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391e528510aec6d2c2ab=
d15
        new failure (last pass: v5.10.157-97-g8dca57ec68a7) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
r8a7743-iwg20d-q7    | arm   | lab-cip      | gcc-10   | shmobile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6391dea8368ab984902abd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
58/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
58/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391dea8368ab984902ab=
d2d
        new failure (last pass: v5.10.157-97-g8dca57ec68a7) =

 =20
