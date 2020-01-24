Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF5B148B0C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 16:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731460AbgAXPQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 10:16:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44800 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgAXPQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 10:16:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so2395567wrm.11
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 07:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HNv7tOMZaDKm/65dWjCD2zEXCKrTyW1Pg+0mUVxHwWo=;
        b=uYefg7UNConbR9A+97m10yNh8F7d2E4gnEov/XcUfXL/PAqTrJoqfqFNB5KVrsFqiZ
         XIKMMAVO4GTCymR4nlo45ynmIXt7pQFGzPQ1PbpJL2WqbPoeuPjgO7Lv20oGxY4/8RXT
         8yFAnKUfUls4u8P//BAyx7mwdVujlE+hV6lsmHiAbt5XeQkQ6raKyFoi9vSKGJv08LYf
         VvK2d6RQxDmtixvDEk55wH6MNiblNjGXg3Bs65/aNV8kV2QmK7nTmuAc8zjMdh4dEOcj
         HTiEpwBltz9r/A+ftSVoide4+Dh0/yWxI4tGlgagsT2IFhbBr+I/sNlvFU6azofiq6ml
         3ysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HNv7tOMZaDKm/65dWjCD2zEXCKrTyW1Pg+0mUVxHwWo=;
        b=NC2Z754vnKl403nCJLHwuOfGrDloO5obkig2Srdl+H+fN8wu3WVxw7e2mP5FSYzt3u
         r9nWvX2EI/o0Rp08k3wFbNvWkiw8VoUlZQPg+PbCXG+hOjGEFYf9yVMvhDqOKT02wEiB
         iqtkGQLl2ePPmF8ido2hc8jK+qCDRBno/05BvFNm5eG8y5+f+/Zny4QKrElNPeL8YTzs
         iMGt4a3oD/kg6Oco22pFceT7BwGaSFnQLPLovWskOYmAAeDM/gKhcwRr6b3C5aOT8Cb8
         ek/rlRjmMBcH7XPDosQv28qHS54xD2joJpGU6Ve3e5U0ey6rk8mGzJb5Xfm1mFapvb/D
         sc9w==
X-Gm-Message-State: APjAAAUhdgN+beMx6lW73pEBZ/IF3yagUKFKw3RrW1tWzuhpGf2oMroR
        WGFkWTOJINNfdZGf98zajCLJCIo14XltTQ==
X-Google-Smtp-Source: APXvYqy71wbdvrpFxhG0lF50idHnQdGzxlREvUw7x+uOuBkuVJjXdoj124UGmWl/Ig1xSRHQ/jggUA==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr5214187wrm.210.1579879006148;
        Fri, 24 Jan 2020 07:16:46 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v8sm7615028wrw.2.2020.01.24.07.16.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:16:45 -0800 (PST)
Message-ID: <5e2b0a5d.1c69fb81.e5468.0667@mx.google.com>
Date:   Fri, 24 Jan 2020 07:16:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.211-236-g07802e8305bf
Subject: stable-rc/linux-4.9.y boot: 89 boots: 2 failed,
 82 passed with 5 offline (v4.9.211-236-g07802e8305bf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 89 boots: 2 failed, 82 passed with 5 offline (v=
4.9.211-236-g07802e8305bf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.211-236-g07802e8305bf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.211-236-g07802e8305bf/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.211-236-g07802e8305bf
Git Commit: 07802e8305bf4196efaa1d5ea69cf72f155a843d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 19 SoC families, 13 builds out of 177

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
