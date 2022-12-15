Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADE364E16E
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLOS7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLOS7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:59:23 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47B41B1E1
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:59:22 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 17so7898419pll.0
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PNUqe7bK9Deobw9+oRgqTmbqHOLvLODQTvbQ0ju1Dg0=;
        b=nYqg0s2sRbEOUZVWx0W5FaTM4hYSW+bYBkwUn1i6xOQAKlqtSTbtkFEYl7m76+grHc
         XhZ2axTbHnm+gp0CxyPqd8O1iNGA4aknL8LIXFA6cN4o6tMz0nCsUof5e2Evhzl+qMI0
         4weIuwFxZn6C+HNhNLPiKKVe83vzGO9eg6ekadXphr5DRs+KCKeElAr4R1Lxt5wVpttH
         f51ssBGLK0+lp28NMNvJBG/IkIxrqCh6yih7SEonQY980TpmBC/mh4CQnEfxJqYySo/9
         sTtj864K85ouc2HAEpDwM2t6JtYofLJNV9Jw+XDOT5nbJQaly5CBBZi90YXO36zsAE7t
         KI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNUqe7bK9Deobw9+oRgqTmbqHOLvLODQTvbQ0ju1Dg0=;
        b=Gghi/362HUmFZ8g2zkbyVZIuRLVz7VaKdNM77rSmFxg5WDqrkdBfVozkaxLqgU0TEy
         xuIggNvEFSls7WUvia8H0sT5fsjpsPvY2ICOBHajzjRqxlnI6rm+wHLRsqLGkKVJTThK
         yeW033x6byO1FIHF1HfzNuci2wkr+XYJm/Uk+qEV0o4+8+JvL1mPvAz2KpTHVoNzfZ8z
         Mzlno9cbVNQwML7QHT7DF4fY8eR4/go2Ixs3KF2HTgu1zRulYR64sULNhZyCEC6y7Yuo
         32JYKC5xOmDadzjKUio3uq/nMCpkq3ICxR5yiCtJi3SDPBn60pM3/Yq5xujjDwRJ58f0
         fGvA==
X-Gm-Message-State: ANoB5plZoplVYSxQhjnMFWNDfr0iYveAcD8rPt0mSB9QEpibN43CXajj
        7+S5Lyxk90+9Fu1zS2tmwrVvYBfuBY6sSBdZzZYBJg==
X-Google-Smtp-Source: AA0mqf5DZ13A1mlPYesl3CHrgyvrvF14AY+K4h7K5QGiY5rGJ2eApoquIj9zyA1EmtQ8vZ5NtVVXnQ==
X-Received: by 2002:a17:902:e80c:b0:18a:4493:5db6 with SMTP id u12-20020a170902e80c00b0018a44935db6mr43536301plg.41.1671130762033;
        Thu, 15 Dec 2022 10:59:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902e54b00b0018912c37c8fsm4150782plf.129.2022.12.15.10.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:59:21 -0800 (PST)
Message-ID: <639b6e89.170a0220.bdff0.9242@mx.google.com>
Date:   Thu, 15 Dec 2022 10:59:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.336-5-g1a8d01cb0640
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 build: 11 builds: 0 failed,
 11 passed (v4.9.336-5-g1a8d01cb0640)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 build: 11 builds: 0 failed, 11 passed (v4.9.336-5-g1a8d=
01cb0640)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.336-5-g1a8d01cb0640/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.336-5-g1a8d01cb0640
Git Commit: 1a8d01cb0640199e60cd95dd430b693073095146
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 2 unique architectures



Section mismatches summary:

    1    WARNING: modpost: Found 1 section mismatch(es).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---
For more info write to <info@kernelci.org>
