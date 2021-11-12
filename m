Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E0D44ECD2
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 19:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhKLSys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 13:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhKLSyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 13:54:47 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F82C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 10:51:57 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so7124731pjb.5
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 10:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yefJkDds9TFbjQyt5iD/X13m6u8YRXNGzA4ZXPplfLQ=;
        b=iBHC758J4LbP0lFvzDs4WpN2XxFPrbEwoBN6ApTVtLBJaOIzpsX/FoCdIXbPptYdLI
         svp2oRAYRU+ZpcjOLRpiellBO7RwDSL3WtLo8pMAc8E/m1erPw7l2ZN4dexZ5fvs/OyS
         uCEGN1jK8SMR2KPjxoUScF0px4YRauZCb6PdR3zhY0nLT57pF0LtoRJjUBkZzRyxHn3w
         6QDKopXFEdvGgfYWsAzc+LhwrcSY+f2Wx+0aFa5qwmxAd5dB2eHmg0C3/PAVaT9AnPVm
         9kI/6ftZHHbOTUxFtuls47zKUAnGwgbHQOsNCBQ0ue6wCFr43vomSj/Hc/5hrDtTCx9Q
         mKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yefJkDds9TFbjQyt5iD/X13m6u8YRXNGzA4ZXPplfLQ=;
        b=BknrcS0QppO0xp1XhJmEeUQH76hcpah6KcIIs9w3lJwGYTyuc/8L71htUA5LiXDwan
         PHa8h5A7k2OgRG8+4mmvtlJNoh9dbk2+OfazHnNfJte0ZC6Tp4ReQ5TGz5yhVTkR65Qp
         gxiuayQLCQOGFRG8D+Ghqp5OFz9220X+dUPXITq3cC+jsnyNBYtpsvQHNX6M5Oyx/n9n
         EhFktSVXdV9tr0OHOwjkiRtgi8yJcepcnEsDjjM0D3jKdCzasZLhFKZc0dMKc1c3hQHx
         OCTyygrI9X68VAtH0pZCrBGq42eVcf0JCDhigpXeKbT5/e5BSXUfsan8ZFGFCOb+fmxU
         l/fQ==
X-Gm-Message-State: AOAM532wg7Va91Eofyd0ZaEtazgCE+s0hexv+NVLvHWLDZTlaSR2Iv7T
        kG1Y5FD355K/N+qYeudVkexNeX2tBegaXows
X-Google-Smtp-Source: ABdhPJxS+nuS9LlpdQKdJQLmYBtTegUnvO4dbWgU8SY+77NYfNQqcWH93ddqp2n5/n2g4Beu0a9tvw==
X-Received: by 2002:a17:90a:df8d:: with SMTP id p13mr38072908pjv.197.1636743116449;
        Fri, 12 Nov 2021 10:51:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm9887115pjd.0.2021.11.12.10.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 10:51:55 -0800 (PST)
Message-ID: <618eb7cb.1c69fb81.afe55.c947@mx.google.com>
Date:   Fri, 12 Nov 2021 10:51:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-22-ge72515f84fc1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 107 runs,
 1 regressions (v4.14.254-22-ge72515f84fc1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 107 runs, 1 regressions (v4.14.254-22-ge7251=
5f84fc1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-22-ge72515f84fc1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-22-ge72515f84fc1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e72515f84fc1f3dcfef94b5ecffd7d6f6ba5dd76 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618e7d836d66b2e5443358e7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-22-ge72515f84fc1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-22-ge72515f84fc1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618e7d836d66b2e=
5443358ea
        failing since 2 days (last pass: v4.14.254-12-gd0fa8635586f, first =
fail: v4.14.254-13-gf0ce35059c8b)
        2 lines

    2021-11-12T14:42:56.534591  [   20.004028] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-12T14:42:56.578617  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-11-12T14:42:56.588216  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-12T14:42:56.601423  [   20.071655] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
