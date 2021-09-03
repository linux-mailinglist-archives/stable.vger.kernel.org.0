Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908F84003F5
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 19:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349862AbhICRMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 13:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbhICRMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 13:12:36 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27A8C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 10:11:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j1so13034pjv.3
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 10:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kGbEuW8b7EuCi4+NHgNrTEv6p7gdzyTzVcj+EW0AZBc=;
        b=sitmL05Jtgqp1HzqLovAH0BRpvzkCZmlcKU5s00rflIvgHe5h0lp5NBEnhdTvoUOEI
         aRqTe6OhVLnFdOvlEqfWJr9eg/3V81JTl5VKzIKIUbH/yDPdKobq2DoK3q5oKyN/0s1A
         w58tbKgufNUC8NE6iB9HDToPLbSZ3YVQdWBLQPsOErXef04jrEhBDggWxsT3fAGH1y2s
         8K6RGOnzykTo9klCvpTF7MkpWZVm9zMc01/BH76s8GFxu/uVDRBGWZMTGpuEYYsnrzD8
         y6OSO4LvBLdocGXX0ux+nlVfvof7PHvC8KfErKcUCtMwapuBkWczv7VWKBYA8PCR9/wc
         lSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kGbEuW8b7EuCi4+NHgNrTEv6p7gdzyTzVcj+EW0AZBc=;
        b=kTlyF9BFzTXrpuwx0UI3byQt9NfZQcUCrNCAp+OxRnLhWd/RxoqKmrvqzPtKmfApzx
         V+qC7GPLDnQlYDiY+vXkvfGHyNhrq9rd1nHJnVgWf6tq5R6myEiEsCEmw544LkI75x43
         IZnLpDGPIkSjapv4J0aFQNK56CpStUqEXy1Pu8uXAJVkrqwGRTGtRX4oAcTQ6LR83c24
         9fm4/6yfg1APibk80hIk0gxFA/0BtPaSxWlv8l6CERhd1Z3dkeahTVu5BoidZkLDPggm
         X3YRguDRcEL24aVrTGiSEnNui+yXn80N1+BP/en0VP5ZTCrH5P7HRv6/aZxsmrxMEC9w
         sjtA==
X-Gm-Message-State: AOAM531McIIgw2i7ySQV1iNwk7oPxVpBemew+eTB2Fh/ydRkRIHhpJrh
        kBgElbY0fvIwleDTiy2pwQ/ot8Yhc/fx7ClD
X-Google-Smtp-Source: ABdhPJypAYgWuvHECM411vPE9cw1a6PnptDlMf6u3KsDLHt2MKBDzsJQeAuUUjfmhhaz9hEn+asxSw==
X-Received: by 2002:a17:902:7fc1:b0:138:f21a:4be3 with SMTP id t1-20020a1709027fc100b00138f21a4be3mr4021564plb.27.1630689096202;
        Fri, 03 Sep 2021 10:11:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm1729pfj.153.2021.09.03.10.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 10:11:35 -0700 (PDT)
Message-ID: <61325747.1c69fb81.94ab9.0010@mx.google.com>
Date:   Fri, 03 Sep 2021 10:11:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 178 runs, 1 regressions (v5.14.1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 178 runs, 1 regressions (v5.14.1)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.1/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      66a613c5173456fe0edfa1a89147381d2802d4e4 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613222bcab96a8cdfad59675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.1/ar=
m/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.1/ar=
m/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613222bcab96a8cdfad59=
676
        new failure (last pass: v5.14) =

 =20
