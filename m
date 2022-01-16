Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E1448FE51
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 19:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiAPSC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 13:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiAPSC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 13:02:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A39CC061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:02:27 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u15so18031418ple.2
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jPjDCj4oMAsp60h4bh2NVC7uOBb8DB/+Zr77nfLG/xo=;
        b=NtzJkSLwE7j9AB1YYHHTNYQv3I88OSzmP8Gr3L2Gv8FAnJiaZ+ZvOJdfrY40yJajHp
         81yACiSnEpS2kC1e4wdRNv2EOS088ksAncRmFfE6Tqkk1OVfRshsnoIvfodV4HouRKyX
         VCDADuP2ARsZ/5VGAfk5Z4vnWw7aLGcgQdLtF/cs0nyX7JrU37GvOfv4s6dLSZ1QCOr1
         hVhSpBLTfmceNXkATrdJ4XebSQa/r/fvcpBFmrPenQ/bQwBj5dkv+p6tH5xOTmXUjGZP
         hQdkBYeIQjiLS/gxhLTmCJl4A1hbcdAH0Iwpp70FAXT1yNZnn/+PZddWsSD220Zl0k/m
         ue7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jPjDCj4oMAsp60h4bh2NVC7uOBb8DB/+Zr77nfLG/xo=;
        b=OrEv9CdPpzbY+Yj9+gF8C8ed+o6wQj5XQ5qD4xH5U3XQa4M9NRrpfEGbWLftQ41Z7N
         P83EKS8S601JUqkYuME/19vSmE1srrijrNFOtmuB1gCsMrVikK7urDAEbCpFoHC0tKhG
         MiDwCElnT3CLpfI5C8RQlL3+mCm+UWwpEzZWAhekS/wDVi/jl5anwgNmRaf5xf56y6fx
         RgLkKdWfKwVqpmIPkQI5bbqJKu39qO5BoRhUS9Zaqo4f14vOEHB8/U7tgeKHpjFI6lW1
         gJW2QbQ0Av7WF+EZat0mo4tQPbnu6iSLd5ii2kikHYjjm3rvLcVOn0VQ3HX8NKZtzQI0
         AUtw==
X-Gm-Message-State: AOAM530men+bFgYpGv/04zHfffe+wr3upDYJiqoHWgAtT/xAuZRbNxFh
        pUmesnOOLHvme+AYJXq9gbLT3BCzK7ePunAx
X-Google-Smtp-Source: ABdhPJx3OqbAWmR+a2TNoGl2uqSGdzte4q/083WzR1qSDgiaiiOuvfZp6FkZzDJqUH59fbDCSo6bHQ==
X-Received: by 2002:a17:90a:b791:: with SMTP id m17mr20961995pjr.239.1642356146791;
        Sun, 16 Jan 2022 10:02:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo14sm11388822pjb.34.2022.01.16.10.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 10:02:26 -0800 (PST)
Message-ID: <61e45db2.1c69fb81.9bce7.f786@mx.google.com>
Date:   Sun, 16 Jan 2022 10:02:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-41-g760a85303c5a
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 183 runs,
 1 regressions (v5.15.14-41-g760a85303c5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 183 runs, 1 regressions (v5.15.14-41-g760a=
85303c5a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.14-41-g760a85303c5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.14-41-g760a85303c5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      760a85303c5a2aeb811f92c76b8dca4c13bf3416 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61e427806be5217846ef6773

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
4-41-g760a85303c5a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
4-41-g760a85303c5a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e427806be5217846ef6=
774
        new failure (last pass: v5.15.14-42-gf9dc3f25c12a) =

 =20
