Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13226769E
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 01:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgIKXwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 19:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgIKXwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 19:52:17 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD892C061573
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 16:52:16 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v15so7632202pgh.6
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 16:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HrmOuOj6wHxb77dTF+61Gg/8IU4oefOyKXk+Zuxyf4I=;
        b=VbJJFg6z8v4i80CWbupzIWSnRQVMVJS26b7HAXo3XFNVVF0baOPK0Yk/BPR6uemc+1
         6+WYEbhf6zbiNwYQCL0gEDocJ3Yc7Ha1XxNiOGYWDVBFJmiNVD2PlqharNgk0azwJ9O/
         tCcTKc24aXQ50yOZb0LE/RZfRqMeLvnmKZTl1V6HPOg5DGsEE5faD5OQvzec3/SKBMa2
         JT3HzyZoSLdHN89dd9Cn2EEB49g1Hyz+HeuVeIImp53nE4I/tHzk+/R4Ltv/KQqfQxmI
         4jeLe4dzE4ktrauOzRKcIZ+IHmFEyQERw900Eq+kR8jKkrfcs7BElwF6QtImO5ppW+b5
         XARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HrmOuOj6wHxb77dTF+61Gg/8IU4oefOyKXk+Zuxyf4I=;
        b=fgNyinGxnGSZMjpiCaMRAbeAFY92nSKjtPwgh8Qau94B88jhybE4zbtHRHoGNswOw3
         qUls9YFT54vyR8T8C33GwBhaEt+Ud0H+YFxZ2+sVBih63vIfqLG7Tw9NfkWnbHOA/7FB
         KnMzZPbb+dNY6Iyr9W48Sn/OT+Lmms7Yg8yVXxZg+hadcWTjgSps98nyv5YxFtZ5wtSC
         yzHs92XIsH2+UIxhmuCQqfzIgTJmFr1X424YkI8Gm7tXTMcSNFZ43syQIWjtFjMeAWR/
         aQZJNKUxnuJEWpLdIGSdJgTr16RWwel4bAJfQvKs8nYny99VYSsaR6pGBVG064HmSPG1
         WF0g==
X-Gm-Message-State: AOAM5325p0X79uVecrO6keaFHIIPi1c12FQO5RXJGd50H66f3c0NrCfH
        2SPs9tIz0ZcTrGZYqv2R5EXky3+yRcOLcQ==
X-Google-Smtp-Source: ABdhPJz9E7TXpLhsNh56IXPyWVu9XLR3hZjjIwtm4swcO4xHmLFE9LdEr5EZyQ0lUYWjTWyujM5v3A==
X-Received: by 2002:a63:dd0f:: with SMTP id t15mr3422873pgg.123.1599868335094;
        Fri, 11 Sep 2020 16:52:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g23sm3245172pfh.133.2020.09.11.16.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 16:52:14 -0700 (PDT)
Message-ID: <5f5c0dae.1c69fb81.5fff0.8d28@mx.google.com>
Date:   Fri, 11 Sep 2020 16:52:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.144-9-gdc4669f837af
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 164 runs,
 1 regressions (v4.19.144-9-gdc4669f837af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 164 runs, 1 regressions (v4.19.144-9-gdc46=
69f837af)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.144-9-gdc4669f837af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.144-9-gdc4669f837af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc4669f837af87843c89b6eaccfe395fd83bc1df =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5bd81cddb7b4be8ba60a12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
44-9-gdc4669f837af/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
44-9-gdc4669f837af/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5bd81cddb7b4be8ba60=
a13
      failing since 53 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
