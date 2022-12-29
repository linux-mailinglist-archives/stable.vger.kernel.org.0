Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC886592B4
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 23:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiL2Wxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 17:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbiL2WxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 17:53:09 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7120EBE0E
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 14:52:38 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d3so20222658plr.10
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 14:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B1TjrZrrJE1OGoJL+TNOtUTpryIrm7z8/UznSRCeB6k=;
        b=HegF5oD2oIZTSc39/W06pAk6ROR79ArRaUyPRPNFpWiPZkX9CgZ/4okUxEOltCLi1b
         QkfeOUmZ/x/KtAczW6WSnc6YYm7yYmlAnA0F4RDujIgGvy+7KDO2YVGiMg5gUVUfpEr5
         5PudX7wjpy21jQG0VYMqWgIeclPHl7S4ADKZD1IsqtxKbAcJpLcVaIPrA+QEESpannfr
         ePosgln+AqlDtRxoznXGqSMABCvk6V/rbu1d/m3JqsRxL08YBsxTLLKb2z99koC+YWZo
         LWT+qmePznnDMnU1+lNB/VEIqg0m2tv+B/3qBn5N2Btw/1CQCUMiCFz5JP1GC/TkdKE7
         XqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B1TjrZrrJE1OGoJL+TNOtUTpryIrm7z8/UznSRCeB6k=;
        b=SFJTTLAHN20LjRq+Gsr7ZSQFNOYwoz505dvv7d2va9EN+28CchNi692wmDHxfZEK7p
         FXwk/P57KWn+K4+rjmY3FhMO+ALeAcd3fFk+PiffmH+UdS9uAfvjGnXZEURz5iGjehk0
         hZeo+SWV3WwHILWEAcQkBJlxzCWLah+DERQcTVUw0/lA2A0uZSqqe6lv3LfKzWNt6wax
         ZEgZVrU/Lix0tuvBQreQuqxt+QGFN3h/oWf6t0xreKdPxpctdY2Btu6TY5xuT31zdA2R
         Nv96ZRlkyYB7ypeqbCBMTFs6Gh1f1DhE69cpJ0H/sSGnbyuuABX7b7p2QLGy1Dupxbip
         xomg==
X-Gm-Message-State: AFqh2koDFqjHikxuj8VHH99/3jR+NrFSeLzLsYu8MhSETQOnzEyM0DYV
        8jvZN9E+xD5SedTRklxgHZdAHgGhCDsbzDVJ
X-Google-Smtp-Source: AMrXdXvs5QUJUdX4WzU+YStULuTIH3pelLL7gqA3hd9MAjMSU6803qDQZHkXmzbjdL1c+pN0rQxc6A==
X-Received: by 2002:a05:6a21:78a0:b0:a3:960e:7d0a with SMTP id bf32-20020a056a2178a000b000a3960e7d0amr47063933pzc.58.1672354357766;
        Thu, 29 Dec 2022 14:52:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902650d00b00187197c499asm13424030plk.164.2022.12.29.14.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 14:52:37 -0800 (PST)
Message-ID: <63ae1a35.170a0220.34521.700d@mx.google.com>
Date:   Thu, 29 Dec 2022 14:52:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.85-733-gd6c277a3ca572
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 132 runs,
 1 regressions (v5.15.85-733-gd6c277a3ca572)
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

stable-rc/queue/5.15 baseline: 132 runs, 1 regressions (v5.15.85-733-gd6c27=
7a3ca572)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.85-733-gd6c277a3ca572/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.85-733-gd6c277a3ca572
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6c277a3ca5726dfb3f91fb35791c3c82ce8814d =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63ade78ede683e299c4eee19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.85-=
733-gd6c277a3ca572/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.85-=
733-gd6c277a3ca572/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ade78ede683e299c4ee=
e1a
        new failure (last pass: v5.15.85-732-ge81e28b1ed4c3) =

 =20
