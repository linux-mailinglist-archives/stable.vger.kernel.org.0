Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A1924A854
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 23:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHSVRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 17:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSVRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 17:17:08 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F66C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 14:17:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u10so9862plr.7
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 14:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l6J6anJ7pbdNfchPQQMBYcc9jK0oGiW2L/CWkueit1o=;
        b=Wcyvg2ozLbHOGrAYleSzaSprnCJuvjdXPsl+/C0cfMvZ02+lkbEFfywB6F2/UEvPpM
         TfEPXJF1zc2zIyY0fG79n6W39x2KBXY7CQP12XOhsC18lPhfeHIKuNz2k2aD8XBWKrWo
         0BKfw6TKCVDYDcKRCQEG71veS1+95apCnYpW66eYi2/cu0kUlgBrQlfK3BHB39XAQMeD
         mDZtH4NBDjKeDmxtwU3JvzaWahoyLqO7lSxO4qjGbcIOhYat5no/nI/dTI+Q+t5+qjpA
         9SDn3fziBssFRha5M89fD4BL+eZUZBr+gBXQSjrDGL/CfGjcddNFTJoYnsggfJZ+07+G
         8oeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l6J6anJ7pbdNfchPQQMBYcc9jK0oGiW2L/CWkueit1o=;
        b=AuYupASVmjoEwbgAb7npzRmq5Dx82a2sHwHFV1212Xy2w3rc2erUqrlBbUCERBm3ix
         82kWhC2ZX200846vpaJubkDWAiPZdO2d+lD8B5uKH2SaCHsAOmsRRqRH6ONibffAgBLm
         HpX4Gao+h00Ump4jcy395D4zMp1sUcM962SKfQNj21c/8qQr8XBLnJ4JgURExoTufccM
         gAg534vEiKo1hEH/FK/HefpWTkYMJMQwM5s26mONOt0BYCleBy4NZLWa8LBSBJzyGW3p
         i8Ao2jFsruufK1Kiw25zt7cKI9KQlRtxVa4lrdsm4NV7IJwhqpi6zY6wS8VTI7rArgQJ
         z8YA==
X-Gm-Message-State: AOAM533PD8aZeOYBJajii1Y+0UlPMDNwfe7UWAh1EN/sqaUZqXXzUkgc
        U5vhTEkZu2ezFkCBOCx5gbrMyZyWn+2MLw==
X-Google-Smtp-Source: ABdhPJyK5K/RxQ/EvPaYDL854msealNZVCC074bFNZAKIKY6c8upIeLiP2ma0pfoLxvXkBynP6YJQg==
X-Received: by 2002:a17:902:ff07:: with SMTP id f7mr34865plj.145.1597871827780;
        Wed, 19 Aug 2020 14:17:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12sm128770pff.110.2020.08.19.14.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 14:17:06 -0700 (PDT)
Message-ID: <5f3d96d2.1c69fb81.88835.0a9d@mx.google.com>
Date:   Wed, 19 Aug 2020 14:17:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.59-75-gbdc7345fed30
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 139 runs,
 1 regressions (v5.4.59-75-gbdc7345fed30)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 139 runs, 1 regressions (v5.4.59-75-gbdc734=
5fed30)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.59-75-gbdc7345fed30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.59-75-gbdc7345fed30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bdc7345fed30e646d8df2dbb480b9f8b801fc784 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3d5da475ecfef29ed99a39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.59-=
75-gbdc7345fed30/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.59-=
75-gbdc7345fed30/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3d5da475ecfef29ed99=
a3a
      failing since 129 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
