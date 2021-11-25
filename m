Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448F645E13A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 20:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbhKYUCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350481AbhKYUAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:00:50 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47059C0613FF
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 11:57:28 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n26so6816032pff.3
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 11:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lfUJ8pEQRP3dQIOemDEYoXqWbDpPjYHlblNGy2C0eTg=;
        b=eviXhm4TcvqstGm8puRv5ObzGqXnDgu2ToEKfc+mJ1OeReVoujKMXh7a5GZmEyP9Cx
         ohmiC9ANwi5HphFtxCYt4Y93AG7yy5CNIM5ksvUBsUuMdlWw/WniE3bmzUVUbsRD+xIw
         8rPmEQhdQD2Xqx7BmrqQNyiSwDbUfNCZzzUy0K9mbE7m8gjqZUm2WPDsnjQAv9hlNzeI
         WpC5gt4jREPiG0Nq/7PujtDrVs2U2eAUW0r+SdPH+/8nRRiMl5lw6gw1ym+4/tMI7CRP
         Dx4N8xZSHYSqeQuVgEOysbx3j1whx+LJZqocucUg43wYfQS6XNAj8GbB2r4Pfjv752/C
         FfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lfUJ8pEQRP3dQIOemDEYoXqWbDpPjYHlblNGy2C0eTg=;
        b=GCCTD9DfmzQ/vGJa8MR0WPkygQd4y4gdkf+4mND1CHU6rQVlh/eVE4SUiV1S09V4TE
         96SO/L/Ez4ETm8hno6ZRe7Wz6k/dGZSOICK9s9p+sTYtxTzOG+9VK5/cPOdxl1TrV5tG
         uXg/ZHOmBylNwZM3Ei8lGaKWa9Je3x5KkWPWMlUcmN2yo5v1dzNDRbFuYsBNkhViaLu3
         ce83Vq9U8f1tdquSE92rmCZFTNVHtbYaz5VV6mp0uX1SJV3mbHruQs5AjVYGMqejYyvO
         nca0BrHCd18iaV4ewUndHOqwC0nV2ThC98qPe8yiMRoY7KMF6Yq3fToIM3x09sWuhtdX
         X2zw==
X-Gm-Message-State: AOAM530LaUnE4krE7o4MX+sCs6laaKeqy+y1KQJm0f3LuNmWg8RnUxpG
        LwMO2lA8DSdqq3+sQNQThF0yHP23UCjL4cjVlLQ=
X-Google-Smtp-Source: ABdhPJzmTUPpP60lkqlB3R13dx2mOTIwRjiF7TpH3VYvcG6g9Ux8U4BGucdrjULKf0t+Gu8SEITj9A==
X-Received: by 2002:a63:894a:: with SMTP id v71mr17776990pgd.421.1637870247686;
        Thu, 25 Nov 2021 11:57:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5sm8175993pjt.15.2021.11.25.11.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 11:57:27 -0800 (PST)
Message-ID: <619feaa7.1c69fb81.b1b4c.449a@mx.google.com>
Date:   Thu, 25 Nov 2021 11:57:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-gb44af49c4a12
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 1 regressions (v4.4.292-160-gb44af49c4a12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 1 regressions (v4.4.292-160-gb44af4=
9c4a12)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-160-gb44af49c4a12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-160-gb44af49c4a12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b44af49c4a12ced75fcff7be0cd2ac0255ac3f91 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fb317656ea04b2bf2efb3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-gb44af49c4a12/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-gb44af49c4a12/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fb317656ea04=
b2bf2efb6
        failing since 0 day (last pass: v4.4.292-160-geb7fba21283a, first f=
ail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-25T16:00:01.200915  [   19.177124] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T16:00:01.251356  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-11-25T16:00:01.261150  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
