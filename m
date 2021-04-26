Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9715936AF8C
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 10:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhDZINR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 04:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhDZINR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 04:13:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABDFC06175F
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 01:12:35 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so4708382pjj.3
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 01:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MxDwaM9CwcklR+YKqIDAxbXr+wgRRdp3iX9BLqLynMc=;
        b=kT5rllJwQE8u48C+7jxAB8JnJgUwdOSeHGwFx+nx+skD5EmBIqfIC6T4pF6Muaqmj4
         5RwbWgue/uV6wi/FF9mA1IVmjp2H892cDhAsZZVQJPuifMr3/FEy/u+Bv6JkOojgUtM9
         /CI7BYcxyu2FNOywuQ/g3ZCioMvp6hYOpJUg0LUnD9XPqE2qn9OotBbSZw703qOZW1o+
         8GZWjCkTT8Yz0XlrtRBj5uyGHprwOyznd6KcsghZim2/vKLB73qAPtz3hiKl97zDDaFo
         98Ss7hKTYex2VKnjt97BElrKFY0qpiUSWY6AV76lOpPs8ZWvFw3ThOiAeLKDBIPBeBCT
         1gEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MxDwaM9CwcklR+YKqIDAxbXr+wgRRdp3iX9BLqLynMc=;
        b=CDMslFXjA03wqosHR5dL7uVghgaB0yS0T5nS65WZVliQk84669D3fehAU+OByfZj6i
         eoR6iyatMInwRz2qXW6dH2lUD6U/WQavjoly1Y8FhLfgVrNInUYgJPLloQ3Fseb5nYXD
         9c/WmM2LgrYwFDSMbOsccWdEzoLzlOkFNT7Mb/tn2ksAxd2gWMtH+GN0si7mF6+s6Xx6
         85numl5seTC7yMDgxbq7Kb3MTcYssLl9UmvWq34bybgSofKwMgv8UPzGMWfm3uQe5lOO
         h8CuxhL+hHEcX5qB/jEtzhMQWDUcmIy9HQMUGE+0lwKlmCd16wk9ea/mTzIeSIJhYwbg
         qVpg==
X-Gm-Message-State: AOAM531wzl5uwDoJQSAl/QIHsJkXACVidS+VHbkC4wMWxm/DysNiBJpS
        PJ2ul/LJX18kWssJcvxGUKmnr8vSdDNhXqJ/
X-Google-Smtp-Source: ABdhPJxiWNyiU9kdBreL1+oFMJOzUDwB6/sAPJYtObhuFauHBUixdo+bjLLP21BBBOga+QhrU+9SdA==
X-Received: by 2002:a17:90a:df8d:: with SMTP id p13mr13547835pjv.38.1619424755253;
        Mon, 26 Apr 2021 01:12:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c128sm10685940pfb.81.2021.04.26.01.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 01:12:34 -0700 (PDT)
Message-ID: <608675f2.1c69fb81.1585e.0365@mx.google.com>
Date:   Mon, 26 Apr 2021 01:12:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-35-g413e8e76f9149
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 1 regressions (v5.10.32-35-g413e8e76f9149)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 159 runs, 1 regressions (v5.10.32-35-g413e8e=
76f9149)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.32-35-g413e8e76f9149/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-35-g413e8e76f9149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      413e8e76f914957fe23bda30b3ea0b73d93f7b12 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608641ff5f5eda02c39b77be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
35-g413e8e76f9149/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
35-g413e8e76f9149/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608641ff5f5eda02c39b7=
7bf
        new failure (last pass: v5.10.32-12-gd2a706aabb95) =

 =20
