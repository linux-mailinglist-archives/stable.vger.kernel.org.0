Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3AF23F3A0
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgHGUOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGUOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 16:14:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DF8C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 13:14:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l60so1473994pjb.3
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zHQ5mU14z0wASr81YlmAMCgRH0pG+/QERQ0Zffpwo6Q=;
        b=n9pzo2JWNggDYq7O0BhJ9y/Bvn8p0IqdhxFcprIn4ibwQxIHI9nVKfz3/GCFvSoNj0
         oiY0IMuNgmdulZaRbKKH4f1fyMtnwWIG+XaRNp/4b77J5Ios2/1ljAfYQ4Edso66l54d
         woUvQmzEIEOR7sDY7HSmJoQzaGq++8E/MM2+L+4jR1UflsM1kzKSLAZvk79iQNzpqwJe
         9h1Tfg/xSeQYOLwNDrFAw+LNdghu6cCol6pKTlXXsfmEMl6R9BWbot2TqYEwK6IyPr5N
         wzxL/yVH8N82yi+nEC/FwgVjqQf9m43JK7Ni0+76HB6wAJRysygmp+Qlx+qmfEiRxRNL
         +qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zHQ5mU14z0wASr81YlmAMCgRH0pG+/QERQ0Zffpwo6Q=;
        b=h3mZnMEiqAmVU24tLTmrKSBDmDY4/fiIouJP5o5+99GfFslKRoMaXsV8IWSg+9Lkf9
         U28MEKscqlXvnkbOnzoJmA953v7S1c27zJSUe9nULQrUDK6mkLrx9+GlpFleKRvPFrx3
         JE2BUHg5WOzMC9ZQV56uhU6zlNjBimQYIEtgobFu6kbbh2tdwEIMS/NpbcvCRc2RyfEB
         nPyjn+S8CUbxN59P18hTiWuVzVXQhYpg2911yUaZcJhdZ81MyTM/eX+r9HvtH3pR7HNb
         35tVqvaI2QqtjWa6O7ITHgFw3SvLsk9GkUI7vyfV02iPt2rAiJ762U42H14xJsS236tH
         olDA==
X-Gm-Message-State: AOAM533zYG+ScKnBwkkU9qOmd9bShWnolmRJKYuru54DcCZVeGcNQADI
        NjBIiuTBMJ3MAKXQ9vDrFRCrRiHUCKg=
X-Google-Smtp-Source: ABdhPJzCluAJi/EWtrmGTISbLjz+0qUfiCf4Pa/21ZavyDgmNfkniRTqjiJRymvS+IxVn9KedVqbnA==
X-Received: by 2002:a17:90b:194d:: with SMTP id nk13mr14084343pjb.220.1596831256460;
        Fri, 07 Aug 2020 13:14:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z25sm13586388pfn.159.2020.08.07.13.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 13:14:15 -0700 (PDT)
Message-ID: <5f2db617.1c69fb81.a44bf.0315@mx.google.com>
Date:   Fri, 07 Aug 2020 13:14:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.57
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 138 runs, 2 regressions (v5.4.57)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 138 runs, 2 regressions (v5.4.57)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.57/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.57
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d9939285fc818425ae92bd99f8c97b6b9ef3bb88 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2d82712b65479e4252c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.57/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.57/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2d82712b65479e4252c=
1a7
      failing since 50 days (last pass: v5.4.46, first fail: v5.4.47) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f2d81b6603ff3a69152c1cb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.57/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.57/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f2d81b6603ff3a6=
9152c1ce
      new failure (last pass: v5.4.56)
      3 lines =20
