Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04433370273
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 22:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhD3UwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 16:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbhD3UwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 16:52:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD4AC06138B
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 13:51:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s15so8846733plg.6
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 13:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Aa8LZtRQSBs4E2DeOsAcRs0TfblsG1nUs5+Tz3A4D00=;
        b=HYutAyh9H7/6mv+3r9Ax6KW94TWC7d4ZFGt3CZSpnJckGwT9zROqgtU5VXqxuOspU2
         zvI5wYuIAQvgKbveUft5lqAOzuL6KuNAYjNiklsWxOfCslygvtQ78t26eXPuD2UIexq9
         m2YmWHHCnKnBOYHapEJIAS6qAMitDrjzA2VX6V3OT7DTHWZQIGCjn6kyfTkqRXTjf4w0
         RXT03XDw3rwzBPWH1HvRxqwdCkRrrkVO3lj6ublbYS0QvKCp1TbSGDkaQMWZ++ibuIGd
         Arie3QFSNsdFFddGzTR5FaStUEGx1lk97VBgPV2CvZKegM5Os5Od5HopRueV0Ln8qqVX
         8CHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Aa8LZtRQSBs4E2DeOsAcRs0TfblsG1nUs5+Tz3A4D00=;
        b=osTZCcKNVZ0c8NHoPNo2CKG/MAYuYDbAUnox8BuNrSJjZyDXi2p/vJpkWfAG186HqX
         WT3BhU/ofdJ9VHOyqw6MX2TnyH+PkDFWALa7jEiJmP1lmNCkUo355b0miFb5EGowsrAb
         sXFcZGj1WA+TR6utVyh2Ut0w2BW0hAZKSagLbaKqjeW/rYur4dNBtfcYXLZbaHbhFMZt
         rLX+UeJPb/7UKkim6MPwbTAaJ0qZnedeCUzYEZFsN4/PvjeKFZKmSd+pWNpCLuFP0C3e
         smPTSUQboMwSUrY2Ue2biULA1FgCD/pWho8/syYgtq4I6PkYBUR6JmWMhd6tDTY15IOt
         OZ0w==
X-Gm-Message-State: AOAM530OhWEVVE+86DvaxKQlUm+dgN+3mEKmVF3pXKfmidDRqZa8BQ9c
        nySz2t90RLXSVvqVBGw5xlSK574ujjwq4Vao
X-Google-Smtp-Source: ABdhPJxtsaqjs2duWYDYrJLeCXBIZ3Z+KOnfzXp26JJMKGY2ayQVIxU3sdjEjIR+Xn1pZY/qKphY/g==
X-Received: by 2002:a17:902:ab95:b029:ed:61c4:a7e5 with SMTP id f21-20020a170902ab95b02900ed61c4a7e5mr7122300plr.81.1619815881484;
        Fri, 30 Apr 2021 13:51:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c16sm3811358pgl.79.2021.04.30.13.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 13:51:21 -0700 (PDT)
Message-ID: <608c6dc9.1c69fb81.0570.a32b@mx.google.com>
Date:   Fri, 30 Apr 2021 13:51:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.33-3-g9fe3189f108d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 161 runs,
 1 regressions (v5.10.33-3-g9fe3189f108d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 161 runs, 1 regressions (v5.10.33-3-g9fe31=
89f108d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.33-3-g9fe3189f108d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.33-3-g9fe3189f108d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fe3189f108d04763059a2dc87e213f4e2064ec6 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608c3e68be3d0a81999b77c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
3-3-g9fe3189f108d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
3-3-g9fe3189f108d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c3e68be3d0a81999b7=
7c1
        new failure (last pass: v5.10.33) =

 =20
