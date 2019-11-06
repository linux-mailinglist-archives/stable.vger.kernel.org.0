Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63413F21B0
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 23:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKFW1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 17:27:46 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51834 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfKFW1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 17:27:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id q70so5961119wme.1
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 14:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FmeBMvtIO8yIliKGXqYKpXEDn9vgKCuEKmn/rnsI0dg=;
        b=YYvZ8huO6GRM1/D55NhoGIIo6ld/YxLyupScwkAFv9ORcRkuIC7Aa8CQwXqPXFcgTV
         M3Wc9wyqOMwx6hsNHQqNbRWdlZLMWmuDmWzFZhAEX9Rd2a/kVAB6xv+9wc/8M/ahncT7
         x3ODMjtzLYzl7g2wVSVOe4gEihvB/jCIdzTxIWxJtTLhN41uxKwsYdyFpXfOLPlarQ04
         hH1Bb8K+ArmQPYcTlpFHFB82sWsrns9cNrI7qHb3vnGPDAac0ptBv/HpBMKjCbN1sZ4z
         cJAqeoAwbShvdJ60EDcaAQCRRutusrqGj7ZW0Xvi6+Tvx/iQaUdLFDVL3D19HGi8xlH0
         Cq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FmeBMvtIO8yIliKGXqYKpXEDn9vgKCuEKmn/rnsI0dg=;
        b=fm5DZbBZbIJthZ4rev2WMMHL8CjNYTlNRp2G61uqR1cc8B5Jm+rYOe1biM55EO8uFz
         50m5CV2USo9JZEtR0NcWjaqi34dXzhmGD6syLZY5+3V2IH7Ldv1Zr509IzF8Kbu25Dr1
         II7PLvTU+YkWFtFm2UipeuFZD5y48DHj1lkEgMGWYC0MNf+VxfRaOYR920CuCJbQMqX7
         QZxgQyd/XzACFMouhKfDZYh86ufK7eurDqdBS287wMzcxXH/rBXy44Wwfr6ay8jtXWcI
         nVJKE6cn+/p7M9HSdtPsxYutp4WZItIoENxwsy/BHZiPHggc+SZLJYvSoqyOHn9hv/98
         j20A==
X-Gm-Message-State: APjAAAWKRQTLtO6xuaJcUb/TDNuvuETfi8E9Cb3yCPd1nHK1Nh0B6D7/
        FAjlw+Tge5D10LkOYPvS0sNwfdfQYWc=
X-Google-Smtp-Source: APXvYqwfISFNV+ooJNHyuchQSjBWUvlbnh7mYEXw7Ms8ysDVIDfL0GTAiC9SuQH6zso79djH37cF+A==
X-Received: by 2002:a05:600c:28c:: with SMTP id 12mr4515096wmk.25.1573079263978;
        Wed, 06 Nov 2019 14:27:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 6sm5353660wmd.36.2019.11.06.14.27.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 14:27:43 -0800 (PST)
Message-ID: <5dc348df.1c69fb81.a020a.e42e@mx.google.com>
Date:   Wed, 06 Nov 2019 14:27:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.199
Subject: stable-rc/linux-4.4.y boot: 80 boots: 0 failed,
 72 passed with 7 offline, 1 conflict (v4.4.199)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 0 failed, 72 passed with 7 offline, 1=
 conflict (v4.4.199)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.199/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.199/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.199
Git Commit: d486a86f38dc4a5059ac7c59b735ec81cb2e826a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
