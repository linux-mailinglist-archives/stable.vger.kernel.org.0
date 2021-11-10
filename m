Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3820F44C2D4
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 15:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhKJOTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 09:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhKJOTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 09:19:22 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBFDC061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:16:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so1833364pjb.4
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ioPv3wiDW2NX+AWcmCevY5hRXX4Wm+rzNRLRtrgM1Dk=;
        b=aRyYFEC27wCgUn2eIAP2AaXY6jz/aIuW+RVP48T4Y9tQlT2gMZB/IjY8rHb2je7159
         x652kCOpvqmyCBnbEosfIL8dPk0wDJ2vkd9QIfnDUZXHlJDDf9AVSf9qGur9sDnAhHXY
         O+xux4q5Jz4FEV8x7j0NRkznmqWclxvIxbwlNqeozR/GlSaEWTyOJoeWcgV9O8qwkaUp
         BexYJh82FNEL1w1dFV9MRe4NeuVJPnhFe2/1Ztj4oTcb6LrQxf+J4oHBj7l690YIW5IC
         hSCTWlgY7IWh7k74X1ELxeAFmukZgQv5f7qA7HL0i81QELbgo2tSPXX1nwUXorQrxZnV
         3xZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ioPv3wiDW2NX+AWcmCevY5hRXX4Wm+rzNRLRtrgM1Dk=;
        b=x51E+zliGNIa652zrXJ1y4nhlO/ZLbvDXrRBBpmLQUwcispFF8AfnlttUBmSxBWYeM
         3o8iqB5fMcUoMOuBD+W+p1SdN6jb2AXIxvNFziyW4WQm4J/h1Y2xsRjSRcJKzcz3h1Wg
         FE1L18TvJp/w9uYi51UZQHevTqrvW/VVkBA2UEFWp0WTOhEcdAKxA4MSgy0dzmHXXbe/
         kQBSxnKMFd65SgmC3mxW/+G9wlYkpV2OoYYkQ4uBatxinzHOrCk7mavhZLN5nq6l72eg
         UI2oxNkZMDF8aJYnq5uK/I8Yg4LjgynJE6y2l3qFZoWHsAEfcWVuUXg5PA10+k3CA1CY
         OeWQ==
X-Gm-Message-State: AOAM530jaKRLZkqCOvUwq2/2zLrKm++Ci5Qr7ZfTr+zM6iAu8jcdc7mA
        jzOzDC0NBiqGRu9RUzfYGDqyGjTGZRTwhIWj
X-Google-Smtp-Source: ABdhPJzQdqX7pSGgQiIRlpyb4JIZBtUMN3F8kY/x3gT0w+tUsHVuW8KWZKZDMCceH0m4j1IU00nJCw==
X-Received: by 2002:a17:90b:1e4f:: with SMTP id pi15mr17123033pjb.181.1636553794180;
        Wed, 10 Nov 2021 06:16:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm14413812pfv.18.2021.11.10.06.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:16:33 -0800 (PST)
Message-ID: <618bd441.1c69fb81.5f506.88cb@mx.google.com>
Date:   Wed, 10 Nov 2021 06:16:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-13-gdd8f824c2f29
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 1 regressions (v4.14.254-13-gdd8f824c2f29)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 1 regressions (v4.14.254-13-gdd8f8=
24c2f29)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-13-gdd8f824c2f29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-13-gdd8f824c2f29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd8f824c2f29db994e4fc9b4cff879c266de08e0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618b9964adcb730ef93358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gdd8f824c2f29/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gdd8f824c2f29/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618b9964adcb730=
ef93358df
        failing since 0 day (last pass: v4.14.254-12-gd0fa8635586f, first f=
ail: v4.14.254-13-gf0ce35059c8b)
        2 lines

    2021-11-10T10:05:06.273130  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2021-11-10T10:05:06.281871  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
