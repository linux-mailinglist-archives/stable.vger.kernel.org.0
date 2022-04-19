Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48837507A0E
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 21:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbiDSTSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 15:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbiDSTSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 15:18:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7343BBF3
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 12:16:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id md4so16319851pjb.4
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 12:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yNhYC3FtkN52sj/ktFlkNG1F3PxfDDNH7E4xDHCM3Og=;
        b=353ERwzodfU64p1ubxI6UsmwwucJ0TdUZxArVBnu59wK3rliwJoVFOIWYpWxkCMBNb
         X2lcjIeY4PBh5jZUlSJTqbmu81ItOD0l9tGA5Vo/THRFnPOOimTw2cnfRcKHzRRY0IRI
         1vN1ToVIkZ8ih6c61fTLWbBf+IvdtQKNBp+Egfufsrqld+lDDV1rCnBJvufb0/gHBndi
         AZ0feDffUjJO7kZZwU0ntkrZf3REBRErhM1Yk9MAdiGOHev45fsQa59G64iPVEgbErya
         PRt52svn2Mnu9Zw1P/xQHVpaN3T/VfARDB4sFwNiQNy/LmoXUTc/Prs/5mrezbufzV6o
         11Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yNhYC3FtkN52sj/ktFlkNG1F3PxfDDNH7E4xDHCM3Og=;
        b=VHZmotyf/4bVdvhd9oQ2mlYzVRgHKw8oCKErguwwg6uYgIMAmkh8OHDsnbhMQwi1Nr
         cZClT+1AZT2nAoc4lCaMn5GYEZdCBDn0ygVUZxyuc61KsDghIhjQ8Pq2F02U0nDrahz6
         wIFMnO0qYhEijztJ1qCZoFgz1ys5ik21lVVoRIkcyf35w6bM8xOg2l7r7/xVTGMh6nrM
         CUgYreRMaHYtFc2Vw5I0+q+1mfxCqcT+cta3mgydSh4RnT+dLf8MeyzWDPPizMU112JW
         ITXDix2dFsHS3dX+VmL8bVzcNX11bxIJ8YN5ZeLVN98zUrJ6cksoBIL0G3dieO1UdPyr
         Wfjg==
X-Gm-Message-State: AOAM531Bw3rdGnnFwmJwHi1antSLmANL2aJ56AYtOcMMB5K3ymNLCezU
        4K5zex+tKibnVXHdlHpV0Jic3fsfAz8lHsmS
X-Google-Smtp-Source: ABdhPJy88oU7Qbc9/bsDrHzErgPTS+NGmRhNbN1verymqHjIWo9oCpPL00Hy5ywcMXjod/jyFV9uXg==
X-Received: by 2002:a17:902:a610:b0:158:9fdd:332a with SMTP id u16-20020a170902a61000b001589fdd332amr17378226plq.94.1650395759698;
        Tue, 19 Apr 2022 12:15:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm18525228pfh.177.2022.04.19.12.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 12:15:59 -0700 (PDT)
Message-ID: <625f0a6f.1c69fb81.ea025.af10@mx.google.com>
Date:   Tue, 19 Apr 2022 12:15:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-284-g877ce30db10d6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 92 runs,
 2 regressions (v4.14.275-284-g877ce30db10d6)
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

stable-rc/queue/4.14 baseline: 92 runs, 2 regressions (v4.14.275-284-g877ce=
30db10d6)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-284-g877ce30db10d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-284-g877ce30db10d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      877ce30db10d6b7e0ad579ad7fe8ff0b964bc0fa =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/625ee3b8619d076481ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-g877ce30db10d6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-g877ce30db10d6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ee3b8619d076481ae0=
67d
        failing since 13 days (last pass: v4.14.271-23-g28704797a540, first=
 fail: v4.14.275-206-gfa920f352ff15) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/625ed93ea78715edfaae0689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-g877ce30db10d6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-g877ce30db10d6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ed93ea78715edfaae0=
68a
        failing since 65 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
