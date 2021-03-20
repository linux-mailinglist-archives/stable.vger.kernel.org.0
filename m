Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBF7342D84
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhCTPDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 11:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCTPDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 11:03:10 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28DCC061574
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 08:03:10 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m3so5678134pga.1
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 08:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OnfqogG6rcQExrwN3ZYCf/s8b4LrW4eKoRnJDwiOvj4=;
        b=wuI9vqMI/S3wKPVurk/aNl17vwbdDGT9d77fDD6IDUT23LJKAd07z1pF/GJbk2AVwF
         +4m4+EdLgOu/+oKVodUfwooahBG2xV0XcAlLQReCB9gp9wt4Q+nPkqgnMDCOKNi9qTRJ
         nPB8/1lqOj3Sfm/qaDq3LAp3b7Xl820F4PjxG2zf3rzJ7LTyDaL/FX/PtsAQxjghbuNJ
         QCko9cZxplP8DEsq/SQnSVwIXw5umd/C1JulsKXxheRLABjx/3W9+7ell81dnsHiKsCG
         ky/z4xBxGvElDPnjip9SalPT5VhUsuNmM5SlF6DkU9PAxdoEcmFOfXXuqvPQwIIIJZ7H
         lPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OnfqogG6rcQExrwN3ZYCf/s8b4LrW4eKoRnJDwiOvj4=;
        b=X6UAcTV2mktXmdVOFwXnIHaCHxLI1l8S435d6uUrC6pIR7J2kq9KVzGlp30Eqoh2ka
         4XfdX8/Ll1ASDPz3cgEQHjl4aPuOxEaGGQMCMUcmeBTjarybBIFpEDKmQwpGyjcAVp8Q
         MWs0LHhlx58MT3t4Oh7JBm45l494/wwvRc6NdeJDjNSEn94mjnar/vGJf51IItnhQpMO
         kszDdlq7jok60iU0BWTlFJ/R9I+PAw94GIIJYEvIqpUtK+NjIg+97Xfip6GzwASyHTWh
         +8Cv9DPrCpuOuiKRZ5D+zPNq+z5Rf2p4PLDuQ8p98TdJO97TenM5UKJlzhFL0vcTHq/w
         OAwg==
X-Gm-Message-State: AOAM5326UmOtnd0nHZCY948iYPsMKJ0KRTSy2vwTYGm9bi6CXIQ6KPJE
        9xlnYTuErC1o7ja2g+VzoW263nLPw5qpvg==
X-Google-Smtp-Source: ABdhPJz1o64+K5gzcZQ4P6R0bRdhQ/MYznwwKP3PIHh/LK8bEmfBebadr0rFqhMXchPBxOivVqCjQg==
X-Received: by 2002:a63:4521:: with SMTP id s33mr15872724pga.1.1616252590193;
        Sat, 20 Mar 2021 08:03:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q95sm8628243pjq.20.2021.03.20.08.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:03:09 -0700 (PDT)
Message-ID: <60560ead.1c69fb81.2a7c1.425b@mx.google.com>
Date:   Sat, 20 Mar 2021 08:03:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 167 runs, 1 regressions (v5.10.25)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 167 runs, 1 regressions (v5.10.25)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.25/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3ba56f490c7ab26974806f8c2f14fc49652efe10 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6055dbac2be835c693addccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.25/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.25/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055dbac2be835c693add=
ccc
        failing since 2 days (last pass: v5.10.22, first fail: v5.10.24) =

 =20
