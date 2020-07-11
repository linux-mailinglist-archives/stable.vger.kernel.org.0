Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C094C21C258
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 07:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGKFPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 01:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgGKFPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 01:15:37 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2C7C08C5DD
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 22:15:37 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k27so3450666pgm.2
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 22:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SJul6dXjF6aUHhlpebRyreJxqBSVCxmWsHR8T+nlCVI=;
        b=eCxBWqFD+Vtvi4uN13svPBmx3scwGce7AbYfwvuCEf5pORw49GUquRjtBVxCN421Yn
         7aKD5xIuSm0J8yk6IJd/VsbHtoqIX/9UCAYA3bjBKLo8VEyveFLMS1CaLGp4rNin2ctq
         QdAHIQIKS/4uobbMa+BRNEtUBOrz7DLEqX9dUB9Cslgmbd4PqLwc3NVZstmt78gmkoIa
         blR5+qp6NjcCo7Mc1He77rn1x/Ub2oxqkHxfI7ftdKBPzG3iXOKKLb1BighIPSvpXTOR
         zCRNw0VUWBw93tg4kt31Vjb0ORdhb8GUf+5tKiVxiyM0LhQHT+svKJVR6bdjrDZQKmVM
         pSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SJul6dXjF6aUHhlpebRyreJxqBSVCxmWsHR8T+nlCVI=;
        b=XigCQYXtbyanTDkM4EJ5AUP/Exr0a8fA0aMPUZc0VGTPV/eGDd8xQ55qVAx+uhXJgj
         s7AGY7RODmJ3GkIrponquo5o7ENb/qpcrfYRp0rAOuBuo1hRs2OKZDTfxpUCb7LpkJsT
         m6To+ju5oDF+ceQUiuf+CSIDSiR+DnGA72NNixNs3BEzx/tqn/K4ABjzESxQqQGI7Zz1
         AfNdWUG5laMYOFqnNZ49iKWb2seOcceLrYrg/b8aeYQI7ILpVkEJi6Ibs9mv6fsvxV+o
         tH0YKW3JGhZvUa5dTuor5cGrx8k+d68XwEhuOjTBLUbcB4rmvrt/mUF5odhgh0n5zQKx
         9n0g==
X-Gm-Message-State: AOAM530YNPWYtvpTKyQkYgDRnJQudr/w7Q8pcBgAHLJyEAgUlA9qG+X4
        WCP0fXx28rEQr0mAJuWTKEC2WX5E/nA=
X-Google-Smtp-Source: ABdhPJzgSXe/MGJ5ir+wtr7+NbgyWgxbku1woIRrfVWaWxhxPwLK1P8XQ3veae3zRd2k04LXbNAXLg==
X-Received: by 2002:a65:63d4:: with SMTP id n20mr63467911pgv.213.1594444536538;
        Fri, 10 Jul 2020 22:15:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm7811388pfh.29.2020.07.10.22.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 22:15:35 -0700 (PDT)
Message-ID: <5f094af7.1c69fb81.756d.3c2d@mx.google.com>
Date:   Fri, 10 Jul 2020 22:15:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.132
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 105 runs, 2 regressions (v4.19.132)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 105 runs, 2 regressions (v4.19.132)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.132/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.132
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dce0f88600e49746b4bda873965b671a23ff4313 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f090d6a770b7db11b85bb91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
32/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
32/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f090d6a770b7db11b85b=
b92
      failing since 24 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f09134d5831f61fa485bb26

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
32/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
32/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f09134d5831f61f=
a485bb29
      new failure (last pass: v4.19.130-131-gd77d34fc4818)
      1 lines =20
