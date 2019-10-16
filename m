Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D748D9AF3
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbfJPUHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:07:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34473 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732749AbfJPUHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:07:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so5434076wmc.1
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 13:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t6ojfWDtafLS0vBTlPTLQ5J6nB8c1IDNXw3nZs1i+08=;
        b=aeVYM5VupYmBCVy+Nio8ziaeoO5pnzjx9BlP15mfKZMYFXbKHrdLHWbHQdSClCt9uY
         2nbcECoWoZQH1kcdcEfHxvCXIaoRWpEAd+ZHenlCeHmy/F2H66Hydjsh1pDoRpSOAUa7
         jI33+F1/3LzrRe1D1doculgsxcO4tDQgeWZH1Lxtt/mBj+3+8Wb87esbEZMi0/Ig+43a
         pE2qHtZhO8+ntGB0f/lzgsAnzYuwwtx3zCSTwi4oqPM2hhEyF9y9s3PGXfJ5/qXoKPT7
         yC2Qx5pnncCKlGaCOluWUwCseDznACK8K6X6aAItHCs+62Aud3do+PIgM2RjKxJr3iGB
         r5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t6ojfWDtafLS0vBTlPTLQ5J6nB8c1IDNXw3nZs1i+08=;
        b=hihZi6M/9FYxd/4ShfllheNc7XzRLU2qn9AMS6b5ZPV76xSQy4uGTJZlE4i4cxTXhs
         nAT+IJp59KUmRY0w7wjCh+nd9TQgb6xCGLi9ySCLP7GkAfHSOp6sMDhk7upxH5v7BSkJ
         YKYTOl45qUSl4GFQQ8z0PP1DJiA+D+JhNVnKyMRH91j1vz++JTd8NivxvuXZT1KaYP73
         KyTtFxBw9EVvi8yQyrbpfQKzgfplcDQD5d/exogHGYu6/DErDtjIYdeZmiJYdOuwBl2g
         zWtb1YdNR3FKs83VuunfSHEZWOYS/ac80Fpast1xjZujodanh4MLz9ftFzlGvdin48vK
         8exg==
X-Gm-Message-State: APjAAAUJ+Bl8juPAY3dpPy+5ZD4qg6VFKceJdTFPSBPWrf+kwhATDb8F
        vbEUqylJzGT9gLsSa2NHJE0pjSnKLLw=
X-Google-Smtp-Source: APXvYqwi5pDO/o7bAIWxRmFwpe2yebrHcElBRcdlpRV4eZWKHy/f4WSLbjDnSAknBNCbaNhvODU3ow==
X-Received: by 2002:a1c:9ecf:: with SMTP id h198mr4809113wme.45.1571256440106;
        Wed, 16 Oct 2019 13:07:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v16sm27367454wrt.12.2019.10.16.13.07.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 13:07:19 -0700 (PDT)
Message-ID: <5da77877.1c69fb81.c3840.3481@mx.google.com>
Date:   Wed, 16 Oct 2019 13:07:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79-80-gac978b42e2e9
Subject: stable-rc/linux-4.19.y boot: 113 boots: 1 failed,
 106 passed with 5 offline, 1 untried/unknown (v4.19.79-80-gac978b42e2e9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 113 boots: 1 failed, 106 passed with 5 offline=
, 1 untried/unknown (v4.19.79-80-gac978b42e2e9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.79-80-gac978b42e2e9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.79-80-gac978b42e2e9/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.79-80-gac978b42e2e9
Git Commit: ac978b42e2e93305e44f16d0d0c6811e440518b4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 23 SoC families, 15 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
