Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8380643CA0
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 06:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiLFFWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 00:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLFFWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 00:22:03 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A817220D1
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 21:22:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so5761988pjj.4
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 21:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XCV8Rp0FymjciKKYMWDU9K0x1CV9/umTRzcUgEmPFwU=;
        b=F9SLx7+fAN0CefXWMx5S17KOD05BmjW2Ka82+/Z8CZDPWGAj8ddNWz6xb8ntsjJyGr
         nJjp07pp9l5yLI3Ye2egG4mIwGgEvgtX5zaC47R1FYEtee4PKSmDYfW7Ra7w/YUCKafb
         PPDwlR+9Wbp1/idhrs1QfyCpLyWxuffnJdXFWFxKlLDcIZlF1C5jJgnVNb3FwGf2rgn5
         nQ3QLWDZBJivbTxFMIpWSJ4XklSVTaPNVU5Ihzj5D4Kcy1NG63wvLi/Yf1iJ3Z1mFTEG
         c4sPmSLCXjCXVZ9jpu17HuiswFGG4icjsFCMgQRAnUKt8iZR7y8M6eci/QRZbaf0XE7/
         nVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCV8Rp0FymjciKKYMWDU9K0x1CV9/umTRzcUgEmPFwU=;
        b=FDbAXIC5oBmEvhM+TFr5XOsZ2B9AIE7sgFONjhJ4M1TcPXNlqevoPeCz6q5Q64wkUO
         4dy76xzSaoynajLf8M2K454/noEQ1v3qoaZ3wNrj+4VQJGSdDQle7RriYAyfhSYDvULq
         dQbokYjzpJuKSJMlzpQVF3GF3luLgZBXrCW0B5+mMp0vMpTgEYI6/LgL80kDOA5wpYRN
         S/WBUG9Jgh60l3cJP2v0GEvPoLrm7mHcZ6sakBUZuTymX/5COMdJm/Laq3Qm50pXvJS6
         FPnJX4z1WPmQMdsFRyCbbv+xxaFJp06Tzx666UXTBd2mmQpcOiW1n1wY7IPCPGHByMSD
         OtTg==
X-Gm-Message-State: ANoB5pn2lE/bog/LmnPxuFxoP96tn35TgkDzTRh8cuMwCtwJjGB9NVe6
        Lzf87MMuA8vmBTakIuJn4xMmbELIhQDj3EWEMsqcvA==
X-Google-Smtp-Source: AA0mqf6Nlb6y4JW82Ypgg4usdOAS1T3X+4jv/OoCfBt3AL4E5ulzsNvv/4JyCtaWi8CIysCCrBnAow==
X-Received: by 2002:a17:903:31d5:b0:188:5581:c8de with SMTP id v21-20020a17090331d500b001885581c8demr68275669ple.140.1670304120731;
        Mon, 05 Dec 2022 21:22:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 127-20020a620485000000b00576670cc16dsm6873784pfe.197.2022.12.05.21.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 21:22:00 -0800 (PST)
Message-ID: <638ed178.620a0220.77ef2.c149@mx.google.com>
Date:   Mon, 05 Dec 2022 21:22:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.157-93-gbdee1eb3ffe4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 129 runs,
 1 regressions (v5.10.157-93-gbdee1eb3ffe4)
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

stable-rc/linux-5.10.y baseline: 129 runs, 1 regressions (v5.10.157-93-gbde=
e1eb3ffe4)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.157-93-gbdee1eb3ffe4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.157-93-gbdee1eb3ffe4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bdee1eb3ffe40e8330125760284c139dd61ce008 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/638e9f07ecb9ce9bfd2abd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
57-93-gbdee1eb3ffe4/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
57-93-gbdee1eb3ffe4/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638e9f07ecb9ce9bfd2ab=
d08
        failing since 21 days (last pass: v5.10.154, first fail: v5.10.154-=
96-gd59f46a55fcd) =

 =20
