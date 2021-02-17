Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02131E280
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhBQWf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhBQWdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 17:33:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF26C061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:32:57 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d2so166232pjs.4
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C4UpQqEe/l/IEE7W4cA6NWsKv55mWMmxVC4jLHZnads=;
        b=muWdik3HxKxaxDGEROmb/xlN7TjXpoQBv78MXhBf0yaDJg2Ul/9IHEhGPyydjLdhsP
         VFhvNlj2w1o06JhaWXhEZ0dYiT0YpFipqqsirUvNA3G4ojKUkgQLxgCJSx1bT+nN+hAO
         h+363VraS8/oxta35E2k/02n+qNA0VNxIr5NXt9KymcrDq4KK9xfac7GAaRjp7DCSdZh
         zcYnLolcT7vN1Fbbzb2Twz4a5Dn9upi6ujSFfHSebRX7ujR5CvwJxEIyPe3NT1+LGX83
         l3EiEUzHzmRRA/3VSAc6heExd7QLu984n8FBCin5Uxxhvdg+l4XPMb3u0I5nFZ7luhW9
         HLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C4UpQqEe/l/IEE7W4cA6NWsKv55mWMmxVC4jLHZnads=;
        b=kBoyjgZZum5Zjc/8mFD09AFvcjheNPlv6BGrE8gHeWc1fCx3YKnH5nxcAom3Mtvqv1
         5+pU+Rn7Q78/2qQnmMQQKEHHwC8/p56ZrwkJP31Ib+QEQNZndGcqBrc/c0JMvy8X7ACa
         MllMCwiZ105CNZgjWNjWd/ztrae59MOoTBckBJrgEucMVD576d7X0KS43kU+aHvW7Cu7
         SC+Y0DqgvyxfRlPpoNkjOwi5xqvxQVDZ8DLr6gJIw6bsYpc1gxKXYHkmCy29Q3iX6MA5
         WWyZhaFQGFxev7jebY0Aa4KHxviDwq1/MlyrxMv11kfuIQ32rgc2CQ71OZD0D4qZrJvZ
         DaSQ==
X-Gm-Message-State: AOAM5310VqzV1CeK5u87FeXZDhA4nmF+DtHt4KXMl2WQUnqEsIX2raJQ
        oHH+h4yR8aDx5G64W7VacbCnO+svUo8feg==
X-Google-Smtp-Source: ABdhPJyUpiS2H1tb9xB+852Cqm3gXQxU1exWYRlm80ayHR663+jDwPX+Cgk1Hk80YUMwIW5JOJH/GQ==
X-Received: by 2002:a17:902:d48f:b029:de:8c5b:656 with SMTP id c15-20020a170902d48fb02900de8c5b0656mr1153221plg.51.1613601176449;
        Wed, 17 Feb 2021 14:32:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm3339268pfu.215.2021.02.17.14.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:32:56 -0800 (PST)
Message-ID: <602d9998.1c69fb81.30f7a.79eb@mx.google.com>
Date:   Wed, 17 Feb 2021 14:32:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 98 runs, 1 regressions (v4.19.176)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 98 runs, 1 regressions (v4.19.176)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.176/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      255b58a2b3af0baa0ee11507390349217b8b73b0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6027f2dc4aacce17d43abe74

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6027f2dc4aacce1=
7d43abe7b
        failing since 4 days (last pass: v4.19.174, first fail: v4.19.174-3=
9-g69312fa72410)
        2 lines

    2021-02-17 18:21:55.917000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-17 18:21:55.936000+00:00  <8>[   22.855590] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
