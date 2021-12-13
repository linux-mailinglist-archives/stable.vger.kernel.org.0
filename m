Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB49473439
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhLMSmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbhLMSmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:42:11 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935BDC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:42:11 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id k4so15330178pgb.8
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0XYuNnYh10J6V7YuTLdqmnlMa4TArWt3xoIhSlCp3Xs=;
        b=cfbxxdfW6Zm8kbUH/wW2ODknQgV5v6tSiHflI5ySOElp2F8JTuRmFZb5OczclW08e7
         dwxhtTnjLh3MaC8Om486ZWhqRnn2L0tQdegohbuFn4LtQcGfkpXlc4xJiZEirUG0TQjZ
         SxuKn3opZBmuuxGQnPddzP3+U8m+Dl1a51Yvs664q/xbb2M0KVtfZtjfKK2lqUGxITHH
         yhp/ToArkvQJN84Zl8u9cK94vL9GquzC8pYy/8qC3Hc0Q8jjHqJunHSar03Ro/rBDMDq
         gQNO4MVF9fazqidiNOiSNjYlWO2xOzzhp/uzzA6cgLaY+PK/7olvQasEJjxtmvoWqUEc
         N77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0XYuNnYh10J6V7YuTLdqmnlMa4TArWt3xoIhSlCp3Xs=;
        b=xlQvU2/QNH0K3T+pVDw0k/7uKxhUJKFR6NPmp5MSPZmZXurljp4hGuuMuxDFe+JnLk
         8/BnKANQqaRSVI2Z9eoDIS3Xs3YLnhonpk5wBkumPFi4lokFpveEDK5Aj8iRQumoJPls
         OiACzhnDusWyQ8uiTo7E7l99I9DaMFRiymE0iEgcT5Mwl7cdkLUxXLYjW+jtzGmYe2dy
         Z5FLnY+m3rQa2M1dvoNCDd28cjX9qwf7JdjGxV97Lu516LSse4TKDRZ+8YHTlMdy9srO
         KZGoxGD4YmjmWZeu2TkAA6Jwlp9/XmJEzesk08IEvSDJ8B/9s98gKX0z9NnFNprqg9F1
         3QBA==
X-Gm-Message-State: AOAM531n+914GtujDD5DZCXrD8EtzVSkwH2VPQJ8/dQitvnz+EsnqgdQ
        rd0eGmmU236naiWBjKBMVyNi8FJI2Z3X40Vx
X-Google-Smtp-Source: ABdhPJx9wjYCxA8aHI4eEFawT8Ct1WDEySJ2ryygCMmcOWXOG+LqTjGSBppVamvn9dfZIqX2smOUbA==
X-Received: by 2002:a63:4f66:: with SMTP id p38mr285671pgl.222.1639420930967;
        Mon, 13 Dec 2021 10:42:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r11sm12997698pff.81.2021.12.13.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:42:10 -0800 (PST)
Message-ID: <61b79402.1c69fb81.e7ffd.4d93@mx.google.com>
Date:   Mon, 13 Dec 2021 10:42:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-54-g5aef54c7f9c7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 148 runs,
 3 regressions (v4.14.257-54-g5aef54c7f9c7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 148 runs, 3 regressions (v4.14.257-54-g5ae=
f54c7f9c7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

odroid-xu3               | arm    | lab-collabora | gcc-10   | multi_v7_def=
config           | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.257-54-g5aef54c7f9c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.257-54-g5aef54c7f9c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5aef54c7f9c79b66de0fc4ee21754c4336cb927e =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b75aa0b7ba33010539712b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-g5aef54c7f9c7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-g5aef54c7f9c7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b75aa0b7ba330105397=
12c
        failing since 0 day (last pass: v4.14.257-34-g5ece874a0959, first f=
ail: v4.14.257-54-gcca31a2a7082) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
odroid-xu3               | arm    | lab-collabora | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61b7863a7bb313db8439712d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-g5aef54c7f9c7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-g5aef54c7f9c7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b7863a7bb313db84397=
12e
        new failure (last pass: v4.14.257-54-gcca31a2a7082) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b75a228a4318c284397162

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-g5aef54c7f9c7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-g5aef54c7f9c7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b75a228a4318c=
284397165
        failing since 17 days (last pass: v4.14.255-251-gf86517f95e30b, fir=
st fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-13T14:34:59.581228  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-12-13T14:34:59.590474  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
