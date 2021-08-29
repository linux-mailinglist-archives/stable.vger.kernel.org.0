Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3AC3FAC6F
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 17:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhH2PNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 11:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhH2PNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 11:13:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2F5C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 08:12:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so10621272pjb.1
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 08:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/5KmX7kLn4fJG2dWDV+5C7nyQNEw7FVCbG42gBJh924=;
        b=mK+xkW0z+hflufQYZHotAQ7JX/U6EBJCUbl13h/yEptmxxfl28lDV2acCqY3hvSX8l
         6/AO/AGe1mnFkY97z2p1Bl5tQj4Oqjq1mG1pxdqDNtzlbsOR0OtL71mVgNgqNNXSmYPP
         n1dwAK6FP+ir3FJzFrp2YOaOfsOb8E25ws2bTzVstWqg8A7h306Uk4idtiLSDoSCu66c
         rO4yTOUAV6F5UpCTmqiMcUOQxFROxyPln+sphWMBI4N6B61MA2Taa0MAlsTAEcFT/zW/
         cURk0JzpfAT0lpE7hUWcsKA523pq4YtazjWEA5mMW7NkDwQP6nzu0yp7co36bigqpbK6
         KuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/5KmX7kLn4fJG2dWDV+5C7nyQNEw7FVCbG42gBJh924=;
        b=TSSlOpG5JECQG2Hgr0ENgIWmi99MfssDLALzitLvWKvc5+IJ0k8C/OdqPxCB1PARHr
         FVbS+fZE/tlIxTOCljbrYItesyU3s4tARQuD7Bn/fHVZUGapjz0qqn5f3uSao+3UTLJA
         R6+iJvHwOtqAuIpNIO89+O3MrMqiHdtVy/VTGgPl4XyD2tgmJZhiFb/ttRGZdqYK1gPN
         p1jShEVr4scP2IFUCI/SvGiB3TO1raUD19/5vQchQNYfFSvSzDDn8HvIE3yNf0l4aIc2
         0zzLyiPbGTg70ocfjwMXd84/s+VRo/G9q5sPp9aCD9o8LWM7ce0N3P+/VS4a17dIIZP8
         oM7A==
X-Gm-Message-State: AOAM530tA1Lvp6MTTLArHVyyYlifmWgvLjj37DIQqpzWfJ/n/1cVI5se
        hLXR6sbsEEujNzhJn5PQLUlDtZgE+e2uZDh0
X-Google-Smtp-Source: ABdhPJzR+XQYkxgYvhfszvydVZi/2Xzoxe10/xeQv+wojgUn8O+hngIV+zmYLmRG4bv6FubY88vd7A==
X-Received: by 2002:a17:902:db0a:b0:138:d2b6:4d1c with SMTP id m10-20020a170902db0a00b00138d2b64d1cmr3352982plx.72.1630249952004;
        Sun, 29 Aug 2021 08:12:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12sm13639722pgc.41.2021.08.29.08.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 08:12:31 -0700 (PDT)
Message-ID: <612ba3df.1c69fb81.a72eb.2b74@mx.google.com>
Date:   Sun, 29 Aug 2021 08:12:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.13-35-gaeadb98365a4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 144 runs,
 3 regressions (v5.13.13-35-gaeadb98365a4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 144 runs, 3 regressions (v5.13.13-35-gaead=
b98365a4)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.13-35-gaeadb98365a4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.13-35-gaeadb98365a4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aeadb98365a422201468ee9d9526e08d37b20866 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612b6da8068b01a2848e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-35-gaeadb98365a4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-35-gaeadb98365a4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b6da8068b01a2848e2=
c83
        failing since 2 days (last pass: v5.13.12-127-gb85f43f33b05, first =
fail: v5.13.13) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612b6fc73f7ef2a8ec8e2cab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-35-gaeadb98365a4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-35-gaeadb98365a4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b6fc73f7ef2a8ec8e2=
cac
        failing since 4 days (last pass: v5.13.12, first fail: v5.13.12-127=
-gb85f43f33b05) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612b6f4a3b5ad39aa28e2c8a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-35-gaeadb98365a4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-35-gaeadb98365a4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b6f4a3b5ad39aa28e2=
c8b
        failing since 44 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =20
