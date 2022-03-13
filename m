Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3B04D781B
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 21:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiCMUF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 16:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCMUF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 16:05:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1226D2AE32
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 13:04:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so12608715pjl.4
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 13:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7tNH51KA/K+k+4/cZh36ZvZfPIOAo6y898S8vcpt8qs=;
        b=5QZyq9uq3eKUS8cebGr1mM8Tmsk70KDsjS8c92WQOahFofATVF/FyUto2SwF0mYUzq
         YfN4DsGQIPygn97bRxThddkKMkN0IG5TFxpY0nm3EeSKKMkrVpn4Yk7XLF1Bl889L3hR
         sUvv0pFpmy57XdJX6n3P/R9wC2ylt8MVi3m+Ttt0ExEIEiGAtNGv8rtWEy31Gcs1PGO5
         JqAc57O6IlGozVFF0YEEXQds0KC3o7zr/rOmtDeN1LxCthIaBOSeUpU1RwwGxnONSacZ
         QuHrRgXF6o+kggPpvePRFJZp7hPkYhkwrDdx8hzK6QSFjjUZT0fQQmsksDHMMINrHZTK
         5MWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7tNH51KA/K+k+4/cZh36ZvZfPIOAo6y898S8vcpt8qs=;
        b=qm7gCKibHFS/uzb+DLJTw+cppXXt8ZBYj6Gu9eM+pcDO9qnwgk6LGjS8Tswxwte9QZ
         Z3y+9scNnHJxbcXdyqbsQYhV79oBVWTylQRxLQ/oGZYJrU2w4KE81bK7Eed3i9d49d7L
         ZKY1v8eocuteNB375HTIn5Uv+eveFofU4utl5I1BhNqMYfcWPmgbVyHyXlw1wZvvE7IJ
         HksQQinGrdFmMEfLQTt/dAAJXxhBpigkT7SHUePYIRUmzsXhWonuxtqbFItP3HnWx3JP
         OZG4wag4GpCg4EWgGDVtsB4X67lslK0a2TbDKOI6WHy/ppXPy4GCLpoi75ckWvkezM8Y
         ggSQ==
X-Gm-Message-State: AOAM532ab0uSdApo82D2raA1AfJ/mvGPkVgP8UayKoDAo6GoIw9XCPhv
        I+5mLidohbDddu7Pl8L1Flal0Rsgbfsmv5LgrNs=
X-Google-Smtp-Source: ABdhPJzWCf3CTpD2yEU8LvC/9mhiX25aNQf3IColSC+gGrcih94AH+s479QAsxl4f7vKEqhNS0ggWg==
X-Received: by 2002:a17:902:cf02:b0:14d:54cf:9a6a with SMTP id i2-20020a170902cf0200b0014d54cf9a6amr19849592plg.137.1647201860437;
        Sun, 13 Mar 2022 13:04:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a631342000000b0037487b6b018sm13928933pgt.0.2022.03.13.13.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 13:04:20 -0700 (PDT)
Message-ID: <622e4e44.1c69fb81.7d96d.3d60@mx.google.com>
Date:   Sun, 13 Mar 2022 13:04:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.105
Subject: stable/linux-5.10.y baseline: 66 runs, 1 regressions (v5.10.105)
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

stable/linux-5.10.y baseline: 66 runs, 1 regressions (v5.10.105)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.105/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      67c781d938b850db236f6eb0bccc9737c29df57c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622e17cc9f6b1594b9c6297d

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.105/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.105/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622e17cc9f6b1594b9c629a3
        failing since 4 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-03-13T16:11:43.042807  /lava-5871649/1/../bin/lava-test-case
    2022-03-13T16:11:43.053490  <8>[   33.773396] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
