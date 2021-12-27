Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9948053B
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 00:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhL0XXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 18:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhL0XXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 18:23:11 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E54C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 15:23:11 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 196so14694095pfw.10
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 15:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QdnodWWwI4iVc9ro+VazVqoGHMWE4y2clMWTrIaGTuw=;
        b=Nsvimt463JFGnMdFHyWuewL1cfseV5klMfu8YxNwkP80f9+Mz/yy79S3nl4TIyMD79
         +vZAINiLKN9anRicCcukY8Yf+QPCxrjPSDZNra5TNyeX+hjY5e2IaaV2VN7PMvBzwZW8
         m4BaunguecQFuZVGKjGzWRDVl+k1xPDS7A6WGf4j5GgnK3pGP8s5FxLQMg6ATDvjMfbx
         ++vHqItcmP0EhB+tWANQmcbhzDNsaxq5H/rXeUZK7iYtv9it2W2CoCerV6cwhALPfMKI
         pDPV17+E0VWVn2V++oRU7rkOOSDQ2SU5n54kxiXfEXMYrtwxDu2bqdjZsGC3aqWFC1pf
         THCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QdnodWWwI4iVc9ro+VazVqoGHMWE4y2clMWTrIaGTuw=;
        b=17BaODmPU8Pxy5yKyFGHBvzpwA75/nOV3P4fjiV1rM+CnuBUYUF/VYPgmeNu33XByu
         WNftevKy4wyQ7Pg4/5hmfOGe7UJR2D2b6Xtiof8upxM4zlDQ0AxSX+iFxAXVUnjWw09h
         LqGgMIZ0FWF7JO50f8NqLzFbSxKIROac7Z0xR8NuhJvmsvzhSjmbQFq4KTBOBqgiJ/Av
         V7qoej9JALPrpLCGDeVs1H8MTzpOIWRjxKxiE75oT78pGPSVXRFDeNbEVjkKw+QqBk6G
         /7J+d83U3E5NtmZwdntt+gAiwlWPCDsaqdp7zOoRuroQuvHou70jSFy2VqJyulovasQg
         4urw==
X-Gm-Message-State: AOAM531bvsU+9Gxu19SFaZ4AUuhtSOlyXsSO9FN5ggxh7/J2nwYJR0wP
        /zjzJsQ6UrbyOFy/6yMKTJP+QsNV+n3F1/Fb
X-Google-Smtp-Source: ABdhPJzYig69KblvbiN9AfiSGvoFUF3+gTzagIDtqF5YvX19CW2chqLFC1tg3UD0Absljchcbv4p3Q==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr17206788pgj.331.1640647390798;
        Mon, 27 Dec 2021 15:23:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw8sm16617857pjb.42.2021.12.27.15.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 15:23:10 -0800 (PST)
Message-ID: <61ca4ade.1c69fb81.af046.f750@mx.google.com>
Date:   Mon, 27 Dec 2021 15:23:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.259-30-g5ddb49631ce8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 123 runs,
 1 regressions (v4.14.259-30-g5ddb49631ce8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 123 runs, 1 regressions (v4.14.259-30-g5dd=
b49631ce8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.259-30-g5ddb49631ce8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.259-30-g5ddb49631ce8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ddb49631ce806b40b03cc8691a81579eea08178 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ca1159bf55e5eda0397194

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
59-30-g5ddb49631ce8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
59-30-g5ddb49631ce8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ca1159bf55e5e=
da0397197
        failing since 5 days (last pass: v4.14.258-46-g5b3e273408e5, first =
fail: v4.14.259)
        2 lines

    2021-12-27T19:17:31.724161  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-12-27T19:17:31.740100  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
