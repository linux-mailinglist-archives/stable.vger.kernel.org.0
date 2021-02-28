Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BEE3273D4
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 19:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhB1Siw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 13:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhB1Siw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 13:38:52 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC93C061786
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 10:38:12 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t26so10074725pgv.3
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 10:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GtBmttXVrIY0lWTOTSqahICdnMl5XOgW8K4EXUTzJRE=;
        b=zEbDzd6LXmWzl09v8apwokX7CBC0zocW1eoWTkzKbpPIGlv6BQv55jLEL8W2W0qFSF
         N8G0CD3bE+Y+3E+0BX8R6vCY6Zy07L2kJ1/kB+PXp35VZwFoHXz04hDaVhKDylHA5CpN
         ryyc92yl+/hBpF7qTuXyUYADExvrnLaOGUtnmzqybCxncXJoGUq//dnQGN3v/anMVkjh
         vYGc9Y9HEldWLi9XSeheeAW7suPiIfh75RCAuhP++PsHZodAKposC5IeChPawOZuv02G
         C/+RRRnezlTEje2zNVR25aVT9aX6GENfSD989Icy248HPH3wv/5FMIwVbzqMPOWynMPg
         17dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GtBmttXVrIY0lWTOTSqahICdnMl5XOgW8K4EXUTzJRE=;
        b=n1zUQy6XwSmko4yPcqwqXixi2DL2HKKEoGj0kPkw2RWjdNNy3d3RCUBwuT5gtZxgJP
         stxoLzkVcXt4AOSp/nUbKrmYMoYR7CSgoCyiD1YupDJItOM7OElCYCKX+mN+jjU1oKnQ
         tvlKVerqJq7hLDT723JsXyU3NWbOp/0/YAMW/q66/QK7DGczWsRA1oXZh5kWqercH6a+
         nNWnPJy6ajvbbdafWRu/b37qDClrBdNQqBnk8GUXVP01Qsjh8tOma5In8n7bCl0gjDun
         sWoqJtiW1Za2MYqAZxORKkKObC47ZxixSgiJjdM0ZiMgpd+gOuu15tHUkCOpFV91pBVr
         51Cw==
X-Gm-Message-State: AOAM5304QcFoI+BAe7nTAfUzhczK6rWgtMCI1w4+1YbgP41SfT3D/uOp
        wXuCU5EETvq513mVXth+Hm6qNbYuET7QLg==
X-Google-Smtp-Source: ABdhPJwtZHI/cCLsJylpiN/d2nmA647loweIj3Z6cFKDYqEF2qFZziaq5uFd+cbfuHmkapz9NktWow==
X-Received: by 2002:aa7:9595:0:b029:1ee:8:2b76 with SMTP id z21-20020aa795950000b02901ee00082b76mr11580423pfj.57.1614537491408;
        Sun, 28 Feb 2021 10:38:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12sm910243pgs.71.2021.02.28.10.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 10:38:11 -0800 (PST)
Message-ID: <603be313.1c69fb81.4df5d.201b@mx.google.com>
Date:   Sun, 28 Feb 2021 10:38:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-11-gdbf0615cb486
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 70 runs,
 2 regressions (v4.14.222-11-gdbf0615cb486)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 70 runs, 2 regressions (v4.14.222-11-gdbf061=
5cb486)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-11-gdbf0615cb486/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-11-gdbf0615cb486
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbf0615cb48683b73afc4f91863502e534d021be =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bb06feae9bb11d6addd2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-11-gdbf0615cb486/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-11-gdbf0615cb486/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bb06feae9bb11d6add=
d2f
        failing since 1 day (last pass: v4.14.222-8-g03edb35f0ec4a, first f=
ail: v4.14.222-8-g8e97a31cd1cc3) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bb0c9f1bf65d66baddcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-11-gdbf0615cb486/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-11-gdbf0615cb486/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bb0c9f1bf65d66badd=
cc9
        failing since 82 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
