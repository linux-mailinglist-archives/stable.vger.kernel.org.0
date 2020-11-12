Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098312AFEC9
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 06:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgKLFiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 00:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgKLEo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 23:44:56 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88893C0613D4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:44:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q10so3387066pfn.0
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uVIzIuVSB1vtD43ySz9Wk56PqHnHH2OJB4CFtgB4Iuk=;
        b=E144Y5Wk3rllUofcJajsAOAksGR7OLVDP3U4dBgOe2hoWtfsMkkarBulIQVEJbZzZ9
         s/NxOuRGD6Aq0QBcmS4bsi5BXgV+70leHsVk7cnEoTy3gvW3Xqrh4H+y/gPX1W73U8KU
         2iW/87MHt4D0BTwjjly0W5yjqUjgcdh7cuGBvDRSePH6NaWdbDT6UOB52LAi0abL2mHv
         ybzyshHB68ezhqjCkhPvWSiHrSDwDfGSTUnTKXmbeaAbqqiSj/MJMLuBngf2KF1iQfLM
         ofVpjzZgOPjdDE13ZnZYFm4Iwf4QZ6jUfimkpIl0zl1izDqh3xR2xTPnrWy+Vr5cUA6y
         8DPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uVIzIuVSB1vtD43ySz9Wk56PqHnHH2OJB4CFtgB4Iuk=;
        b=Dc+7EB6E3MqdYWmoConwZGj3L1a+TvlOh6QTm1pAb+NzlTa5timW7ovz6Xv15hdWhI
         rW4IyZqiIUowz0Vaz9Td8JTwv2qXpGHEYTrsrzBRnFXJAKohsIbhzxejFvtD8CZfZY6C
         2Buu3Sux1XkJlJvPR/VG8/Wsj2lZDz6h31Z+o7NISkwFyaH9+AQsUBC4Z6ZAtDFRqfVN
         Y7fOmPFJeu1/9V3MAal8BfvbDlYOEsUf5gHnD+6g/ujhfc2ljyEeac6jShlzFpq2rCMA
         eh8ckIXVJ3dBbjjadJhfYMCBEi/ehnCpAFzUuEhKrOUawEVqFTpUM6Fn6xSYZuopQHqS
         omTw==
X-Gm-Message-State: AOAM532u34/PS26kdAdEM0bNtgNfuuOq3k5jXxRx6Smv3Kik/rVfw1DM
        yYFD0ksLjrn9nf/MPUMTAB5Y1zr2XPLAVA==
X-Google-Smtp-Source: ABdhPJyAY6smXMSNISLZxS2JjXSDHh/sUJg6V1i9vXRMdp66lPXK+f8X9hSo/5lNq4Q+aKHDSQ1Fqw==
X-Received: by 2002:a17:90a:6042:: with SMTP id h2mr7628444pjm.77.1605156295824;
        Wed, 11 Nov 2020 20:44:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm4477486pfp.1.2020.11.11.20.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:44:55 -0800 (PST)
Message-ID: <5facbdc7.1c69fb81.cb944.a1f0@mx.google.com>
Date:   Wed, 11 Nov 2020 20:44:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.243-17-g9c24315b745a0
Subject: stable-rc/linux-4.9.y baseline: 137 runs,
 1 regressions (v4.9.243-17-g9c24315b745a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 137 runs, 1 regressions (v4.9.243-17-g9c243=
15b745a0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.243-17-g9c24315b745a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.243-17-g9c24315b745a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c24315b745a0864977865b7cc1353d382573574 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fac8c12dc7f61580cdb886b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-17-g9c24315b745a0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-17-g9c24315b745a0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fac8c12dc7f615=
80cdb8870
        new failure (last pass: v4.9.243)
        2 lines =

 =20
