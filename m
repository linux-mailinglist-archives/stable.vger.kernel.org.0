Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4ED400562
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 20:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350577AbhICS4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 14:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349372AbhICS4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 14:56:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AC2C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 11:55:34 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w8so6371747pgf.5
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 11:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i81qdeQPB/0B2/weDKbAcFnshUq4zMRoUBQsY13+hUU=;
        b=VYK8pLY979EziM55uTQts8aBAhoYvde0MB8AC+1Q9jl+/iZIgOo5fwRIQFGyDsIoMC
         bqCLBM9of2KlEgd8soypV1ys1ArqiWZOd/cpN8XioN9/d0X89FWxVPeVahbtCASKTXen
         8fIU9WZ16huc5q8gylN70t5ss6tk6du47IyOuswIyDjzB7UJlfaQdTV4XPsARtiRS/RD
         inxiUKSbKhKEBmJJhCJJWvNORByZubzG4OSWnY+4/NGl/lZiieNR/Y0N9MieHoxRw2b2
         WsLzq3e+v/qVk2sn3jECBEu+bXZI3gHShQrDL032vOFJZumwmP2ULuJIP0PZgGVKGojq
         rOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i81qdeQPB/0B2/weDKbAcFnshUq4zMRoUBQsY13+hUU=;
        b=LZuNQDOQ3t8eZTPM+SPMLexmZzbxocHf37g8I5DgdA6Aeop60v74xVnzC5T7PzXtk7
         XSLPICoeOAlfr1P0llTUXDw9R4RQTwX/ApguWlje7mvrV97Z8AJn8PHijg+ZGNU/Si0U
         TuQd+us2W8gSMro7wsoyEnGfTd53uPSDosb1T3Q+MWeikaq7i/9wMFWoZ53dCPgeiNHv
         P3O0iHnY82wK8lPoioHSAp/+hGuy9FITG6PeaINbJmUB2Pb1v4BNBmLENKeyUOT1S2oj
         xKq9Ya306ROnkZbRyKksK3jfe8NjtdxgDDygoH+BcM5h7U354wy09Hmyp8UPMHbVLLHU
         WqxQ==
X-Gm-Message-State: AOAM533EPwUK1I7mUuloSE75qNEGQEDAX0eBJTgwH2yrfp9hHBpfniJe
        mONmmSThYapaFEjCep2nrkfgIcGDLNUX+CzD
X-Google-Smtp-Source: ABdhPJy/S+kCme/86TMnmtGVrRnVHIsEh7NiLGPzfDY7PSqfkYT61edG10J2wLsgVlRQLAkCAavHoA==
X-Received: by 2002:aa7:9e4d:0:b0:3f8:6326:a038 with SMTP id z13-20020aa79e4d000000b003f86326a038mr256088pfq.73.1630695333258;
        Fri, 03 Sep 2021 11:55:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 126sm112914pgi.86.2021.09.03.11.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 11:55:33 -0700 (PDT)
Message-ID: <61326fa5.1c69fb81.7317c.07b7@mx.google.com>
Date:   Fri, 03 Sep 2021 11:55:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 129 runs, 2 regressions (v5.13.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 129 runs, 2 regressions (v5.13.14)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a603798fb16829e56f80f57879611e67bba4910d =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61323971a06b4e5717d59682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61323971a06b4e5717d59=
683
        failing since 49 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613237e364734dda7ad5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613237e364734dda7ad59=
68c
        failing since 1 day (last pass: v5.13.13-35-gaeadb98365a4, first fa=
il: v5.13.13-114-gd049bfc3077d) =

 =20
