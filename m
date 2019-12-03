Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2769911062C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 21:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfLCU5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 15:57:37 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:55781 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfLCU5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 15:57:37 -0500
Received: by mail-wm1-f53.google.com with SMTP id q9so3474411wmj.5
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 12:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XLtelNLxbVZEHBasZGnixH3U/kq18l4OfB2alic4gpk=;
        b=Fy4QuTV3Lk/RlT5fzy0aTUYaudXQevVy1rjbXli2hjEPFJ8NNhXLfBvT2OF/TOs/yy
         nqYAZnoNhsO0cRzdmKgvl5IiccIMqbWpIAXDAFOFf9zOmAPcTCmlCQw/nbpN4DyU6ET2
         W+n2x+2MwraIqk9eXynEKwdSF8IE8FXItF6MjT9tUb9JXllm/m2KUqmQRqRl+BF6ypTH
         sIZV5U2oYYk1AK87W+LxeVCv55ke5QbiqgZUXS4Jhp4MieZFSS/rKJNT5YkfayFLqZw9
         KrALU11pylCeJnvmvdd8thMum7CwSDlxm21UWnaeyS4TAQAAZhzJZlJEuohdScRcNjoq
         4SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XLtelNLxbVZEHBasZGnixH3U/kq18l4OfB2alic4gpk=;
        b=Xw/Wq+iWBs1AdixfUrpXGG/1M8Bde0sePgFROpd8djCdoBAzKWz7da6AwB65GBAXe6
         BAEQNdP/kgL2fj9w8lKlqvwZujNJPX+IudHj9+mskBRV1nEdFwVkT9EO9nR5WPqUECo6
         LJCWD+nxsr4kQ8KYYpLnMf/WxlEZPwyOR6cYEUNTuoJEjzN9ONE/kM/Ba3AtavB460vU
         I9DyfFJHuSg5PNg5f/TtQahi1RSdKFfiYE1TMAkKERW5Pc9K2AwoD1bV77JxXI9fSmd4
         NFYD2X845bVwRZdWW2Xclp7/RC83oIWk9B4KWINITTDQlrsAwB6illHZX4J3GEEd4mzK
         9gCg==
X-Gm-Message-State: APjAAAU7M53w6KmuaPaAZF4/mSIS5+JVzCji1x6Nn2/onvZYXh66pCcT
        nm4xBP5Q9szzn5uqopUjyfmgh92cOpY/DA==
X-Google-Smtp-Source: APXvYqza/46KOqypvUvRvqB6VZ+5o4xbmICCBgHGQgedU8nhOO6qD2xuG2Sj+JeynPa3J1g00L0tKQ==
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr36954498wmj.126.1575406654639;
        Tue, 03 Dec 2019 12:57:34 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x11sm5392695wre.68.2019.12.03.12.57.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 12:57:32 -0800 (PST)
Message-ID: <5de6cc3c.1c69fb81.80445.bc2a@mx.google.com>
Date:   Tue, 03 Dec 2019 12:57:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.87-304-g18087c2f2df3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 119 boots: 0 failed,
 112 passed with 6 offline, 1 untried/unknown (v4.19.87-304-g18087c2f2df3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 119 boots: 0 failed, 112 passed with 6 offline=
, 1 untried/unknown (v4.19.87-304-g18087c2f2df3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.87-304-g18087c2f2df3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.87-304-g18087c2f2df3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.87-304-g18087c2f2df3
Git Commit: 18087c2f2df3a451ab41c9b64fd85a933732a6ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 21 SoC families, 17 builds out of 206

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
