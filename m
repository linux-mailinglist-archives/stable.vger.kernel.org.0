Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085CC57A511
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiGSRVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiGSRVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:21:12 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B59F122
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:21:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c139so7875191pfc.2
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=grll2lRKcU2ZgWun+4fuC1ALYwo4VhpoAicvIBTEzfI=;
        b=o9mEizxbMvb+avgpfBaacA3D+xqhMxyJ0ZuL0jpWgsTBk83gG8dRMVPUyUNQAEBoWS
         MYZsXtm6phd9+iTitRQGhRrcFUA/uB6XrngGHRtsfCna78mLMuqwdGHM+0p4ndins+yB
         849Dv1O4RoW27MNp+BDw81IWfm9ypWRKMKnnyf5hs2Nk2aH+Xfoy2bIpZhd4RUqu8cSF
         DE0obo7zN5WoEu8KPb9rhnkWCCkSt6WfC0LhXXEfUc3943zOPrwMWAvjLtqwauM0Q1yl
         RF1fBRwmnd2/4tn4hRW6xdchp5VORCWscYS52FcdeTKybGQNBEbvOJTiZpFcXdLBUjw0
         OkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=grll2lRKcU2ZgWun+4fuC1ALYwo4VhpoAicvIBTEzfI=;
        b=7UqegPTpGRPP9i2Zv1/YsPk767VrM4PWEq+RTkj85D+7ULuoflR80m72Q2TVPl3hxP
         LxQxNbVy6ytWeepvSKYzitUcvCPrsIFylqBB5f+iYOLx/7Xb47iaQH5DJAITrY2RVtNW
         X+S3Iv18pKrBwHhxo+RsqL3nYRpiSLs87DPzcG7AjL0XCBHewSSiWPw+jrBZba9iMZZK
         NJLAy6GKa+ZvjMdZMFGbXkVs1iK/3YzKg0fjUGwB8q9lmjdz+0tr66ehDxsYBZElHMQG
         SzxnBYaYJc7fgSyqsX5TYDlVUIEZf4g3Iju5vPX1UrvFFB9uWZoU+YVXb/M2kkKWg1gJ
         1Fpw==
X-Gm-Message-State: AJIora/RPzlO3DXN/mo91GY/JeKlVBmIv5P6Rj9GjOps2tX6sabTHgCD
        ntbCuvtbAzg59g/tn2tHYDuy7i6Wpk4LevXD
X-Google-Smtp-Source: AGRyM1uJQeHSKEdQLetsPwVNzfJgBXuNSyMZDs/ESZeHd6Sl4TOdepKoB/9yeZXCahIq79d0WuOGEg==
X-Received: by 2002:a63:e352:0:b0:419:adbc:8b9e with SMTP id o18-20020a63e352000000b00419adbc8b9emr26164096pgj.532.1658251271470;
        Tue, 19 Jul 2022 10:21:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p24-20020a63c158000000b0041264dec901sm10269308pgi.21.2022.07.19.10.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 10:21:11 -0700 (PDT)
Message-ID: <62d6e807.1c69fb81.904eb.e9be@mx.google.com>
Date:   Tue, 19 Jul 2022 10:21:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.55-167-gddb6c29a78fb
Subject: stable-rc/queue/5.15 baseline: 182 runs,
 1 regressions (v5.15.55-167-gddb6c29a78fb)
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

stable-rc/queue/5.15 baseline: 182 runs, 1 regressions (v5.15.55-167-gddb6c=
29a78fb)

Regressions Summary
-------------------

platform       | arch | lab     | compiler | defconfig          | regressio=
ns
---------------+------+---------+----------+--------------------+----------=
--
imx6qp-sabresd | arm  | lab-nxp | gcc-10   | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.55-167-gddb6c29a78fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.55-167-gddb6c29a78fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddb6c29a78fb92877cded780aab88d39f6f9488b =



Test Regressions
---------------- =



platform       | arch | lab     | compiler | defconfig          | regressio=
ns
---------------+------+---------+----------+--------------------+----------=
--
imx6qp-sabresd | arm  | lab-nxp | gcc-10   | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/62d6adb5d998f235b4daf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
167-gddb6c29a78fb/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-sab=
resd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
167-gddb6c29a78fb/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-sab=
resd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6adb5d998f235b4daf=
06d
        new failure (last pass: v5.15.55-167-g4d10b228cfaad) =

 =20
