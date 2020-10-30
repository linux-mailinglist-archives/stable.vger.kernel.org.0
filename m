Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BA729F96F
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJ3AGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJ3AGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 20:06:37 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B86EC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:06:36 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a200so3724551pfa.10
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0LDlAa2UfMZ0ztR+ObYlMRuLth8/cnRZ1+4AqykIQpY=;
        b=VBVHQdX0dcWCpOgR8yFRIdQ9nNmD5AhfbgnU3D76Dz0rpye1cmorc7JUcKiWqxLYDG
         AR9aRwntOnWvtTvLhCmNABobn6k8SyeiV7YNAyamXE5xn0JhxrUf1O7jY2/7KbZjs+qj
         NcLvf9zZBbFz4EkVflTe4Sh/2i1TnpT+sCbtJrYzMFz88NEWzA5x+n55UBOdyFBMyxMi
         zNUf/SBsEjq5plgSJw+5/wK4l+caj3dHTQ30P2Id3rgvcXQMTfiBB1GTyRlOBKyXyM9E
         2lt5B1YKSWAzQ7UvEHBsvhrPyQYSy+rguUC2kx4uPcR9ehIAIp6ufbZLvkoC+dgIL14H
         TJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0LDlAa2UfMZ0ztR+ObYlMRuLth8/cnRZ1+4AqykIQpY=;
        b=dfoP4eykF1FqyojxWwfjKzE062nNb7DBIjH2lsA9aPJ7DXD082e0ybWsYe+piu298w
         1Fl0hWbAYVqNdpMV6H4175vRnVHOxp0+R9e/5AEEzOmzS+2jl7kNQ8X+6QCd3tRGqdmX
         NIfXAKT9Jp8puiOO3gdBbLgcYhAjmrx79poWR7UCBL2lWrf3afdjh1fGQbfAIYGuTHXc
         XCMSqbsMo6L1BOP64vxZ8pKeAXCoBv4u9zkSuJcip/wa4WmBzu+2VBhib7FQU6xovN5c
         F+Pv5PfFVluvye2bhhEp0y5zCPQwlc8797Z58cKPnH4fUXh4PrbbTXC/l7LHf03X6TxF
         CSgg==
X-Gm-Message-State: AOAM532JDV9JQS8VgpXqSxHNiUmZr6beEw3rE7ayjG3NWjBgGlqcafUz
        NZ+XNmvIkXtecDErOrT9hRrNlN4ow4bfmQ==
X-Google-Smtp-Source: ABdhPJy/pAV5p7lKI6nPg7vpERjZR1sNnBm7rbEPoeTXjalH3XYqqyYxqOOlDCv6z7hBvElSoZ6Egw==
X-Received: by 2002:a63:ee02:: with SMTP id e2mr5796047pgi.287.1604016395566;
        Thu, 29 Oct 2020 17:06:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv7sm126910pjb.27.2020.10.29.17.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 17:06:34 -0700 (PDT)
Message-ID: <5f9b590a.1c69fb81.22012.07e5@mx.google.com>
Date:   Thu, 29 Oct 2020 17:06:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 86 runs, 2 regressions (v5.4.73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 86 runs, 2 regressions (v5.4.73)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bde3f94035b0e5a724853544d65d00536e1889b2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b2423825a6a1dd9381019

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.73/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.73/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b2423825a6a1dd9381=
01a
        failing since 201 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b2743b5784a0d51381047

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.73/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.73/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b2743b5784a0d51381=
048
        failing since 2 days (last pass: v5.4.72-55-g7fa6d77807db, first fa=
il: v5.4.72-409-gab6643bad070) =

 =20
