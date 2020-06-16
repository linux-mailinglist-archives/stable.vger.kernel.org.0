Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276F41FA78B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 06:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgFPEXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 00:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgFPEXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 00:23:20 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA43DC05BD43
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 21:23:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d4so1609365pgk.4
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 21:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oqE03DWh4TFWoh1mD0TbRJslnICjLAKWu1+PNs9hNRE=;
        b=2HGz/XmVMiEyc3Pa4m6XntBVgulGaBy9CFY9GAAqhjnNjCrRHpfINMonVMSS3RbC8j
         X1GihX7vyNcKgHpIiPDMeHwLoeykZBzS0/hXi+EUTXViCNskXVcjrrO0ttQtBFAirklT
         uC2YbEsST96JWxZ1rGGk0gdusK97jZat3rkE4szBLWLZzEeraXoW+8lpnyM5uJgEi7xa
         yqwnBExem/DY64YY7sYTlFXM8z7FPnA8b09Uop+PFoTwPZecNMTrNyhBjc38HHI3Eh1q
         fqwDaatJdsSxE31Cp+tVWQh5uQW7aN/tewAmccHE9gMcOosXDQH4v1EjsWWuqdA7SNgZ
         apYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oqE03DWh4TFWoh1mD0TbRJslnICjLAKWu1+PNs9hNRE=;
        b=MTe3AvZ92TCJ1/j0ut/n8MQL1aTDrk2yXL036O9D/AsMVHEVZiAHT1loXDz5lZfyJC
         +5NNXcZiMSeHW4heMqqk03ZlIm2IfVO5tst5A9siIwq7mnEtN1WDpdgt7W8ntfl5aFer
         jh9W3gHJ8uIzhqyWbhoxvXAFbohYSMzL6z16+SufWf+motEX5gppq7jSV7BFIzA4Z+X7
         h1+zfx63EMPU3L+Qpz8QinfXsGa3zJEhaNwmXh73cYUm8g2QpYTk/2WpzGOM39Dd5vqd
         WJQCAW6rVootvwvMsaW0Cyy1YwyikCI1c3oQfgip20w0mXMBxKBeIbQ1i2sqGu9hFtdI
         y1Kg==
X-Gm-Message-State: AOAM5328oorZvWU2gXjWhdCcqFiCnOrYHZX30H6GRJ2GLNEyh/vMyo1x
        iPEsk2ah+QlskDL9GjSsvaXN/MynQyA=
X-Google-Smtp-Source: ABdhPJzIuLxfZ3Ob3g1zs+yxcZLVho3H0LgrsesrUSPA5VHMdjySSPhRkn8bHcb6lrTYew9GbnGIbA==
X-Received: by 2002:a63:1444:: with SMTP id 4mr645837pgu.388.1592281399672;
        Mon, 15 Jun 2020 21:23:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm15290379pfp.24.2020.06.15.21.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 21:23:19 -0700 (PDT)
Message-ID: <5ee84937.1c69fb81.c75f8.4651@mx.google.com>
Date:   Mon, 15 Jun 2020 21:23:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-157-gcbc29a7953ca
Subject: stable-rc/linux-5.4.y baseline: 62 runs,
 2 regressions (v5.4.44-157-gcbc29a7953ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 62 runs, 2 regressions (v5.4.44-157-gcbc29a=
7953ca)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-157-gcbc29a7953ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-157-gcbc29a7953ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cbc29a7953ca53d5db824b78b27ea50936747544 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee812edd8df5fbf6297bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
157-gcbc29a7953ca/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
157-gcbc29a7953ca/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee812edd8df5fbf6297b=
f0a
      failing since 65 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee81829cc9c76a09797bf2b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
157-gcbc29a7953ca/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
157-gcbc29a7953ca/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee81829cc9c76a0=
9797bf2e
      failing since 10 days (last pass: v5.4.44, first fail: v5.4.44-39-g0e=
4e419d5fc3)
      2 lines =20
