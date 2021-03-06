Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C61732FB58
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhCFP0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 10:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhCFP0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 10:26:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB47C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 07:26:18 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h4so3410694pgf.13
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 07:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TWxbmUlhGEnwZxjO01MLdZZapSnRgikzt/R/bFmy9FM=;
        b=OLOn+BpJP3cbwMpcJ5eqzWcWXD5zJ9oRkMoKcmBhKtVyzc43bpL0OjKs6XMVC+zOJq
         mGip8cvAaKE5AN/jmq6BtIdky9Ppg/a5TubJnVvibwtPtNBBQAluIl8q3NOK4sOJmCXY
         fjfgyQfJfdoGuQQw0lglY0OjK+CSpDi2/NJ6iO0SFHjF6REtUZVTcG704ali4fd4OO0b
         kdPV271/QAq1efUmiyRTwyzF7THr5rBEl6MqTEMy6Fh2+vUB9rbCEwGJq29bOvSr+xs2
         zS0Ix3SAhuA9KGVC4p0gd6VGf4CwoyFzuwtTcRSG75l8CgtuVqoxZKyj9HakrPzTGi8u
         jCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TWxbmUlhGEnwZxjO01MLdZZapSnRgikzt/R/bFmy9FM=;
        b=lgknzHVvMlWnN39DYV2SCWP2aQ+kGOuo7DbGDGljtzza5ZQQnHTccUVb/Ysfs8X242
         a9icqyXdcF+x1gkHHbNuDQEmz7XuRibJ7jZMU7qxcfLew4qMbHbfm/2Ku+gfX1jIzhy/
         Nl3aZbEw1LvIFBm97Xv6LXBMQk+HPKaQmnzgZOe8KxVOKoJ5RzVtD56wSw0eZtoOHnPw
         U4Bs8fbF5YmpblcmWw0BbCY7730kLp0i0jLi88/oWUuNJTOUoRTtDdn37HCp8R/y1KPM
         b/2Wux0FXQRj9MHqdsUBdKIlwFY5ukjC757URB2wKYbtt9CvYXLQSVRKMd43zGs76rHJ
         4IIQ==
X-Gm-Message-State: AOAM530CyHd8MS2mKv4/nfbiQSl6nVoG9XTukyaiDrD8zRhImAeIU4dK
        dl5y8RkhXbLE396LQiXtBnFjfELX8vqfOg==
X-Google-Smtp-Source: ABdhPJwVoORDAL2+rjNDdNMMOfrRGx4Lyw8rLaT34ZvULOUzJd5Oz68icIpD/r42AyYmKIg7AlXm4g==
X-Received: by 2002:a62:80cf:0:b029:1f3:1959:2e42 with SMTP id j198-20020a6280cf0000b02901f319592e42mr2293524pfd.39.1615044377442;
        Sat, 06 Mar 2021 07:26:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm5499095pfv.185.2021.03.06.07.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 07:26:17 -0800 (PST)
Message-ID: <60439f19.1c69fb81.47aa5.e4d5@mx.google.com>
Date:   Sat, 06 Mar 2021 07:26:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-102-g3f7b2ad335513
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 116 runs,
 1 regressions (v5.10.20-102-g3f7b2ad335513)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 116 runs, 1 regressions (v5.10.20-102-g3f7b2=
ad335513)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-102-g3f7b2ad335513/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-102-g3f7b2ad335513
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f7b2ad3355132435bf621505b95c21220588605 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60436fc70d3e853738addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g3f7b2ad335513/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g3f7b2ad335513/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60436fc70d3e853738add=
cd2
        new failure (last pass: v5.10.20-102-g1e6ee0c5a3a07) =

 =20
