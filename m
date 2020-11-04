Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B82D2A6CBD
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 19:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgKDSf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 13:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKDSf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 13:35:59 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE8FC0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 10:35:59 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h6so17308844pgk.4
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 10:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4/Ehn/MGy09wUWEIyidLV0YlksrATE73j2Rj+Y9uTvA=;
        b=He/SMbqRzNT2shOjXhsLB1WgtK3ZHlu5A48NXb2jzQdMedD4QK6af0VMxxDFAUEXAc
         XWKy0p3y4D8l0NRpK/Lag0g7jhxnlu+QgqIBCGEW8T7nUf6tZfHWmBcmNoi+9m+oGAg8
         gWo0xtGS0/j9KGXtvxIxWtWQEtsXzS6+XHRQVKuFpL4Qzo/liMUzOWzuo0gHbSi/ekjJ
         rsWv8H0JTCtwppBYJOZdGtnqFFCVza92uqLlajNELGx8wOZPOul6qGdX6yJzA94XzTUb
         Suq3BoOycQl8LeK/3ieLMYk2tyieZSfMzYG8Yklr42odXRpYjD+B0y6535u+gU2EbRTZ
         Z5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4/Ehn/MGy09wUWEIyidLV0YlksrATE73j2Rj+Y9uTvA=;
        b=R5k7Hr/oBrBDtsoFL588lQcdS96u33TpTQxAMV9EypLVBZMiA5QZ9nOJhPTTvhozy2
         IIZgZNmuWbHxIY7AzP5K+YFSIpMkPJRZp737WKNNgU3u4Aa9UBSnr/sAbAYsPV9XVXIG
         LHG2U3KpVB8S2chmLUENFt+l8RCProSAYDzDIqJ5JMauQ3iofEocpg+EmtsVf7jz6jzY
         vho/4O9EKpogrMRdcui0FwIdwjMVTdM0FXP3i8umktwmXzpujugLlRhaupis7QeGmvVS
         ak0JynL62P1wigkhjVOcw1vd+rJyC0is4PNe4c5x77pUjHCTyf4t4QlWpuBj8IneiUOc
         xn8Q==
X-Gm-Message-State: AOAM533TWyyuzMZYk1zwSHMeo/p8Y8j+IHon8IBA8sLTBOwEQqR1q3vh
        cWkFzkpk13X7jHy18MZGrDQHPPMKes1Dsw==
X-Google-Smtp-Source: ABdhPJx9drJ0RpFAMAin+wPQ3wsJoF+/JWx2F9AAuJKULPAknGU2hR7ap0SwpDVlgPUy8H1Jtu7f3w==
X-Received: by 2002:a17:90a:7802:: with SMTP id w2mr5695406pjk.160.1604514958305;
        Wed, 04 Nov 2020 10:35:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm2988656pjr.30.2020.11.04.10.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 10:35:57 -0800 (PST)
Message-ID: <5fa2f48d.1c69fb81.2aff4.717e@mx.google.com>
Date:   Wed, 04 Nov 2020 10:35:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-65-gef20a15d5af1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 130 runs,
 2 regressions (v4.4.241-65-gef20a15d5af1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 130 runs, 2 regressions (v4.4.241-65-gef20a15=
d5af1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-65-gef20a15d5af1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-65-gef20a15d5af1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef20a15d5af16e5e1f25325936343886afc835c3 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa2c3ce65fb6694c6fb533c

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gef20a15d5af1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gef20a15d5af1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa2c3ce65fb6694=
c6fb5341
        new failure (last pass: v4.4.241-66-gcf149e8ad82e)
        1 lines

    2020-11-04 15:06:05.331000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-04 15:06:05.332000+00:00  (user:) is already connected
    2020-11-04 15:06:05.332000+00:00  (user:khilman) is already connected
    2020-11-04 15:06:05.332000+00:00  (user:) is already connected
    2020-11-04 15:06:17.291000+00:00  =00
    2020-11-04 15:06:17.298000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-04 15:06:17.302000+00:00  Trying to boot from MMC1
    2020-11-04 15:06:17.491000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-04 15:06:17.732000+00:00  =

    2020-11-04 15:06:17.732000+00:00   =

    ... (449 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa2c3ce65fb669=
4c6fb5343
        new failure (last pass: v4.4.241-66-gcf149e8ad82e)
        28 lines

    2020-11-04 15:07:54.044000+00:00  kern  :emerg : Stack: (0xcb925d10 to =
0xcb926000)
    2020-11-04 15:07:54.051000+00:00  kern  :emerg : 5d00:                 =
                    bf02b8fc bf010b84 cb953010 bf02b988
    2020-11-04 15:07:54.056000+00:00  kern  :emerg : 5d20: cb953010 bf2000a=
8 00000002 cb9ad010 cb953010 bf24bb54 cbcb2390 cbcb2390
    2020-11-04 15:07:54.065000+00:00  kern  :emerg : 5d40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0857e88 00000001
    2020-11-04 15:07:54.073000+00:00  kern  :emerg : 5d60: ce226930 cbcb239=
0 cbc889f0 00000000 ce226930 c0857e88 00000001 c09612c0
    2020-11-04 15:07:54.084000+00:00  kern  :emerg : 5d80: ffffffed bf24fff=
4 fffffdfb 00000028 00000001 c00ce2f4 bf250188 c0407034
    2020-11-04 15:07:54.089000+00:00  kern  :emerg : 5da0: c09612c0 c120da3=
0 bf24fff4 00000000 00000028 c0405508 c09612c0 c09612f4
    2020-11-04 15:07:54.098000+00:00  kern  :emerg : 5dc0: bf24fff4 0000000=
0 00000000 c04056b0 00000000 bf24fff4 c0405624 c04039d4
    2020-11-04 15:07:54.105000+00:00  kern  :emerg : 5de0: ce0c38a4 ce22091=
0 bf24fff4 cbca94c0 c09dd3a8 c0404b20 bf24eb6c c095e460
    2020-11-04 15:07:54.117000+00:00  kern  :emerg : 5e00: cbcb9980 bf24fff=
4 c095e460 cbcb9980 bf253000 c04060e8 c095e460 c095e460 =

    ... (16 line(s) more)  =

 =20
