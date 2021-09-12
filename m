Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37C3407D85
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhILNRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhILNRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 09:17:50 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E73BC061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 06:16:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q68so6739952pga.9
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 06:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GRx+OiXFaSroBPdEr1WDBTmxhIjGT7TLhs/JsqM0MQs=;
        b=agrKTzgwi8eQ0XILIqLhUieHQ8QJQ5/302eX65iOkW2ypPzTiZr7kkUSRo/u0LDydJ
         hyDYQwskhVouUQOntGklsaVNBLmiU7zU/DYzUsLqysSZFl9CCFJfMF5xJk0mF+P0xlYf
         XqwIhLYJkGmY9RajmWjJkwyYTYF2SSd7x04y/m9qxD1fMlFBmobXAQzEv+2GtdePx9U5
         70UwJT1jQVomtok/7yoz1ja4J4lyLypbkSugBLM6HHj0alEwUoAh/lhHrHd4j+/Gsn6/
         83Qe6w2wmHAXS18eSzjpvmtgo8T8SJd7aWyNM8Bk5E9RWhC6Vt5cWRLSdO446iWAqFoF
         R29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GRx+OiXFaSroBPdEr1WDBTmxhIjGT7TLhs/JsqM0MQs=;
        b=zSiXLnqSzl8gStrfaYUr57Dhpi3jkTVHz+CmsxjcS6Fey0o2ZEutkuo3K+nkSsa3H+
         X5kS0a7APyvewWbR3TF722s5ZP2GYF35Dm32Cl2DURWpQep6S26QLzOnjZei/Xj6tSmO
         1vwf4/GXvymd4lXkCFiBxUhvIxp2x7WX7MRRtg1ZBt8Oht5uoAb4QkFmhw5HkQ90LVoM
         6AoYy8vDX8SlWr/rcqfogcD5evKgZkCJ7vEZAWXohDHu69XwK8QP+91TbICdlSGF2h2E
         4l/qY+9EyXqxFf++vtBSorEeFBjfDEB2JIU5fo2ul4qDflxojzx1pSzDTAF9Cr/Nabzo
         Rnjg==
X-Gm-Message-State: AOAM532ckeFxYyuydiQd+DKtTRLiln2y4X0vq4tlzt9q1s7OxvDTUr8I
        SZtajEPOysVR0NzbjnvhVfRVVlm8CU3s69kt
X-Google-Smtp-Source: ABdhPJwuw6QO84Rj9t7CHi45BBMzUg6Ig7ZODLU4gH7E67Pv9grwbqM5fYAshVpGGE3DfI+tFOCfxw==
X-Received: by 2002:a65:5643:: with SMTP id m3mr6585213pgs.224.1631452594602;
        Sun, 12 Sep 2021 06:16:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22sm5042170pgo.45.2021.09.12.06.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 06:16:34 -0700 (PDT)
Message-ID: <613dfdb2.1c69fb81.255a0.d50b@mx.google.com>
Date:   Sun, 12 Sep 2021 06:16:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-23-g3e6e24d4af82
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 203 runs,
 2 regressions (v5.14.2-23-g3e6e24d4af82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 203 runs, 2 regressions (v5.14.2-23-g3e6e24d=
4af82)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-23-g3e6e24d4af82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-23-g3e6e24d4af82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e6e24d4af8272b3fbd4eb4efe515193dca96ccb =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613dce555919e54b77d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g3e6e24d4af82/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g3e6e24d4af82/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dce555919e54b77d59=
667
        failing since 1 day (last pass: v5.14.2-23-g1a3d3f4a63ad, first fai=
l: v5.14.2-23-ge6845034189d) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613dcc2629aa89f30bd59684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g3e6e24d4af82/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-g3e6e24d4af82/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dcc2629aa89f30bd59=
685
        failing since 1 day (last pass: v5.14.2-23-g1a3d3f4a63ad, first fai=
l: v5.14.2-23-ge6845034189d) =

 =20
