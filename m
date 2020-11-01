Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BD22A1F0F
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgKAP3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 10:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgKAP3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 10:29:02 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25E5C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 07:29:01 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b19so5537368pld.0
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 07:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0wB6UztHS9lXBHMA4Bw4DyZIegLqckD8RvKo8YCUdW0=;
        b=WfsDmW+VayF3gSDg9A56ztpykjIN+ibOPdvW6Z/vWEDDwK1PJFCoPEnxRL6fS9aIpx
         r2U1CAUYzpk61StFIak62IhnsY10xqF3On+pp5xJZZD4IDHcYCdmrfZcCa9ax5KCKa/f
         bmb7/mNlwJw5qfd++8fMwYePgXv499LbqpiCrghx9TQTKgzrzfeMiGpU0k99E/xQ5kXD
         8CWpgKMVEh/hW7mbyCTPQlap+rrwd1PBGXnMUiPtxKeGcz6iO+UKoS11LQBKogsBbJb1
         k12FS55GIK3UlUrka9YusoWSOEH/TbeRuMWUdGxxpZ5A/9Fq6ThYOJb6nhfqm71a6lNH
         3UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0wB6UztHS9lXBHMA4Bw4DyZIegLqckD8RvKo8YCUdW0=;
        b=rwJ2kMyt6nkBGUct8Moy3qjXJSSS1Cu9SMQO4vFVv5QCa9KRbbD3eo86kpibYW5aC2
         o8Ef1vFtbc59+4F8bqHL110TeDzvLqIJ0lUf6M4Z9MT5MlIl2kyjPm7tnyoOppy+qtz8
         LAr28HSGTEV5D0RUshR64PrlTv0wVmkE1exKenfKKVishtByzrAbnOjQ3Q2KVY9EB53M
         Mo7c+iNVNXYixlYESbtgt2xV1Psy8UxsGlG3DxRRTvKWHfe8iKpDgKyrUZNC/TAWWEx3
         fPPytvVjVbRT9SwNj7ilNKrTnG210lCP7zhplF9A+9IvGSzKWp3ly+htk+FzHRq4Al0p
         r7uw==
X-Gm-Message-State: AOAM530C3KpqWc0uvIbVIBnw3ZJCRspqkif3Efd87OW34/qjdsNXwUqJ
        7puOPWKELN12PkxzutLcmaQwMA1JZyB5VA==
X-Google-Smtp-Source: ABdhPJzvRFQux6gNSgyVZplQFPpDNFy3Eq4KJbqFjmYbczKxFSBlcw8Jgb6TjjwZi4HAvvuuwqBCBQ==
X-Received: by 2002:a17:902:7102:b029:d3:ef48:e51e with SMTP id a2-20020a1709027102b02900d3ef48e51emr17048228pll.72.1604244541059;
        Sun, 01 Nov 2020 07:29:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y203sm11480691pfb.70.2020.11.01.07.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:29:00 -0800 (PST)
Message-ID: <5f9ed43c.1c69fb81.1c013.dc30@mx.google.com>
Date:   Sun, 01 Nov 2020 07:29:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-35-g047c97e1e99b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 190 runs,
 1 regressions (v4.19.154-35-g047c97e1e99b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 190 runs, 1 regressions (v4.19.154-35-g047c9=
7e1e99b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-35-g047c97e1e99b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-35-g047c97e1e99b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      047c97e1e99b2b20ca5f8cf5ad292c868085745d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9ea1311a4a82bf783fe7e5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-35-g047c97e1e99b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-35-g047c97e1e99b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9ea1311a4a82b=
f783fe7ec
        new failure (last pass: v4.19.154-17-g3d66f439c70f)
        2 lines =

 =20
