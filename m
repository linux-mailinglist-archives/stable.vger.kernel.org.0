Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DED3828B3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbhEQJr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 05:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbhEQJr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 05:47:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E35C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 02:46:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ot16so1420444pjb.3
        for <stable@vger.kernel.org>; Mon, 17 May 2021 02:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q3xF0Z0cY2AQetLtcHIzyco5G70ARpQZyMbWWjpWqv4=;
        b=Ti2kFYaW4X1m+aQddlz5ytFE9tzu8dZEARH8KMSpJVHEpsUcaCMD+MWumGaAGp4wwQ
         pb+FzXxskgxnjBYYdb3Qh77sPkpVrJYl+4cIVP8Z0MeZk2MiIHfDaanWhCoLnTIpH/u6
         Dou5cGKa/NrM2+DGpjZEKILuqZerahjd4W0Zr53kAluPQpzZykY04nqVfSQh0YuOCyu6
         VRiGjoANAZ2eg6N9HE04nnROVA24WH+jKrTaR+j4XB2mOoZZOtThXvnxuHRHPZ/5NhRd
         tdFwpbb5LRB9YJPriHL3PYX8lcvTwfavO4XRfqhV2vzL6JGQgfuwhI1qY51bPEdRb4ui
         L3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q3xF0Z0cY2AQetLtcHIzyco5G70ARpQZyMbWWjpWqv4=;
        b=nGGS0tVwjzhZQZa5GEW/GuHOU5sKHZKdcsUbkHFZ+OhSdlw77degkV+B2jkrbeu3+8
         rIx6rYh5lOlI8fhdaD8QG4BuVebjlvQFBMgTaYzmLp+sTTd+kXAUFwGyOy6xNkbGHobf
         bN/0CF8r2LTBkgZOLf/LLWmaE2RvYtvVcEShkhwDofqisu+YQwYEPeDzcMG7yaPKeBUj
         igaKGtpHLYJrSI1iBz6xvvuBjcg2fNCfUu4qHbKmt1zdmuQW75wRcWNWMo7j1l6UGxOF
         bM3rAnKbm6vu9l9muS8DaO09nmSWbaqvtlLk1MCQE4kdwv/qHbLrOE+S8X+6r/Qg1jvF
         qyvA==
X-Gm-Message-State: AOAM530lIw+Wd0kvFLifHLYNOL/AU1b+HN5HoCB5aaeSRLVCATEAMNXT
        8GFs6YcAQv747WGY8SKFvTNrRRCe7tD7nZ/z
X-Google-Smtp-Source: ABdhPJxx+VPU+xFrjeQosWjFEUaMhpblVOUqIxpSYpv+A5zIitWLhwc3yfWt3UGJH2+xPiu76tlj8A==
X-Received: by 2002:a17:90a:5507:: with SMTP id b7mr4222579pji.27.1621244795202;
        Mon, 17 May 2021 02:46:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ci2sm8300239pjb.56.2021.05.17.02.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:46:34 -0700 (PDT)
Message-ID: <60a23b7a.1c69fb81.350e8.aa07@mx.google.com>
Date:   Mon, 17 May 2021 02:46:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-280-g28a979e1dfe0
X-Kernelci-Branch: queue/5.11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.11 baseline: 110 runs,
 1 regressions (v5.11.21-280-g28a979e1dfe0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 110 runs, 1 regressions (v5.11.21-280-g28a97=
9e1dfe0)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.21-280-g28a979e1dfe0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.21-280-g28a979e1dfe0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28a979e1dfe02f3194caa64a85fbb4f551b9acbe =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a20c7d7d15300507b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
280-g28a979e1dfe0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
280-g28a979e1dfe0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a20c7d7d15300507b3a=
fa7
        new failure (last pass: v5.11.21-249-g923b46b3a2c0) =

 =20
