Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A50211366
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgGATSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGATSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 15:18:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA0CC08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 12:18:34 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e8so12196130pgc.5
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 12:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gqbyPSqo3+g3Hr1NA2qN6UQsXFSxKynB7kJdVFssM84=;
        b=frsUnwfdvDh7j9PQBObgYhcJp0dsRq0Xcd8qGCynpcjc13HKVyeOvhu/2U2fj1w2ih
         frdbQKXM0nGmI6KINCSquzW7aAWqziOtv7YJUVzoPXNp8ByLkFe4OguPRUUmrlLLvlFt
         aorfLNbagR+9oHyZou/51e/mZ/1eRiv1C4fZa7yAjlXabUjJvvVoi9iS5vwQNjYeoI/q
         Pxex/22yOpLS33d0RqbPPJqDG/jh1et4Z8E8le50ZqBG/C17xoB4jwik2zuWcQ1UFx3F
         C3Nkl1IqSEj/WmyO6p7wPViRso9C0I0P0851XH3/HBmR3drNXMl5Q2xLvax1dQrdKMX4
         3OHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gqbyPSqo3+g3Hr1NA2qN6UQsXFSxKynB7kJdVFssM84=;
        b=enBlqve3fpuGT2xjDnA+lu1yhNAgh8ZJ2BSKqaHeXq5cHcHs1zerby6TjwvVl84Mgu
         9r9uxuZUyLD7gFnpFgEAgs0a9/1wiu20warGCtOhwje2fVMVW1Xzy4+DNOgTTXTqHdrc
         ec6wYSD66H2XIk0cwvVY34hjdjH92dmOFLDq0cheXYxZl4RDSUtoKLF/rdrHRpL8Xq/d
         F7twKDMfksK/T8WyoyntkclLuKeqyIFPAOR3gGghMEx6AZqEXuFUhdIp0HcCYjWLdon9
         nBFSklY76P/SOeE/6HpM/Md5+fyf9gnqTz+wX+Vit0tP0aNTSNKemNECTxR2kp8Ev8Qv
         YQpA==
X-Gm-Message-State: AOAM5311by3OS2i5lExVoKlmE3aj+7ibaGnpIyAVpKv8Yy2w7/GjoyN+
        BnNnW9A7pRey8CqVENahCFGFI4d7cWA=
X-Google-Smtp-Source: ABdhPJw1TP2bpISH6src6TSn5VU1iSGrmr5633qtvvk520ZWvW8KgIYXjcK/SrDVyP0r5G1mP54ZDw==
X-Received: by 2002:a62:8183:: with SMTP id t125mr16052392pfd.210.1593631113734;
        Wed, 01 Jul 2020 12:18:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm5667755pjs.39.2020.07.01.12.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 12:18:32 -0700 (PDT)
Message-ID: <5efce188.1c69fb81.af838.ef69@mx.google.com>
Date:   Wed, 01 Jul 2020 12:18:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.131
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 77 runs, 1 regressions (v4.19.131)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 77 runs, 1 regressions (v4.19.131)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.131/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.131
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      399849e4654ea496a6217ba4e5ee3d304c995ab4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5efca6c29c2427dc6285bb49

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.131/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.131/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5efca6c29c2427dc=
6285bb4c
      new failure (last pass: v4.19.130)
      1 lines =20
