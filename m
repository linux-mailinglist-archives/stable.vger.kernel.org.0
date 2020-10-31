Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249C82A1892
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 16:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgJaP3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 11:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgJaP3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 11:29:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FD9C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 08:29:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lt2so903089pjb.2
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 08:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9W1DCCS8DMeS/n2s7Knpxq0F9ZPUaq4z/oH8w0v140c=;
        b=HGPX/IbFb1CjzZtxUUQjNvm6DxD/JTPT4Y+7/O1k1/V1lUprEMZge0sYpPPFf43BYA
         yzc7N48HNl6ZXk84D5I2UehB5KeZVtqmlOkFIqEw2dwgkh59xmz7CH1mvz9hS3ad651q
         5L0QKzUvG/WRcEC4TSFNW+HTbZ5dLYWb28F1paf2wXenpMacU9+K6+BvpWCGMI1X/py6
         hauyYIQz67SUwuBKh76zvQkTKtCKlnr1MvNKUYWPAHal2fEAQB6/LADyofLFyoiDmdaC
         925TntjVOr0LvRY74sp0eNANt4Znpnp7NsJCDtxBU7YZ6/sTgDWs4Kh8+0AcA+5q/Sqj
         ukXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9W1DCCS8DMeS/n2s7Knpxq0F9ZPUaq4z/oH8w0v140c=;
        b=pN4JRmIanm7zNIynSEwIxYx9bjOjqjkSsGYXwv5lcmGY/xqhEhXAi/bsu4uepkx7gA
         nW+U5tmt6lYiwd5Y20a6llYDrP+7IFNIDks4OMrP2ZdWAUl0dqQfanotdJarkWgBhsMS
         JDv8kU52Hd4d18+BNFnJvqnoD26teYdT5+I0ANd6CP+TJlAFuluzV1nrktBxQCCRhLG1
         IN+wdEPxuaR1BhG61BvvCrrh6G36GSdGW/J6Q40W3RWm7PDCgucgTZlyTgpyZI+y7tEu
         oF44noaMgrc1gpvacQv4bwCElwRpyOzIgFmEBSSONeeYoy5NKCUXG7TaQYktpCW8/2pB
         qxIA==
X-Gm-Message-State: AOAM530fyMung3hxqBf+kYGBHyFAqtwRxuhDvAy+Hal+a1Wa7nRJ1tLv
        +9Z/nTU7FjaxkIrvCawOK4ZnJjj40l5dNA==
X-Google-Smtp-Source: ABdhPJwK0QfHeEfTCUKSpae7nCQvfk6wcYcRUnQvCHf18pB9J9CeiJHYb5q6yGEJ9gmys3VCAtu0vA==
X-Received: by 2002:a17:90a:db48:: with SMTP id u8mr8381427pjx.93.1604158191117;
        Sat, 31 Oct 2020 08:29:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z26sm9156120pfr.84.2020.10.31.08.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 08:29:50 -0700 (PDT)
Message-ID: <5f9d82ee.1c69fb81.87698.63be@mx.google.com>
Date:   Sat, 31 Oct 2020 08:29:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-29-gda3372b12107
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 157 runs,
 1 regressions (v4.19.154-29-gda3372b12107)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 157 runs, 1 regressions (v4.19.154-29-gda3=
372b12107)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.154-29-gda3372b12107/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.154-29-gda3372b12107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da3372b12107ae7134dcbd8de82542974270f340 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d5124047190f1763fe7d5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54-29-gda3372b12107/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54-29-gda3372b12107/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d5124047190f=
1763fe7dc
        failing since 0 day (last pass: v4.19.153, first fail: v4.19.154)
        2 lines

    2020-10-31 11:57:19.519000+00:00  <6>[   22.638610] [drm] Cannot find a=
ny crtc or sizes
    2020-10-31 11:57:19.559000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/100
    2020-10-31 11:57:19.569000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
