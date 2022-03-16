Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6854DBAD5
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 00:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiCPXHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 19:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiCPXHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 19:07:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF5DFAC
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:05:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so93135pjm.0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0yv/R5OmKthZYUrc7tssFC9fFAQUriLrI2+xo3OKK4I=;
        b=qLvujHkavcGMsFNw0q1Lm+0GW+/gVZOO+hHDMgwRD7xOKhts+NgcATWX3jql1a3x6k
         miLtituS3IDqSq2y2NviSK78OFcRTHscvPJvKEpfUeCtztCeqEX29GyJ7SQglFBe18DM
         EXRwZ+ODh9p9HqtZxTW7tTtFjWdhnDTeOkd3J5/X+7nB7dM7OhjmRrB6Swx50ZeCNKAx
         97fHp8nB75Amsdb/u5aOoB+46UGm5yEeY1f7hvsLNtAMjScpcVnOhQnsNQcbLJnFe9lX
         a62/rkjdwkBxQzTAoXTPyoSECwg2zJNujcbRjM9nKNsZpW0Lw7jJ9yoNQ3OcDWjYCGIv
         Cu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0yv/R5OmKthZYUrc7tssFC9fFAQUriLrI2+xo3OKK4I=;
        b=afZbkGsSXC6RQzsHf5QUAfRHzzucqF7IZCz/S+pEYpwN/8wo0GmTKjg7CFHKUT3wsR
         /232fnj8/1lfSSYvBWq6fhHTFIHSITYaTh7DD3hIBEtQJVZVLBUU6Igj/ZAZ1yfFpKks
         L4el2UanV/W2Lvs6VZmQP2NaP6T68eQKyVyK7024duQtXiNRhsJCs5TWnenT/zGPiA9v
         CY6vuzGqAxCCl9LxctKK2nqZ9O8MmnlZgcGwlyUTPMAS+pelPcH4HCLStDuzR22B60UR
         IucDug/d7ReTt9OV+E4eQDRFRTAGAVcaMrng9LR8T+bhGexnyBRDSy/XbnfylwRLO4OQ
         yLYQ==
X-Gm-Message-State: AOAM531mlBVzrjV0ZkrjBj4/pEfibxTj7Ul+6QANDEficfSDYoN3pyRL
        n0XxUwr3uh413tDdZuewDJCwPRqw15o3yOwLPkI=
X-Google-Smtp-Source: ABdhPJxKaN2QA3DXXuaeEwadtPWPcZ7oGR3eKo7XI92AdwLWl8/7MtIPOYpzTqqSGfcsjkQ8o7Vbqg==
X-Received: by 2002:a17:90a:e397:b0:1c6:3b63:bcbe with SMTP id b23-20020a17090ae39700b001c63b63bcbemr2095805pjz.180.1647471956780;
        Wed, 16 Mar 2022 16:05:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13-20020a056a001acd00b004f7a2f18e61sm4327369pfv.137.2022.03.16.16.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:05:56 -0700 (PDT)
Message-ID: <62326d54.1c69fb81.f5ace.afa8@mx.google.com>
Date:   Wed, 16 Mar 2022 16:05:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.15
Subject: stable/linux-5.16.y baseline: 105 runs, 1 regressions (v5.16.15)
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

stable/linux-5.16.y baseline: 105 runs, 1 regressions (v5.16.15)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.15/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3ea3a232f03adfcf6d18d91d6e851057b6cb079b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62323a66071fd6aec8c62976

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.15/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.15/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62323a66071fd6aec8c6299c
        failing since 7 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-03-16T19:28:17.186097  <8>[   32.368481] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T19:28:18.209705  /lava-5892834/1/../bin/lava-test-case
    2022-03-16T19:28:18.220854  <8>[   33.403377] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
