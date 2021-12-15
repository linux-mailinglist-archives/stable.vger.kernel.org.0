Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C021C4750E7
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 03:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhLOCSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 21:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhLOCR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 21:17:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB19C06173F
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:17:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id mj19so1068271pjb.3
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rYK9jkU1DoxfVDM0/LFEOFIR7GRRhJB0hC7ZjcGI3XU=;
        b=ZA/+hVIaz3PvAMIHrcBbz8IrS1AxXYogtzACnyMeq8Lp3Y7Gg/qXT8kh36+9JRm9i4
         eg/f49JGpdyZf7sTAVIYZrJsgYhKLGuY9W5NqdIV48sJZcM4c8zC5m5sfkh8F3BSR7tQ
         ast4TjSj7yPQDlpKgcZ335e/kAtCXGGvpdjgyC+BJ7epuOXW0IQk7GlARufeiQHEWLQr
         H/hOIXI4IaVzh+1fOTxwDoH5uX7uxt93FYmBCabw2utup/nSbPpkRrIVQq+ZQKdBwf9J
         7RRdSau2cdEopYfmey7IYVhToxWZfaCdhRADO+x5z9XJCtymZR2qAsCrvGev7GZ7GG1m
         4BPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rYK9jkU1DoxfVDM0/LFEOFIR7GRRhJB0hC7ZjcGI3XU=;
        b=jUuYBSQ0ATbOIOJ7T3Oc+/gsbIKxcon+2pmjLhtQBwJBO+oamvAaTBI4RdiJwuF0rY
         sv/LOb5imriSHMsWwC17zNo+5baI94Q78Gv9ehpNjP4zsDRKx5ZXGWVNL9UQkoJ9MI7U
         MdMLxVzionV+WTHJjkFzoB4aPFSVMX1OHHPJX8836MpMS8SaJ18GqRpDf7gofNdgAz4k
         vzdtDkE4dxbuPYEg7TZWWKLiWjfgLQYofgoR6q5Ub7gdaYILEmkJ7lUiJlT6JOX8/YIg
         gnjgosPo1jWp+6TK8xF8m27ojzDNbmoIor7t/p8moDqzEE7AObYbJTi5mSDvz9s41MUD
         wT7w==
X-Gm-Message-State: AOAM531nV4BJGeTZVEzwzT9byIVyWHJq8shXqWPRR2qGv5xROOer5vvq
        km/xb7BmVRggxHRQNwmk3uVqIAHoNO0E9Mds
X-Google-Smtp-Source: ABdhPJxs3haHhztx7A7lGfp9dwFYmHS1zvEr9WxBMZJ8EemFcjhnxHqIERhyKI/VFowN/gTmEsmiSA==
X-Received: by 2002:a17:902:860b:b0:143:87bf:648f with SMTP id f11-20020a170902860b00b0014387bf648fmr8832767plo.11.1639534677159;
        Tue, 14 Dec 2021 18:17:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm380515pfl.118.2021.12.14.18.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 18:17:56 -0800 (PST)
Message-ID: <61b95054.1c69fb81.cb106.1e39@mx.google.com>
Date:   Tue, 14 Dec 2021 18:17:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 87 runs, 2 regressions (v4.9.293)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 87 runs, 2 regressions (v4.9.293)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.293/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.293
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98d396d082d499d85ea373e3f8d6e7906c232cda =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b916405758464b53397126

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E=
3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E=
3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b916405758464b53397=
127
        new failure (last pass: v4.9.291-63-gb14dcd4dade2) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b9157961cf57aeab397174

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b9157961cf57a=
eab397177
        failing since 1 day (last pass: v4.9.292-29-gdefac0f99886, first fa=
il: v4.9.292-43-gad074ba3bae9)
        2 lines

    2021-12-14T22:06:22.402601  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/130
    2021-12-14T22:06:22.412038  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-14T22:06:22.427726  [   20.483978] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
