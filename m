Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B466DA64
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 10:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbjAQJ65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 04:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbjAQJ6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 04:58:50 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C402C65F
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 01:58:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z13so5188894plg.6
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 01:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nwKv2h+wE0THOMTJUzUoFeqkd7D/KGHQ8D/sxKMDRNk=;
        b=htv4IKI8UeUHmhIgu4z+WpIaXIjMwnSmAXJWSlqTEnzA+GIlF9YX0CYWYrNAXHoN5I
         9xDN/zl/u+EJua4H8/rCppMn1bD05h7bZ2XCnppY04szMJtJ+K4E3Z2WpCjEHgl+RlfG
         HEjc9GXYdWEhFbqso6CKp45vywDGXLGTTQ3pywav+nbNFauWDzYfdGoy/Zb2WbpPVRPC
         EGKvRqNES3JSqFRFAf6elyRWT2FJ9HaUiIGDc+SkLM1Wq7GAGRgxr3yez+nX/rek/TT+
         W4XAvH1YO2+K+o448fHcAhCb4jbd5xAXqMlthFUhR9k1RX711BNnp0q9q++WVv/XO7j4
         WUhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nwKv2h+wE0THOMTJUzUoFeqkd7D/KGHQ8D/sxKMDRNk=;
        b=Hxd4JaxxwO4m7bO3FAo2PhPzEmRFpLYPA2HDoo6Bc2W4XCAkzAriqjBtyt7mtg6m0m
         SlkiH38M3thEAmR8VetfusfR/JEvJQBc+tKMTSEBSepKqj7C+gdiRCR+sUODbvYIf6kK
         0OgR9JxU+gsQiPhJbhB2WzXjmeNR8RUH2V7M9i8n+HoEOIIqAjoq1Y+Ax6kpUki5I8ed
         8/k8nv81kN5aRH0pf76o/uWzw28r+uSOHsVoUvfHLw10mfN7NOmH2Ig3nbXpS/JM/6hV
         2Ga2wEMmPr/vH2JUtbSKTWS28sIZzaPlcx1+KNmWuifj14B7nmelfTp4TGS86ihTAhR0
         HzSw==
X-Gm-Message-State: AFqh2kqmJfQKStX+3DnE6u13/QJnT24Lcg30D9IjSn1SZpsbP7SuZSnS
        wal1TIkaClX3DB6t52BOEdkQi3n9T8oZqF7QhG6Prw==
X-Google-Smtp-Source: AMrXdXt2Q+SE9fcOw2fh2m066liBO2IDlqUPOG4bYy6rpeNoLkgsiGRGwBStWJg5iagPoBNDSVljCw==
X-Received: by 2002:a17:90a:c28e:b0:229:7ff9:6fd2 with SMTP id f14-20020a17090ac28e00b002297ff96fd2mr2590016pjt.27.1673949522310;
        Tue, 17 Jan 2023 01:58:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k60-20020a17090a14c200b00225bc0e5f19sm20064620pja.1.2023.01.17.01.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:58:41 -0800 (PST)
Message-ID: <63c67151.170a0220.a7ad9.f68d@mx.google.com>
Date:   Tue, 17 Jan 2023 01:58:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.162-852-gc18d4190037e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 78 runs,
 1 regressions (v5.10.162-852-gc18d4190037e)
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

stable-rc/linux-5.10.y baseline: 78 runs, 1 regressions (v5.10.162-852-gc18=
d4190037e)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-852-gc18d4190037e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-852-gc18d4190037e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c18d4190037e60d9e54c94986e74e6391a39cb68 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63c63b5a24e03c0a49915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-852-gc18d4190037e/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-852-gc18d4190037e/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c63b5a24e03c0a49915=
ece
        failing since 19 days (last pass: v5.10.161-561-g6081b6cc6ce7, firs=
t fail: v5.10.161-575-g2bd054a0af64) =

 =20
