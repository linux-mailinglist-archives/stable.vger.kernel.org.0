Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570594132C9
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhIULrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 07:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhIULrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 07:47:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF1AC061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 04:45:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n2so10561709plk.12
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 04:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PVfGsz0IN8/BlXYhlc2oJMldojyACAlaCjr68ZmXG0A=;
        b=LaDBig/GRZ9RhpLHwjxyce+4lQITMm9bCgcqKaVJPswFUPTk49Q63DdzeP0cl10Hz0
         aCn/EVIgFL9but6SHtYqSUpt5c2Zi/sz1yraWbh3hD9JS9AjBT36BYVPvoZntX/RZyrx
         nEqMgfxc4/WL7oqErw7pduyVAfALv2UElnHyXF6j8vgchVpAAy3QOWCLwcsZg1P95h8g
         6FfEuRa306Dv20HZ/iON9bFc9lBVlfgBR/kbwP22/EKMf9qusP0OgrTE3xjLJLTrMeBo
         dpO6q859YmYT6eHl1rT7i0zO6rah18pocDsXf0jfF+ZDjQP1ojlyzwnIrZj5FX4Mucz6
         ndcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PVfGsz0IN8/BlXYhlc2oJMldojyACAlaCjr68ZmXG0A=;
        b=0jNU36W0WcCUYCmW18rz+nvlI3xLGD54UAVT0BrtrmagzBSC5YnDwmHOJn9v3W05Ae
         vULPk1ewnwZNiPT5O2es9N1Z8p62fwgdWf7wOypoxepYp8qiekg5+aHo8MzHhcZ12GfL
         1rdNycUqmgioaFW21tGvXGCA30TvfmDbvRwuJUrJoDdFFiHiUVOwp8Tt3F6MGU2o+XwH
         UI8P6fzoMTz17btEiiHwJzfWjLW6JHnI9OKrDv2wbuIzkzne+XWmgCs+LfZajbnN8utx
         fNVqeRPtNJ6nNwsGNCGidwkhFkv6amrPyo6Jrk4KRK3vWjuH6LEo0rGgzI1PbyBnSonc
         yJUA==
X-Gm-Message-State: AOAM531nGGI7rlMpnZ0iapvONMogVD/+UJj52YljOSzgqmQ8e972tv/F
        iVc62gha3C0YaP0R94BbDb6eEYqRflgIKVkY
X-Google-Smtp-Source: ABdhPJwimsgjUWX+YqL+MpawG27+EuG6P0vjlMgJqlj9dY4WsqdfjmjSCMQ280J1BawvlE3YYKNdsw==
X-Received: by 2002:a17:90b:30b:: with SMTP id ay11mr4800495pjb.192.1632224740156;
        Tue, 21 Sep 2021 04:45:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm17881574pfc.95.2021.09.21.04.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 04:45:39 -0700 (PDT)
Message-ID: <6149c5e3.1c69fb81.9f2df.1794@mx.google.com>
Date:   Tue, 21 Sep 2021 04:45:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 166 runs, 2 regressions (v5.14.6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 166 runs, 2 regressions (v5.14.6)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.6/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6a7ababc0268063d0798c46d5859a90ee996612f =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149919b8dc806b2f699a314

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.6/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.6/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149919b8dc806b2f699a=
315
        failing since 8 days (last pass: v5.14.2, first fail: v5.14.3) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614994065bee0ba88e99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.6/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.6/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614994065bee0ba88e99a=
2e1
        failing since 8 days (last pass: v5.14.2, first fail: v5.14.3) =

 =20
