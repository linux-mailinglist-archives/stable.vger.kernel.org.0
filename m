Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E821E297D38
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 17:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761328AbgJXPwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 11:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761165AbgJXPwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 11:52:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6709C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 08:52:41 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j5so2575193plk.7
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 08:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q4wxE0TfGYTfCv36tFC215o+EuACP3CHqaxdrwhUhIQ=;
        b=xxOnv0zxXwH1APkYsN/CXxpu0T8yJjGoKUpDQ27mmZGbc+kJt/PE02LESLklBzCV6A
         JT1VBOyCfuVdhvTV9dC5TnbEHCXnZZFMjjIfPPYDhBxBn9KT6BQJJlMbqI8N2Fg5sojA
         bh+LD3h7bvO2t+sHoXcxA0VdvmA0V6ctvJ1knhCZFKXLtnFFBcX+K1BogbW3kQKiER8s
         1Amsis9hfud4X3dpBXxzRrOtz/vokhog8qMC20kAy213hHb6m5xqtFAOcCKou84nTjlr
         AT1aJsQvizBxbrMRIARNMDrnhMRT4rqCSt/FiVQWDu9jkRqOaIUDgK27zuzs1actFoYI
         8BAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q4wxE0TfGYTfCv36tFC215o+EuACP3CHqaxdrwhUhIQ=;
        b=rizMv5Zixg3RWmUNa2MQHn6zmFaT2W5v6vwE3dbLOz+lXjqTvQEVbZkw1Hsu27E+8b
         08ld2hyrpUeYTPwLOZ05vBqNEIs9HTw2RHmD6V1vuXou5JTfb7v7QI1R1GqLwLbK/G5p
         ktgnIjtydhN8lHJV/CmH2R/l6GzUNLAnDvhotnw2urog86E8cIyUVyUqkNi/+Tedpq8p
         LGwpECRBeyU6SGsXyYERv502hx90W7XTQ47tlWG7Vhim+UTocAtjUtgz1u0TWJa++Tjd
         LZpc51V6EdcVq8Ss99Yl4lKTkgMoBqX2YAYpc/BgLuyGqb/80Huec7A+hvERmFA4/poD
         maZA==
X-Gm-Message-State: AOAM533hlwZXf2I6HRZ/ChdwS8uNutJQE95soR5XdIJ3r903gon1uTdx
        OkGMAZpAwPjPQP1iZ6Rk6bmO4VSlNhA8rQ==
X-Google-Smtp-Source: ABdhPJyKtTqAsf0rkTEQqkUq0i2hx6HfaJ+pXWeWnzPRZbu3bmqEt6rAf1O2eNH0X3lLraP9i0WpQg==
X-Received: by 2002:a17:902:7c88:b029:d5:cdbc:ce6d with SMTP id y8-20020a1709027c88b02900d5cdbcce6dmr7465005pll.22.1603554760694;
        Sat, 24 Oct 2020 08:52:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx24sm6993215pjb.20.2020.10.24.08.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 08:52:39 -0700 (PDT)
Message-ID: <5f944dc7.1c69fb81.b57d8.be3b@mx.google.com>
Date:   Sat, 24 Oct 2020 08:52:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-22-gc247dbbd6699
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 159 runs,
 3 regressions (v4.14.202-22-gc247dbbd6699)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 159 runs, 3 regressions (v4.14.202-22-gc24=
7dbbd6699)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.202-22-gc247dbbd6699/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.202-22-gc247dbbd6699
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c247dbbd66997cc6490a439e2d195b3ce814fe12 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f941af32196f05f4f38101d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-gc247dbbd6699/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-gc247dbbd6699/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f941af32196f05f4f381=
01e
        failing since 92 days (last pass: v4.14.188-126-g5b1e982af0f8, firs=
t fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f941b435017fe1401381045

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-gc247dbbd6699/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-gc247dbbd6699/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f941b435017fe1401381=
046
        failing since 207 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9419f12c35a62fe8381029

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-gc247dbbd6699/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-22-gc247dbbd6699/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9419f12c35a62=
fe8381030
        new failure (last pass: v4.14.202-11-g83970012a2ed)
        2 lines

    2020-10-24 12:11:26.099000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
