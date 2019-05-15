Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6155C1F9B9
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfEOSHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:07:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38225 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfEOSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:07:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so519799wrs.5
        for <stable@vger.kernel.org>; Wed, 15 May 2019 11:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=8a0Ne4dNSZVwjHUcXcSPoak6AY4jKew3Xjufj621ND0=;
        b=wXrr8sCcejr0Sn5P42P7EREL6isxTX27F1XE5Ee8AJaQxQNI5CgunlVJb57CoD2rXl
         IBT7eqq4OtTkutBPtV2HM7UEnraymUDCXGEnfknCLekAj0Wz+0Jv7VpD0azbH4KR2vVj
         P+F7mdwtoYqJjQVJg6Dqgz+q4AvQQdGdtIJQH2XSp6odv2SJ/6q5vRLKMjQ+qfdbZbAC
         jT+QK91WiZo0a1dZsZ2GqUrfZrTpg7CkDiXcFuMtC1LQtPs8PjubgRAvh+Y7+yoMq+xo
         bujFGr/Bk0lcqtFXtg7eTNqaR6HsLhb8CPSGzSkYoD0q9WD7sNsG/3wjS3P19Atgzw+W
         q+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=8a0Ne4dNSZVwjHUcXcSPoak6AY4jKew3Xjufj621ND0=;
        b=ohWp6VWneybVZVBp038CaVSsyVV0MX+24b9nXgpC1BID+85V7xTkNC1uT6h+hmAySF
         2iIiDGMbHcN9oRS/VSLRqeQUHuSrFz9ZFZUsb1qD6H1vNKIs5eUvs9Qn3dTg5ihrVmKZ
         TZ/RilKFLFjm+o92VDgVeKtrUBDdGkSbqOD2WtHSqd33oZmkfsKeG8fvgDFK/ek7kzQU
         EK4N5qfNBbjq/1ACeNQItMZNcIloLorIKJQMiXFM1yyzL8u4Xw3MPwa+tlRFI/WQLDEK
         a8st83ErQmJ0V3GSCtM4Kllm3AoJhTpDE5HPcV0R21UFg3dsSKO2qw5VbrcdyRR+PVgl
         uG4A==
X-Gm-Message-State: APjAAAWsTUIGA6C8FDlqqwbILM8ggLgf8nUeoFy2VsFegx4TqCjmbDGP
        eCCaR87O7fXKKDSZQXsAbDLBqw==
X-Google-Smtp-Source: APXvYqwd+fZ372FY962ClZLlouA2RJtuhiS2tWYmp0FxdAbIVFhEtHVlJZJTNskXwPFnO8h/ICF98w==
X-Received: by 2002:adf:b3d4:: with SMTP id x20mr29130196wrd.284.1557943667392;
        Wed, 15 May 2019 11:07:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d9sm3560590wro.26.2019.05.15.11.07.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 11:07:46 -0700 (PDT)
Message-ID: <5cdc5572.1c69fb81.b2944.5072@mx.google.com>
Date:   Wed, 15 May 2019 11:07:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.119-116-g7b9ae876e241
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 1 failed, 122 passed with 3 offline=
, 2 conflicts (v4.14.119-116-g7b9ae876e241)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.119-116-g7b9ae876e241/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.119-116-g7b9ae876e241/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.119-116-g7b9ae876e241
Git Commit: 7b9ae876e2410f72fbc14db54f141d516adeabca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 23 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.119-98-g8d3df192f=
d69)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
