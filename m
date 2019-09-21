Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A09B9FF1
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 01:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfIUXMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 19:12:08 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38273 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfIUXMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 19:12:08 -0400
Received: by mail-wr1-f52.google.com with SMTP id l11so10185291wrx.5
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 16:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ft/LpsF7I8deTquRs+KaS1i/hhxYHh0BknMSKnSbqAY=;
        b=QTI3Ozs0HMmFBF10VXrZ61ch72MTZCK+EYhKsbJjpvqn1QGlSKAE3+FINCuFITpFrT
         nhuF5pLWn/6yZrMFlOJfEyUeBqgLekXEkaFWcg0+rWLP6pVxVixbg/6PtqVXkNCGInP3
         X/bQyhGVKEJnOANRPjM5ia5wu9HRyL4bjovNX0bppXfFbIvtxxf3nuXPZlglt8yawETl
         axAaR/74w3Ty7FO5Xx7PcnsjpW7c/uvLNRgswvQDe/mgM7C9CblTskyeRmyCp02y8OKu
         IYyYf49PQ1KOFXuAuOgn3EbAJxOe8PSCPE3eUYdm1nQaLpDt+llPpg1LtYpZw/4C/S+A
         2V/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ft/LpsF7I8deTquRs+KaS1i/hhxYHh0BknMSKnSbqAY=;
        b=pXE1WKx+wP+6EwkzbkvvM1NPOYJTw7Ns42LoICfBldIy5OsxCd70pEVb59aaQEsa/u
         qK4UEpjb3wFyl+P0e/KTbg+AaoNT2ahVf6OHNK4S5wkIRhelnASXsTUPHMdYD6fXc0BJ
         aoZYZXzBZbSwdcdxRzeUwaPE2nbDzuX3CmWrKc7Uv7eQx/BsqbZs7cxZQzA55OArlVOK
         Hl8SKAkS/KZjOnvYw4cuTYWlsPrl14R1rN1aLC3X+k+gIYzDq+FKuksJE9nfAXUt3IVI
         7F7ay8xYHpYudAlWWuDsAkYwgPviL0tMMCOxn4uHAL88G9hWaH38y4R1tPcB+7SxPfpZ
         hIFQ==
X-Gm-Message-State: APjAAAV3BQq1NgCvB4d7i8yihClGUlop6M5ytPTkimaKC1sEwlK0KTrL
        c0cJzFtfXnVbX3Ls3+s8Dr49KSqd4PxVpA==
X-Google-Smtp-Source: APXvYqzkg9ONg8CmA1egRLpPgZG4QsANNs5NJfYUkt+haAh0Mu66Oa80OAOrDgZW/T87+9pQtWD3ng==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr17660147wrj.269.1569107526286;
        Sat, 21 Sep 2019 16:12:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z6sm5183922wro.16.2019.09.21.16.12.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 16:12:05 -0700 (PDT)
Message-ID: <5d86ae45.1c69fb81.64a46.a677@mx.google.com>
Date:   Sat, 21 Sep 2019 16:12:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.194
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 112 boots: 0 failed,
 104 passed with 8 offline (v4.9.194)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 104 passed with 8 offline =
(v4.9.194)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194
Git Commit: 1b2be6d75ad971d27decf2a97f5544c35aeb9f2b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 21 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
