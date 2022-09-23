Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888CE5E82E4
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIWUFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiIWUFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 16:05:33 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50FA10E5C4
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 13:05:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q3so1015800pjg.3
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 13:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=bg8i7HV2i3whGo5IQs3kZXgEgXa3KcSx3MqF0nUzY2s=;
        b=B8YYIHfF5oQxbUDVTBDxBZFLEjbvURs47meVjh31cyP2DUsaJ1gxIz6UPf8pLoWvB3
         DmmtR/xipuOvWvBd+mGdivDzJUzfeqISf/2w0I19GMSDasUx+lBi4RpQSHoh0bSVpTxM
         7TQUY59DrULCqdQk4GgbLmTx4pd5csOOJHlM7kG8czjrF0h/cPLYR2QeUnmMu3114N60
         3DpmMdxRH0BUz02FFmp06AIevZ9YJafbUE61+VOPxUlXynqonbPjMo7R7aXbv3dgZtkf
         Z2yYRL2RHx17jPXU/mNnkHgOwERv99BQco7TVvrwDmU2xLK9en3W98h8gNS3c3I9fVzN
         8RkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=bg8i7HV2i3whGo5IQs3kZXgEgXa3KcSx3MqF0nUzY2s=;
        b=r/8Z+Aa160FwvxVxefVEJI/Dxna4Xq+gUrnqlLbND/c26d6gS8rwlXuM4hw15lE/SU
         KCMHLb4EkdZGNz+z7/S4EahACoXJu32GlXK55sn9J1t7iZ9irrZFEQQrMOGMhDgkSgvq
         Vubeg+Wv6APjDOrf0/fzUlMJ/Bh/RoH69ZLji5dgBq7X5+3IrWdiZ02yJSJqsiG/+3W7
         ZXkurBvtEM1fEk3VFeqTqIvd6ZiYADLnGpM2gyjMt55I4r6wVMD7FdB3dbaqidRiGhTv
         X3+BhbeY2KUxzPSL4IGP55ezTwFQuq5aqfm/VLgirsc1goemsBEn8b7kVSlRrLvVdjbT
         oEpA==
X-Gm-Message-State: ACrzQf0ul3Cn+XEJiTFPUgb1zOFTXWgAvXSBX30Krxur7h2HT7BD7ZoH
        OEHDlmnyG6Q/q61VCZQgFbOXuJ6jTLyOVdLQGo8=
X-Google-Smtp-Source: AMsMyM5HFi1QIBgsStBhVfBsnsO0dtQrMQ0bU6smsOrURUWQ4QTEXXdCP6sDRZSzT+L+/T1NufUNfg==
X-Received: by 2002:a17:902:ac98:b0:176:9e76:a930 with SMTP id h24-20020a170902ac9800b001769e76a930mr9959588plr.15.1663963531275;
        Fri, 23 Sep 2022 13:05:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15-20020aa79e8f000000b0054bcc370441sm6777409pfq.104.2022.09.23.13.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:05:30 -0700 (PDT)
Message-ID: <632e118a.a70a0220.6fcd7.d136@mx.google.com>
Date:   Fri, 23 Sep 2022 13:05:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70
Subject: stable-rc/linux-5.15.y baseline: 187 runs, 2 regressions (v5.15.70)
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

stable-rc/linux-5.15.y baseline: 187 runs, 2 regressions (v5.15.70)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.70/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e98e33d345e981800e03dd29f6f6343286d30b6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/632ddfa5f246e2b107355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ddfa5f246e2b107355=
643
        failing since 38 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632de6b293a6e0185e355659

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/632de6b293a6e0185e35567f
        failing since 199 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-23T17:02:25.047704  /lava-7361542/1/../bin/lava-test-case   =

 =20
