Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB20E4A3182
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 20:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344258AbiA2TV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 14:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiA2TV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 14:21:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07646C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:21:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso442337pjm.4
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uvzhsAE0Oh1tKUFitrJXhebqKwPw+HuYiFGXQBbKgq4=;
        b=VHmQZJwEpVVcIoHriuvxeYoH5fV1R2/aHGINCz5T2BFoThTbpquXek/1xJh+5N7W+e
         wcSlnbYyFAkHdiSfYhF7krBR7scvYFxI3waxW34GyRRJxecHlbsCPE5WvG/Fz9SVCi1B
         puG+cwXw7tpU0h0k+Pv+Sm245xK/GFAmn17l8cQtt0j+yxO4J+sY/jKliUmYoJH+s4pe
         jCAqIm4aBCLxHc0MoEGJrtlFyT6SFn2KrB0tOpPz0ztcMCYaw4OvukjTOOa+7ZGoCtNg
         Zo6P2pOJjg5WBy6UyMoOzLxeiZWuW9mlUHgbxGhR5vSIV4c1KsErDlJa/bK027KZmiOn
         72uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uvzhsAE0Oh1tKUFitrJXhebqKwPw+HuYiFGXQBbKgq4=;
        b=wv47LQ25aRdV9CYblpa52UwCgLjDOYVNo9wnoBTRYWzbVcOFBeAQ8z7k+KWSxpxPaT
         /IKAcvKdPZqFZVwAgDSbAzmF63kBkAjCUkTDMW1R7Nep8zPGyLOPGxpwtRYKrm1VlCDI
         xabFsQ6hiM1eGp8GD7mm89OkKbwUaqqpOEE2HJlz5ahyec+C305aGKM+o/4Q+0oPOGoc
         ZwsxZ3Dj/RicxZkflNRSjBchodYjlnAOdggktvEUJo+qcOwFhD1rjJavzDChoMM/hfLU
         IXX2uqQgnLXC6uf1Qc7sTGFm6fpWxmrZV21aKTw66xMZ+Kc7rTPBeBGiwig3w//c+IXe
         yvoQ==
X-Gm-Message-State: AOAM530WYeAawv+BqBDLRnYdeshRpUW3iww+niRKhF19x16X2RSL/zto
        Nv7owaLL4ggJebkCf4tdItf3reDGwaLMxc/T
X-Google-Smtp-Source: ABdhPJz82SICp+AVkiivpDuzH9HDd+pG2NRr0l9ln+7p2nr73QXs+4yplK7f5wt2q8AEl69+uMADTA==
X-Received: by 2002:a17:902:ed89:: with SMTP id e9mr14347673plj.88.1643484087328;
        Sat, 29 Jan 2022 11:21:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d32sm25799508pgb.46.2022.01.29.11.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 11:21:27 -0800 (PST)
Message-ID: <61f593b7.1c69fb81.34192.768f@mx.google.com>
Date:   Sat, 29 Jan 2022 11:21:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.18
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
Subject: stable/linux-5.15.y baseline: 104 runs, 1 regressions (v5.15.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 104 runs, 1 regressions (v5.15.18)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.18/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9c43548a7fb8220b13b0ff980989b44f37d54138 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61f55b0884ba4d6c31abbd1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.18/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C5=
23NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.18/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C5=
23NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f55b0884ba4d6c31abb=
d1e
        new failure (last pass: v5.15.17) =

 =20
