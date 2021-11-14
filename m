Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4393D44F626
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 02:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhKNBiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 20:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbhKNBiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 20:38:14 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7DAC061714
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 17:35:22 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id g19so11707635pfb.8
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 17:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mPQbuQl7gLksqq+Mkm+9qHNfjehnqEqNJnscsoNOfjs=;
        b=hy8LAh0eue4ieUrgz3EiwnJ9vB1QOymWendLWTWlPl1N/UoavvJTffwKwvyoFCYh3l
         AeduFItk1NYsILAKmrYQ5kkjmbBbm+0iosHPRPL8k9v72u+EN2hel8SDPsbOhn5p7eel
         kr3ghUBivlSpYqSUxiY6SKCq8enIyn0xq6jw1qcK7y+J1+uogr5Q1AXwqdSJsmmHpPIi
         pGr50MOXHJM9G9ggbZSb0q2vhUXkWQhm+RZ0wYrE+KN6zfr4y6WfCewTjJW4kfIq3xwW
         1x3Wo3ya+m4uHfOzaofBnlZ97omOlHYOfuATJHKgmuWxhhMsQMN9JKfkbA2uEcLHE4Du
         IwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mPQbuQl7gLksqq+Mkm+9qHNfjehnqEqNJnscsoNOfjs=;
        b=ee+EEAZVqoDSWB18wLlg8dxBXb8IEcG1/8IFMEuXhasDf7cBbrYkO99VU6XQ7APWw4
         /DQzvKhGsC41H+kFlc2bVp8QcINrdSV9h4oBdfhKxTwNm6Q+IYwjMIZOhn46Ti0ezwwJ
         3z1uuuh2LRJV5Q8zh6YTDCKd5HcAoceV1ZcBs7FBKYcVjAalzfZ1bc0aYipFTqY7Rtug
         /J6ZPqCXoUIBf7BwXq7SEsENBYXE0w1JkFp7STq4VKlmeY4foIfriWGi7XRQVuqQRvay
         /R9L7/MlzqStpX+SxYfcn89vPgJ+355r2P2DbRaVWqfubWVMfpTTxIJx1y9y4yE3AP6w
         cWog==
X-Gm-Message-State: AOAM533akP73RFoU3WesEvzzs7SeNUFEKZjIdTc5DVL0G0q4/YIRrpgg
        BLe7h2watiwa1JHq/JWSjcPxZV9vqqB+/Z2X
X-Google-Smtp-Source: ABdhPJzEnL6Ks9NNutlOY4DYGwd2dgKk7aw+I6U6Kr54pf5J+laxI727Tvfnw6MabM/uw8vdXlaVmQ==
X-Received: by 2002:a63:2049:: with SMTP id r9mr1767623pgm.413.1636853721495;
        Sat, 13 Nov 2021 17:35:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o185sm10630627pfg.113.2021.11.13.17.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 17:35:21 -0800 (PST)
Message-ID: <619067d9.1c69fb81.10323.e74e@mx.google.com>
Date:   Sat, 13 Nov 2021 17:35:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-154-g052582294decc
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 205 runs,
 1 regressions (v5.14.18-154-g052582294decc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 205 runs, 1 regressions (v5.14.18-154-g052=
582294decc)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.18-154-g052582294decc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.18-154-g052582294decc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      052582294deccebf22a0e76ad2bdaa9dc1f3e61e =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61902f7c6a17cb175b3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
8-154-g052582294decc/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-k=
ukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
8-154-g052582294decc/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-k=
ukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61902f7c6a17cb175b335=
8e7
        new failure (last pass: v5.14.18) =

 =20
