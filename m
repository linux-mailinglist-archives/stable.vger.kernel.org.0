Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBF73A3C4B
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 08:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhFKGzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 02:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFKGzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 02:55:22 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DCFC061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 23:53:14 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p13so3695215pfw.0
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 23:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iEf5V36D4DnpH+hUMSKnI5G0lBsaa0B7OG7PCRI+qUQ=;
        b=ultTwLzGNtJa6KdO1t6x94p37cP8Tk5EXCb2OVzWlVDm/NXshg4nGJiWRZ4d0MukOy
         sE8dVvmR9m1A+XiLOyL9fYt3Qb88SdZiRGxXPH7jZGLPl1tMM3zZJN2WFrTbT9D4ygjr
         yyvLBD1Lx8E44RK6i5tdmqxPSuhqeDBh5KAxN/TWk/jRJxhhw71jRmjkuqc3iUwkG1ot
         HvFgfn6Ptyu7GQ9ZLLSOfsY37OnHQlLJm2EaHMHPNIJ5ndciXZ0UYdEjFESfC3Wd1Y7M
         Z7Uv2BZKVrn7mqeKybNgFmrmhj3Q/fFceF+V2cgjAZXljLaKIOsnkG8JMWPq2DTzOMil
         4lkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iEf5V36D4DnpH+hUMSKnI5G0lBsaa0B7OG7PCRI+qUQ=;
        b=KbEXF4fZLwazeLTh2t5EBCcLC7lpVb4eDzg9SYbf2wZqtlnHEfmai+D26XaHf6plGI
         zx/PZk5XuQZ9gDVxkxJlDdjLnvFcpNfQk3C2CDOPXSKsT64OiTe7Tby/Ug2d15GEzdPM
         eAmoBPevduRsgfJ+BXU1Xk3gBjbQ0AH9e8FoI82OvWLmY1Bq602tHnHnv7vTixA50m26
         7DYmGNg+4GZW54dr/anTPqgf6Mi+/HjdtQhx/eimXiA/a/ntkOwF0SzYNbVU4hoLKJKx
         4H1T9eqkseomKs36qJ26bcInF7+lqDN8XdKyQxjBa2opT44yaHW42S55igHGhdlrDD0I
         IZeQ==
X-Gm-Message-State: AOAM5332XfX0nDfBa32IGqZ58mUgsdmcT5QGFRbeYWJCT8W2Ot/ot3Nz
        WRY0J559QQPeqXoemNAQMnmP8iSMKD/d1jVj
X-Google-Smtp-Source: ABdhPJx9nHOjICnqz6QBBZvx139HrqbR6KDnQQf9pzbHLiqUDwi0+NcJcMbm5WLOtiCJIX3CmbryDA==
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr2205900pgc.326.1623394394285;
        Thu, 10 Jun 2021 23:53:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm4120559pfk.191.2021.06.10.23.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 23:53:13 -0700 (PDT)
Message-ID: <60c30859.1c69fb81.74a1b.d980@mx.google.com>
Date:   Thu, 10 Jun 2021 23:53:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.43-44-g87df6d2f0aac
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 145 runs,
 2 regressions (v5.10.43-44-g87df6d2f0aac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 145 runs, 2 regressions (v5.10.43-44-g87df6d=
2f0aac)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =

imx8mp-evk               | arm64  | lab-nxp       | gcc-8    | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.43-44-g87df6d2f0aac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.43-44-g87df6d2f0aac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87df6d2f0aac62752e442c44bbca84c17ed1147f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2d22a88679cbc020c0e1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
44-g87df6d2f0aac/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora=
/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
44-g87df6d2f0aac/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora=
/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2d22a88679cbc020c0=
e1d
        new failure (last pass: v5.10.42-137-g42a95aa58d3b) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx8mp-evk               | arm64  | lab-nxp       | gcc-8    | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2d603f514e108a00c0e1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
44-g87df6d2f0aac/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
44-g87df6d2f0aac/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2d603f514e108a00c0=
e1d
        failing since 0 day (last pass: v5.10.42-137-gf24aff0aeb21, first f=
ail: v5.10.42-137-g42a95aa58d3b) =

 =20
