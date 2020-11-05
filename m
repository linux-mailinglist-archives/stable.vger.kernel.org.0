Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26002A8883
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 22:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgKEVHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 16:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEVHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 16:07:22 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB05EC0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 13:07:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i7so2207950pgh.6
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 13:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NJXkgJnEqsJBmCMeCw5bcwGcuSQkgcOsTFZ4qzhdOrg=;
        b=wq+aJKbBd/2/27yeSx2px4Lpf4IUWw0hYXy7JaF9FiwGtWe9pNngY57If9XxCB15NL
         n9Mf9ebWRhupp88wy6CqBEZrDJnYCfsq/qu3U3wTSqbbv7zf7WwaTDQq3q1Is4DmLSwu
         B8j/mgpKa/k1fpZ8lBsgx7MnnElBafZIno0CZHq2HrlNuYxhzccdDSFJYB4E/NcYN3qq
         8Kcx0s/VXWN1XycjeZUZ22Pv95KSHNVf4c8E3VBI26TBCRXWZ9bJ0tYelX6U4GvnzUCq
         I0fWk0VE9WRXMeroRS+ABQLVPubiD86BSR67DjAXIMX66LqP/GHIHljGp4xKoQGYHOKg
         mQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NJXkgJnEqsJBmCMeCw5bcwGcuSQkgcOsTFZ4qzhdOrg=;
        b=OrDXzFQ3AWtDPz93MEErDUgNTFlNIPIhkqICNxW6vvh/XjUCNvVRFlLPapBGsGYbQc
         cadP21JJdVog5eDlMYp4dONYP7g9rfRymGvu4njfJcvip1P31f/0IdTewkJ14Z6fi7/l
         woTzL2CJR020VVxJzdDjsm+PbHHqHB9PkLli76jXP+ujvGbg8/6kv3ueiOnoeyMYOV++
         7A5ZOPHBLTLTh/pdw0WLSKlmfvvEIhOctyRnE0wE3Sawgr6Pt3GWmfD7Yvnt9tDfdcX+
         hH0CiftAMDoTmaBqdjEPCsSPNrYGKlE80j58ZZw2flZR9Twa+K6Kj2+f3e6u0vdQgw6x
         DMRQ==
X-Gm-Message-State: AOAM531UpNufdx7C7CBvqRgL+YsQmyA2OYRGfF22E/1EdYaKpzG36yQm
        eLOzyu2JtSm5nRsEBt2QJHhXxsT9/j12ZQ==
X-Google-Smtp-Source: ABdhPJw95g3PAjOSfZJFPnxTqBJrtup29ATkoho9eC44ePaZvVWwFhMUqqxP3xyk9jFu+gJaUBjR/A==
X-Received: by 2002:a62:f909:0:b029:18b:588d:979e with SMTP id o9-20020a62f9090000b029018b588d979emr4331119pfh.48.1604610440099;
        Thu, 05 Nov 2020 13:07:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm3252324pgv.64.2020.11.05.13.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 13:07:19 -0800 (PST)
Message-ID: <5fa46987.1c69fb81.95f44.614c@mx.google.com>
Date:   Thu, 05 Nov 2020 13:07:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-1-g14d558cc8860
Subject: stable-rc/queue/4.19 baseline: 190 runs,
 2 regressions (v4.19.155-1-g14d558cc8860)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 190 runs, 2 regressions (v4.19.155-1-g14d558=
cc8860)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-1-g14d558cc8860/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-1-g14d558cc8860
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14d558cc8860bd0ef6a329f0aa0577cc891c1285 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa43856e96e2158bedb887e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-1-g14d558cc8860/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-1-g14d558cc8860/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa43856e96e2158=
bedb8881
        failing since 1 day (last pass: v4.19.154-191-g43abc622c570, first =
fail: v4.19.154-191-g7aad7f07408a)
        1 lines

    2020-11-05 17:35:33.867000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-05 17:35:33.867000+00:00  (user:khilman) is already connected
    2020-11-05 17:35:49.699000+00:00  =00
    2020-11-05 17:35:49.699000+00:00  =

    2020-11-05 17:35:49.700000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-05 17:35:49.700000+00:00  =

    2020-11-05 17:35:49.700000+00:00  DRAM:  948 MiB
    2020-11-05 17:35:49.715000+00:00  RPI 3 Model B (0xa02082)
    2020-11-05 17:35:49.803000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-05 17:35:49.835000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa437d50474db8eb4db88a7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-1-g14d558cc8860/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-1-g14d558cc8860/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa437d50474db8=
eb4db88ac
        new failure (last pass: v4.19.154-191-g7aad7f07408a)
        2 lines =

 =20
