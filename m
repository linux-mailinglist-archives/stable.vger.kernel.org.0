Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E316C26CB2A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgIPUXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgIPR2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:28:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373B0C0698D8
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 04:46:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fa1so1468884pjb.0
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 04:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QaAlyxPmgwzV6ZkozSHtI0JrE79TjYJmNCTl6P2UFt4=;
        b=ltQkvMjgK8l+53VJ+NS62ZL8eTLEqi1xKRvqBJyWwRWEFfcsXaviTnuHUm3JGnxuHL
         nb5qDjhwVWFht4gfYa6HM8tL9vrZ/vK63I489QB8l7G8MqqWhzyfwl5tYQZSIRh5QBkq
         YPE9UFJcWYoqDj2ID9cFwr6EPa80WUcE0IWKV5g1TvQ8RCAV2okif3FGU371A2uGzfBZ
         X1oMd6N3gSCgssS7eHwQB7M7TL3hfXz/KUSlmk0po8G4IQ+cqC4bsomRs1NhDPGlOGjc
         2FA9vj5urfKuTTLo6fCDyarGrouStNfcgzw/GOahUikQaoe27orV5S59Y/DpCpW7XeH7
         bOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QaAlyxPmgwzV6ZkozSHtI0JrE79TjYJmNCTl6P2UFt4=;
        b=Isueu97yn/Hq5pQBuzT3KGledmalrR9bo5BarQnLI3159ybWtnuLiswSk/rAyOQis1
         /7Tr7/V7WoPyghhYtBW9V2Dl3z6A6xGeNqyqlGaTy7F3Gh83ragJw8kKh0MUVydLcfur
         sV5mmhSKsZhP6hGmxwaJBD3w7ooG+7Ib9EUOvCqzYoK5IyPNqfhAD+h4EPLx0iFsGu+J
         6ZMkNebXb9CLswHlc5A4AsPqLB1WOF2DKNeYC3Q3TQ/EKwhZRtnJYV4aYIzvXHS2y1E/
         lJZF9bnQ78DlMpZJBkrWB3Hd1tHZ+Cb6WiRuaUPKIk5nO+ULRISmkRh7X/ZHem/8EIhR
         zflA==
X-Gm-Message-State: AOAM531mAmTawFOC/doeI39f43uPwYm1GTGM/q8v0TixBgv7xaGQuZXB
        cbjV1v6ptPx2vmx8gb6CQeRn/meswz955g==
X-Google-Smtp-Source: ABdhPJzVQABEv8dRG9bv+tjSPsOkKr6YVUKCBsp3XtQsytyr3g+b3H+H5NIVtqpfxsL4X2HrdVXqDQ==
X-Received: by 2002:a17:902:6ac2:b029:d1:e5e7:be59 with SMTP id i2-20020a1709026ac2b02900d1e5e7be59mr6066727plt.51.1600256764254;
        Wed, 16 Sep 2020 04:46:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm13913970pgf.32.2020.09.16.04.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 04:46:03 -0700 (PDT)
Message-ID: <5f61fafb.1c69fb81.26603.3127@mx.google.com>
Date:   Wed, 16 Sep 2020 04:46:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.65-131-g0d8c7a7aec77
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 117 runs,
 1 regressions (v5.4.65-131-g0d8c7a7aec77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 117 runs, 1 regressions (v5.4.65-131-g0d8c7=
a7aec77)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.65-131-g0d8c7a7aec77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.65-131-g0d8c7a7aec77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d8c7a7aec7700b34810ac8d10a2d43df7810052 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f61c843c85591f1bcbed954

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.65-=
131-g0d8c7a7aec77/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.65-=
131-g0d8c7a7aec77/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f61c843c85591f1bcbed=
955
      failing since 157 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
