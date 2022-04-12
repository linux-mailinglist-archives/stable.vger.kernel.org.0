Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624CF4FDBC1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiDLKGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 06:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354182AbiDLJoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 05:44:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C35862106
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 01:53:12 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p8so16906435pfh.8
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 01:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M7T8U1lSR6jQjKrmo7LANnxFaYZTc1v25Mu0nuqeJ+A=;
        b=qioiFQGyqHETE+OQUTVe8UlY7Jt7uKZlaS/WFuAYu9d14PyEEQISl82ZlYLbpxsHdL
         KutZcwL8tEDFObHWIbVLTvpd+4PG5uIarS5aza3pJsqOdMdkWDKcduJ5hJZ3s3wMVKuf
         4/2AcCrF+Jn1529wAzwhgXzkVmwafNTElmjhFLg2d33zsmSOKzEtlbZilV3y1bQSf5T1
         TVI5e0C+CcBDK9ZQrO/IZ2jVFSyg4zliPY29LezXnzl5YOrTZ0YD1F3nKpaDyPw1OftY
         6Od1EvpUBq2M3VGYJ9sly+1b5A8zu2Unq/+1CWLrLACY5VPPYubFYvjYIIlE44st7esl
         Aeag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M7T8U1lSR6jQjKrmo7LANnxFaYZTc1v25Mu0nuqeJ+A=;
        b=ySAiAKBOERWA0xttiMsBs+rp6+pahlTtpdKsdy76Q3hEYjX6YxnfhgDEirzuAwBnD6
         9K1QThsk4FMoqhapOa1/1aWztrLOg0zHPaRTh58dYnApk6eEVwiYCpCt0iIrvLCN+fL8
         pszlhzpOtz+uN6auKmO7Bh2TRiHF3mLxP3pI5T5Xm7+qr9c5b6DSrMjAiqyTbyCJftEy
         4/yMGiaUIiBCvuS22ZcPceG3hzjkPaBMwv7bLfWEoZcLd3eRkW54KBrCCBczLt0+XlwF
         uLn2AD1UKcWP2eJY0aQ83/kn1y2iauA62wpPeb3i0aBU0Qk3IDxhUkOW6UjIeN+J/M5m
         w4Rg==
X-Gm-Message-State: AOAM533a0tNyA5i49/eJqSEUW02Y67AQFqolvzL82hWsDAd/9A/U/Q1Q
        DgmViJ6F63+oTsxXFHmNNpn3HQFkit7gmKwU
X-Google-Smtp-Source: ABdhPJxCPivYXTtTQDF0WCHO8Ne5eQD7gWG39KnlBmVi5VJhPCn0D2TGkksburLlClvBBV//HgK1eA==
X-Received: by 2002:a62:bd07:0:b0:505:c3e2:8d5a with SMTP id a7-20020a62bd07000000b00505c3e28d5amr8996248pff.48.1649753591408;
        Tue, 12 Apr 2022 01:53:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d141-20020a621d93000000b00505aa1026f1sm8491961pfd.51.2022.04.12.01.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 01:53:11 -0700 (PDT)
Message-ID: <62553df7.1c69fb81.d02fb.55ae@mx.google.com>
Date:   Tue, 12 Apr 2022 01:53:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-331-g22275249a7f8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 102 runs,
 1 regressions (v4.19.237-331-g22275249a7f8)
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

stable-rc/linux-4.19.y baseline: 102 runs, 1 regressions (v4.19.237-331-g22=
275249a7f8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-331-g22275249a7f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-331-g22275249a7f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22275249a7f805fdae201d5e8470040c5854dd25 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62550d1674fa09c904ae06a9

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-g22275249a7f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-g22275249a7f8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62550d1674fa09c904ae06cb
        failing since 36 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-12T05:24:28.419598  <8>[   35.803537] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-12T05:24:29.432222  /lava-6070237/1/../bin/lava-test-case
    2022-04-12T05:24:29.440561  <8>[   36.824686] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
