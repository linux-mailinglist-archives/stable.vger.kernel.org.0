Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E264144214F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 21:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKAUGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 16:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhKAUGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 16:06:41 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1969C061764
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 13:04:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y4so3016509pfa.5
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 13:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UG9gXimKyHeRyqNpJD5hlsYeiCld8sO2bkIPhBFmQrI=;
        b=TdxBCS5FnJsnJ6zVLF6fktUSEpEjcHyO8FbiVkq57TKADkbqLSukBF8IqcYkYmUdhm
         ekF7UJZp70OGSw9GbCGSlCuvDZlSbna36vkA3HcrCHy512K2DaDUzQGfMAGsaTsw36+N
         la4LCglaCmZaeN4DgyqFFqiog1ht5DJnNuvWIB9dXZSuvRRdL7KwhfuAru2FtJfukrps
         aBIVoh3+WdZcho2P+mvTzWn0cEZfZrmUj0hrlRgvp2rGHz7p0I5KNdoZEJpxdxH20bPq
         iz07s4ibdtQNdZmxQTIWehLFqbcGOZ/VZXNTtyIRhLzzuWrelpYtAcZ4DovoXWDUlb8j
         nKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UG9gXimKyHeRyqNpJD5hlsYeiCld8sO2bkIPhBFmQrI=;
        b=qvxarRPo2LTq7rZLd6xvDDVUNiaxcqq4dirkzeRVTmnYsgpARY18Mc6IkeFutrnrbJ
         sHTzViyQbHXxroS6v6ZGO1PG6blHkT+qvqeoAqju84kdGvglEgKzCWxy8BWf7UvqLp0E
         OVcCTWJYZMeyGTm5Ar+0Ws5cE60jEBreCnddfxCPn1Ja/Mti2NYYJRxnEvTw+RXOvEQk
         Vnsf7GKAht8OB6172XDtuM+9AXwXDPVf03oqH58vd+h62P4fMB9Wx/TbtOhZ3Xx8c1vc
         tEVWt++x4stNgkrpDAwb+9c1ic6vJZxgubCKEJdmO/+i1vWrGZ554RWUdfnRZcnHn+QJ
         Mfag==
X-Gm-Message-State: AOAM5307+mX5MqUPyPqEocnLC3tkDgrP1cG3p4TeSVupyNRQk6+34nls
        E/OT4oHmCZHyl7KSWdGaVeUy01D2UsMddLSi
X-Google-Smtp-Source: ABdhPJzJcI4V4q03+OE47z60KSED/Lbc0AmKi6V4gvBZgzEocvhytib2c9jYmFyFip9Fl38CaeWEdQ==
X-Received: by 2002:a63:be01:: with SMTP id l1mr23753139pgf.445.1635797046936;
        Mon, 01 Nov 2021 13:04:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 79sm5089170pfy.128.2021.11.01.13.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 13:04:06 -0700 (PDT)
Message-ID: <61804836.1c69fb81.9c06d.e037@mx.google.com>
Date:   Mon, 01 Nov 2021 13:04:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.290-18-gd0c0f8a764f8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 102 runs,
 1 regressions (v4.4.290-18-gd0c0f8a764f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 102 runs, 1 regressions (v4.4.290-18-gd0c0f=
8a764f8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.290-18-gd0c0f8a764f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.290-18-gd0c0f8a764f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0c0f8a764f8c71b396535e71f1d3bd792f4b34d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618013e0817845b5cb335919

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.290=
-18-gd0c0f8a764f8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.290=
-18-gd0c0f8a764f8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618013e0817845b=
5cb33591c
        new failure (last pass: v4.4.290)
        2 lines

    2021-11-01T16:20:29.913279  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-11-01T16:20:29.922592  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-01T16:20:29.937800  [   19.449493] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
