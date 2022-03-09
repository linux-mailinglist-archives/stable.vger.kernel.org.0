Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB64D2779
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiCICOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 21:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiCICOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 21:14:20 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F952722
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 18:13:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so998048pjb.3
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 18:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hGNRSRP54nCuPlUwLMsDNhd0k/HOjWsQ9R27NNBLOLs=;
        b=yXWT6kpU0TGi4Pko3HnKXClb7UJcxSI0s/aHKfUfR0YJ1f/CL5ydffR22XoZanCH1b
         VLAgH0ETQySnjyZ/OmI+Skzi6hnHgxkX63uRe+ZrACIMyHxrbH9qVV7p2yXg6STGhGRf
         YWcLh5UotQXjHYXhd/zf6/4hwHZHk7Ltf1gakb6HxQcJ9AS669cIuThq3gb5Bdb4cM74
         TmpYksKXkn6fe6TkrIZgbPm9VZ9RNxqyFSBAQQ3RydnKeutiSXOz2W+GgkS7VAewBrVV
         QX4I8BaWVcTl5nPhcN79iyhAH13ulWpNgULtZnkJRsXEYSriTjxwjlq3XLin8/WVVbeG
         hNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hGNRSRP54nCuPlUwLMsDNhd0k/HOjWsQ9R27NNBLOLs=;
        b=pvKvezQoL97tmvizFFs2Sc7IfVTst2dBpjx/Lq/pLJ0xkNZ/AcDHTnSwE1QYnp7e5T
         vNTmmDaZ098FZuB91ASWFqDgn4EMizQmF50XnGKNj4qg8idKwrLsjgwL+3UDsjzUR93A
         3tMzg9gNjr7e8TJ0MQLqP9m7M3f2ffIJYuwScLVo8uRM0d0raeSWOm3dJKJUFwwy4gDX
         WoBwPYxuPpz/LDdMG6nZ1iNmk3ArmC7M1JVEac1K2Ly8nHFyC/KaItLaf5jxPWV+vgBu
         75aeZun+TectpYGn0nzGwXq/fM9c5KrKToyMOFMisqHrvJlUXvX45jjlaKEKU9znADcH
         lRLA==
X-Gm-Message-State: AOAM531CgQ0FlnQ8AkkeulCBmpWUbcWP/6dIo6okmsosqvcKdtELSo6V
        KCT128S4hV6tOmB73CTZyel46Hq4KKeT6hdvJjU=
X-Google-Smtp-Source: ABdhPJxnL85S86L3cS8iCP8BL72ofLwVJ4hdj6wlnWfHLdRl3oNFhWimUYM4ENH/5hXMmSEFAaQ0Ow==
X-Received: by 2002:a17:902:7207:b0:14d:938e:a88e with SMTP id ba7-20020a170902720700b0014d938ea88emr20428680plb.42.1646792001892;
        Tue, 08 Mar 2022 18:13:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm415386pfv.69.2022.03.08.18.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 18:13:21 -0800 (PST)
Message-ID: <62280d41.1c69fb81.34670.1b7d@mx.google.com>
Date:   Tue, 08 Mar 2022 18:13:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.27
Subject: stable/linux-5.15.y baseline: 67 runs, 1 regressions (v5.15.27)
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

stable/linux-5.15.y baseline: 67 runs, 1 regressions (v5.15.27)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.27/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      efe3167e52a5833ec20ee6214be9b99b378564a8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227ddccbc2654cbaec62a8d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.27/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.27/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227ddccbc2654cbaec62ab3
        new failure (last pass: v5.15.25)

    2022-03-08T22:50:45.101247  /lava-5841245/1/../bin/lava-test-case   =

 =20
