Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6939510C8A0
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 13:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfK1MXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 07:23:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36275 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1MXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 07:23:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so30829594wru.3
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 04:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PIeBA+xSBJR/evilPCi6a5Z+JjzVeKnwJm5krYtZyP8=;
        b=u4KxQhAJtVPmq2el4DKL3t5LaxVen4yewKaNgW0LBfaMTiq4w0uhNnDAf7CEj8bYRt
         Nl/vFTaewLd4fTGWtn0MxL9njAzRTeP1rAqtAuCp3g5mAkZVRK6rCJhZOSjXChMX92xv
         7MDW+/Ses95BsxM4GvQn0OXmfyLY1dI31z94tQ+NMFBiOdxjiOkF9VKM4VoaWrlOQ0ss
         fxkvap/nrHTdulanWUy1wSU05l5KJs1gIg4ADTTMSgLXv4Q9cJuU6SiUvlmZZe6e983c
         nVV1LHAHg++0YjfJejSQsAe16OrWJFXksa2NBbxDYhAAPU9nBQRo/wPl36HxHIXBt9JN
         yN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PIeBA+xSBJR/evilPCi6a5Z+JjzVeKnwJm5krYtZyP8=;
        b=Gao0zpRaP/blxf1H7EirI1+Txf05SyfwPwJcKUHkpRyWh3Nw+Cncmed91UqTB4qU81
         4uxLEqK3zwNufwTwImPsPGU3ZTj3t2OnAQfTZfDzeKKg1VpEKoXrNbtDryP+18qDgra/
         lIsYTNBa1EnmdIEjVKK+nGKFuW++Vjea99nQT4JLTLfBArCcVVTklu0fBR1zUJ/Do7EV
         AUxT4CwIukyAFlBUdopk0GA4K2eaeBcnHowS2fEy5vmFOPffZl9pKraEqbqTA7bsi9mZ
         +ufUcKbZm5DocmP6EPjCs0apWeoa1jJhs20gEhtjMF/Zy2EuJl+bBBrbSzs5bc7rw+uF
         6yZw==
X-Gm-Message-State: APjAAAW9ZFMsTIr0qAZFPOG6lpgdi+e69AqZb+Gt3C1+Igc61QdrfNnm
        wgUf+nu0Yi53GVnqJReBRfLViS6dhQ93YQ==
X-Google-Smtp-Source: APXvYqz156o8+ka8PHs0edgiO6KJg3IUsDsXgTzpbomF2eLIsUSaY0Ydodn+uivohyDcOhhblLaTVQ==
X-Received: by 2002:a5d:480b:: with SMTP id l11mr5437493wrq.129.1574943789046;
        Thu, 28 Nov 2019 04:23:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w19sm10074943wmk.36.2019.11.28.04.23.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 04:23:08 -0800 (PST)
Message-ID: <5ddfbc2c.1c69fb81.9da69.32c7@mx.google.com>
Date:   Thu, 28 Nov 2019 04:23:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.13-97-g27442d398302
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 146 boots: 2 failed,
 138 passed with 6 offline (v5.3.13-97-g27442d398302)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 146 boots: 2 failed, 138 passed with 6 offline =
(v5.3.13-97-g27442d398302)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.13-97-g27442d398302/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.13-97-g27442d398302/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.13-97-g27442d398302
Git Commit: 27442d39830209266d439effe7503146b8f4d0a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 86 unique boards, 25 SoC families, 17 builds out of 208

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

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
