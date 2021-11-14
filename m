Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1544F9DA
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 18:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhKNSBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 13:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhKNSBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 13:01:38 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE97C061767
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 09:58:42 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q126so12579361pgq.13
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 09:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pegMfS0KHo1/McUC9OZARNuuOhSzwcC9BICw5JE9H1U=;
        b=2Ktgsnv4ZyhutOTwcnU2SPL+41/0Z3+ArCHre9Q+uffOyaT/AJYGVabvCk9YzjhLwN
         L+bLDKTQdtisuU/3j/vhgl9VV59/d1Ak+I76ZcK48uZZQ6tDXQ/GO+UcLj44RN1HfVJy
         CnS6ZEc6Ub/xBl4+f5UYXypNi2yTlmSUJs3pzM6qi+J0rAOgrpDGrHFy7Y1HB/9NH/sq
         UPPPRYCi0X5WVeZpvWUtP71olOBzNoHXuJF6USezxHhdPg5pUFloXGWlDJj1R9HAIsYW
         Sc4lQVzNzTwjTChkf9IQLORz/MGGF5CzsuGYEEdk6zsQUWYkoXWfBjzgmySvWP7lwGe7
         Eh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pegMfS0KHo1/McUC9OZARNuuOhSzwcC9BICw5JE9H1U=;
        b=vc9dHYhvhw25aBR0luKkOTlDtLEsQmQxAjruxaaK/Oxz3f+ZDIbnVlLU7hPg21UZ1l
         OllEEC36hQ5tlp1TS6maWd4sUymqn42ariPw0UAAkP/ML6PnJ3jzbgh04GfI823OQ1fD
         3EO7B/7sQfKU3axk+gA3TqL6ti8Wn5rvZ2zqA7WfaVGCWrPneUOIATTGSUlPr7hlnKYu
         V8buGc/djWR4kFS//ikH9v2Qr0aUnTfwvPo+qvnkYgIUtSY1StcdgJIIUqMRqLIMHFtX
         BMvoI6105ukr3mVy8qtjjFYuMLc1n88U+37i5q5trLMUs8BURId7cc/OM5MVVvWlVVJw
         Nosg==
X-Gm-Message-State: AOAM533UHp5Gijur1KarS768FaRxKhJ0yRrC5sIMvStj0cQpjkzhs4ao
        sYOQtDEq0TX5NwCb4vaiGl+ULHsI6RufPWUx
X-Google-Smtp-Source: ABdhPJwXXtw5KbqEKgqoBGlWgOjephDMKceHnB5zBqayOJkSIENpUrZ5n0pq0NhQr0bXjdD44e01MQ==
X-Received: by 2002:a05:6a00:1ac9:b0:49f:b38d:fe7 with SMTP id f9-20020a056a001ac900b0049fb38d0fe7mr27889244pfv.63.1636912721583;
        Sun, 14 Nov 2021 09:58:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm10556176pjk.41.2021.11.14.09.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 09:58:41 -0800 (PST)
Message-ID: <61914e51.1c69fb81.1872c.ecf4@mx.google.com>
Date:   Sun, 14 Nov 2021 09:58:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-56-ga964f8b74c43
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 158 runs,
 1 regressions (v4.14.255-56-ga964f8b74c43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 158 runs, 1 regressions (v4.14.255-56-ga964f=
8b74c43)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-56-ga964f8b74c43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-56-ga964f8b74c43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a964f8b74c437637637813dcd4fe6f8d7813ec1f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61911717dcd871716c335913

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-56-ga964f8b74c43/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-56-ga964f8b74c43/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61911717dcd8717=
16c335916
        failing since 0 day (last pass: v4.14.255-31-g6c7702079927, first f=
ail: v4.14.255-53-g91947c5ae67c1)
        2 lines

    2021-11-14T14:02:42.944507  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-14T14:02:42.953966  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
