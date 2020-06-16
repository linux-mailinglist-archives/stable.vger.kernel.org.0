Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD061FA91C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 08:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgFPGvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 02:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPGvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 02:51:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4147C05BD43
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 23:51:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ga6so1001877pjb.1
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 23:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XwWwKHRhXw2fM5MHcCmV9o1ow4VEFRI3ZmatDEsE+T8=;
        b=coXVhkkxEnmLQpXYbmj1V2EoeKtGCK8DbFt922n+is5+P4UGA5oSJvX+E3gpt3WGy5
         cu1Td8+Eg4CYWOidpaBh7fXQphUSppaAcvBh6uuVPkVfEyNvHFnpHsd+CfvVO/m4QwMt
         WK3PjnnrSvx8k+GknV+AwM5NXlEDi6RYk7FYLKlXY6SvU0a3IK4iLIx7X+tzse9ujDSj
         HmD91uYHWEOq5pKOeyo9Z91tc8OR/n4SpURVDeMGuk8U+SDcC8QONi+BGImI3EC8olqE
         cy719BJ2L+b2d1IjgMWk88TZOZWJCK6lQBeth2KOOxivZaPAh9rWh99Qmbfmtl14wAK0
         2pIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XwWwKHRhXw2fM5MHcCmV9o1ow4VEFRI3ZmatDEsE+T8=;
        b=DQIH4aVk8K1dSB2SS3t7Zr1AaQBW27d2w7mW5CL/zqFwu0iYoKa3wq00PELM+mY/pA
         xkg+fv3rgm6uKz5z1dBF9GX3OKV8hu0jjDFqEDbhlUmBPjvryW9whau3He0K0YiC9wB9
         x8V25Ii670VDvc1/T9RbMwC87VpdFc65mf+Mp0V94ribhjgPN8tbfA6uhbXCNVE88FSc
         t5Zv+sScSF0VogoiJHspY8Uyj35pjnrmIqpUsED5SvbJBI71VowT+xFbOCyS5arCnxQ5
         vKnSKsfWAqHXOtD0fOHzAsz61OZq2nQVKgf7A3Qli/eT7iJJhiYo/gzz0Wm2ajqg9/mF
         48FQ==
X-Gm-Message-State: AOAM533ZMe7K7ahd93IZlIs4GqA14YBfncPiLVikbaB2qQtnXiDQoxcI
        ga+kjQZqB1KpurDFn9sgsMxbl+7+dyw=
X-Google-Smtp-Source: ABdhPJzKj+DFtLcubsJFk+57EOKwwvVhRzRWas/Kt1xfUhUJe7BAgAoG0QJ9ehvQMrGjVnWvNjJM7g==
X-Received: by 2002:a17:90a:ce11:: with SMTP id f17mr1410898pju.123.1592290262795;
        Mon, 15 Jun 2020 23:51:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f23sm1338114pja.8.2020.06.15.23.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 23:51:02 -0700 (PDT)
Message-ID: <5ee86bd6.1c69fb81.b46e1.4997@mx.google.com>
Date:   Mon, 15 Jun 2020 23:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.226-72-g6940a98776c9
Subject: stable-rc/linux-4.9.y baseline: 69 runs,
 1 regressions (v4.9.226-72-g6940a98776c9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 69 runs, 1 regressions (v4.9.226-72-g6940a9=
8776c9)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.226-72-g6940a98776c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.226-72-g6940a98776c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6940a98776c9014fdcc806e39ab0ebc8316cf241 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee835ce715a72faa297bf1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.226=
-72-g6940a98776c9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.226=
-72-g6940a98776c9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee835ce715a72faa297b=
f1f
      new failure (last pass: v4.9.226-43-g2d9a8182e06a) =20
