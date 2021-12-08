Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1E146D4B4
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhLHNt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 08:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhLHNt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 08:49:27 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A58C061746
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 05:45:55 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id o14so1561378plg.5
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 05:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yiaHLXWjO8jAit1odSogXmjyYFqRg7jdueu3ZBN4Loo=;
        b=KQU9uHZNPxUp78+1RQ/fAygwXlj6sGv/IB/D4z/ZODcXi40aOgdX/PFfEVU1Tsp/dT
         IE2u37+T+7raBjWc+8CAnvZgWE3kHQeFTvhPBPXtI0z01JCqCH6RKpWBsQX3zYMobrja
         +kHDjTMfSp3NuVBchZj/yd+Fp8QMr4FW8nvqURCOXmWx/7AgD5BmvY2IdGHuYmQJXRk9
         3leH8z7yfrP1SgeR+hNlEkIc30KWGDseMmjxXOQ2gA5vtqjZw2uuEspIuyftMm6jeybv
         NdjYqEOyYS0XZhArZpxoo0OOc1XfHUV8Evgx15rgiUMwA24dyMZ1jzq6RHfpmzvIUqSY
         b/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yiaHLXWjO8jAit1odSogXmjyYFqRg7jdueu3ZBN4Loo=;
        b=5nhKDO6XgvKIZ4SZxSO7O5EqP/XoT9+JkU0I+fs+1dK1/lTbdUrYhfJN/E+T+SPKLP
         Hg5+QEVnXzwpzbEjRtJ/oanLE474CVGfqj/Ta8kq2wSuFAEdMnken5Y1h3aiV1UP5IEj
         y6J62iYWCq9BdZiHH5brnUvTGvNAwcVIidaSBQoPs1frX0aV10G8e/411rsrE1ARKGYI
         gmGWC+chbrAF0HcqiFdCJqrzlM597CQSaHOBzIc8R/mm/a+om0J0ufwbH5s1i2PPBp5G
         Wa0A/pX+Pmiv4UHKTs+J97V3KeS6FyNURgyuWMgjT1SR060z6dbVtgW/lA9aMx175YLt
         uJug==
X-Gm-Message-State: AOAM532ww/ZiN995O7fx/jRiMOQpWZVzjPFhb2yTEnP2QyyP4aYqmWzb
        39jUfIK6Uz9Ikza87B6VTL1j8bkWYYaNEkAD
X-Google-Smtp-Source: ABdhPJx8eI+3TleQfi5cqxZ16AS6odLyjOp0bUGAK9SGfb3OiRpo7BIjMyi8VVE7hkrMvgMf61XcDg==
X-Received: by 2002:a17:902:c245:b0:141:f279:1c72 with SMTP id 5-20020a170902c24500b00141f2791c72mr59184372plg.18.1638971155058;
        Wed, 08 Dec 2021 05:45:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s38sm4137672pfg.17.2021.12.08.05.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 05:45:54 -0800 (PST)
Message-ID: <61b0b712.1c69fb81.c3fc.b49e@mx.google.com>
Date:   Wed, 08 Dec 2021 05:45:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.220
Subject: stable/linux-4.19.y baseline: 195 runs, 1 regressions (v4.19.220)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 195 runs, 1 regressions (v4.19.220)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.220/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.220
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bcd694e3e7181ddb30e4156df69a2775ce51ed4f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b0841baf3f7d5be11a94a8

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.220/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.220/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b0841baf3f7d5=
be11a94ab
        new failure (last pass: v4.19.219)
        2 lines

    2021-12-08T10:08:12.336510  <8>[   21.151062] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-08T10:08:12.383902  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-12-08T10:08:12.392688  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-08T10:08:12.407195  <8>[   21.223297] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
