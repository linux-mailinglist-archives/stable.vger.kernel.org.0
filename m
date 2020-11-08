Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B09C2AA8D1
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 02:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgKHBgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 20:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgKHBgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 20:36:45 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B39C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 17:36:45 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f38so3998475pgm.2
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 17:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=urmxIGoemhaxsAE9H3QALeEK8NmdZiktoC6iyf3PVog=;
        b=I/m+CKHLqVH4QVyrjvydyJyKR3y5SJEBg9j1dbWRrTp+riViOqsLm5juWh3layUTiR
         rwKRKD3aBxGXTrSwDH7qoq/ywe24Q9vXeKRS6EsIX5g27BgvzHtf/ukc3KOccbbF5N81
         CFN7usHLsYIMhZOgFnfKOdjPq/KB/Jw8fJq3Txw172oy+6F4PnSolrxRdMMIO0sYSFD/
         bpHEcKqxipqXsdlB5Yx4EKqguaaRiz1xFWDGyZABlgF8B3a4/7lOB8ngT9+6WFbQXVdc
         sXMc2nK5NjNwx5AbYgxKmwu6PMwqY6M/+b+E0/XXy0bLbx7EtmutxVaYklZ8R6knQauc
         wwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=urmxIGoemhaxsAE9H3QALeEK8NmdZiktoC6iyf3PVog=;
        b=cwLlzvZoqvox3E7V4HRnbvGa/T+JbGEXxwuermZRsY3sYNc1P9TIKL+qZBOiNByZyn
         c8sIVAAYv3/gcwhX98s/3BsvkhKcTqQlTdZwce/MX2ZTfZO8NYiUUd1l/OUXOJ++iC3U
         lCuN4KiI4WgfNCcjjhSc+jq17e4oIsJhJwl5YGj49qukIx0ZGm9gW2iavhUlk7xp0yZh
         AsCPuvCYHFyinS4ixeKnw9ObDoZSxQ++ADUNv+1Cqeh8AdMW1WKQ9WFsHQBeWjApoeVd
         a8YBoWuJQjvjB2YX7jobuB8s8jin5dNFe5/LAUQ+intl2pyiWF0o//MZdYsZ9/8/QZgP
         Y1yg==
X-Gm-Message-State: AOAM532NTcdU1BSt1izPnWJ/OV5HaffJjTUt7e7uDP+0ojZZK/hC+wbE
        vfGb/ndPOetvC2bxdvkvz/fxd9DhCdvoMw==
X-Google-Smtp-Source: ABdhPJwOSxfgxII8LuYxzTfSdXoYcpSFvzIcnxXo7V0+a1r+vhmuiGBMzbNqd7I/zyAIHW0LbJUbqA==
X-Received: by 2002:a62:3704:0:b029:18b:9bad:522c with SMTP id e4-20020a6237040000b029018b9bad522cmr8008380pfa.5.1604799404881;
        Sat, 07 Nov 2020 17:36:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm6267993pgl.57.2020.11.07.17.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 17:36:44 -0800 (PST)
Message-ID: <5fa74bac.1c69fb81.484c3.c32b@mx.google.com>
Date:   Sat, 07 Nov 2020 17:36:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.204-22-gc61fb0fa5762
Subject: stable-rc/linux-4.14.y baseline: 165 runs,
 2 regressions (v4.14.204-22-gc61fb0fa5762)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 165 runs, 2 regressions (v4.14.204-22-gc61=
fb0fa5762)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.204-22-gc61fb0fa5762/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.204-22-gc61fb0fa5762
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c61fb0fa57623557ba759bbdfcf341cbd2a5acda =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa71b757b53ec4989db8886

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-22-gc61fb0fa5762/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-22-gc61fb0fa5762/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa71b757b53ec4989db8=
887
        failing since 221 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa71a64f1d65696aadb8883

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-22-gc61fb0fa5762/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-22-gc61fb0fa5762/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa71a64f1d6569=
6aadb8888
        failing since 2 days (last pass: v4.14.203-126-g8c25e7a92b2f, first=
 fail: v4.14.204)
        2 lines

    2020-11-07 22:06:24.692000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
