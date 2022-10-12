Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B5F5FC72D
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 16:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJLOXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 10:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJLOX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 10:23:29 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6A9CAE58
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 07:23:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n7so16410952plp.1
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=V7sNxjMfjrfoGVIR88rHQ8GpTjbWZ5Dyitx2gQerPGw=;
        b=YJbPMqVM+e/NkW7L2p16RofV+WVxn+HNGVfrtAUBOi2Yw79MGcSDJcetPqpCuJsfsh
         RLxHRtTesVXNDqin/KXxHI7xnkSkyrOz0bRYVREONuZUgoy3VrVci18EGWxGMj/CN769
         QbKwdsDVHEjfKs3NK61deT0ry8VCkAg/2BjjrsZ3ptoR8rdFMG8XuzWYRB9Ujz52FW9f
         wplj/Us2SfciishvfHJZQHl/8IaaT9Gxyy8tJuPyDqLuVGWqqBhiFD1oyPjs9ChOCbS1
         4MrJ4vob5KVM2n8HjjTffQQsE8hqV+QsBwB+0YC8RYVASkIH2wXcJnp5To0m/wsIlUt0
         be2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V7sNxjMfjrfoGVIR88rHQ8GpTjbWZ5Dyitx2gQerPGw=;
        b=K+cX2Gk+4/kgmZ+zkuf4kpbJV8zeaojUW9Ws8zjc4HQ39cKjqkeRxbKgL62kKMiYbd
         jPcn+foeBW2FOYwxcTyHJZOlunCl4MEamYWoxXVK8xUVdy4vMWcaq99xKpAgpAEodtSV
         HOWvROBUzGD4HBH33ow8t0c1I5cd0rMxwyA5yNEvVhbAegosCOfS3WQZ6DuhteahTRP3
         ClljfpKqbs342psNIq2aZPw0IeV4ZtmYgV5eps2WWbiUw6dALwRVbuTx1kTWzTSwMEAK
         uoj9+3dt1nbJjLEX01pKFbzyBDothS9D89c2DPeJlYpmaQpLYvclWHQhs/w+mnvq5Hy5
         jtwQ==
X-Gm-Message-State: ACrzQf0SK74IfCt7EckokvJRER+hbQnumxp34Up0JFdOd7IDM7MAn+fY
        0AN74VECyzaeaxeU/je/uEizjxhqEmsD6fW9iIY=
X-Google-Smtp-Source: AMsMyM5tlzTzh3pz/1nmqHIUx/az55PDQ+2okaGiU9YwBBNILE2jsuh+cuS/xkIgkHORCv1Q73JJmg==
X-Received: by 2002:a17:90b:1bd0:b0:205:ed0c:7e84 with SMTP id oa16-20020a17090b1bd000b00205ed0c7e84mr5589528pjb.234.1665584607497;
        Wed, 12 Oct 2022 07:23:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b23-20020aa79517000000b00562eff85594sm9106824pfp.121.2022.10.12.07.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 07:23:27 -0700 (PDT)
Message-ID: <6346cddf.a70a0220.42175.f55b@mx.google.com>
Date:   Wed, 12 Oct 2022 07:23:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.73
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 111 runs, 3 regressions (v5.15.73)
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

stable/linux-5.15.y baseline: 111 runs, 3 regressions (v5.15.73)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.73/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      17aac9b7af2bc5f7b4426603940e92ae8aa73d5d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/634694d54ea40a2e96cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.73/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.73/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634694d54ea40a2e96cab=
5ed
        failing since 13 days (last pass: v5.15.67, first fail: v5.15.71) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63469b2a837cce819ccab614

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.73/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.73/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63469b2a837cce819ccab=
615
        failing since 6 days (last pass: v5.15.70, first fail: v5.15.72) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634696dac67ee506c6cab5f2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.73/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.73/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/634696dac67ee506c6cab626
        failing since 217 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-10-12T10:28:25.207771  <8>[   59.820160] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-10-12T10:28:26.228596  /lava-7562799/1/../bin/lava-test-case
    2022-10-12T10:28:26.239685  <8>[   60.854085] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
