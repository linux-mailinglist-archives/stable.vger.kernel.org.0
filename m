Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBB1402FB2
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 22:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346488AbhIGU13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 16:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346682AbhIGU1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 16:27:17 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF53C0619FB
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 13:25:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 18so78320pfh.9
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 13:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e0dmJVPkNnTUeBfkcE/+IJGBrOEoyMBurLU/ZsAe788=;
        b=aZlGPERAjxYTko26dh8YTyTPQUXTZCVxHOSzzSmrqnVXIKJcAiX15h+50Gtmfe33+6
         epQVaSD6IfVzLFVRpreNvCe4GtkqciBSLgXeNoZtJov2n8h+VieSiNtCuCkZsGbY/1ik
         B9qgcJ44nRj60O0VOdads9YsrKteKoBYBdHwnsofqOjItbgsH3NU25Xh3n1jkqUKPG45
         JwMZDgkKAAnk5wnKiNyB1djETi4aSZeRdQo3sC6/MQx0ry2lYkjZMo/pN6sWsttq+f6C
         QDmLIID7s9gipqq97NKYV747/cq9PD6GBJUbbTbAuE+kTc9BvZ5sxtffAPuu14onEPWy
         Zx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e0dmJVPkNnTUeBfkcE/+IJGBrOEoyMBurLU/ZsAe788=;
        b=ObpLQlrOUokG8YuapAcuwoNWO/gu9kOENV5uAUaBrKubyiCAqxt/a6Tqc0zDPWJ561
         YzKpiUoHFaImMTJDKqfpYmDObkrjrw3Zd2oKklMN8N8Gb67xsNYstnfuq0u6gBKYITVe
         RHgqRr9J7Fz/xTVNEwT92w3NlDeTFUv6rmWOVf+/KYu3t8mUIbUmGQ7L5lVaIC3Cf0gT
         20GUF7Y1TgzJg6yvkKy5PkWC2h86eRiS+upvAKIFpJBr3ISy9xHzAMt+7MIEmdx6oFva
         azjZ8KUoAZ9ooe/ewi97sFd3+nA0+Pq1N0WEc/ji9uMwCj7Sf9FxdHriTMhwMr6+nKwb
         JynQ==
X-Gm-Message-State: AOAM5319gAu6XGpZVZ/ddGh1Si1njm0RfBqcSEyfkz9xQ/L7cZpW0gJg
        Rq/aN3kc5AgQCt9c67SyUZ0WtK6zezRumpao
X-Google-Smtp-Source: ABdhPJzDOmTNEDTHSdMnF9dM/bw2hmW3mg4O5voQ8SCXXUFQpgnhs77cEd7OQtWteBq8WsV2SltM2Q==
X-Received: by 2002:a05:6a00:17a5:b0:412:badd:61cb with SMTP id s37-20020a056a0017a500b00412badd61cbmr211870pfg.15.1631046356629;
        Tue, 07 Sep 2021 13:25:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3sm9921pgf.1.2021.09.07.13.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 13:25:56 -0700 (PDT)
Message-ID: <6137cad4.1c69fb81.6c3f0.00e7@mx.google.com>
Date:   Tue, 07 Sep 2021 13:25:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1-14-gc097b4308d82
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 230 runs,
 2 regressions (v5.14.1-14-gc097b4308d82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 230 runs, 2 regressions (v5.14.1-14-gc097b43=
08d82)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.1-14-gc097b4308d82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.1-14-gc097b4308d82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c097b4308d8289eb3a0f7f56bbace69b69ec0881 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/613795f750d51cb7b7d59670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-gc097b4308d82/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-gc097b4308d82/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613795f750d51cb7b7d59=
671
        failing since 1 day (last pass: v5.14.1-2-gbbf2e6a216c0, first fail=
: v5.14.1-2-g1f34a835c69c) =

 =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61379bf5598effdd20d59673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-gc097b4308d82/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-gc097b4308d82/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61379bf5598effdd20d59=
674
        failing since 1 day (last pass: v5.14.1-2-gbbf2e6a216c0, first fail=
: v5.14.1-14-g8db0ae7d7076) =

 =20
