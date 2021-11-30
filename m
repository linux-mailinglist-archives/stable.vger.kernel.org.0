Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46024462BDC
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 05:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbhK3E6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 23:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhK3E6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 23:58:10 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC60C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 20:54:51 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f125so5191555pgc.0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 20:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7LdgJCLStKRiCQLyjSSQ9yFPSlGSOozdK3Fd176D3IU=;
        b=i/2alGOL9BAJuN6ca5ECr4UTstKY386nI+a/Rg3jF66NCRfsQhtIbnOtVA8ulptQGH
         5YTe1HptKJdzgOWANVEeqV7+M7ULiuiJeK8CTKeiGJ7tbBAvGJgEXHdwNbrfIetuOjvz
         44ITQ/aurcnpPrHoqQJVT4uxa7cxFu8yR5iycvVd5GmEtKB6ziXEV2e5BgiYg50tp35T
         dewpYXJRdgtTHCgSo2vVx+G6NS6TPe3s0OOgFrjb5yzIT2jmFVb4ABOvFaLVuBhzjUFw
         aSJYY57KEdGFgExb4k594iFWfiPaTZdi8kG8b88OcgD2n5q6tOBKI7iX2Ne14y+5P+i3
         r5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7LdgJCLStKRiCQLyjSSQ9yFPSlGSOozdK3Fd176D3IU=;
        b=N/Mp30Q7x9keYeF+BzytEGzyLFvbITb33ZP7lk3dYxp4xlovgnXLrcNpcj7G9YEnF2
         LjCf1HPD63gKNyafEOTG1qzPQEdMSOOt8HjDkwlq64fD40Wp759qxRGOqOz2r4eQHu3N
         L6PyAyYR61m7dFK1MpAa7usNU5A6YltdW4bjMyRDJQkqceuq8PLw3vKxLAY6FMjdx7B5
         UqLYaL2oNdTa4mUbVCGN5X4k300jjhWQi1tuyYZxriTlTZEPs/LPzmK5aezDoRiQmLr3
         oSvRFuWcbir3+OVyTB92uvLTSiD0wdm96OHyo/3DjQKuKXxvz7u1sqBYsWEXwKsBM8N0
         hjgA==
X-Gm-Message-State: AOAM531imUjljZug881F95c+1DWI0T4B4LGnUfQaAj9lcwJ1mKGRx9bX
        1jcj7SC68xvHraBZLfUWrQobPPyhsrTndF3L
X-Google-Smtp-Source: ABdhPJws94BgcCOt9XoAB8FGw2Wunl9Qfb8IaCI7QkWL7vzS75xJSOaURZE3Mh/Ai5mlWvRw0s4vtw==
X-Received: by 2002:a65:4d03:: with SMTP id i3mr8286501pgt.623.1638248091117;
        Mon, 29 Nov 2021 20:54:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lr6sm973614pjb.0.2021.11.29.20.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:54:50 -0800 (PST)
Message-ID: <61a5ae9a.1c69fb81.19f38.3be1@mx.google.com>
Date:   Mon, 29 Nov 2021 20:54:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-32-g8d63932e73701
Subject: stable-rc/linux-4.4.y baseline: 87 runs,
 1 regressions (v4.4.293-32-g8d63932e73701)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 87 runs, 1 regressions (v4.4.293-32-g8d6393=
2e73701)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.293-32-g8d63932e73701/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.293-32-g8d63932e73701
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d63932e7370161a3a375545fb2aae080284b673 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a575c532e7808d9318f6eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-32-g8d63932e73701/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-32-g8d63932e73701/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a575c532e7808d9318f=
6ec
        new failure (last pass: v4.4.293-22-gd0a6005afb1e1) =

 =20
