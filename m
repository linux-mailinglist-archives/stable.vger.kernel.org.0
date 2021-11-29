Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B0046250B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhK2Wer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbhK2WeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:34:09 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF002C0F74C5
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:08:05 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u80so18243380pfc.9
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6wBkP+7YYx90d+oh7IV1xJza8WQ7HKrCcZSs0pkJ8WY=;
        b=nskpCbJbe0fAFeAUqiwJI3UuPn4lQr9B46Ni65nyaymIBFAiCxJC8L8VSHV4CS0hiT
         gJJUjGWxk1usVPBGnmxdfZncW56wRUeU029gqgNw6ZOTTQhXtygpbzAfvB3DlfzJq79E
         w4dMw7N9dsih2AlOWlvUK9KOhaUqunTqInoUO/9hbSj1MZmdblaceYruiuROnAOL3ZEE
         M34Q5RvwMpYDJVwdZulTekViSsEQHAkFAKsXuTW2bmVihdr0+H83zIeBnIPpsbDG+zh0
         tHB0jKa35zKEpZzgMksHBBO/UAXHQADHqBlyn6Yu6vVU5xw1j4XmnnRrRvVhV1PdFASE
         iBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6wBkP+7YYx90d+oh7IV1xJza8WQ7HKrCcZSs0pkJ8WY=;
        b=0qpoSEhaFBh4srYEu2i/gpjQxI8YEMh+0dHfmxhj42RVmsL0KCLi5/w3NB9Sa6KnPW
         72kbPkvhzlLIt77332dM/nCS4pSNVZ39AeiZoWfLEuJABVriegB/CCtmD6uN9YDh1CwI
         JrrR5wFfVzT2UiSv3uP1ByLdJNxiLCdvzNxgrFcFsNx1w96Zp7pDbrhmDosM32qRTWZV
         Em9+YfFuadRpn+pwFx3Gw5S506eRQR/San46VGaOiIZGQNePUcx8Q7n5HsTgF2IGEd+2
         Y8n1NzA1ZIKVWWPYTtiMX/qQe6fikaxuFV285oCLjF6cq59AAiU5dkUKf+0s/jNKAuW5
         TENw==
X-Gm-Message-State: AOAM530V7vVECSkJ1zozKSvY8nH42XJsYtNPzVVYZ8TJlO8aK2Krg51p
        00aw80DWT5CQ8Bk02RcrRB7N62lzuY5780y7
X-Google-Smtp-Source: ABdhPJwVL1WydD+WY7ZmlIgZIfYI7iI+hwHVQaiBpZlSJhfd6Ail2Wc1VYQH8fXkjdfTKYkdAJvnWw==
X-Received: by 2002:a05:6a00:2af:b0:4a2:a6f0:8eec with SMTP id q15-20020a056a0002af00b004a2a6f08eecmr40849823pfs.23.1638220085380;
        Mon, 29 Nov 2021 13:08:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16sm13182480pgl.29.2021.11.29.13.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 13:08:05 -0800 (PST)
Message-ID: <61a54135.1c69fb81.44e33.3720@mx.google.com>
Date:   Mon, 29 Nov 2021 13:08:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-27-g7ff5d3e83f3d5
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 1 regressions (v4.9.291-27-g7ff5d3e83f3d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 1 regressions (v4.9.291-27-g7ff5d3e=
83f3d5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-27-g7ff5d3e83f3d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-27-g7ff5d3e83f3d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ff5d3e83f3d54dba8b109b12f95e3712a9c78f4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a5082b8cb92ba62918f6c8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-2=
7-g7ff5d3e83f3d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-2=
7-g7ff5d3e83f3d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a5082b8cb92ba=
62918f6ce
        failing since 4 days (last pass: v4.9.290-204-g18a1d655aad4b, first=
 fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-29T17:04:26.582153  [   20.415008] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T17:04:26.623782  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-29T17:04:26.633013  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
