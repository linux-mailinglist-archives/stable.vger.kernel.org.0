Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D086ED77
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 02:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfD3ADf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 20:03:35 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42338 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbfD3ADf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 20:03:35 -0400
Received: by mail-wr1-f52.google.com with SMTP id l2so2908554wrb.9
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 17:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=atFA89oYWNWBrsHMvTkuZ10vacbIppmdXiHPWqNUyTs=;
        b=wzgWAHeAC8ex6AAU/uf3Zuqi/82SFVpvVUqZ9ImjUJyIx00MITckh0/ByDSFwa7Pm3
         AKu4zs8wunfEhX9azgb9ebgbyn7G/5c/wnWLNkOoitYkPWgZZUIAfBt85GqxDxsQx0kr
         zO+nPKlvZqgf7I6Nl/UKYrxlfILlbKCAJU+GMw+/Te5j/nlczWykRrPt+pPtYcqN/Sl2
         0Iq1d9ATGdJMjGIMhJ2qqHKwl/7FreHux3tXVrfiVSFSbTQV3C8lnQhdqwdKWx4CcDRb
         PZRAisKl4+ksQU94oHee1z05SU3obSbbTUuByadKdj0jl64o+2vtkVOv1E9nDCnVGWYw
         r28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=atFA89oYWNWBrsHMvTkuZ10vacbIppmdXiHPWqNUyTs=;
        b=hmGH8CK/+NtYC+elpMz48y8pBa+dH2zr6RVOqLAUQvH4+gDKLmOqQ2sQzb24PCGNnr
         QojlWMMKu6c7UyqvWzaUpA4OAxa13sM0b/nIBGlBfH0E6Bah+6Pw76YMnPkbkA6ICtX3
         s0rVp+7tKmY7yFEapV5eD22YnxWHGUCbitCmGFiVq4i42J7uHMa3DdHV+61wcPd1I4/+
         XLi9DNM01Onk7MOynasLlICami9jIIcQgDBgo1vrY3n7pVmjVhPU6iSzqXhuzl+QcG1D
         YajENWfkZ0Zb+sh3EIpSa8E3gPuyYEcrwIU2uz4B97L3b9PWOEjJyNAs73hY8Pufxt/M
         d4Nw==
X-Gm-Message-State: APjAAAWaC5IaWFXgxahYFLYTinlHNdsrCCtbJZ8/ISicjUQRAj8perax
        0qagEPd6jEyl2liPVHY7qH4xzQcZ/T9qCw==
X-Google-Smtp-Source: APXvYqwfmUK/YQyPeWmx93ft/wFxDmROt+zs6O66rLKd+wXN/z0MFOAnLKPjArSsif/XqllEbcHUdQ==
X-Received: by 2002:adf:f64f:: with SMTP id x15mr22343260wrp.202.1556582613173;
        Mon, 29 Apr 2019 17:03:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t24sm8269187wra.58.2019.04.29.17.03.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 17:03:32 -0700 (PDT)
Message-ID: <5cc790d4.1c69fb81.1f94.bb1e@mx.google.com>
Date:   Mon, 29 Apr 2019 17:03:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.10-72-g49e23c831c03
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 127 boots: 6 failed,
 119 passed with 1 offline, 1 conflict (v5.0.10-72-g49e23c831c03)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 127 boots: 6 failed, 119 passed with 1 offline,=
 1 conflict (v5.0.10-72-g49e23c831c03)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.10-72-g49e23c831c03/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.10-72-g49e23c831c03/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.10-72-g49e23c831c03
Git Commit: 49e23c831c03213f223c936133ca1baa2f34a9fe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 14 builds out of 208

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        exynos5800-peach-pi:
            lab-baylibre-seattle: FAIL (gcc-7)
            lab-collabora: PASS (gcc-7)

---
For more info write to <info@kernelci.org>
