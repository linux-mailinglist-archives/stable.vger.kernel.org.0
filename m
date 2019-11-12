Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC2F87B8
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLFLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:11:32 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52106 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfKLFLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 00:11:32 -0500
Received: by mail-wm1-f52.google.com with SMTP id q70so1634693wme.1
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 21:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jb4O7IJ2ILRQfgZLEEcp8zvE57bJfU4NqztKtxInz5k=;
        b=aUlBnWZ3FkDPE2bzxQwym/cYO7GqXzlmmu2KtRZAR02XbMpxyILac+hNGz803K65OG
         QI12ary4EiiufIYUtnfwfg/qr5NLS7BfRqIcgBIDYXxxE4DJd8aW+I5wGULoJMRHkwUX
         h326IgKqJsP/mdiI+6vo4Da1SZ7JvofrQGUBI64Ra/dKOpb67Zj3yHD9Ny68LagOcFxw
         JF21oXG6TzTnHYwNRlfuQm8pG0JKbCKmdREilTGefyTVY/14fg06qL4b8iN1fhND2VyO
         vqCg7PRs3W0ZB8EkrNbTzsKv7fO4nJ8cOrZgER+h3GSAu7sdSZUa3/Six+ZTEgkIY8mF
         bE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jb4O7IJ2ILRQfgZLEEcp8zvE57bJfU4NqztKtxInz5k=;
        b=l+kiHidbbz8eELxf7GpNRM1NlAYNjWN4ZchGNa4G3QW18+ZAZ6OKRXRIj0/gcE0f80
         eiQLLZCbgcPOPewzeC0boxq890iBwSWeK/wCP0grV8LuvZJYnlAxTxN+Ayk466jzG5Jx
         uvt3KhKoaSRASrz5GHT/xcDj9ZygXkYRqd1iLyX3gKA1GytsMerynURA2PXbaoddUvHO
         0mTxywXNG/l+hExzdR+5yDjQQJmGFmyruSsM6W3C7VcrV66aWM2N7CycZrjsoVRhy5jt
         j3uvphI2bndDnXLmeH1U79LtPQoc6tNZwAOGlbEtzO9kXU0JR7jsVhQRgC3zSpUcMlHe
         pN+g==
X-Gm-Message-State: APjAAAXbWEulxDG5dWTSNOU5YNsg1WmAmEOM3z8ZDdbGLT2i8cQ/C3gB
        WO6Wf9WZ8s5OCpY78hTjNfJ6K230pNBXWg==
X-Google-Smtp-Source: APXvYqykJwbSOQyFJViNOjmNsC6I6tvANZbVsP0mOoGKTPAa4sJDQeKo8JY5Rgvc129DH0bm9Vif3A==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr2217808wmo.51.1573535490291;
        Mon, 11 Nov 2019 21:11:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t1sm24827438wrn.81.2019.11.11.21.11.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 21:11:29 -0800 (PST)
Message-ID: <5dca3f01.1c69fb81.bdbf2.5508@mx.google.com>
Date:   Mon, 11 Nov 2019 21:11:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83-126-g0f8b6b0b5b94
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 112 passed with 8 offline (v4.19.83-126-g0f8b6b0b5b94)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 112 passed with 8 offline=
 (v4.19.83-126-g0f8b6b0b5b94)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.83-126-g0f8b6b0b5b94/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.83-126-g0f8b6b0b5b94/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.83-126-g0f8b6b0b5b94
Git Commit: 0f8b6b0b5b946b33f5b60e9de252afb809a17e6a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 14 builds out of 206

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
