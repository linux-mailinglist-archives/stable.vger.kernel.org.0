Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB6931B5B6
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 08:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhBOHta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 02:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhBOHt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 02:49:29 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81531C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 23:48:49 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id b145so3695897pfb.4
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 23:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pG281MQQCZVmSqEv842b3+NVGFH31oYmraAcw5Y71XM=;
        b=dySHdhX1Fj70O1LkYosQxMlrF+0ryF5DNsx7LLw9DPpk4fNKT1saEk2iUg15oLK0C8
         BarljiTxKI76y4RxW6x4kz5+fHYhYnR51ArSUwRc3VtVBIl3KG8aK0K/0Lz6aoLrJse/
         aqxsvexHhFoq7x2+VgQuEqKk0Ya9dKrGPoJX/Sis3kQ5J2yTSjmjabOdxL3b19WTXD4r
         4rsp6wxpK/aPubJoK/t0UVoatzHSr/LMcWQ+TMDRROYAoSC5SdDdK7WFfo7o7POwgH58
         qx28K8r0G75MxJaBuuBothGX+WGjEUe1P9371w5RDZsX46mfXVocKZhR5XcpfpC2Jz69
         Lkcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pG281MQQCZVmSqEv842b3+NVGFH31oYmraAcw5Y71XM=;
        b=TptlWH6LwIjZieGQN+dGybfcr2dN8HBQvlSVJKTKa9QpB+K+3IslYnw60BJxo0jECA
         m7W8ZswF6LXGOzsdg7EDpew3HJNhCzx+LrqIS/UrKOtO8HL1meIH9+NPN+Lyf53jC9Li
         ehtcDVmOuQvFfLtpTsUMBi0rnCEtyj07ZN8xVp7WRB0BQWwYirv8/JyTJR4Ic16sJ0Nc
         cCwc/rVo4lej3CJiKx7h+x6A0WVZTR9+JDrkdjbcshzfUaYhS3SXY3Tivv605MKkbPDn
         zS+P2mG/0FQI6O8p+SOrggjX2BmBd7QYIaxZCvJ3+JIxpaKwPD7WPVlLfQcDzeufr/Na
         eJvA==
X-Gm-Message-State: AOAM531aviqhfXBCoYVeu8IY2jKYye2obXzTvkCPOlBqDsCyKioJwEzM
        ybKiqOU8ofKEzx5YYKEGZ7co+SgUOpteqA==
X-Google-Smtp-Source: ABdhPJwFe4Mm8bYBEmWn1ZpSOmmd6N+SMAwOcP9PjSd3/CLDjvGuSy1cwL5ChOfK3G8wxoUSe2m+qQ==
X-Received: by 2002:aa7:8d0d:0:b029:1d7:3c52:e1f6 with SMTP id j13-20020aa78d0d0000b02901d73c52e1f6mr14488269pfe.39.1613375328588;
        Sun, 14 Feb 2021 23:48:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ep14sm16381486pjb.53.2021.02.14.23.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 23:48:48 -0800 (PST)
Message-ID: <602a2760.1c69fb81.dc178.377e@mx.google.com>
Date:   Sun, 14 Feb 2021 23:48:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176-15-ge6d3f3cd3f8b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 77 runs,
 1 regressions (v4.19.176-15-ge6d3f3cd3f8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 77 runs, 1 regressions (v4.19.176-15-ge6d3f3=
cd3f8b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-15-ge6d3f3cd3f8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-15-ge6d3f3cd3f8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6d3f3cd3f8b4498fb1e90166afa7f93f6831173 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6029f607d0fe7f27b03abe62

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-15-ge6d3f3cd3f8b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-15-ge6d3f3cd3f8b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6029f607d0fe7f2=
7b03abe69
        failing since 6 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-15 04:18:10.223000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
