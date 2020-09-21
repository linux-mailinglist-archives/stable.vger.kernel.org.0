Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20F7273694
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 01:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgIUXUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 19:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgIUXUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 19:20:38 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15B9C061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 16:20:38 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f2so10362310pgd.3
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 16:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T/t9kVckBHAzstt8LAZ3zkfU8urqdVvbGCyDMelCll4=;
        b=ju/E/oa5t9Fx59pVrdEtncj2trMWdT0v4ImJTC+hzTq/BNjM2EJTrLzBS7xGOYD3I9
         +qdc5c0wC+8GRlEFhnjeZvV+LjckBfmvsE/GTcbaPRrqD68MThYfIO2zwJ/oqwviCqWs
         Hz1ezVFbyUzjV/UvgG34DJWvSWkTlgfO0vpro51Z9fR7sepMWiiSTdG53MCbXeh/MMgJ
         yILegIFP9aAjgrj/cDfQahAkwWYS1PAxalRnPQcqniElxVRan0MiJFeWi6YGpY/JsdyT
         aV7lhT2RHEk0I93UGMRYoN/P1HmQLc8gmNHNOMEJ4QoMbJVNwegp1YUVX+hXnIIXF7LH
         05/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T/t9kVckBHAzstt8LAZ3zkfU8urqdVvbGCyDMelCll4=;
        b=jIM9+/O9cQOeKrUfP8A70De2+XZSRsWo09rPvM/kAfm1K6OfEfDaweKsDVoNGboZky
         BQcHOhlkLYF1bPw0Br9eRDv9bdEDJcb5ZhMyEGHc8c8Or35AJgO8jUMKzHHssBiXbkFD
         TiTy09PvLNTkTI/FbOtj5x53v83rETKdMlEfYetOvLMgbEgb4TBDW+w10IbK6DF8w4cs
         Bs/y9Bdmd15HvdemXvKwWtgfLLmkyHfm8dlvNg/mY0LG33YF7Meyr+HpIVkMVpWKYdFz
         Nl5YmbhOsAV5Zuo4ZpeM5FNyTiMhrdy2aBG3NWiS1Hn/TWfapvp1fceYYvsnNhXteQGw
         OUyw==
X-Gm-Message-State: AOAM530rOwrSgf4JCue9tpW3WEA5j/xU4YIYHFvpEHyB/gFMPXZi+PWx
        AFD/BHKYwGpaf2Qa0uGG0600rF/D7fLZEg==
X-Google-Smtp-Source: ABdhPJzRZwUeMZPy23tPHmTMkg0SeZYgBxK5mtyKSV/5bNfMfRpAV7HTToRYe/dtR/1c41haXSzzKw==
X-Received: by 2002:a65:4987:: with SMTP id r7mr1394266pgs.228.1600730437661;
        Mon, 21 Sep 2020 16:20:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm13002223pfd.24.2020.09.21.16.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 16:20:36 -0700 (PDT)
Message-ID: <5f693544.1c69fb81.45a12.fd44@mx.google.com>
Date:   Mon, 21 Sep 2020 16:20:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.65-202-gd2226b45a5b9
Subject: stable-rc/queue/5.4 baseline: 123 runs,
 2 regressions (v5.4.65-202-gd2226b45a5b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 123 runs, 2 regressions (v5.4.65-202-gd2226b4=
5a5b9)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.65-202-gd2226b45a5b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.65-202-gd2226b45a5b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2226b45a5b9fc917d02fa6802523acb67821ba1 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f690206f897319ee4bf9dda

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.65-20=
2-gd2226b45a5b9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.65-20=
2-gd2226b45a5b9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f690206f897319=
ee4bf9ddf
      new failure (last pass: v5.4.65-194-g0fd0cbea115f)
      4 lines

    2020-09-21 19:41:46.994000  kern  :alert : pgd =3D 949f6073
    2020-09-21 19:41:46.995000  kern  :alert : [c224e3fc] *pgd=3D0220041e(b=
ad)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f690206f897=
319ee4bf9de0
      new failure (last pass: v5.4.65-194-g0fd0cbea115f)
      13 lines

    2020-09-21 19:41:46.997000  kern  :emerg : Process dropbear (pid: 134, =
stack limit =3D 0xb5798d48)
    2020-09-21 19:41:47.002000  kern  :emerg : Stack: (0xeafb9ef0 to 0xeafb=
a000)
    2020-09-21 19:41:47.037000  kern  :emerg : 9ee0:                       =
              eafb9f44 eafb9f00 c023e4b8 c0253af0
    2020-09-21 19:41:47.040000  kern  :emerg : 9f00: c0257ea0 c0257dd4 0000=
0000 00000004 c0d62410 00000000 c0258bd0 2d943ecc
    2020-09-21 19:41:47.041000  kern  :emerg : 9f20: ea851700 00080000 0000=
0000 ea851700 c0d04248 eafb8000 eafb9f64 eafb9f48
    2020-09-21 19:41:47.042000  kern  :emerg : 9f40: c05e6c14 c023e45c c096=
7c00 c0258b10 00000005 00080000 eafb9f94 eafb9f68
    2020-09-21 19:41:47.043000  kern  :emerg : 9f60: c05e8eb4 c05e6bc8 ea85=
1700 2d943ecc eafb9f94 00000001 b6eeaf34 b6eeaf34
    2020-09-21 19:41:47.080000  kern  :emerg : 9f80: 00000119 c0101204 eafb=
9fa4 eafb9f98 c05e8f08 c05e8e18 00000000 eafb9fa8
    2020-09-21 19:41:47.082000  kern  :emerg : 9fa0: c0101000 c05e8efc 0000=
0001 b6eeaf34 00000001 00080002 00000000 00000009
    2020-09-21 19:41:47.082000  kern  :emerg : 9fc0: 00000001 b6eeaf34 b6ee=
af34 00000119 b6eeaf3c b6ee92b4 bef3b5d8 00000000
    ... (2 line(s) more)
      =20
