Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C448245004A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 09:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhKOIzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 03:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhKOIzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 03:55:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB6CC061746
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 00:52:02 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p17so13971184pgj.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 00:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9/Mm0JeAYa70rwgwTp4v6nyZTD1aWk3l+T8G9cHlOfw=;
        b=dD7IVyHfSeNkrSpcbTa0uOlnDPTqYVt4qqjCSHDEtBaQfWsTLqmZrD6c4rKj1XWPlA
         GGTgEd345WEvpnFF0HPwoIqcThTLEcexQGfJgF69gr+h/+2o/9PleMYS6dZZsUFf0eIM
         SoYICbUvd8/SI64rUD9tRhejim42LuoHuJgYAvsI7MbCx1jMNbaQQR0BKRmIcK8uqrgq
         wnmm4uaR9id9sj04+N41/OYDSQUjD6TpfmcQNx0UfdR3+sNWIMjvjmYlaRBWj4DC+H7M
         eMs+H9DfrJJ5jj/kWSC2Bw8YCIYqi2mN7KVZaHu11jwKxLCVl6wwEGF5QlyGX7R03leF
         HwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9/Mm0JeAYa70rwgwTp4v6nyZTD1aWk3l+T8G9cHlOfw=;
        b=youjGYlYKiD3mwIAg/013oTXqnnzF8FZoelnGoa9fu+FFezWo8lPm8obbvw5COv5PY
         595QffiPfkLPaTDfpoKIMRr35amA9eS17pLArrhJ3lCe1jtkPxWwgjJsNhY8QVSOLshD
         iYjU/Pi/mrlrrzwI0qGC+7mwP/trvJnNufPuK34ERKnDQgucmnUNomjb+aOGeYhjRiNb
         nxc/Nc6oinhVM7DoTDFWKxxgcJwKIUkPhK40jHGdM6sYSeu4oLsc4H2Ge9HzNx4YPocY
         RTM48YGYENnqKf6yxR+qqPRcaC+29tj6MRYi4c2gv/zAhs0dPDuP0jzHL2uZT0pnOvPb
         QbSQ==
X-Gm-Message-State: AOAM532JVP/gZhl+VEENFBxRCI32cCfcg74sjdKKRChQJPclc9wQZd9S
        pKcJTPmxjIUBaYp9IgtmhKP9vo1d4m6x7uP0
X-Google-Smtp-Source: ABdhPJxa8HrzMfQZWbTAHxtCPCUPpd8S2qyX1Ut4gnZCxER2CYe0EMNyupESFOK1byf69afjEY0CdQ==
X-Received: by 2002:a63:83c2:: with SMTP id h185mr23368833pge.146.1636966321875;
        Mon, 15 Nov 2021 00:52:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm14587834pfi.174.2021.11.15.00.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 00:52:01 -0800 (PST)
Message-ID: <61921fb1.1c69fb81.7dd0d.a31f@mx.google.com>
Date:   Mon, 15 Nov 2021 00:52:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-153-g690c63d8995e7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 1 regressions (v4.9.290-153-g690c63d8995e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 1 regressions (v4.9.290-153-g690c63=
d8995e7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-153-g690c63d8995e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-153-g690c63d8995e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      690c63d8995e713d19450cbe68c8c200ddc9dbdd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6191e8b32f5cbc35cd3358e1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
53-g690c63d8995e7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
53-g690c63d8995e7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6191e8b32f5cbc3=
5cd3358e4
        new failure (last pass: v4.9.290-56-g5c0fdc0dbedd)
        2 lines

    2021-11-15T04:57:03.575950  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-15T04:57:03.585587  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
