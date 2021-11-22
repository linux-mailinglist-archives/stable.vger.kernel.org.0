Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F17458B41
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 10:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhKVJ2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 04:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhKVJ2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 04:28:20 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F9AC061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 01:25:13 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so15502918pfe.7
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 01:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kdDXNaQVBDW+lEawPKuop3dXiBjUW+MDVbKr5TD4g/M=;
        b=38IjtOfkxNJAlsdp2X3ubyv1riVWsyQm4eEZPbTeMG4N/iVZg7lS0cDx6qLIMFv/iI
         7ie4PO6iHYprAb+fPYKWqkVuUtoslVYvmvVZtCaB8zDgIRD/gYvi0HELUN8buLss4YWa
         6oNyVj5rdp2QA8nMP53kAeb5Dg9oYygBivWdSwyFXrp/ZJLzrHNgZDc+73Y5NYhkiHFd
         Y9NDpi9jUy+ZmcaWrJ/yMhUYq1CIyq31LABIsXgrbVzRhfaDInfNeLNp7H/U5toIx/Mi
         MmCEYTW1aPnfuTtDYYvPirIIsSjVAmPCg66lBbyOewK7XHeLmFTn8NG6pFG+WyP7Rv9o
         JdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kdDXNaQVBDW+lEawPKuop3dXiBjUW+MDVbKr5TD4g/M=;
        b=B00KXyXhNTmH7SG6ElD4ynR+Q39zpxBiYTjM/KmlwGnP1oy74MwSH2SJBNVbpXcONr
         +MvDq+MAFlNvDWKF79lwvGPdYJBP2y/phZJuRqSZc7gEydHgK/X8SbBKJ0ILWcLEyyMN
         8jcbmLOI4DxpZtMV4dRqCJvN9mnutHJK/lEAQN0nk+AI0ysE0WQtWqfBPYr9ObFl0hG8
         GTZw31kcNVrLsCICHzlF8tWHb/07u4XcY9WzphCm68rLgyw87B2sdcvQah0BhCr/KpvC
         GCTZDKhpkvdyNmCELgHGZLCEaIwjfgnTv0FB/6w7RS/nk1X2pEHPGxD797M/8bB5bFXJ
         1Quw==
X-Gm-Message-State: AOAM531YbU/VSnkbaTNusqCFZLLSe42KB0qTZrAIjTgTJwIVs2UZ6gmc
        j+P5Q9TBrd6eCAotpVNFJvY1NI66vD8fz0fT
X-Google-Smtp-Source: ABdhPJxYLRp2/fZYMByHQnXKgmoNbuGVYvJsPsB+xql0CBsFcRYrKnP+m0ujgE7SDZyIvsMYazR7eQ==
X-Received: by 2002:a65:40c3:: with SMTP id u3mr32821052pgp.160.1637573113155;
        Mon, 22 Nov 2021 01:25:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p21sm8270585pfh.43.2021.11.22.01.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 01:25:12 -0800 (PST)
Message-ID: <619b61f8.1c69fb81.7e7f0.7fb2@mx.google.com>
Date:   Mon, 22 Nov 2021 01:25:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.292-140-ga310aae52ea5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 59 runs,
 1 regressions (v4.4.292-140-ga310aae52ea5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 59 runs, 1 regressions (v4.4.292-140-ga310aae=
52ea5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-140-ga310aae52ea5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-140-ga310aae52ea5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a310aae52ea527065c5f882b6c08d30f9a589820 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619b29131a26aa1db5e551ec

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
40-ga310aae52ea5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
40-ga310aae52ea5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619b29131a26aa1=
db5e551f2
        failing since 0 day (last pass: v4.4.292-116-gc13aef2ca259, first f=
ail: v4.4.292-140-g1794f2b1b0d51)
        2 lines

    2021-11-22T05:22:07.448944  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-11-22T05:22:07.458149  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
