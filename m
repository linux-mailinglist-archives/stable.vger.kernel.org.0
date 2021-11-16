Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4F4529F9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbhKPFsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbhKPFro (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:47:44 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8E8C03AA24
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 19:36:26 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id h24so14602216pjq.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 19:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FgVPUvCseq1E3wlFAKrOmp8GAZ+5Ga5LAoruWPGQawU=;
        b=O8KGP+QqGSyx6qNMyp3ljHXMFom2B7lm3oJwEAZZrdcvqCqpbPNilnRajLMYdY7i14
         8bc0h3rDjJyovfKXIyiSwbVqjZ8e3PPeGUXbAEO+ljx5Bo1bQod5EA0/RImeJziYeF8n
         ZAZJ9Uh7pKY9T4ffPX0wnN+fgBSqL2F2ohIzPUH0PShjBkwEQrY02K0D5Z03cnh+BJcz
         vE4wcVoKHftKSOsnJJiAFZGuX3085h2cEa8VzBlNrgeolIDPqj9rcEH8yyN6C3j1fWtX
         +UBC7oIX+nto62cNTXsnmlHWxozG49WwJHS269FhrsS+wkn4lSpU0ffsoq2C/3L9HlVH
         xsXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FgVPUvCseq1E3wlFAKrOmp8GAZ+5Ga5LAoruWPGQawU=;
        b=3QTRpKcKCE2jLdVvVTyHul6+Epp/Z8CSoG2cjdWlkAJxlhMgoyVy7NG0C/mjO4qRYv
         OR1nZW4q8dgQJqCTc7XFFXzctn4OaRleB34VfJn8/fVzTX76g7JsqQwYrUf5k0h+Xvhm
         LhAd1x1Wkk9WHcAmzlVD9pAv8b/FAFLkZ/mIdyqeTY8seDn93DCmrN1sSmEB0a+AXnGD
         zOPsFzfR9zepidvtyuLyG8g1/sl4RbSTr797WTjD/QTaAQiLJH5aXD3FeuYqICQ8Dik6
         5zRWbwsxGkl1H/E24NEMhyDotplLSw/dnERfnCK+bagAawx8R7kXgysQArwQLgksvjnr
         Fh2Q==
X-Gm-Message-State: AOAM5302Urp08CPVdKIYPczjYboJpSxohnN7i3qMnI+5i1HjLSFkiXMN
        p3h8nrq5XthpDJRf2I9YsF3uZ0Dgo3FnzF6U
X-Google-Smtp-Source: ABdhPJz/TGDhmzsrTeobMkyfMiqCJnMYqJBuXVF05ISuCGtxnCg1QC+N/Yw8qRMJPfCuMdf+CwH3LQ==
X-Received: by 2002:a17:902:6b47:b0:142:82e1:6cf5 with SMTP id g7-20020a1709026b4700b0014282e16cf5mr41525320plt.28.1637033785740;
        Mon, 15 Nov 2021 19:36:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe12sm680413pjb.29.2021.11.15.19.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 19:36:25 -0800 (PST)
Message-ID: <61932739.1c69fb81.11d1e.32f6@mx.google.com>
Date:   Mon, 15 Nov 2021 19:36:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-160-gfda05b2acf23
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 113 runs,
 1 regressions (v4.9.290-160-gfda05b2acf23)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 113 runs, 1 regressions (v4.9.290-160-gfda0=
5b2acf23)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290-160-gfda05b2acf23/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290-160-gfda05b2acf23
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fda05b2acf23366de13f499e369bfb9889641f6a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6192edacb1e7949b5a3358f6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-160-gfda05b2acf23/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-160-gfda05b2acf23/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6192edacb1e7949=
b5a3358f9
        new failure (last pass: v4.9.290-47-g9cf7dced83274)
        2 lines

    2021-11-15T23:30:35.100117  [   20.278442] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-15T23:30:35.135285  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-15T23:30:35.144810  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-15T23:30:35.157172  [   20.340026] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
