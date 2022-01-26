Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3946049C0BB
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 02:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiAZBXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 20:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbiAZBXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 20:23:47 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD63C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:23:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h12so21764482pjq.3
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F/3Uu2Hnc8cITa0HAtmAd8cBsoypXwrWp7BB641CcVY=;
        b=A4LW7W7KcU9CeORXIZYJ/QjUCvdEmX/IhPA9/djrUEs2aOSiWYauzCWOFjVsB1d5WZ
         wlIHBoSiqZo6WpHb+Ad1C6/j8ZZbQP/AOjQy3Vr3pc14LJgEjodfUaN2EAS7KOIxDGDT
         ckxKPC3fgZ7HfZyx7AfHzAS3W89CEkkIs2Anj8kpqcQjC7CzAKDpnkT468X4I1b9kvVT
         RzdDdxKm1zoeeqeLc4zMQ8cG9yk1pd5N/PEIkX32g6c1X4ODAAFu+k+X9alJQ4AmAXxq
         72huFfPBZ1GMNVXzr87qDpbKGg+WHDnjeqwlSykgmrkoIcpmn5OJyM1p1hA0w3DSOWZk
         yCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F/3Uu2Hnc8cITa0HAtmAd8cBsoypXwrWp7BB641CcVY=;
        b=ZRfNQISpqkYSenafiZemgaovdF6brWz6Rmi3G3MhPRCvT74eAQpdUilmKLKcY4hPip
         l8iDRcuCVz/NhwoSXUNOfnXwRdqej5coG7C50a7Pip0Il4TI8IYqBrvQg8c/0lh/cyIN
         6PHSK1DIB1YS2Xv/fxsIoR2ZB5RnSLlZQRDeacEWfSDLzlPA+yT8yRi0wq/VlSAVfSLD
         F5y5SoRiiJIdDRGVRgZHfLG4JH1PQN8z89xCagoXmjCvRjsRIz39SzC9TNFEmhKT0IE+
         OWw8LedMQ+/7SEaBSQ+LE4Qf1Ahawm/KHqWdgi0DvX6DW8G06E3hCX12r8PrRKQpghYp
         nkIw==
X-Gm-Message-State: AOAM532qnAskS7UC/to/ESPla5uJqCnx/Qp3c4NBdE1jj7ckcw4z2EEH
        YHJmEmtnz72zk2ZTesQCqob8FqNquTd96xP4
X-Google-Smtp-Source: ABdhPJxE8yhm+gAIxV/Wa2osqoTpn8xTKPmRbdhA/hwdtZLayUTAB6JWGZ6BJDx4lZbtl4RXiFrmsg==
X-Received: by 2002:a17:903:245:b0:149:d2a3:ddbf with SMTP id j5-20020a170903024500b00149d2a3ddbfmr21129984plh.3.1643160227122;
        Tue, 25 Jan 2022 17:23:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g8sm221981pfc.193.2022.01.25.17.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 17:23:46 -0800 (PST)
Message-ID: <61f0a2a2.1c69fb81.1be9.108d@mx.google.com>
Date:   Tue, 25 Jan 2022 17:23:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16-842-g384933ffef76
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 157 runs,
 2 regressions (v5.15.16-842-g384933ffef76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 157 runs, 2 regressions (v5.15.16-842-g384=
933ffef76)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
asus-C436FA-Flip-hatch | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

beagle-xm              | arm    | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.16-842-g384933ffef76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.16-842-g384933ffef76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      384933ffef76e18b9783e4777881d7aca33c32d1 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
asus-C436FA-Flip-hatch | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61f06815c5b3fb0551abbd26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-842-g384933ffef76/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-842-g384933ffef76/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f06815c5b3fb0551abb=
d27
        new failure (last pass: v5.15.16-848-g7d6af35208d3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
beagle-xm              | arm    | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61f0933bdcf510c5b1abbd85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-842-g384933ffef76/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-842-g384933ffef76/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f0933bdcf510c5b1abb=
d86
        failing since 5 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first f=
ail: v5.15.16) =

 =20
