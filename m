Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69E2379CF2
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 04:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhEKCcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 22:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhEKCcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 22:32:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D983C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 19:31:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cl24-20020a17090af698b0290157efd14899so481163pjb.2
        for <stable@vger.kernel.org>; Mon, 10 May 2021 19:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bLKswOwzl8VEzeuYu7WYE+4y3kgoJH/Sq86v8aLmG28=;
        b=RIscSlu2kM+ay5cCl2p1Qa4vCayZ7NJYMlz0A3rtACJ33RhhKOlHfbK3AVEVaEPtmf
         fdMdsHYlr5QGI5nlqzi7BdJpJgWi7dLtP+G0WPQp7fs4wCN6fDjPngJK3eB3V4mcbg5b
         dyIxwqA/j1STBqPeojef7tex7osbymYEDxa+gs7O7DrogE4Ttu98n5XRvbFoDkPcYzEz
         qZp0iRTD5o0LyTgnMKKiGeTK7u8x8Jm+PfgAAe6jd/sGfZlLamnldwZq4NVQAddsMrl+
         qRQJwRIGDNI1XLwZmwCFvmzybTpp33A7yT0cqtzrci6NffFTa6cbSotinHHdB2JUQjol
         y/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bLKswOwzl8VEzeuYu7WYE+4y3kgoJH/Sq86v8aLmG28=;
        b=mjZGRtg3h0lMhAfVD6lcZ2tH4bECiaLILKPHeVDfVVB48OwqcoiL+M0ozwEW/8m7gZ
         VFIu0uNp0ahs+q/zEYrsUVWAKlEmMLtXa3xwfIEs6zzTyRVDFj4RBUvXALcGWtbDXVMk
         CAENIHFBzVNVwjELN3Qj2pp/tVVVYd66mH6vdwXZhk/+9Nm56GuPZx11Yh6z+MxzP/um
         YgehneULf14MI0G0JRtoVCxhbBIfx72kcgoZ64aABan17YPLlzRS4GGXb8BdPXswwWEB
         nvhEyio9xwkv1rYfGEJFwOlT15ONCbXZ/dDTNX+0fDJ+Hmtc4ess64b4bzhJ4dylWsm/
         Aivw==
X-Gm-Message-State: AOAM5339oD/1WEDFJTJMxLcKrql8inVI8v40cU1IZn8XfnAe4gs4VqSv
        UN+8ti0DJIbzDWHpCU2lRNQQRwcBBVGUhljE
X-Google-Smtp-Source: ABdhPJxj9Bf27cBpcsTsuJ1+qYoWjdSajX2oX+jPmsMwiHMvlKCrd/vgKLy49oNjCIurQurvfXTPEw==
X-Received: by 2002:a17:90a:fa0e:: with SMTP id cm14mr2446429pjb.59.1620700265577;
        Mon, 10 May 2021 19:31:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v11sm1594950pfm.143.2021.05.10.19.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:31:05 -0700 (PDT)
Message-ID: <6099ec69.1c69fb81.dcfd5.5ca3@mx.google.com>
Date:   Mon, 10 May 2021 19:31:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-343-g44eb32ead9ee0
X-Kernelci-Branch: linux-5.11.y
Subject: stable-rc/linux-5.11.y baseline: 159 runs,
 1 regressions (v5.11.19-343-g44eb32ead9ee0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 159 runs, 1 regressions (v5.11.19-343-g44e=
b32ead9ee0)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.19-343-g44eb32ead9ee0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.19-343-g44eb32ead9ee0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44eb32ead9ee049c1d607d49a1eea51e191dbaa6 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6099b80f3fd33684bc6f5482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
9-343-g44eb32ead9ee0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
9-343-g44eb32ead9ee0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099b80f3fd33684bc6f5=
483
        new failure (last pass: v5.11.19) =

 =20
