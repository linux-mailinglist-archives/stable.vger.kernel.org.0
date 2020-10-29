Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB529E577
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgJ2H5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgJ2HYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:24:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287F9C0613A8
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 21:28:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y14so1274761pfp.13
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 21:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=36PBI31V4sqzsibE/vFa8kXFsCiF1HF5CZrT5NQqVRU=;
        b=KGpxwX+wkvpzB1HChrCnVqweRuCRk2FP/bx/V1ZUuJScUCVzuy97AcUh6Lyh1WpKeW
         /ZJfYISI4uxvPKk/J7yr/ULiJ/ME9ZxxfcVoADVvto9JpHGEv4YIgHS5nCzHF5xobsJ9
         IC8CaCcd+mSRhxh1eTXUjBDbPNCODqFRJ9BSJN+8va68QtUTtXkRN5BqXqfDqCgaNvIo
         tvVUS3bwlpRGK0UOdG9t6h4VTSMZ+NEjZ6FoIM6AP/5OSO/y+wEivl44PvXigNjWZ/vU
         xdV2lYKMvTN5cZjE95WWLvHn0R5ggmP4vq7f46g/1XFFlTcqs7MMKN0zA1VIhXpQdPPZ
         wHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=36PBI31V4sqzsibE/vFa8kXFsCiF1HF5CZrT5NQqVRU=;
        b=rcof9LP7sLe9lEiybbAyCk6FmyzPcOX0bjFQ+MxclpibeyHZGTBAgdXhgShQsFk56i
         pt0mFl50R4RoQv5wjrgfqkmLrvjdHhDdXOwzH9EVQfmmx1pUJVfpZMh4SJi8sKFzM1nA
         ZWgRh5FeMIdqTe5S80dK6ZjgY0fzzcmdEdfUDuj00EIo5iCKYte3OlDQuNCR/THTVJ5c
         qcqOm0oCjymi8NN2QSjHFln4syq5yToOQSTNrUzTj7ud6NFfcGb+19RdRjRmZ5cA8Mm2
         i5+1Qp8B2r6FpaO2uTJt9VWmWyfkI/eazADL6e8SMwYEKTegNtHt7OBcTP0s4tXdzrWm
         8cUA==
X-Gm-Message-State: AOAM531RuM0PgzYEqI+K+zN4KEFxFt/oJcNg4TLDKZ5UXBhlkP5jlzvJ
        6Dn8w9FE4HdUE88b1nwN+bykAeM/8ezDYQ==
X-Google-Smtp-Source: ABdhPJzTtutThZMeTlf9NzMjP6BQh2WyzRWhcmd42cD8xUjwLs3TthB/TT+jH7vZXbMZaR+KctOvmQ==
X-Received: by 2002:a17:90a:540c:: with SMTP id z12mr2279517pjh.33.1603945724352;
        Wed, 28 Oct 2020 21:28:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm1148049pfu.119.2020.10.28.21.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 21:28:43 -0700 (PDT)
Message-ID: <5f9a44fb.1c69fb81.6bbc4.400a@mx.google.com>
Date:   Wed, 28 Oct 2020 21:28:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-112-g4dcf57ce1d3e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 2 regressions (v4.4.240-112-g4dcf57ce1d3e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 2 regressions (v4.4.240-112-g4dcf57=
ce1d3e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-112-g4dcf57ce1d3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-112-g4dcf57ce1d3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4dcf57ce1d3e912bc9a4a4550a5ef4c7048e1859 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9a115de7dc64ac8238102f

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-g4dcf57ce1d3e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-g4dcf57ce1d3e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9a115de7dc64ac=
82381034
        failing since 2 days (last pass: v4.4.240-110-gdf2675c594de, first =
fail: v4.4.240-110-g42970a6d4724)
        1 lines

    2020-10-29 00:46:38.176000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-29 00:46:38.176000+00:00  (user:) is already connected
    2020-10-29 00:46:38.176000+00:00  (user:) is already connected
    2020-10-29 00:46:38.177000+00:00  (user:) is already connected
    2020-10-29 00:46:38.177000+00:00  (user:) is already connected
    2020-10-29 00:46:38.177000+00:00  (user:) is already connected
    2020-10-29 00:46:38.177000+00:00  (user:) is already connected
    2020-10-29 00:46:38.177000+00:00  (user:) is already connected
    2020-10-29 00:46:38.177000+00:00  (user:) is already connected
    2020-10-29 00:46:38.178000+00:00  (user:) is already connected =

    ... (483 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a115de7dc64a=
c82381036
        failing since 2 days (last pass: v4.4.240-110-gdf2675c594de, first =
fail: v4.4.240-110-g42970a6d4724)
        28 lines

    2020-10-29 00:48:25.315000+00:00  kern  :emerg : Stack: (0xcb999d10 to =
0xcb99a000)
    2020-10-29 00:48:25.323000+00:00  kern  :emerg : 9d00:                 =
                    bf02b8fc bf010b84 cb919210 bf02b988
    2020-10-29 00:48:25.331000+00:00  kern  :emerg : 9d20: cb919210 bf2190a=
8 00000002 cb83a010 cb919210 bf246b54 cbcc7c30 cbcc7c30
    2020-10-29 00:48:25.339000+00:00  kern  :emerg : 9d40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-10-29 00:48:25.348000+00:00  kern  :emerg : 9d60: ce228930 cbcc7c3=
0 cbc87c30 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-29 00:48:25.356000+00:00  kern  :emerg : 9d80: ffffffed bf24aff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf24b188 c04070c8
    2020-10-29 00:48:25.364000+00:00  kern  :emerg : 9da0: c09612c0 c120da3=
0 bf24aff4 00000000 00000027 c040559c c09612c0 c09612f4
    2020-10-29 00:48:25.372000+00:00  kern  :emerg : 9dc0: bf24aff4 0000000=
0 00000000 c0405744 00000000 bf24aff4 c04056b8 c0403a68
    2020-10-29 00:48:25.381000+00:00  kern  :emerg : 9de0: ce0b08a4 ce22191=
0 bf24aff4 cbcbeac0 c09dd3a8 c0404bb4 bf249b6c c095e460
    2020-10-29 00:48:25.389000+00:00  kern  :emerg : 9e00: cbcdcc80 bf24aff=
4 c095e460 cbcdcc80 bf24e000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =20
