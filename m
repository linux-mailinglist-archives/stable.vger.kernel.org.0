Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26783D90E9
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 16:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhG1Ou6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 10:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbhG1Ou5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 10:50:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EECC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 07:50:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m1so5529378pjv.2
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 07:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wi1O82pbGM7ouU6D1Mgim/A/wczXPJtWS0yoWXDX/UA=;
        b=IDbz2WlKqH1SAqIaAHy8MbcNHn0NZdPD75pBVSB5YCC43FZANXTaQ1MiTgiNzYdyW/
         8o/dfRR4V4T3CXRX9Y25p06L2wxiaCHuF05OFoPieiZ9s9S95tMXt5ClaqQiDLbW/AJx
         SN3rzrGEq9rNC2JuJ2p+myCKU/Wc/yUOiRe2NdbKQOVaky18jUF4PWX1Zl/YRrqaykmG
         LeUBCrfqxOgtcg0RwxJI1O+YNytiRcV0aLX+htQz/6muCNOGXgz293/6LE8uQnPuIHcl
         wMMgGZmOd6tK6tMA5wYukRDhgPq3BrBdgRSSKiioLS2KTxA2q6eqgRYiEM8nS0KrRn9f
         94Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wi1O82pbGM7ouU6D1Mgim/A/wczXPJtWS0yoWXDX/UA=;
        b=NfR/urGiRyq0PnuTwEMfgPKha8eGGvHSXH7q+ibC8OCblQ0lickT8oWoCz/ifpwV+q
         AAEaTbyvpmW4ZBbU/Z2gEfdOc9rw0cAkLSJs7v+HYx2Z30thI3WJiVe+TNyTiLS+35gR
         sQXzBk7HcAOI6Z1M3LBkBFSUTTeLVCZ7mZOmjRvdB+IewyiN90ccFBhXEUNoLidwKFRv
         eKG0pYI5mA80pipMM08nKBMKba6ykRE13ZFPkeRUiRcCqhGzWqScemFKtTPo9LuDUCDK
         fDx+HWQx3VjVB95n5o+FwrTzGsG+VI0r9TUhKzi/L1FXkdJ90tF56J72OxwMRADAIYjH
         D1jQ==
X-Gm-Message-State: AOAM530vH3XHVsfMKOJURTpFbgudpOaacTKWZTtKIGaNxXhlB8jhDMdp
        2+TVwNhGoWSMEvknC3gryB8amNiVjPG7Tj4w
X-Google-Smtp-Source: ABdhPJzXh3xZ0YlMDRtaJPjqerzLspDUyXjMnZWsSTj8wwo+CUGuiVoJW6h9sEbIQCyLYbW7QKr5zg==
X-Received: by 2002:a63:1a12:: with SMTP id a18mr154620pga.269.1627483855052;
        Wed, 28 Jul 2021 07:50:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm206135pfp.184.2021.07.28.07.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:50:54 -0700 (PDT)
Message-ID: <61016ece.1c69fb81.9eb73.0ac3@mx.google.com>
Date:   Wed, 28 Jul 2021 07:50:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.5-224-g078d5e3a85db
Subject: stable-rc/queue/5.13 baseline: 174 runs,
 5 regressions (v5.13.5-224-g078d5e3a85db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 174 runs, 5 regressions (v5.13.5-224-g078d5e=
3a85db)

Regressions Summary
-------------------

platform                | arch   | lab        | compiler | defconfig       =
             | regressions
------------------------+--------+------------+----------+-----------------=
-------------+------------
d2500cc                 | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig=
             | 1          =

d2500cc                 | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

fsl-ls1028a-rdb         | arm64  | lab-nxp    | gcc-8    | defconfig       =
             | 1          =

imx8mp-evk              | arm64  | lab-nxp    | gcc-8    | defconfig       =
             | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe | gcc-8    | defconfig       =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.5-224-g078d5e3a85db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.5-224-g078d5e3a85db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      078d5e3a85db396adb737af0ca78a9822b99a447 =



Test Regressions
---------------- =



platform                | arch   | lab        | compiler | defconfig       =
             | regressions
------------------------+--------+------------+----------+-----------------=
-------------+------------
d2500cc                 | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/61013431629ace36595018e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61013431629ace3659501=
8e3
        failing since 16 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform                | arch   | lab        | compiler | defconfig       =
             | regressions
------------------------+--------+------------+----------+-----------------=
-------------+------------
d2500cc                 | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6101378f2c061d03cd5018c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101378f2c061d03cd501=
8c9
        failing since 16 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform                | arch   | lab        | compiler | defconfig       =
             | regressions
------------------------+--------+------------+----------+-----------------=
-------------+------------
fsl-ls1028a-rdb         | arm64  | lab-nxp    | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/610139335a4385fcc75018fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610139335a4385fcc7501=
8fb
        new failure (last pass: v5.13.5-224-g079356b51f75) =

 =



platform                | arch   | lab        | compiler | defconfig       =
             | regressions
------------------------+--------+------------+----------+-----------------=
-------------+------------
imx8mp-evk              | arm64  | lab-nxp    | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/610138e1c6700e48005018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610138e1c6700e4800501=
8c3
        failing since 1 day (last pass: v5.13.3-506-geae05e2c64ef, first fa=
il: v5.13.5-224-g6b468383e8ba) =

 =



platform                | arch   | lab        | compiler | defconfig       =
             | regressions
------------------------+--------+------------+----------+-----------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/61013819a0849577d65018d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g078d5e3a85db/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61013819a0849577d6501=
8d7
        failing since 0 day (last pass: v5.13.5-224-gf89aabcaa51e, first fa=
il: v5.13.5-224-g079356b51f75) =

 =20
