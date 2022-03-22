Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE894E3583
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 01:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiCVA2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 20:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiCVA2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 20:28:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C733596A7
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 17:26:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x2so592024plm.7
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 17:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dyLaDhH7d8cHGGB87QnDNoBS1itMBJn1rSFqZYHXnq8=;
        b=JESbDQKjxBREPTlGiJ7LuX1lEmv2VS2r8iZaAF4uJj4pMSWoj1i4loE8Cat8BmT/Wg
         udJ3LI9os8RmH1Ii294t2nbu6n5hGyqGuqomR/xwLVzSjB3Fs67+0wve/jgK/gMEE9Xa
         1AeWGfZoL7NwOB5AYJRPfrTYQ/ssXUMzKaYDGSvsK1qLadtkF6SJbqS/VTIrIAtS/ZSd
         h+xMM8WLgWidZb2JQcOBPEizLhpg09X1Fcd1STq19wmfeB9LXc9ROih/5vQtGlwROmbf
         SdK6wWEwaRB5USbA1bQBxfGqSj5Dm1qWm2lTrirVVLC5pxFET80iDQmrkEPlnduhYWnN
         Z90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dyLaDhH7d8cHGGB87QnDNoBS1itMBJn1rSFqZYHXnq8=;
        b=jPOkNgpYBarUEXZY5k7TwkXHOQhgngxsPvhWIxS+tc2AhwhtgWSvUGbxqCbtkFzkrW
         CLLOQ0TqKlqPN07AOzAy1/fauWYaLmf7beMvnRzHSZqwwvF6aVqI/oLGjqLzxdn5Y+eA
         IM8Khj+cyV0w/yepzQ5ICdi/YGgUWDAuZAT6Ah1oRIzNCpWrdqIZ7h7pb+tJ0RLenvvF
         IkkL/5M9QoIBenuLa09RYeOmdE8M7Rr8vZhn8mwvjVK1SuJtoC95p4PQBH4kET7mp/3z
         1tA7dxuL6EfzJJ+SLzCrWTbEcYPVDl8NkEs0yaaByx/KysET5/+Q85TF3QVI+uVzOp62
         DBcQ==
X-Gm-Message-State: AOAM5318pU4oJ4QtDJ4e9v/UEl3T8mm9uZ4QLBW63IHKqzj2EDVOcufU
        Wuvtjg1lQUwcdydRBXPIMGb+tCOpPuRbOvSEDqY=
X-Google-Smtp-Source: ABdhPJxgwGBizFuAozo74k+0RWrbCyKRTv0BRn13y2go27QVCeJpJxbSIQk8i39RV8DgM7LRkR5yVQ==
X-Received: by 2002:a17:902:e889:b0:14f:c4bc:677b with SMTP id w9-20020a170902e88900b0014fc4bc677bmr15218208plg.68.1647908807895;
        Mon, 21 Mar 2022 17:26:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lb4-20020a17090b4a4400b001b9b20eabc4sm610309pjb.5.2022.03.21.17.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 17:26:47 -0700 (PDT)
Message-ID: <623917c7.1c69fb81.b3895.2f50@mx.google.com>
Date:   Mon, 21 Mar 2022 17:26:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.30
Subject: stable/linux-5.15.y baseline: 100 runs, 1 regressions (v5.15.30)
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

stable/linux-5.15.y baseline: 100 runs, 1 regressions (v5.15.30)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.30/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0464ab17184b8fdec6676fabe76059b90e54e74f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238e96ee65c34049e2172b9

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.30/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.30/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238e96fe65c34049e2172db
        failing since 12 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-03-21T21:08:41.172780  /lava-5917035/1/../bin/lava-test-case
    2022-03-21T21:08:41.183304  <8>[   33.581418] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
