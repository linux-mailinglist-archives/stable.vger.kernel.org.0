Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0730EB4D
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 04:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhBDD6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 22:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbhBDDzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 22:55:50 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93415C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 19:55:35 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id z21so1215178pgj.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 19:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ICb5d2UJjID2LI8IIe1/U23wrBG/WnzewZdFG+zdqT8=;
        b=L0glMRC00l/FeMwiMtVhdrEvA//EgOYe+wcDkES2avgBDhbl9ugQcrn7mjK0+rFT8Z
         f1XsMYo8epL3654gfhAwxotsHy+dS1Rn4r1OA8TsjehB1u0fa0dmfwvbn9JoJbRfHv+L
         bXZFCmztsMgkN7oiPWsQBERLiO5IfI+fAC2CW45oKdHzGacqQkEDHfU881VT5PxxNgOW
         N3h42Q5z6oxQgXMToswcQ2fulV/wUu4UM8JZHVyPGnuUbR5WhycPlP1ndvM3XnOjdH/X
         oiE0lZeYdM11i0ynjcAcR29QuENalFpx6ZWATSF8eQYQnZ8cy+Tk5Krdt5ZGSnJpRGdS
         EB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ICb5d2UJjID2LI8IIe1/U23wrBG/WnzewZdFG+zdqT8=;
        b=C5XPCEO7ItLYMOhuo6DsJwjEPa/oBJSxq02HmiXqPjuGDX0UvvOFShw94KuQy5aUpD
         pRqZSc4VcEVuxh58nBMw1RyuF+wf1X9ZKnDtcbqj5cWt2bKP8qGVls1dK9aitYYPpB9F
         cGQn16+Ldv2xUj3SDjj9HyXjpw+QeU3IY9zUs08RJxXX0P1Km62e5ckAhKiXVingRJjC
         C5KrnnOf/HL41LmgPme2Zv/R+nUGRnacBKyeB1LkI4NQ2Fvh7/CV/40huKdHx9UkbdHW
         /ilNK/kaR/sLznLiOdC/CiLDRqmXYWU/Rgpz4e9VqTChzsVSjjJ7hGorZDlpqR31cW3a
         TnWQ==
X-Gm-Message-State: AOAM532v7AeGeQGwf0YMEQNh5e8q4mhBP1QYdvaKccn9j/xGhIIOMjUo
        ziFOldgi7R/9V7DwqAHsY3/LWgRuVizSmQ==
X-Google-Smtp-Source: ABdhPJznwJud4dgVSumMCNWvgq11n8ePTA9wL75TjziKb6WEEhugNdDjT2te/VnPskv+yv1uVM/fnw==
X-Received: by 2002:aa7:84da:0:b029:1bd:5f0e:b1f2 with SMTP id x26-20020aa784da0000b02901bd5f0eb1f2mr6107131pfn.41.1612410934904;
        Wed, 03 Feb 2021 19:55:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j14sm3297786pjl.35.2021.02.03.19.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 19:55:34 -0800 (PST)
Message-ID: <601b7036.1c69fb81.2df27.86d9@mx.google.com>
Date:   Wed, 03 Feb 2021 19:55:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.12-143-gaa7eea29abb8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 162 runs,
 1 regressions (v5.10.12-143-gaa7eea29abb8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 162 runs, 1 regressions (v5.10.12-143-gaa7ee=
a29abb8)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.12-143-gaa7eea29abb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.12-143-gaa7eea29abb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa7eea29abb806d03856b012b49fe74b45a8d701 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b4082bb13472a7a3abe87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
143-gaa7eea29abb8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
143-gaa7eea29abb8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b4082bb13472a7a3ab=
e88
        failing since 3 days (last pass: v5.10.12-3-g0bb4aea7b36b5, first f=
ail: v5.10.12-31-g38757cf9716b) =

 =20
