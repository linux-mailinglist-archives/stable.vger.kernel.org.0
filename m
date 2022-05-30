Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C23F537A26
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 13:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiE3Luf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 07:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiE3Lue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 07:50:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FCA69CF8
        for <stable@vger.kernel.org>; Mon, 30 May 2022 04:50:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j7so4928432pjn.4
        for <stable@vger.kernel.org>; Mon, 30 May 2022 04:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XJw3ow3AOymwlwG5p+Pge4MWrMGUTS/5RyhcHwjgAIc=;
        b=FiVXKud4zeN3nwQnwZOp2dmxDwpZF1ZoFwcuibYamQDhsKZBM47SaHfmYc89nTQCsI
         t3yDhYIvlevSSQqy8UY9Btd2m/+w/Dyn12Xp2v/zG/5jduEwuyBPb7kaZLMlmiHom1PD
         2jIXipOYE3Pcd0/5S42kL5Fyys1UFsV3KdenMLrGBIftpvQbokYhdkhFb461vhGAfSIJ
         p1cpbHXs/eONYDrUsLcAzTt7QRe1uU9NN2Fat2LwVt7aqOoHGSbJsFlHSVDay55hh1U8
         SKZVUHoIzbvjonbYn1xnP56xGdokoeji1nhvwNAYVD93/aYlVrJGShpyW/ROavuxJoLk
         YdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XJw3ow3AOymwlwG5p+Pge4MWrMGUTS/5RyhcHwjgAIc=;
        b=Z+ov3tIjiH+s//aYOzEe4ot3Uw/S3wI7X1Uuwy82aU4Znf2HxiPbyuAeSdzvX0y7O3
         k7I7Z/XxhG/4Dr0G1vRlbs2tthBk2OmFxzN8/Cs10ifULsNWLvV/5gvxRvX2n0QA13Xv
         tyulwx8PBhkiu/n1AT1gJIWQW7YzGSacvP92TjhQkowf2/gL7MAH70SgsyluVW/XKf25
         fLdduuYsXgcbwdCbCdGgZFYEn96sDdl8P57SFz5FYuyzz4/3rjacgCwh+bpD1zd61/mq
         Io59R2ZJR/TygBExlefxzKDGFFftu2/zLVQcOjiP2LOrQ+tDVHLA5vVwWrzx9y3LrKT0
         KLVQ==
X-Gm-Message-State: AOAM533gqA1mGSU1v/vEeOffWOnm7k6YzeTYUvGuLS/h0cD9Gq0DCct6
        hsRjRxp/Umrb7MRoaQPbaOnpBN9GPKbFA1vzt0Q=
X-Google-Smtp-Source: ABdhPJywVpX6coRIO1FnsPTnjxDhpa6yW87T22/vJRK80JigABzReIfr6jKtBUD9g1yktn1ebKPL4w==
X-Received: by 2002:a17:90b:3591:b0:1e3:25d3:e78e with SMTP id mm17-20020a17090b359100b001e325d3e78emr641516pjb.29.1653911432826;
        Mon, 30 May 2022 04:50:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b0015e8d4eb239sm4820499plg.131.2022.05.30.04.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 04:50:32 -0700 (PDT)
Message-ID: <6294af88.1c69fb81.40642.a228@mx.google.com>
Date:   Mon, 30 May 2022 04:50:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.1
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 152 runs, 1 regressions (v5.18.1)
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

stable/linux-5.18.y baseline: 152 runs, 1 regressions (v5.18.1)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.1/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0047d57e6c91177bb731bed5ada6c211868bc27c =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/629477d80e2e564d7ca39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.1/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.1/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629477d80e2e564d7ca39=
bce
        new failure (last pass: v5.18) =

 =20
