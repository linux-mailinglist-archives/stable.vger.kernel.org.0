Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBB629CA43
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 21:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760014AbgJ0UgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 16:36:08 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:36808 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbgJ0UgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 16:36:07 -0400
Received: by mail-pl1-f172.google.com with SMTP id r10so1385836plx.3
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 13:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NOYDOUUaTsCcl+hHG6Aiu3U7HuPD7lzZFtHDMsbCsBY=;
        b=nad9XtQa+UE/sDuZUiTUV/MzetpwQYLyhYo9+IS3q1D4kkpf5GzsS5JIjmR3DWUs8o
         MuGdWYxu4DO1kSz2H+ho9+PNhfIIseAUzXlEDnPBN+tmn8+iwkfaQQL42sJW+NPZRIFk
         CKVDrNgqkLmkOjiBUxBRzXnELi4HaxTpg5g1NvpyYs/aXrIiOz365byULjoDXDVdtPbp
         p9MKP+9S3xBAm/gpn6mZYu30dttLY0xa4mUX23Qo8ahM3H/p5Eq4320xEIvMNmaRSbEd
         1Kn2yS1IzmpUReAchg+OgqSxfrfQLacN9Fsyk/t/CgutAvxH7jJmvqSMU3k2oJ6o4N5b
         o4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NOYDOUUaTsCcl+hHG6Aiu3U7HuPD7lzZFtHDMsbCsBY=;
        b=UdHHvXKTBk2AI+S0xN/OBnN068wZ0LM29E2jbLYWFKgTEVHF0Iqi0vPVmOGUK3HtkQ
         GY8lSc9XnJnfpTRz+PO3xf1+0iRcrwGUf4g/JoyxOZM8GmIFAQt1HnIMkmY0U12lJW30
         /QtzOcv/+Cg57woUIhvowqvcIjiCM2IZuyH9rLNw14IWz3NGg+sVAeXiaN+KguLGYLgU
         0DrjnipKy8gu9pUoBKFFsLsYoLDIwUZeUj8I8/Vz0Zas2IiFmqOZ+1gNNiQI64phVA5u
         GRkQfMq91XurIEFgEY6HrpUkveBuHE9klSnOgyW4tK1uXMZsfp+pebqXbFGEQXuJWqwe
         bNOg==
X-Gm-Message-State: AOAM531wlPuABLXDsOWCUtGeAh250nihtp0w5omb3THhw2I1eybBVQ6b
        FWtR0RnVcZeURUyVFujNDg1L9EjPQG3bZQ==
X-Google-Smtp-Source: ABdhPJwcLjIsBXTpJmL8WkGP8e4vaKJqs9ui73VqtUnEl+i7/YWO0+JkpDmrpG6na3wGlh75VKAy7g==
X-Received: by 2002:a17:902:9042:b029:d5:eef1:c9c8 with SMTP id w2-20020a1709029042b02900d5eef1c9c8mr4215868plz.0.1603830966291;
        Tue, 27 Oct 2020 13:36:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x198sm3077316pfd.187.2020.10.27.13.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 13:36:05 -0700 (PDT)
Message-ID: <5f9884b5.1c69fb81.ec471.6073@mx.google.com>
Date:   Tue, 27 Oct 2020 13:36:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-634-gd1d01ed15406
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 186 runs,
 3 regressions (v5.8.16-634-gd1d01ed15406)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 186 runs, 3 regressions (v5.8.16-634-gd1d01ed=
15406)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =

imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig           | 1=
          =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-634-gd1d01ed15406/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-634-gd1d01ed15406
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1d01ed15406ec67118adb200ffbd77f01632af2 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9854c7da1074c645381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
4-gd1d01ed15406/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
4-gd1d01ed15406/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9854c7da1074c645381=
013
        new failure (last pass: v5.8.16-627-ga9047ecdbcb4) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f985e072217831ea8381022

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
4-gd1d01ed15406/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
4-gd1d01ed15406/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f985e072217831ea8381=
023
        failing since 0 day (last pass: v5.8.16-626-gbc7f19da4ffe, first fa=
il: v5.8.16-627-ga9047ecdbcb4) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f98545052c314031d38102c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
4-gd1d01ed15406/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
4-gd1d01ed15406/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98545052c314031d381=
02d
        failing since 1 day (last pass: v5.8.16-78-g480e444094c4, first fai=
l: v5.8.16-626-g41d0d5713799) =

 =20
