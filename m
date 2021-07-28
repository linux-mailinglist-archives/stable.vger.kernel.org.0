Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EA43D89FD
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 10:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhG1IuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 04:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhG1IuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 04:50:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9F5C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 01:50:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mt6so4132582pjb.1
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 01:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=07BNKi3G11QmaDL+jPHpA4jynnqCiz023GGrB7d3+A4=;
        b=BZVsoTIS4wLom4GBydy6ohULvKqijGfQEBYLQFD4D55sHWDfFPheQ9TZqdhe+IgokL
         EKtTdcG5cKpSjwYJzm8xjInYvrvdkM41bg3W98y87pVXlGWDuOgMloOb0lueFAsIQdd0
         oK4PxLb/6AOZ4ySa3M61uG6SWAt/0cPfRiaDyqTYL4eJkZzy8OmH0RS6VO6tw46KzqiH
         R+X6j5DwnB6lowwxNswYSYN1Ks4IPfYJQOn5U1AC2ZExTB6edhBzASCWuDPsrg5Y6IWd
         TaCP2UIAGPCEkHknX4JUjD92Y6AYTvaZbsDazTQ11K4eiUqenU7R4qWW1TqRj7Q827BL
         4VHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=07BNKi3G11QmaDL+jPHpA4jynnqCiz023GGrB7d3+A4=;
        b=fVEJ4lBEOuZag5j/LqXfxv1agnJaw0zkPtjwKaZ0rWBWEnkP6CDayVmVn4TQZqcUmB
         xF++GQYafRMhWWhIjgynKEOfgCEJBnDvK3enYdMxQa8ejLpS0Ge1tz8/jn1guZGIIsp+
         6V2NaSz+ehmHysQv79I4AT9nXUdLiuUMegYy8QdStrfT+Dk6QAvpj9f7luF0dknTZicR
         ZWnAP0jidDqD10AKMev4E8OanByTm7HAl2LyXwBNXI5xyfE5QryPFmscn6HTvndsN9FA
         R2jrLZmikS7o2MTELGeNmTUkcxC2o1T/57aEre4eBpg2LSoaEpQOUc0/zDXrwuAu12MS
         K3oA==
X-Gm-Message-State: AOAM532iZ5QI7KfpFXVt/Xs8DD+urIM6mv3yuuLe/6jy2ghGwpzAM2Xv
        R8bc3Hb7G/nK/5ebCfudruCOkZAXgnf0kJr5
X-Google-Smtp-Source: ABdhPJy/itIQ1/cRqiSHWRIrAUjZkVirFZVTBPEkkRfEw9pE7U8cNSzpcijy9hVUrtnQyCZg6d2iPQ==
X-Received: by 2002:a63:1a12:: with SMTP id a18mr27610973pga.269.1627462209665;
        Wed, 28 Jul 2021 01:50:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm6754269pfe.162.2021.07.28.01.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 01:50:09 -0700 (PDT)
Message-ID: <61011a41.1c69fb81.3eb2f.5231@mx.google.com>
Date:   Wed, 28 Jul 2021 01:50:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.277
Subject: stable/linux-4.9.y build: 5 builds: 0 failed, 5 passed (v4.9.277)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y build: 5 builds: 0 failed, 5 passed (v4.9.277)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.277/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.277
Git Commit: edcc1d3a1c2e80a7fe254889877c0b073474fd5a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 3 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
