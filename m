Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FB565194A
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 04:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLTDJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 22:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTDJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 22:09:36 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E661A2BE7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:09:35 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 124so7672658pfy.0
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MpYAoLP9649H/B6ucsGbKTIVtYl7qQI0xAIPtSY4dEU=;
        b=bTExC8ozE4mewtRpX/mKNXb1WvEC1dfS823g/OMqElBPALonAWrQinLHo/diDlVYdP
         CAGwzPdVzIL7fd6IHR5zuUaDqmOEGCyRBo72+qj4LELW7Oj8dELcbHvKmdcOwxxwI2QB
         ZXgymfn4ZfCnOoGaIGDeRhLxd5+BUAJAjxgplnwAVHa40oec9BXm+v7PHYhXKLK+O+1z
         YcD2Uffbqu7biRrH9prFvLaO2+txNciFkcYx4GNMmvvKrb3diMDdYEhftpN6wQ3J01lA
         DhwG8ybVkAtdJ0lsHEklAxxTS41gxtzYfdXP/ENjfGPE9U72k9F90qVBgSCFtN4SjRTM
         Fd9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MpYAoLP9649H/B6ucsGbKTIVtYl7qQI0xAIPtSY4dEU=;
        b=KcTtmH7jIRTEiB7/EjCwgiRIDcZo8OLsxMZOLe1QPjA3Zml9wyn2lwamqC3s0lF/Ic
         +bgXzvA6CaFRhgo+gpbSYL7hnP+0s+bsRucsnz5nMq8TyIiV8gdNs4061BQVPtC2+yPP
         zo9yecIrXbP21erjeyvrELYihetdNXuV1JRdcnm1zed33D9Pde5umWm1R1JsGAbWVUMj
         suXievuLVz5KvDQvAbYezNzHDEHAawgDoQxtfudu72b05D7EbfENyG3mLWUTGJb44pRk
         dDzNMDMYwuE+YznyYvNo/PTXoPStrkma7aYeg+B0a5X2xpJUVg/wdWuX5gsrFU5YQU8s
         0qGw==
X-Gm-Message-State: ANoB5plXB0MbjPYRIBqZCvUjJjC4Nukk7g3toUBAUwJaHtARxa2psXj5
        kFxz+yfOWZxw/zp2osf9tvqTtEP1McNQuEWB5Hw=
X-Google-Smtp-Source: AA0mqf4b+VPcA6AqpCNtBGokMhqlDNFyErj9uM7KMot9shj9VAApF5gWlkGp/q1SeseSuWizlZ8bhA==
X-Received: by 2002:a05:6a00:1a42:b0:572:4ea8:30b9 with SMTP id h2-20020a056a001a4200b005724ea830b9mr57430908pfv.15.1671505775091;
        Mon, 19 Dec 2022 19:09:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11-20020a056a00004b00b005756a67e227sm7637698pfk.90.2022.12.19.19.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 19:09:34 -0800 (PST)
Message-ID: <63a1276e.050a0220.9e958.d718@mx.google.com>
Date:   Mon, 19 Dec 2022 19:09:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.160
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 167 runs, 2 regressions (v5.10.160)
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

stable/linux-5.10.y baseline: 167 runs, 2 regressions (v5.10.160)

Regressions Summary
-------------------

platform          | arch  | lab          | compiler | defconfig          | =
regressions
------------------+-------+--------------+----------+--------------------+-=
-----------
meson-g12a-sei510 | arm64 | lab-baylibre | gcc-10   | defconfig          | =
1          =

r8a7743-iwg20d-q7 | arm   | lab-cip      | gcc-10   | shmobile_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.160/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.160
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a2428a8dcb4f3eb80e7d38dba0bf71e4ff20cecd =



Test Regressions
---------------- =



platform          | arch  | lab          | compiler | defconfig          | =
regressions
------------------+-------+--------------+----------+--------------------+-=
-----------
meson-g12a-sei510 | arm64 | lab-baylibre | gcc-10   | defconfig          | =
1          =


  Details:     https://kernelci.org/test/plan/id/63a0f7750e1acdb5564eee22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.160/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei510.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.160/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63a0f7750e1acdb5564ee=
e23
        new failure (last pass: v5.10.158) =

 =



platform          | arch  | lab          | compiler | defconfig          | =
regressions
------------------+-------+--------------+----------+--------------------+-=
-----------
r8a7743-iwg20d-q7 | arm   | lab-cip      | gcc-10   | shmobile_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63a0f50d6d420df0c64eee34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.160/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.160/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63a0f50d6d420df0c64ee=
e35
        failing since 24 days (last pass: v5.10.155, first fail: v5.10.156) =

 =20
