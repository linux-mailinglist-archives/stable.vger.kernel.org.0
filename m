Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF631C49F
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 01:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBPAdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 19:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhBPAdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 19:33:05 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40215C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 16:32:25 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z6so5139789pfq.0
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 16:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jkYkcxVbsieBWi4TZPZ5P970g4pln+3DWelz0xbFWFc=;
        b=ucVJBpWjEJej5IJXxEWLqMgvbC6q4iM6bLGiSHvojjwJJK7AwZKEapdtuuqbnAnxki
         c0m42Yk3/wRe4el3XbqNFzkTxXTTvFfCOoFCs+y3SYz+O12AJzGS9fsMC4FrVjrp++G+
         RGTSBcFk8DjjFe9YFEI9SFQ0Tr37L5dP1gpC39mTAjZo5SuOg2TG0/eNXlDV9JbAESJh
         X7ywu7HTPwb2SjmnYMMXQSj7jidjlwO6JMmmwzKMVNPuG6M+puqw9cLZPkqEwh0Tef42
         ujuLTpEVOa4rro+EQoFwVHpi3zkQFypQffSFXqQK5hDr16St+Lls6c6o9sk/KOvKln7N
         tPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jkYkcxVbsieBWi4TZPZ5P970g4pln+3DWelz0xbFWFc=;
        b=BeU/W5G8a1AZF8AE9FNBVhYsmFraAZauIviFDeKlleGWDybD9DBq1LYgQpVcKoaYn4
         yl/g2QXAgy0JWEn7L5rzGmwDAauDYpu+jLZVbhDcEoRSTkH6/fIwk8JqUkMb+XYZmv+0
         uCp0kxEyEhMO7PIbP8zHH0WNj7JFq7e1rBTuhlX2xKZeVzGZLUc+XH0dhWuzsHpchzMQ
         9QFxs8wJlyFIILXvn34nfN1dvbXkwnmLdRAJ6UpkKYDQdU5eswsenDDutzHR6G64dlv7
         0zeU/MpN7vaZ6oMAhMnwI+Umi4E9dgzLYSxSJPaFS8E5JxLYRBVVuQMO3L1WQv+qC9Mj
         53Aw==
X-Gm-Message-State: AOAM532D17yJLofm8F7LHROupjukpHLaXod1quiZPn+GvXrSKeJwEt1d
        fzPo/Ae6IQtlKTQhbvUb/ayzyqLXaITdZg==
X-Google-Smtp-Source: ABdhPJxAyj0xuosDLyK67xh+TBnQjKO2Dyz9+qxgeYyGaRW99QFKGh7fjSbvTD28Ul8uECr6q6filw==
X-Received: by 2002:a62:25c7:0:b029:156:72a3:b0c0 with SMTP id l190-20020a6225c70000b029015672a3b0c0mr16949077pfl.59.1613435544399;
        Mon, 15 Feb 2021 16:32:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q22sm19454943pgi.66.2021.02.15.16.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 16:32:23 -0800 (PST)
Message-ID: <602b1297.1c69fb81.41521.989b@mx.google.com>
Date:   Mon, 15 Feb 2021 16:32:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-35-g7844ccc4863f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 39 runs,
 2 regressions (v4.9.257-35-g7844ccc4863f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 39 runs, 2 regressions (v4.9.257-35-g7844cc=
c4863f)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257-35-g7844ccc4863f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257-35-g7844ccc4863f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7844ccc4863f44f339cd31c85322d1dbae9fb91d =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/602ad984229405c69daddcdf

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-35-g7844ccc4863f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-35-g7844ccc4863f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602ad984229405c=
69daddce4
        new failure (last pass: v4.9.257-21-gbf5bea27bd35)
        2 lines

    2021-02-15 20:28:48.620000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/602adc2fd73efc5424addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-35-g7844ccc4863f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-35-g7844ccc4863f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602adc2fd73efc5424add=
cc3
        failing since 89 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
