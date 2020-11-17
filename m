Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911692B55F3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 02:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgKQBHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 20:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKQBHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 20:07:17 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ACEC0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 17:07:17 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y7so15823480pfq.11
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 17:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bFD5m9ck+2yobX7pV5ogsP8QHNPPBoHHuHqWoP1cjr0=;
        b=JJjFCeQGv05F0uSw6Lc93XazpQwt73srIgvtnVRB2g7q3+gxZRb5XypFI2ZBQ2hMe8
         tCa7qkINJXbtDlzeomCctrgTK9BBLQxq/LITDl2BjtcDi57DwZubxjA4z92UGSMbwQ2Z
         JcdE0dMlzOsabI68riGKqFU2/QsrZXhSbWY5Qv4JKl93as7YWi+c7pAr7tzGKD95hILv
         6kT9yEavAHrFw9iQJi14Cwj0vR+d9056CzmIIk3Z0j9HKWcJCS3Z6HUyOYkwRQZwQr5i
         AMQX8gaBIDmqZB1/fY2K4m2lTpTABqwiI7RAw52gs3BNOTmqImKbCAkcwxC8UOOVo0Te
         QV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bFD5m9ck+2yobX7pV5ogsP8QHNPPBoHHuHqWoP1cjr0=;
        b=ZESJfbU0fmqB9LNHsyGQSM/xv2KisZPqUzoSAg/avhd5MNh4fD6y+QfzKQKWc4bYVT
         BTTKPdevynQjyyy9PUIgxuwai4btEjmm5rWMgOKk9KRV86ZGe8tcQVy6xBLEyrU/jA4C
         pEHBMyhNByPYBPFoLHNG142BmenTM2uRcGLYD7xKVJ9mcs3hSJjJIkkMh2hg+vUdhs+2
         XovdkpPApop5w3QkxDiGnyhsUNkIAPsls0o4tI4bzIAkYJg+ZeU+VIN8xevDiDM2CzxS
         a+TdJS+D+zxjsnDsB1PHAznMaTShAeIylXv3sdTkVKVhiPHnH0HcYwP4/hhyHyR4PqgS
         C1ag==
X-Gm-Message-State: AOAM530OVXl1F+UL9KYhrFpSKffApVYEW7JCxllr2hZmaipEswwvMhQ9
        3sxNaYEbNgPDc6RwuLxnjZ+SUp0OvNs/FA==
X-Google-Smtp-Source: ABdhPJxMi/g5rPNV+z/AWmLY/oVgQDpcCWH3gjIHRmB+KSbEcoFMKEiXN11eGXwEBhMDHVMoJrB41g==
X-Received: by 2002:a63:2026:: with SMTP id g38mr1566794pgg.30.1605575236796;
        Mon, 16 Nov 2020 17:07:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x24sm2154712pgh.17.2020.11.16.17.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:07:16 -0800 (PST)
Message-ID: <5fb32244.1c69fb81.2f1c4.4f77@mx.google.com>
Date:   Mon, 16 Nov 2020 17:07:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.243-42-gaedb439106403
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 build: 2 builds: 0 failed,
 2 passed (v4.9.243-42-gaedb439106403)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 build: 2 builds: 0 failed, 2 passed (v4.9.243-42-gaedb4=
39106403)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.243-42-gaedb439106403/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.243-42-gaedb439106403
Git Commit: aedb439106403bf8967b240e3026d45894489852
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 1 unique architecture

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
