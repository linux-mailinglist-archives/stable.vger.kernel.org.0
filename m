Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB71396062
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhEaOZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhEaOXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:23:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA21C03463E
        for <stable@vger.kernel.org>; Mon, 31 May 2021 06:44:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f3-20020a17090a4a83b02901619627235bso4505591pjh.1
        for <stable@vger.kernel.org>; Mon, 31 May 2021 06:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/d5BhG6cvR0m0RMzQqXdAmX9O6b03puyF5itYVeFAlE=;
        b=Ei86ioCYfAypxLXBdDwPi9pLEf3dCyHmu1uUcdwfJvQQ+7NPg4ZX8GHlWKmjNUsyBi
         0c2mvIukUDh7mWth136aPXiTzrpoktqTVpDb/zZU8yE7VSnmBlZ40taT52nU/Wwtm2rO
         pIudkW3dzxAmHqKOEKTvp+pUW4/X2ASVXjBVlHBykWreh4ATHFm59980BUda+KPYhhxj
         5dN6uFBT6f7r7nwrchRQQ8UVsHB4jZvZ5xsYWt1RX/Cq3c1Ii7KVfg38kOnYwPNmhknx
         PY/gRWa5U89Ay3v44CYyVGiBbXJeYKQC+qmNEzPD6aKvNiqHpWWHuAartmE8mHU4gfhU
         HcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/d5BhG6cvR0m0RMzQqXdAmX9O6b03puyF5itYVeFAlE=;
        b=dDsxYSdhN+JR5esfOudJxt/H+r+7rwsbKvcs9P0eA0OmcQzniK6WeCbNQQiV0bd/7Z
         FwMgJCm4qCMxXmpS4QaJu6DD+bqCf7859L0wF4m2GUGPCIG/R9se12uWaJ9Zdf6CGs5V
         1jZYM0yiS+ZxndvJzPTF4SaaXR4rmaHMlMk/22h2s5mM7gYTXA12hQfOLGbQoRuJE6NA
         UiQpg04Nj16rIX6OVyvO+H8ln6rz2LhTTmHjD1s9advNutA+YBTVwIQSokSHy1i60I54
         EqnvVVaq/9hlxNSCOs8w93aVYnMQ80YH2Mvr6hIaVIJTbmIC6ibLcrc0tmzSdSiIttP5
         Yc8Q==
X-Gm-Message-State: AOAM531qbJ3PXBwGzrCxt5kQHYGZvGY2p4nt76jSxYLbtSX7loB8d3+5
        XYRTQ7E6wkJbApRvZHl2z+9oXQTv2CwvXdBM
X-Google-Smtp-Source: ABdhPJwmgKEuhdZKOH8X58c/fbdtslyMzk+QlVUG/Pyxy8gDBmM2lhB9DmWBt+C2h+e4isgFNp1nOQ==
X-Received: by 2002:a17:90a:2f81:: with SMTP id t1mr17715941pjd.122.1622468694423;
        Mon, 31 May 2021 06:44:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm5968505pfi.122.2021.05.31.06.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 06:44:54 -0700 (PDT)
Message-ID: <60b4e856.1c69fb81.d8f17.0efc@mx.google.com>
Date:   Mon, 31 May 2021 06:44:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.270-67-g3c706be65cd5
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 1 regressions (v4.9.270-67-g3c706be65cd5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 1 regressions (v4.9.270-67-g3c706be=
65cd5)

Regressions Summary
-------------------

platform  | arch | lab         | compiler | defconfig      | regressions
----------+------+-------------+----------+----------------+------------
qemu_i386 | i386 | lab-broonie | gcc-8    | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.270-67-g3c706be65cd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.270-67-g3c706be65cd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c706be65cd5511631d8f0f6d9e45730d0fe1211 =



Test Regressions
---------------- =



platform  | arch | lab         | compiler | defconfig      | regressions
----------+------+-------------+----------+----------------+------------
qemu_i386 | i386 | lab-broonie | gcc-8    | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4aed0242544e77eb3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-6=
7-g3c706be65cd5/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-6=
7-g3c706be65cd5/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4aed0242544e77eb3a=
fa8
        new failure (last pass: v4.9.270-66-gf6e0b6889430) =

 =20
