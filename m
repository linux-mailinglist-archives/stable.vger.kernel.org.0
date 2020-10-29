Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4D29ED5E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 14:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgJ2Nqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 09:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgJ2Nqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 09:46:34 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37679C0613D3
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:46:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f38so2392357pgm.2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SG4jwj5DxuxdwUYnnnVpJm1/Id0pO48dgkvSS7oDS0s=;
        b=rIwhWo0RgQ8LVijDkYOicXHmGSsyK/yWHvIAqvFQKN0tyVffMU2c5dTMxMf1KB1Om9
         qUeEwTcqLKoQ6x3GH5z5JTyXswyVLhGn+gvHAG4NPH9cDa5N6JzDuda84QBemL5yZK7T
         K85vEWq//+5Cvr4RBAy3PY7m5GAxxDyxEAAKONdvxoCLf1TuvEokQNOY7kztopLomeST
         6cRKax9rSHKfLwlrW+izkP3qMwA7cmMHt3+Wmu2n5IxfTY46K+TBCwjMBQJyPVi2Px7P
         gB/D4EELE7nu3hks1k/T4cpqwvb+rS0Fwg/wtmSC36CQ0Ot4I4Mc+ZsRtIofJj/FXgID
         zvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SG4jwj5DxuxdwUYnnnVpJm1/Id0pO48dgkvSS7oDS0s=;
        b=jUCcD+VvX3GULJg4zMVpNDYNIzADiI95Fh7h0JXkIwDfmweMuRE9dp5jbYqHuOg5Xf
         MHzDS6tvXH4N3HsNpska5+B1H71GFDctVuLj4CS+yfHF88B7me1NJcel+zA5Q7ZcdNe1
         O+uTbFuXmkAHzKLRUg0k+x+8JAqc9OEJztqIogpODVeKuI/wYadGMJWL5UxuVVMr/ozk
         5rMYy7gICyF23s25azp0fQi0VkFq3gECsiQKn33hqvIbArVmEvvVF7vTAkNhaSzE44Xu
         ABFhdSDRj7aYwAlH6/RdKbFHkwAr71SrxoxGKYLi1nmejAKuWcPFM1K50NUMQZ1hGDgu
         RxQQ==
X-Gm-Message-State: AOAM532V8NpWZNPVhClHpFytXTVIgwuVgQQBjeVe2SR3B10D+wTpne3i
        udk1dlmjfkEObhHp6GFbfqqSmSiig0kDFg==
X-Google-Smtp-Source: ABdhPJxb9fkgXhBDKdOzz61kNfnWOSwYZccDwKHYhB9/+YnDyxlwtXFKCBEjnb223epfBMmfFunRWg==
X-Received: by 2002:a17:90a:4e0d:: with SMTP id n13mr4403963pjh.95.1603979193516;
        Thu, 29 Oct 2020 06:46:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm3032553pfn.173.2020.10.29.06.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:46:32 -0700 (PDT)
Message-ID: <5f9ac7b8.1c69fb81.98106.71b9@mx.google.com>
Date:   Thu, 29 Oct 2020 06:46:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 124 runs, 1 regressions (v4.4.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 124 runs, 1 regressions (v4.4.241)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.241/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8dfc31cb1f532f20ae71ca049a84c40226f30753 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9a965a622741e597381021

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.241/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.241/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a965a622741e=
597381028
        new failure (last pass: v4.4.240)
        2 lines =

 =20
