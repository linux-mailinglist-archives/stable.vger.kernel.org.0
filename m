Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0C567723A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 21:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjAVUKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 15:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjAVUKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 15:10:47 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3D912F26
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 12:10:46 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id f3so7596989pgc.2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 12:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Fq5+jfGnEEChcFeUa6Tj8V8Fu+IhmYTBr0wY1J8L/WI=;
        b=G4wvblOKpw5HPazEXtWrV5XRcUhJCYYRbWO97DTInP2q7oTEiJtPMCQMWkBFhl5fDM
         6A+EJerjASD953NDuhNASymrKAlQuxwSAfJtJ0a7fv2nB/txsvZ4pMWmqRwtsDDGDOxR
         VMcR6aFtdqGLhQrA3uDZh6YhctenCG0dySP9mTzt1KbrQHZ93ij/arGbEp2wcQVeU2+n
         poGxpaif7q+cSO7UvaTDFLSHBbUvUB0dXbHR3mxsLQWe65R7Hgvy98ScMguwot2qhwjn
         4j2+Dd4SgAs8ZsEI9uwRC3qWwxDnVY+5F7DIJ38q3gBW/nT9kfVQDoOWBH6ZzOfJRT5i
         kgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fq5+jfGnEEChcFeUa6Tj8V8Fu+IhmYTBr0wY1J8L/WI=;
        b=1gWP9DNCVOgtNT0YYVmYeBLu0D1KoHXtoUbU2qRu9G61t/By5e8lD7Cwb2ex/g+r31
         /nuaBtZg005IcD8alw+JkFHm34JBI236zUckOQ+Y9JTFM+K3gUOUl9TnmMGkD6W/bGzb
         2K6E/lng7XrpkhWW21Q6bT4hzWZR176xfHC5fhYO5rwuHJzScpYGEd523RA++wSmc7fe
         PO6ugwh2nB8KpDOK6/kSsNS3qK0pzuj2KRr54hCeU4SXrCPFELM7FiuAoOYg30q/6P/w
         M058ozzj9s8FJjMC3kepwzNtUu/Jf29bgbM1rW/Unt08r/4n4hOStbHx/iJ9lVVA0aKH
         z1LQ==
X-Gm-Message-State: AFqh2ko55M0pCqWarK51hluYTlguOMJPQgcZNu6r0brNdjcHdGcKJQ+1
        2cwe28u7FPVEbaXjEbjBKC13eG5Smax53HWd6CQ=
X-Google-Smtp-Source: AMrXdXvga/eDSJTFYfA1NRsZZ1u8VU0xrKVyVQK/Huc6Y9JODSc3bzzqg0Es92qwIEnKIn0qsn8wXg==
X-Received: by 2002:a05:6a00:331b:b0:58b:bf9a:fa81 with SMTP id cq27-20020a056a00331b00b0058bbf9afa81mr23423786pfb.4.1674418245587;
        Sun, 22 Jan 2023 12:10:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w188-20020a6230c5000000b00581f76c1da1sm29519126pfw.191.2023.01.22.12.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 12:10:45 -0800 (PST)
Message-ID: <63cd9845.620a0220.637c7.f127@mx.google.com>
Date:   Sun, 22 Jan 2023 12:10:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.162-951-gcf1f70947a7f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 175 runs,
 1 regressions (v5.10.162-951-gcf1f70947a7f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 175 runs, 1 regressions (v5.10.162-951-gcf=
1f70947a7f)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-951-gcf1f70947a7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-951-gcf1f70947a7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf1f70947a7fd1c296cfddc8809b26caf0188df2 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63cd6323eb4dcc138b915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-951-gcf1f70947a7f/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-951-gcf1f70947a7f/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd6323eb4dcc138b915=
ecc
        failing since 24 days (last pass: v5.10.161-561-g6081b6cc6ce7, firs=
t fail: v5.10.161-575-g2bd054a0af64) =

 =20
