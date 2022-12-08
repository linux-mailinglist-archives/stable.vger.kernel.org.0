Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72E464745E
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiLHQdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLHQda (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:33:30 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0467E831
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 08:33:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so2074841pjj.4
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 08:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5WbGvBbkrygaiFxEvn43VTw7K5vD7VzvLn3m1lBT7ko=;
        b=ATb18OgSMQwQp4qzo5pacrl9xzamHzb0i5SkYpyPd7QAfp8dD9aP27D4qgRyea6rX1
         esZ4r1nciR85VhZI8WymX14vPsRC3WKWk9TEKvFVQ9bWz0izNctxN4ern3A5zhjMgnPq
         MuC/rKXzAbZAi3Ab2yLnZB/CLaFVNQ+5NL2H+aBAVv/mWuyqkh88tEJK1ABgL3/pwX5Y
         hlNGBoHEZX2M7c+0s0K1aMK1NSF3JpjBwgR4Gb+j4f1/I1qlKMjGQPvdyckiiwHXdWUv
         5JmCIYjL1UyDbCWm8mWGHeLGYOpCBwzdcEa8IMdqiN4taepTrkPfR49ikusNlc5Iy1yD
         iB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5WbGvBbkrygaiFxEvn43VTw7K5vD7VzvLn3m1lBT7ko=;
        b=YY9YhxRbWf427z7PjfymBqIxnogzttgYNiiNVjdo8EiTDigSo/lJfxdWP3SnF3of1c
         zPCNxlsQZAFg39I8dTni3j2rvIWlVUvqqkn5afY9/0sDQwmqeHom7xcuXNerwkZlAnJF
         uAw6cbhzpgFeHtokBtqXZmg7Szv9c8PYsahDXG7c4pcWkehnaMlmyfAvHsU9NouwpyiK
         e2qnAdWmcx4kZJ/16xE+waI6FLttDuKqr+yS07tlZqT4YPzPGD6djW7NZ4RsUWhwU2Nb
         G5yxA3qOoCGj89eK5KS2n7IcAqRn6Mz/PaeJCOLVbN1EIrADp155en9Y5JbF/qAb0CJh
         Maag==
X-Gm-Message-State: ANoB5pn5H2kl2Sm4zz7GGPQlyyQBzVE43a7sOXkzxGj8m9EI1YhJK0Vw
        V280kb9qtBlhCRDLQfIrb0CDgyevSE+gkgsMIVgkiQ==
X-Google-Smtp-Source: AA0mqf4gzOjyvCGe329gJsTtlbYG2c9jVM5T+QQb0i6IBOnQ+Q7cv9hH67Sas9VQEUPk2dPhB8kUOA==
X-Received: by 2002:a05:6a20:6918:b0:9d:efc0:62 with SMTP id q24-20020a056a20691800b0009defc00062mr5326509pzj.10.1670517208312;
        Thu, 08 Dec 2022 08:33:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm16897471plx.246.2022.12.08.08.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:33:27 -0800 (PST)
Message-ID: <639211d7.170a0220.d2a8a.1065@mx.google.com>
Date:   Thu, 08 Dec 2022 08:33:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.82
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 158 runs, 2 regressions (v5.15.82)
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

stable/linux-5.15.y baseline: 158 runs, 2 regressions (v5.15.82)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
odroid-xu3       | arm   | lab-collabora | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.82/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d9790301361c52921c6e5bdf155fe0d3bf7a207d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
odroid-xu3       | arm   | lab-collabora | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6391dde3914493abc62abcfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.82/a=
rm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.82/a=
rm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391dde3914493abc62ab=
cfd
        new failure (last pass: v5.15.81) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6391e4d9b6ff5f64332abcff

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.82/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.82/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6391e4d9b6ff5f64332abd21
        failing since 274 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-12-08T13:21:05.329494  /lava-8287897/1/../bin/lava-test-case
    2022-12-08T13:21:05.330381  =

    2022-12-08T13:21:05.340560  <8>[   33.607282] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
