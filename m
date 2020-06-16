Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253B81FC142
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 23:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFPV5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 17:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgFPV5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 17:57:51 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BE6C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 14:57:50 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b5so200419pgm.8
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 14:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vljnJb8bYYX3Ob+DnEDmJEeAHLCRydExXLKlr+3wsjk=;
        b=aMv6RiBuCowxxwiZ2D8W0pG3POgR/D9Iorj1kbbzvlbTay3JUvM9iulZ80ACN7Uz8e
         Y9kt3FUW1XsSCQeCoBHN1n9dnmC/u9FqnMnp4o+ZGk2dThH8dhek3qTR/4X30VrHoG7s
         oT+zcvup97ijb9JocF5mo69QpNaATLdVviMUgnS4b9o4im2yS8SK9cR/++pw2nyF44h0
         RDFf0miuTzkY145p+/EECq4knHYPRXVwPcCRitcpogdbjb08oUYDEN0U4nlYfLE9YHTr
         ql3pZA2Q+lI6p3lg9W+wE+lfi4x4MP8k87BTnvQO4MOleb5nx/6vir2t6D6rLgJw7XzY
         riUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vljnJb8bYYX3Ob+DnEDmJEeAHLCRydExXLKlr+3wsjk=;
        b=KQUfIU2LrkTqAKRNDdhExzMIja6tgMwteOcYmB2usmBd8UiCPrXFyzit4uffUBhqO1
         pjhGtFIz9pOeLJQjHJatFkG4n7Kjwpkx/N7NSqJtPvyQIS16djJOZOM7i3V+a65gICmy
         lmQIZf0ooFVf3uXf7oOMmEK3uQBda6UqkZCgWoZ2Gx6vtLsjrGxMtoNvMzQ/xhv56s2j
         WfroGG+Yc13w4ME2ssJrN/q3W5154dfQBw6Obp8qIHokG7RzP5htQGPMDszSUt/IJY6k
         rLeQvH8ZGpYInJEmHNuRCdQ2kqhstfcwbP2V2y5uWBSCQA+Z2ZibUC8XnQF0qm2kRwkg
         jtMQ==
X-Gm-Message-State: AOAM531hhar2WLUizXfH/F6pluxZncrkvvVMp9gduSxC+C8VHgc+IO9m
        XtGkmHGeozcudzOGdIpWSClja95x2cU=
X-Google-Smtp-Source: ABdhPJxhl+WFRYgSR5O1px+jKZJt1A0HZ7CLZQpNEZtKT8cQvfnFZ7bzrOLnOQYN3qcrmAtb3opL9g==
X-Received: by 2002:a63:5d19:: with SMTP id r25mr3588544pgb.360.1592344669491;
        Tue, 16 Jun 2020 14:57:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19sm3311682pjo.57.2020.06.16.14.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 14:57:48 -0700 (PDT)
Message-ID: <5ee9405c.1c69fb81.cf22b.9b67@mx.google.com>
Date:   Tue, 16 Jun 2020 14:57:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.226-97-gbb217dde5322
Subject: stable-rc/linux-4.9.y baseline: 72 runs,
 1 regressions (v4.9.226-97-gbb217dde5322)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 72 runs, 1 regressions (v4.9.226-97-gbb217d=
de5322)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.226-97-gbb217dde5322/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.226-97-gbb217dde5322
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb217dde5322a941e9840f3902a3ef062e8a83a3 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5ee90d7376ba6bab8497bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.226=
-97-gbb217dde5322/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.226=
-97-gbb217dde5322/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee90d7376ba6bab8497b=
f0a
      new failure (last pass: v4.9.226-72-g6940a98776c9) =20
