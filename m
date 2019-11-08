Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14153F59B2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 22:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbfKHVTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 16:19:40 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37051 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387667AbfKHVTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 16:19:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id q130so7621209wme.2
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 13:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s17ezj8mhQA2Ay3cV+ppWlwyBYg10zT8SDpTzV3dFjw=;
        b=a/r995Ju9c2WjDQl2t1AWmtzA6BcE5dSL1rNzPCG9FzBCbRBlDwfSXFQ+TZMBZE3YC
         6sONb1qGNH6pg9ypgnjm7sjdIsQeCzP8atwEVmvYUAwK5GLjhPXJnV48q//Thd1Id9Dk
         Nox58FuspbK405LDgJOfrXeH+nshGCknEORL2v8y8gIqD2Oi8wWAeDA2UN2Ah0M5REBl
         ClN0b1jB9iA7Xi3ojgyRnvlsnIwk4T8uVNM2Uy8advGvLzSPq03RqYuSVLYaP5MoT+jS
         bo806PtROsmZuO0l9DbRMBcy3AaUu4y5byWNhBN2GsVreB2JbF/I9VvTtiXgC23wEqr1
         Q0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s17ezj8mhQA2Ay3cV+ppWlwyBYg10zT8SDpTzV3dFjw=;
        b=fTp1tOdPO+Bf8CIfbRYJqF3pTD5wMwZ0Yo/rVRDzmrm6x8uCri5YBGYt8c7HsWxTgH
         +5HxAYYwiH61g4PIO5S+dawkeo39WR8j56bqtz+g/qnCdn3nqe8GS/pGtOWop48P0pii
         3LAeRHDwLrT5YAlz3EItWT5oAzdVrWBGzL8H9tCBYBSNgN9tlgGM2Bs5zEm5/Z6W5Xtf
         j1deb2OHc96inCzq6pGon8LxEAsjDWU/yLz4uGRdm8fGNBSbq8vrPDkH+F9yTuCKsN3+
         6YqcvrZzpmxaZgkFfcu3GiiEbS0tfNY8E2CHHfTfeq+YsxdB3wF9lTLAvyNIyE0H9syk
         Y0fg==
X-Gm-Message-State: APjAAAX41BQBo94rYAG5nL8weBdQ+aPuU4qg/0leUeF8+N0Yx5ChaJXr
        8GGKaO6NanlfHCWIQa7Lu9b3UABaBg6eBg==
X-Google-Smtp-Source: APXvYqwR6oWsvSIgLC7E+nXBRZAHD3SJwBfhcNZ1/ZsI1N0T9IjGUH6l0Ot5UzylEOuABoo6z+wFXw==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr10746872wmc.150.1573247978015;
        Fri, 08 Nov 2019 13:19:38 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a6sm5679727wmj.1.2019.11.08.13.19.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:19:35 -0800 (PST)
Message-ID: <5dc5dbe7.1c69fb81.7bfa3.ef28@mx.google.com>
Date:   Fri, 08 Nov 2019 13:19:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.199-74-gcdd54f443927
Subject: stable-rc/linux-4.4.y boot: 80 boots: 0 failed,
 71 passed with 7 offline, 2 conflicts (v4.4.199-74-gcdd54f443927)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 0 failed, 71 passed with 7 offline, 2=
 conflicts (v4.4.199-74-gcdd54f443927)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.199-74-gcdd54f443927/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.199-74-gcdd54f443927/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.199-74-gcdd54f443927
Git Commit: cdd54f44392767a03868dc27eb7e6b80fa2b26f7
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

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
