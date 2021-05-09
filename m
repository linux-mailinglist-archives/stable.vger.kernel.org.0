Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1317A3778B5
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 23:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEIVfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 17:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIVfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 17:35:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9530AC061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 14:34:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id u25so1306468pgl.9
        for <stable@vger.kernel.org>; Sun, 09 May 2021 14:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xtd7H5GYktOCWqGFZEWmMXPwOY58P/h1kM67D8fRoE0=;
        b=o0OPa/zBYYMcR1eCkeJjjwospOk18wtEx5UZsR5QMV2zPvNIRyMryTZaLh0l0JXYSf
         KEOeSsekcFy+40zY5ZV2WZk2KJENacUrji/9lGycxVktbfdoUJUlctheaJzwG6pZORKV
         Px9yeSzE8oBD9Edeq++IOzBSKmbEFSucUPhJ11BOtg/LaZjzEXBanWPW7LUbpaUusuY1
         k5nIG8b03WR7MYU1Vx3L1Q+ANHpxBhoGFl3m16DAFPxmAHNtT7rVwlmp6xZpPo/23UQf
         k7erauDJz943jUpF3STi+py8HyTLw6t0V30XeEye4gsgVOWTqbkdH4qEkBZzJMEYXWI7
         5OaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xtd7H5GYktOCWqGFZEWmMXPwOY58P/h1kM67D8fRoE0=;
        b=NbedkqFDuNRNKjom1+Wd00u7mIckG20Yu7v3ovGlZyyP7860qoucDNcEZBM0PneIpJ
         5ocaPvrC6oKBAKz0h491HM4En8QjUNwImiugD3ekbM6I+n9XX0fEEIbsRyqCuDgsinEi
         npJnT7KDAdD6jVoHE3ZmI9EezvJdsewbHu5tbk+sX43aWrv8yg7EcuYClZW578SyGuK4
         YitcILCCNbW8R3lmulLylws1OqmGM2/KcBEVBqB6UzcQyRSB07W/8zHxG046ZtrSRRYm
         Os07B8eOAVt+wkD6bnDw+Qn4K5xOTCG494S3H3QGrfOaIs+Q8azDzKnazDkWydZdzOtF
         RL6g==
X-Gm-Message-State: AOAM5316LA0XwclhwzwchgnAIYA7OoSTJoSyaPe305AxsnPSaxcILG+2
        kPMkd4qlF5LB4LciXzC4Wpni9bdI0psgrJE/
X-Google-Smtp-Source: ABdhPJxF3LUaM70AGarT2fNdfB3Ynhog1SXk1lTHCT9amnlNvFgOGZv2QrGPHiFFjMyy9tO8HG6lBQ==
X-Received: by 2002:a63:fb4c:: with SMTP id w12mr21805833pgj.337.1620596045877;
        Sun, 09 May 2021 14:34:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8sm9414351pgm.7.2021.05.09.14.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:34:05 -0700 (PDT)
Message-ID: <6098554d.1c69fb81.5e93a.cbd4@mx.google.com>
Date:   Sun, 09 May 2021 14:34:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-296-gcce8f74c8b60
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 160 runs,
 1 regressions (v5.11.19-296-gcce8f74c8b60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 160 runs, 1 regressions (v5.11.19-296-gcce8f=
74c8b60)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-296-gcce8f74c8b60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-296-gcce8f74c8b60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cce8f74c8b609b3368d9985d5aaa9911d067edd2 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6098242bb243a397536f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
296-gcce8f74c8b60/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
296-gcce8f74c8b60/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6098242bb243a397536f5=
471
        new failure (last pass: v5.11.19-254-ga88b3f3599f6e) =

 =20
