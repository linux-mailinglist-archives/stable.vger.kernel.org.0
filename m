Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5762A475149
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 04:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhLODR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 22:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhLODR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 22:17:58 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952E2C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 19:17:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id u80so19475437pfc.9
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 19:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kK39/0AlnNAWmSZQGDfJAh0mdMFi52HP98uA6cNsE+8=;
        b=uqXViY3xuLgJbldm/CTa+dBMySKvkaqH20udtTupzHok/bYPG5XXwNIsXRso/NvBQw
         YwAHHDffweH5QfcbK/6UOfmmkM3fqUCVC0v+kaY24DTOrz33qZWFV8tuWdZK/spiC0Qg
         05Qf+DcwiT2+eX0TB9fRETIHMO0r5sz2zr14+RIq7x/RLb9nwlDGPWwhQP4JISjW4Xir
         rLk7HA/MVvBUD7GizQZuu+L4lQ+p7AWnpSgmYnnP2XsbJyP8OPFxwmTyybQQIo6sm0mo
         XaMEcrasrl9vGkdE3YushxAk1lobs+JYHww/nGDAUwmmNvhV3fzu6LbwnExai21B8pEi
         4x+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kK39/0AlnNAWmSZQGDfJAh0mdMFi52HP98uA6cNsE+8=;
        b=t8bG4vC8TtmxXmesPbNneWGoepDU7PfhKOhHAihDlYc0WXbV+FxzV1x/sGY/CNiCpX
         rM6ZY5fm13KYBG0HtcRu0wB8p32Xz5hMBFClbmcTy0sl1TiB2cd+6y3MtYQjkFEkLdhX
         uY06ytIjDZbWT5lj4Q0eanYNTz3a/O1+UkxJ0TWA0UAwq7FsmG8fVahm9wF95MRtfKQN
         DielVgiSRJWMSAiZj/WPSICv+Z7RDI2innLOtqWP7a4utPlG8skS+Vmc0PBispP5zFeC
         6ioEG0gevsPR5MKwM57YzSyfhi5guc3OgF2+Ozf1nYXEDYW1vQQKXOTBAr62y0qHlABU
         fKDA==
X-Gm-Message-State: AOAM533OG5/0K1ik8ePRtYJ0cBYZmton6baRMmXPKBH3kgf+xn05qwX0
        aFgrl2VwiDwPkiyRJtCtgtzCuyYlvEcCylIX
X-Google-Smtp-Source: ABdhPJya3NFjZWsbaSuYNcPLg+0GB/lfUAIpGow04Z1QfhngLCJvb9eK3V1aZYBsl1R/NGUTrf8vLA==
X-Received: by 2002:a63:db16:: with SMTP id e22mr6360179pgg.577.1639538278004;
        Tue, 14 Dec 2021 19:17:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h128sm451336pfg.212.2021.12.14.19.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 19:17:57 -0800 (PST)
Message-ID: <61b95e65.1c69fb81.4307a.21a8@mx.google.com>
Date:   Tue, 14 Dec 2021 19:17:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.85
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 168 runs, 1 regressions (v5.10.85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 168 runs, 1 regressions (v5.10.85)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4f2aee6612e56c2a9a5da6131ccd80e57d5075b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b92544e2aa5bd9fc39711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b92544e2aa5bd9fc397=
120
        failing since 1 day (last pass: v5.10.81-154-gc7ee3713feb5, first f=
ail: v5.10.84-133-gf6a609e247c6) =

 =20
