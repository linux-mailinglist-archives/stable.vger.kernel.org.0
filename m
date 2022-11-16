Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E8162B1A5
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 04:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiKPDFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 22:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiKPDFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 22:05:16 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989EC1704C
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 19:05:15 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 136so15446739pga.1
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 19:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9ItVSzqBGwxAmIVt+Jp9sMbORILhMJWLrcIvyzyoqXs=;
        b=UaJOJiHHQE019MBmip7wcVpRgmh3h98wJUVoczZB4y1drHi5Xgk1EDgehs3iLcpa2j
         zYPsDwrxvaWNfgMo5jwxnJF9mcsiegywmhvQc/o8bC/VABoOzD29FmOdiNoQ7Edtpfi3
         3afH9Tf5/CQWQLEb+BWfjANxiCfuc/4hfl5IXKkKW5g1EEsjBAG84oYSRbTbilDlTRnB
         rgv7pgkyEAPMhoA0V9V+7sWmkPoijwUYOMZ0uU5GHokg0rQSPYrM/nVNQySJykA7yyqq
         zBdAud/TbhzcPwg0mVM8P/lqzXooQyLp5rDpURFP0yLE9VEJRZ+or/ek3lRJ5/kzhfpb
         h0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ItVSzqBGwxAmIVt+Jp9sMbORILhMJWLrcIvyzyoqXs=;
        b=gBUxA68V6aGH5EZD7jZRjI1KW13eMAgA5KhS6lJ8d5fTasAFsz/P4HLJzu7IsxINge
         9VQdv5h8IgUv/+2+JYEcDWj3yTPU8jqRmnTCrB3rlaN8wcSR36NCFlld0pKw9r/2PGLm
         i7z4iVL8B1MjRL5L6JgNnzWMvOSzpttRNQRG/C1zxXPelSR4aJLt23GXQiL8mt847IzM
         MGbsWoMS74PdtQRrmB8Zs9bbsqzGvN9Vuwb0oYJAY/cPNIloXj+qZ0crCEA4g+TtGDnH
         jViI21GlxRxtTuEeXQVwSxeojp9qhqyIgJPQ8SgOYXqjWPLNbLvAgkK3kbKcvi63bNgH
         zpVg==
X-Gm-Message-State: ANoB5pkU+DCZS0LMjQEG0CPXY1aK8MXdiI6KEJsVzFTb7QWEu7IYkD8t
        ykfgJ6iI0SUXAdBvTd+g/vK4HJ2RD8u2QJYD
X-Google-Smtp-Source: AA0mqf6wKG67sCoc3gUYJW4mKj+FNoGyVElKdhk6Fv7npO6uvMg0nBCzUYJ28iYnjr72MAnsZKB+VA==
X-Received: by 2002:a62:1dd8:0:b0:572:24c7:34da with SMTP id d207-20020a621dd8000000b0057224c734damr11747930pfd.73.1668567914954;
        Tue, 15 Nov 2022 19:05:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g75-20020a62524e000000b0056164b52bd8sm9583067pfb.32.2022.11.15.19.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 19:05:14 -0800 (PST)
Message-ID: <6374536a.620a0220.2f035.ec52@mx.google.com>
Date:   Tue, 15 Nov 2022 19:05:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.78-131-g0963ae7afcba
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 164 runs,
 2 regressions (v5.15.78-131-g0963ae7afcba)
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

stable-rc/linux-5.15.y baseline: 164 runs, 2 regressions (v5.15.78-131-g096=
3ae7afcba)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.78-131-g0963ae7afcba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.78-131-g0963ae7afcba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0963ae7afcba623c33f520314e776e107c35c45f =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63742928a385ea15482abcfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-131-g0963ae7afcba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-131-g0963ae7afcba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63742928a385ea15482ab=
cfd
        failing since 50 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63742aa18a443606852abd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-131-g0963ae7afcba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-131-g0963ae7afcba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63742aa18a443606852ab=
d1a
        failing since 50 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =20
