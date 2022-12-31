Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305B165A602
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiLaR7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 12:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLaR7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 12:59:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179E7E4C
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 09:59:10 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g20so8050227pfb.3
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 09:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=minI9qegQy+/bWCABHWMM1+j+us0ms5xbBYkVECMtZo=;
        b=f4B4QS9b3KpRUwT7ohS2ZmhsUqrmqij1+5mTy1BRseEjaq+KgSspxk+9sGvTCIQM3o
         GqFFjdImKW0XCnxcnEqRVz1uvHaeQBDfBdU4JF4oT0iAB3I5mhMJP2QXfhrq0fOD2HDt
         bRKPVDweGBXRLX/MDtEj47NB70MXh2gcFzZ3tEw2U2/lkD8a8Mljp4RqKeAbKLLiXUn9
         Ds/FMJ9GL3urkKjsfyd+DuOISiQoavcp/jOTd73vmahSnkYxLqh19KCkgJh2CjEM4lbd
         kSuPO/yTj7J3jgp6y8BCOR4HumG8uuZij49AzaZicyn38zY5Mntcc9uhGQf7bgn/rvuw
         U8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=minI9qegQy+/bWCABHWMM1+j+us0ms5xbBYkVECMtZo=;
        b=YlXGch3LKcSRs6Iu7ekTE1qFrlPRDvVFsZYoE/NWASn9N7Riq3R7jxTLXgbLFmnX6T
         tztwKVzA0kOVc9BE7upLIwSQPCE5RReSf6uxIa42Scjk0Hgcvdp0fWUluRxNW4zoDb19
         MscLRE7wsAahDXlmRdi5jMvoCYU/f7kwyrgWUbquHPXUy15fOVNLh6KUHZizFyJKP+SE
         cLO0gdcSWyToitvePem8fheKy6JsNJYqRdKXcn6tpgpKCL9B3QNsjrgs/RSOD3Um+jbB
         gWmQO8XbD9dqgIKpLtjftQAb0xlsvPxYn1zD1yJOx7kznYK14HqLnG5zCGBSKUvJ8HAp
         0hyg==
X-Gm-Message-State: AFqh2kqFN5MzArviRfBFiljboOlRa8EanN8wp93H/2P5uZVYyW/Qw37r
        hwnmiIw2v9wjvxUL/vzjuQfLM4jQlSD+9rSnoXc=
X-Google-Smtp-Source: AMrXdXvWacCFcDV6ed5ZU1p45o//Hxr0dxO99Y0rfQJZsvb/lwTxVc1PkINFMKEkuRrqVHY4+g/uBw==
X-Received: by 2002:aa7:91d9:0:b0:575:2337:17bf with SMTP id z25-20020aa791d9000000b00575233717bfmr43732010pfa.12.1672509549169;
        Sat, 31 Dec 2022 09:59:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s187-20020a625ec4000000b00581ab852316sm6138133pfb.27.2022.12.31.09.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 09:59:08 -0800 (PST)
Message-ID: <63b0786c.620a0220.f7d8d.8a9c@mx.google.com>
Date:   Sat, 31 Dec 2022 09:59:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.161
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 140 runs, 3 regressions (v5.10.161)
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

stable-rc/linux-5.10.y baseline: 140 runs, 3 regressions (v5.10.161)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig          =
| regressions
-------------------------+-------+---------+----------+--------------------=
+------------
beaglebone-black         | arm   | lab-cip | gcc-10   | multi_v7_defconfig =
| 1          =

r8a7743-iwg20d-q7        | arm   | lab-cip | gcc-10   | shmobile_defconfig =
| 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-10   | defconfig          =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.161/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.161
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a9148dfd8e03835dc7617cee696dd18c0000e99 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig          =
| regressions
-------------------------+-------+---------+----------+--------------------=
+------------
beaglebone-black         | arm   | lab-cip | gcc-10   | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/63b0456cc578f4a0234eee23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b0456cc578f4a0234ee=
e24
        new failure (last pass: v5.10.161-575-g1e5df46609293) =

 =



platform                 | arch  | lab     | compiler | defconfig          =
| regressions
-------------------------+-------+---------+----------+--------------------=
+------------
r8a7743-iwg20d-q7        | arm   | lab-cip | gcc-10   | shmobile_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/63b0419b388624d9884eee33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b0419b388624d9884ee=
e34
        failing since 2 days (last pass: v5.10.161-561-g6081b6cc6ce7, first=
 fail: v5.10.161-575-g2bd054a0af64) =

 =



platform                 | arch  | lab     | compiler | defconfig          =
| regressions
-------------------------+-------+---------+----------+--------------------=
+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-10   | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/63b043b63c4c5c5f554eee27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b043b63c4c5c5f554ee=
e28
        new failure (last pass: v5.10.158-107-g6b6a42c25ed4) =

 =20
