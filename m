Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8BF2A4A6B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgKCP4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgKCP4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:56:12 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9F4C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 07:56:10 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id y14so14546910pfp.13
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 07:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qiiFLrEpuw9pajPM1T8sV1CEXdENx2aiIe77uRXAErk=;
        b=By4JGHcE0aiJ6k71qnbpK4SlFaIlMaKIdkvcPmLpmE4bu5KQB2ZYf/R2vyJuQAVWVk
         n7qn+CHXswoGuBx+4pbqmOkl6dob9I/iVvot6htF24qklOOH70j69OxlfVeAAVkxIIan
         47+PUkwHyNuZw6PJLn34Hpv2b/hb589//oYPZRCxbGmfNSFgrkodTUxoDOnEnCWyl54d
         WMpoInLSwnlwVBY/gJxkIoeYgIchmx4l81onXge/mpxKDfY+IGpwRxKuKZf4oiM2DA7u
         NFWoZa6VpM/rgIlHT00MtCufknGEzm1l2V2E7wJKXmFFM3BNnwa0K2JFZXlHZPMPOJJB
         FyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qiiFLrEpuw9pajPM1T8sV1CEXdENx2aiIe77uRXAErk=;
        b=hDlUhnYIrr1gBBu7Q887QSmS0poMzpI9me3wO5Jv2RYNePB3hJg2IKzoF5SMJIBppl
         avN7gFdd882bc9J0SHL0Z8oA5wpsr6dx/IyjMuOiExK4VRWqZZ6MKr7U/KWUwiTfQgmi
         0nLQdJAUBNdTC/4ErqS59NIOARGIHVvHfL8Gvemj8mIOo+A9PM8Gj/OfAoNz4dxs0GE/
         mcIQF7j6JdzWwn5mhuVOgdrdNBFoAA3nGli9NV7axeUk45GR6/JX0FLdwF6S4GmLkfA3
         gPO5umF0rSxklW2uN7KglRz51dFEeOymgBzTclNsUfaxRdY4ESox8O6e4LCkCackztFt
         7cow==
X-Gm-Message-State: AOAM533MxoBFbuR5EY41iI46Qf31mpa4FPhTwG8hbcJriV/EcXbxwJOf
        u5/6E4CNbknzfZg9wnmNM/Xdp6NatMDcbQ==
X-Google-Smtp-Source: ABdhPJwx5CtWTUK8bVcIYmsclHLfphc383RuwtVMQOiRfPIfNpfeSgXieU5QogKqhyBv9VC0vmlMSQ==
X-Received: by 2002:a17:90a:6501:: with SMTP id i1mr493528pjj.30.1604418970167;
        Tue, 03 Nov 2020 07:56:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 198sm5477202pfz.182.2020.11.03.07.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:56:09 -0800 (PST)
Message-ID: <5fa17d99.1c69fb81.2b484.ce25@mx.google.com>
Date:   Tue, 03 Nov 2020 07:56:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-35-g00e1b9176297
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 132 runs,
 2 regressions (v4.4.241-35-g00e1b9176297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 132 runs, 2 regressions (v4.4.241-35-g00e1b91=
76297)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =

qemu_i386-uefi | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-35-g00e1b9176297/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-35-g00e1b9176297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00e1b9176297755d1c41206456c06d42e9d676f6 =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa145a59e814908313fe7e9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
5-g00e1b9176297/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
5-g00e1b9176297/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa145a59e81490=
8313fe7f0
        failing since 1 day (last pass: v4.4.241-8-gd71fd6297abd, first fai=
l: v4.4.241-10-g5dfc3f093ca4)
        2 lines =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386-uefi | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa145888d41cd05113fe7e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
5-g00e1b9176297/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
5-g00e1b9176297/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa145888d41cd05113fe=
7e3
        new failure (last pass: v4.4.241-34-g4300be89420d) =

 =20
