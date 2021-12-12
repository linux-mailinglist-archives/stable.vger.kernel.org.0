Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39272471E1D
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 22:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhLLVvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 16:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhLLVvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 16:51:33 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EDEC06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:51:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q16so12860517pgq.10
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQvTQ2fjgTt2C8ygc+F8mlJyQfExxehy5UwlhZome8k=;
        b=kRFjAULMlMDncJ1SIQnLZGpHxdlXj9YVA4QprQps9tO7kwLgJQK/Gpkj/brn5Py2V3
         p+t8OYHcm88S5c7wJ7Pm2LWipSiqhVKrPhBpBAN3Mr7vOqmcD3mn0oyiJpo7DORTRo2I
         nIHxoGxtzmojwE3uDBJbSM792XIrt8sIAYDyjlbVU4fNTn7fIKtv4Ah0aU4VC+lYwmZa
         dmcaKitDiGDZwSTsRCg1OUOkyn4jQWOzDn3gjkN/nQbwyqQaaQcxDFtug9AUVko4quQK
         lUhuAusrA64xwCgzlDG7ya34DuLXhVAGuyIl6sKXPkwwWuhfxF9C0lzcCr+sCDILhSAl
         lhlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQvTQ2fjgTt2C8ygc+F8mlJyQfExxehy5UwlhZome8k=;
        b=hEXieVUJUGWNSfoC7wUgcIHV1jmFwfPM1CqvADwsD8ZTlZLGyXctTtKcdMlgQ7AKr/
         jsccZ4KkahNLX+Vylm4ByrVRYF5nYApqP8MBYPDILyTpgjgn973D1hSnJks38ME6aJXN
         4LhJv0kqe3hPTfQrxfqzw+1WspJtwiImVlT9qGB6IhBZOHQaEQxaDCJB7/i7eDpKl5Tu
         p21aYvA2mRsbAYMzRJxTqDghfZ10/Y6HV4K9UdstJ8yHGnKIL3Fe+7zOkOS/8WUEE5Qy
         +2agDh+1xZT1/WgLFdRJLJorqXdDDXO1u3AYQYgMzkS1cOaJKUdwg0tjiGsF3pVgJqUK
         sEqw==
X-Gm-Message-State: AOAM5325h048bHQ8hIHYPry4pXpO5vFmI4lsKE5vk4eawDQ67S1AdMfW
        5Gl+DqS0ejMZaiu9k+z4y6BtdGCpiaqBm2++
X-Google-Smtp-Source: ABdhPJymFC7BHcfrzGo6duwr3ZMMp7cY6mEUAK/93HCq3JwvzTjAGeJaqn4MgkRFwjO0q3U06rVQxg==
X-Received: by 2002:a63:9d01:: with SMTP id i1mr31600860pgd.560.1639345892285;
        Sun, 12 Dec 2021 13:51:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm8229698pga.14.2021.12.12.13.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 13:51:32 -0800 (PST)
Message-ID: <61b66ee4.1c69fb81.5a614.7676@mx.google.com>
Date:   Sun, 12 Dec 2021 13:51:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-50-g08088af69537
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 191 runs,
 1 regressions (v4.19.220-50-g08088af69537)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 191 runs, 1 regressions (v4.19.220-50-g08088=
af69537)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.220-50-g08088af69537/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.220-50-g08088af69537
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08088af69537a433a1e9fee71534696ae9992c91 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b639bc3dd5fa5d18397122

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-50-g08088af69537/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-50-g08088af69537/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b639bc3dd5fa5=
d18397125
        new failure (last pass: v4.19.220-27-g87731ec9404c)
        2 lines

    2021-12-12T18:04:30.653170  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-12-12T18:04:30.662651  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
