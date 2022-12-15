Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1C264E258
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLOU36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 15:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLOU35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 15:29:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76687389FF
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 12:29:56 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso3965346pjt.0
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 12:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EuDc9IaFTlzUNSqbKF4rsu9bEWbPzkKvJb18DhAxJh8=;
        b=Z8xolmqXcJk1Iq4Nmydmg/1u4I5RCVZSJB3nrJouvHi7uWhZCbYmOX26WSm46NCVQr
         Vh2rxlr0oVfZACl3V2voW3STZx17OV7CKJx2snJGYpIAr0KVJnfVxLzEC7cd2e/IhKSY
         oM2XyWyFubsRBzd4TORGaKFyc4W05lSdo1QQIB5NpC+ihyUq1+PwsyGqDBoQDH5r+drJ
         AbJt8bG/ex+bFzDwdY7dv+9xvaL4JWYFfWu+/3Dw/fsNgbs+uuHT2fBFwMWpTosuulv4
         wbEY0rBE3aeUvHD7XPrAg1iesVzOJWzFXLDr3LmaIk0f3al4qyf91tVIxDsZfOeEXYh0
         eYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EuDc9IaFTlzUNSqbKF4rsu9bEWbPzkKvJb18DhAxJh8=;
        b=5ympvdT2ZnCuKY4xILXvqDznk3iLuxepK6caJZ6cfHX1J45p9rEQubJKFcGsxhRga4
         sHpGU9fovVxe7m8mEFdt+RRISvcL+wEtTHOodEK4M2ssHFvLGpau1Pz84q0B9XgNkQd4
         5oAVyXB7J8uW7e7E72UKGrOxbBXaY9GmpMKuFlvn8ucjBZkZVMjYfE4prf0IfzlS35Im
         tisD64Ide12D1E9NnyrZCr/hzbHNU3dP3uvIF/KYJHUx90aopuavyzoDrtcFTnnAXnnV
         1bEl3v9c+MIpNJiG2SNVDZeZQtVCxEXYaQgBLJAN8lwkl8JSpR0gm3QLVhL1NYRsFDhf
         0TGQ==
X-Gm-Message-State: ANoB5pmuPZ75XBdVNAqSY6VIsd1PpbYzTd3ibRcceI3FJfy23StRn231
        jaWuEnsuTmDo2BTbEgEwsKwfVuMb/2XhFA/mqMY4WQ==
X-Google-Smtp-Source: AA0mqf7znorPH9OKWphUbesuq0HaArwFC7dprxT5qPlFaZWegNfvAO7e44D3YRXUiBqkWE6bpazdFA==
X-Received: by 2002:a17:902:e887:b0:189:e5c5:3a92 with SMTP id w7-20020a170902e88700b00189e5c53a92mr41108890plg.60.1671136195660;
        Thu, 15 Dec 2022 12:29:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3-20020a655a03000000b00478b2d5d148sm140593pgs.5.2022.12.15.12.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 12:29:55 -0800 (PST)
Message-ID: <639b83c3.650a0220.6e89d.0623@mx.google.com>
Date:   Thu, 15 Dec 2022 12:29:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.269-8-ga93bb7dab75d
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 build: 15 builds: 0 failed,
 15 passed (v4.19.269-8-ga93bb7dab75d)
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

stable-rc/queue/4.19 build: 15 builds: 0 failed, 15 passed (v4.19.269-8-ga9=
3bb7dab75d)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
9/kernel/v4.19.269-8-ga93bb7dab75d/

Tree: stable-rc
Branch: queue/4.19
Git Describe: v4.19.269-8-ga93bb7dab75d
Git Commit: a93bb7dab75d814a9f7d223ba991a696ab03e6e6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
