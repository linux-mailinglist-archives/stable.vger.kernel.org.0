Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0D439194
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhJYImz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhJYImv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:42:51 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67DBC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:40:29 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h193so10220450pgc.1
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B6xdWW+anDKFfHco8Ej/bsDLOxs3ZcvO5DVZ9AAVCik=;
        b=ifSDsXUX1us8SWt0J8Bb1GTOPPSK7cWvMooRQQaUnExVPwo7SzTK33Gswn6/VNhCA9
         bMeis3orGXtFBYUSu4KbrUX5WVePYhoh0CZ0sQ9OyFw85P9BlElLhiLSyxS2+7N1muRR
         kQBXlE3+4J/6qKpn6pyShoHFWTBjAflkwhiiZ/PPlin0hAiixY6Jc7kTycQBffiT2mIl
         XcQCcCCikWgJKSzyvlBB/lkvpZClf15H0TP++HJSzuP3ITergMd2QedJ95kt6bKWPBD9
         g/dWVJciyiUw3mSdOd9d7uKj1TH0zqLlQhnIPazvE48vkqKltjcKEBDbrFc4Va76AeF/
         RsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B6xdWW+anDKFfHco8Ej/bsDLOxs3ZcvO5DVZ9AAVCik=;
        b=4soRionGxNwMu42J9KNqPu5YxW2+yJbpmgmJgZ1/wVG+Pt6EcPZI/Goem9QmnNwOKc
         6Wt7kF47Gioj1hubXDgL0ZewjWHexDCZ1DlehgE31YYnjZtAs5IBnElncV6pJDTZZCvf
         mMeocnid5MhQvl70W0pUWFSmpfrtCzKwv7AclthXupCUFXs0H9yimU3tPGeO0PcuDYs0
         BX8G8l90EDLnXI8Ikp0DeMCv4EStPkKxpVabU6EIO8HWr22+2EclOtdwBABiAVlFslCq
         jak/EP9QWDoKdhbIBVPDTJcKVHDwogg51zcnpbmqNAkljdEQGZheQWcaH0iDprz7YMO+
         TbYA==
X-Gm-Message-State: AOAM532cbAvaoZCVbEZ1FOLdijJ68lwxDV/KyRbjU3IMRsJkV6JGzG/a
        OtcI8fvfw/jPnER7Zx30kByQa141t6Vl3toQ
X-Google-Smtp-Source: ABdhPJyOlO7J7K0otPfM1/R/RhHtaaWT8EjYcW11RiZSp6hvj1/UMwaGlIt672ymbKamg6KXk0AAUQ==
X-Received: by 2002:a65:6658:: with SMTP id z24mr12991740pgv.266.1635151229066;
        Mon, 25 Oct 2021 01:40:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t11sm3912980pgi.73.2021.10.25.01.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:40:28 -0700 (PDT)
Message-ID: <61766d7c.1c69fb81.222e.9c2d@mx.google.com>
Date:   Mon, 25 Oct 2021 01:40:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.155-52-g038259934764
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 161 runs,
 1 regressions (v5.4.155-52-g038259934764)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 161 runs, 1 regressions (v5.4.155-52-g0382599=
34764)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.155-52-g038259934764/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.155-52-g038259934764
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      03825993476478d2b48a06a7b31465e5b0fba429 =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61763a9672ca91c100335911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.155-5=
2-g038259934764/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.155-5=
2-g038259934764/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61763a9672ca91c100335=
912
        new failure (last pass: v5.4.155-52-g00d0519619ad) =

 =20
