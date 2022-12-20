Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9AA6519F5
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 05:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLTEXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 23:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLTEXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 23:23:49 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDE6358
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 20:23:47 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 17so11130689pll.0
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 20:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oppE3CgZn5PfLeBGrHQFqIRkRgjkW9SmwucSx3NcJKg=;
        b=w3TgMclq/DW45WnMhrAZXO+MOfgyYwEKgIDe2Fnl4uomj7pePQ8ZR7cPY0jCQdMGzE
         6K16LzCraFhnE/kCDUyZSHq3ei+nH+S2I4N2qzyyziGzj7IRbw2paSXwt/kz/0DQf1y0
         Ti9VFd44zJB1LYFQATX1T5ncSlz92u6BFDXHwJ9rTT7JCjeBIvNKJ7MnUoPOpjKJve6Y
         9ubDRW23Lpv0bHmI1vnUPRn4AOUbA2PfWQbbT1iD/bt88fIOP1KIv/k6V01rhiw+mHWx
         Qnb6JRcv57YWsHbKl7bCHUGRT+5z8JBsC/UEH5996nxV7n9T4hntW82iwJInBcgrqHoS
         CbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oppE3CgZn5PfLeBGrHQFqIRkRgjkW9SmwucSx3NcJKg=;
        b=SFbY4VmYh+A/HgUjcx1WCKZF7GnWWBySerb9CiNF3PL9ilcYzSiV3FZ/VtMZNu2bu+
         UHzpbLkkbNKLr2xBnZjt099cDHxL0Ey9XZ6vD14/kCjodToMgftFQp9p4yfsDQV8K3Ia
         ooe+ghNpu9ZGBxbrLN5DUAImNaeCiw6hrBCiAuX9DdaiKYzL8ZBLCkWWSFql51LXvbYM
         QaajIVVttN7deqW2K1N8PyCkjJSlfhVDr+JaGXNoj7+NLLPesa304dIf40bBEEZCzT4P
         3Mh33WhZAf7K6pQ2wZfOS1hIMjHrmsfhILotPqPFLi36AgytqD9pq2ClPJm4vUVHdMsl
         nFRw==
X-Gm-Message-State: ANoB5pmSliN0NMk4ppjblzxX/8I30vOEr8QFCePiV+KegmCb97tCK+Jr
        vmryCu5iMx7lI4OjPiFZrK0rns122GetY6wbXUI=
X-Google-Smtp-Source: AA0mqf5AFpfT61lE28SmHGehTWHtOT/oG10lI8TDlp69YrRTPjsO6bnvKRut0MVXvPyIIRQc2zpjQA==
X-Received: by 2002:a17:90b:702:b0:219:5f68:586e with SMTP id s2-20020a17090b070200b002195f68586emr47186961pjz.18.1671510226254;
        Mon, 19 Dec 2022 20:23:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gp12-20020a17090adf0c00b00219bf165b5fsm6841930pjb.21.2022.12.19.20.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:23:45 -0800 (PST)
Message-ID: <63a138d1.170a0220.43628.bb19@mx.google.com>
Date:   Mon, 19 Dec 2022 20:23:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.160-19-gbc32b2c55e20
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 161 runs,
 1 regressions (v5.10.160-19-gbc32b2c55e20)
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

stable-rc/linux-5.10.y baseline: 161 runs, 1 regressions (v5.10.160-19-gbc3=
2b2c55e20)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.160-19-gbc32b2c55e20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.160-19-gbc32b2c55e20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc32b2c55e20a98b04c9ccb34c50e4fbd7f2b8cd =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63a1063ed6562e09094eee3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
60-19-gbc32b2c55e20/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
60-19-gbc32b2c55e20/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63a1063ed6562e09094ee=
e40
        new failure (last pass: v5.10.159) =

 =20
