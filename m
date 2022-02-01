Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38D84A555E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 03:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiBAC5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 21:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiBAC5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 21:57:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921E7C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 18:57:16 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d1so14201085plh.10
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 18:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=upkNmNP1ItIhcsnyLCzKIWbJaMrS8a8AOr7SWxHQbPM=;
        b=raWN5vF6QZg68Um67AoBGvFhSIauqbqMyQ3YVVC436OGmXvUYc+Qhn9n/jKs2SV3PE
         /ALF3X3PoKEwxl8VrVxx7P/e3b6ARL4bRZbCQHbHPyMykgx2hCQZLxLFpir/rtBKPMnh
         X34b1lDe/EhGC8ei3hqXz0E4+7jYPwED2E/6YiIAsXsnu08oq3gn4RW8uMNLaFXIAYxE
         iWJwyBU19D9tzs9KTPP0CT4Tjvyhw0J4YJz4A+KEPbDBy9pM3EYQv/hLrkGYZsN0wwEo
         i5NLQlJpmRtiOBi39VzyZJWokBTIUOaM95efySJ7rfsi7SwcBTBKO8TpB8MjgNmF9baR
         TG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=upkNmNP1ItIhcsnyLCzKIWbJaMrS8a8AOr7SWxHQbPM=;
        b=Rc+Er3+QXOYXLCp12pXVNsDNXCZqqk+hiZkTtQ9KJVmUgz0prK5bKqhERZKBrZ0iGA
         RIZ4TO/vihZ896vyWtsTnu2Z1gCS5kYhPGIsNup976VKLl81IQupeUoJrDX9uDIVATfu
         s7xKHgUueBOqwW7ZM0mVKAXxM9SfkGFB56+czTaFexNOEPyDLbLrlqZNH25rtf2y5pVX
         UDnxPpsnqEyUYCLNEBxy67bmVkQr3HT4KsLJsDUeP3TyjUM4SqDw8WC/KDSXhM5sCrVb
         5h0K7NJNtUKSBkAAGM3tqfAYvBTmPn+HIScAaekgcnD15YiCe06DsxeRgwX87zgIGnnl
         voHw==
X-Gm-Message-State: AOAM531H/nPmAkdeEAvjqqDzaZUmcFKJ9tEiolkgIXCbHyzqfNOGUoYa
        55YgXzfpenxhXWEWR17EQU4PQBmHT8QPYznC
X-Google-Smtp-Source: ABdhPJx7Ks+ZWqV5oKQ2VKAONeYAb8bJoWOFWq68azapEZhfTcHk/PSpJVL3IX7kiizGxelaTJEH6Q==
X-Received: by 2002:a17:902:6a83:: with SMTP id n3mr23307858plk.139.1643684235974;
        Mon, 31 Jan 2022 18:57:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15sm19961562pfi.87.2022.01.31.18.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 18:57:15 -0800 (PST)
Message-ID: <61f8a18b.1c69fb81.f72cc.564b@mx.google.com>
Date:   Mon, 31 Jan 2022 18:57:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-37-g88d20e7b4411
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 123 runs,
 1 regressions (v4.14.264-37-g88d20e7b4411)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 123 runs, 1 regressions (v4.14.264-37-g88d20=
e7b4411)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-37-g88d20e7b4411/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-37-g88d20e7b4411
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88d20e7b4411b813c55cf3285c3f95cab224375c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f867ebfbd5193e5b5d6ef2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g88d20e7b4411/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g88d20e7b4411/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f867ebfbd5193=
e5b5d6ef8
        new failure (last pass: v4.14.264-38-gda1a5053b8f1b)
        2 lines

    2022-01-31T22:51:05.010351  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-31T22:51:05.019149  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
