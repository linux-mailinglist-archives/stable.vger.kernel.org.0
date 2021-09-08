Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CCD403AE9
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhIHNrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 09:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhIHNrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 09:47:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CEBC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 06:46:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so1555516pjq.1
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 06:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1XAwJjrcox6sd/Txi2dY6Vfnn67OQYU7PmjhzIngjwc=;
        b=nmRj1w+tpXo6hwenfpPD7um72ChhmnhA3rFdci9KQaAdxJWBBRtv/gWqvTm62jQJ6/
         durdMBZZ4Smz+2ORZW+bikyKYOFhQ1HzZLz8ABxM4CGWhur+bJxx24WoEuzeax0lTK4b
         XcSa/K+NuXCBeZj9tJmhRTFIxGCEav3LaUbAO+nK9TpT21KY7TkNmwGSxAkgPbL6+Dq/
         r7zE/BLI1l9Y7UDG3zoXFaWR/p3NAwcli0ulgPK8J20UHaKQWkVGYcfxoBpDT/HUHezB
         wZTrilDgdjFMaENrFprM3GuFYuA4xJgTJwQXE0b7nEC12B6FV0TfSLjoUwjQ1L1sGRyV
         vYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1XAwJjrcox6sd/Txi2dY6Vfnn67OQYU7PmjhzIngjwc=;
        b=Iz9Mwna1oNQ6Lqpba2meABKrUhFKFYVIWKVkrhvd1wjCiHtlV1zZgdYOTKlHvsmFw7
         AMJbGS2CC6VVYGRAxWpeIkn3ZiWyrTjj5stApd1WHVIQtP/9T/1ap6pjssee6gugVMqg
         Q0z4WxInMTuiQoj5a7jTkXSs4Y2UAoW/BF9PzHPNsGhXky8cS7r5SZrFo3vgTlxQzK5A
         SGXO1HztpYNf2bgl3BDTrRh5f7fAsrqcSKESSWKssGL9cTGuBiTxc4tiiA8OYEV8wDjZ
         xMObZY1KXp2EIwFlo6IcQTgivMIJabklfOP6AnA14HsDPDk9gImoZjhv2/AeFDts04sg
         WVHQ==
X-Gm-Message-State: AOAM532mEF/eeeeSU/o/xdBQT+fzfXOXwsTk9WX03Fr+UDthhrD9GCsR
        NPt+gfVN9XqkNVzwZxxTCCsCMLqetQ9GLspu
X-Google-Smtp-Source: ABdhPJzbTH9bRWvN7giPzSaEmL4Ux4OMoNkF1guNWSDDD97XrI7/DMg/nNZQp9x8Z4kwQMNtn3TyDQ==
X-Received: by 2002:a17:902:c155:b0:138:64b2:3836 with SMTP id 21-20020a170902c15500b0013864b23836mr3139892plj.68.1631108763465;
        Wed, 08 Sep 2021 06:46:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm2390954pfj.70.2021.09.08.06.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 06:46:03 -0700 (PDT)
Message-ID: <6138be9b.1c69fb81.365b4.684a@mx.google.com>
Date:   Wed, 08 Sep 2021 06:46:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1-17-g77d60f40b9ee
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 207 runs,
 1 regressions (v5.14.1-17-g77d60f40b9ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 207 runs, 1 regressions (v5.14.1-17-g77d60f4=
0b9ee)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.1-17-g77d60f40b9ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.1-17-g77d60f40b9ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77d60f40b9eed633b25d95a5f6b755cce6dd4d3f =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61388ea6a62e443c68d5969e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
7-g77d60f40b9ee/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
7-g77d60f40b9ee/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61388ea6a62e443c68d59=
69f
        new failure (last pass: v5.14.1-14-gc097b4308d82) =

 =20
