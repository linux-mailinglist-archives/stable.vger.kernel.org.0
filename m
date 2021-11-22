Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073024588F6
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 06:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhKVF2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 00:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhKVF2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 00:28:22 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAD0C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 21:25:16 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so12690512pjb.1
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 21:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gTdovLg41Q3xQ78OJHUHvHFeK3v3G9Ph7+aCNUyd1Gk=;
        b=xpADAk36ARWD1uczedu+qHS7P4MIT7T0/+8iKBUzWd4Xe9eyVn1tCizlpBnUCrP1Mc
         yU6Lc/nwf9b5x1QlAPiwvkuKN9ZsDuflysoGA0Elgj/7DxbT4R1oF4hOyF6VPomSmh9Q
         PBVM+fBG9lGxBDWd6u8BLvmV8EZ3fX7rfs/dk4NCBd9U3BSfyKMleZyattyMK1emTt/4
         WATgVEJzdjQSRg0ob+3XikeuB497W2nz1qO1m0MOyFvfugXXlJ1l7DhV6x3GeYEQlf3H
         RT6kFGo58nji6rI8ZlEmNIOGMrxdMyjRsqBfQGis9ebuihYI5NHVbKiUSB1LGx6ghxW5
         t2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gTdovLg41Q3xQ78OJHUHvHFeK3v3G9Ph7+aCNUyd1Gk=;
        b=ePv42RrR+JYGOvxdb81B1s8HvT/g0EMJgdufdOfZ5/iOpPmbAbUwMWr0KAS/34TqeS
         L+Z5VKgDWWEWnjhAFJmUiWQd6B05Zk56pDZQNwjTVuQj4ABFqHnmAMF/S5yVyY5h6Kxz
         Ag/dZafFHLz6I4NkTKjlnHTQSYBlIeVoRVSPp3hFsCmL5J20de5s1VGzc960OvMbdF6K
         7rklILAzZ4A12Kf8RTHgaJ2mfkLV4Lct4+Q0FB02IpYEV2z5Ys7SpVlS/wv/np9V6XTV
         dzib4ubBwOnz1VoViFAcWJyAZaujPD7HTmElebUrj4x18nfWYU3M+AD+u43yatU/9ecg
         5i9Q==
X-Gm-Message-State: AOAM532Ix1cTUe5whvOwy/pphYJOPbqR/n1JowxW13EmTeZmN+GckgZq
        SrmtOlQ6xwodDNX4ND1raYRwcYeZLbEHIYbr
X-Google-Smtp-Source: ABdhPJwtHKy0eP2ReRSoCsfwv9xqgTX69juIXGMz5fgaxwlbLKjKqZm7gmxbnAcUyTW2Ff5Ga0EO3A==
X-Received: by 2002:a17:903:11cd:b0:143:d220:fdd8 with SMTP id q13-20020a17090311cd00b00143d220fdd8mr2006199plh.79.1637558715893;
        Sun, 21 Nov 2021 21:25:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f29sm4988119pgf.34.2021.11.21.21.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 21:25:15 -0800 (PST)
Message-ID: <619b29bb.1c69fb81.9720c.f646@mx.google.com>
Date:   Sun, 21 Nov 2021 21:25:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217-301-g59e657d57c9d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 140 runs,
 1 regressions (v4.19.217-301-g59e657d57c9d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 140 runs, 1 regressions (v4.19.217-301-g59e6=
57d57c9d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-301-g59e657d57c9d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-301-g59e657d57c9d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59e657d57c9da8f3315ad5b07c33b2d501abebac =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619af06cc5455969aae55262

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-301-g59e657d57c9d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-301-g59e657d57c9d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619af06cc545596=
9aae55268
        new failure (last pass: v4.19.217-258-g500386e5fa6f)
        2 lines

    2021-11-22T01:20:25.457660  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-22T01:20:25.467009  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-22T01:20:25.482937  <8>[   21.347991] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
