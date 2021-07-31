Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2FC3DC6AD
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 17:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhGaPdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 11:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhGaPdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 11:33:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734B4C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 08:33:06 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e21so14645160pla.5
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YIJIuHW/bJjWvOGjD0tws+S/OpeYLgqMLyl7KJAoHhw=;
        b=Ida4AyIbbGHp/eECUN74H6gfjbzg1P3AkV9EJ8IbCVQPvMX4eWY+YSgIAlO1Mzxsbl
         4IgnmztT6TQSxHh/IqkFIwfO7UDZoKaXG/CyLRfQJ/9LjsFNubPaL4d28CPQMY12A5Yr
         VHXPfDKiGPwDNh+OSGTrh7iVEvwpG+oQiQWT4SIiChB3I4nPVNPzcXDB3keTbSfXc9j4
         eLSL42klbb7EFMi/PuQGxP8RAjM7izODDK/ZfErcZqSUV/8D0d7kotvrb74VJN8zhDYR
         40+5vzq033uD5/dy9RUQYElyIkIfKrCT6CaKwf0FHcYl3u5PvCMW7+1JJyshl/BVpfXr
         q2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YIJIuHW/bJjWvOGjD0tws+S/OpeYLgqMLyl7KJAoHhw=;
        b=uSWjEB8zNYizBSxUwizAFy1YEwy9VYpYi9LOgnLPqIWGmnt6XlvxMHfXwmpLdWgipn
         O/2+1E9H5h02//DoC/1oX3A7E3NOGIvUbPMMsixR0O+FX8xuSL0dNgQuVjTdw1ebEPvt
         JxUBYKR+13D7YC7SA0IDLLQX4XCQB8wcDr1xCWVLP7MwHMq8LhfoXhXo/wZ0zlgTk4fT
         fG3PZFPCxgA0yaaHhJEr48x5/YlFV50gtvsN++ArpRggHGzH7/9At4SN52bjRklGDDHf
         4HD/1B/4hTknUGDTP5gdpdQmbgXWKdyf2y6T0hJiH6F1xwc8CrzFkUs3dz/ENFpCgG0R
         YQfQ==
X-Gm-Message-State: AOAM5334H8u8QjvtmLpzwOy7tAqpr+6gEuCFPlPc4asAqHa7A0A1u9Sk
        bSPvV0cNUwaGnTnslICYlVSFGTBUlm9tB00R
X-Google-Smtp-Source: ABdhPJw2Y3Y95K5mXDp0Ke50u8Vd41ya6TNWd9P3zG4aoZ+7C0tEstG9T3guVmAyVbJ+cd6SOM+aMw==
X-Received: by 2002:a17:90b:1b0c:: with SMTP id nu12mr8976993pjb.177.1627745585782;
        Sat, 31 Jul 2021 08:33:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s36sm7216383pgk.64.2021.07.31.08.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:33:05 -0700 (PDT)
Message-ID: <61056d31.1c69fb81.6b9ff.2cf5@mx.google.com>
Date:   Sat, 31 Jul 2021 08:33:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.55-27-g65d2f1e1446b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 105 runs,
 1 regressions (v5.10.55-27-g65d2f1e1446b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 105 runs, 1 regressions (v5.10.55-27-g65d2=
f1e1446b)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.55-27-g65d2f1e1446b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.55-27-g65d2f1e1446b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65d2f1e1446bd6469b036a0c7c80bda078adbc02 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61053979bc4cd6ea2785f472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-27-g65d2f1e1446b/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
5-27-g65d2f1e1446b/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61053979bc4cd6ea2785f=
473
        new failure (last pass: v5.10.54-25-gdfa33f1e9f64) =

 =20
