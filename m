Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46BEB3176
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 20:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfIOSu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 14:50:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37930 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfIOSu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 14:50:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so7761286wme.3
        for <stable@vger.kernel.org>; Sun, 15 Sep 2019 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uMZ3zlE67H1xJyjQXnFG+Ey02SH/DzZoKeRWABYZWy0=;
        b=uKHDUhltqKdsopx39cW3Ghn1z24OjBUJMtqnhlXEyJu89oKJsNudHRBS4ha2c6V310
         +rZMYXU07VnTEFUHRVndSk2I5tdo+QSy02KsxuC8qUZd+B1TxzbfWxATi39XKhbPJq+Y
         PPF0y2FnDvH3FqVbdpLWBNtnDxO9AR2yLqUfvy2HIYfXQ4dXRUeLDWtwmc8D3EVCQGOo
         8WQ4nRV0qFBksI+sBAfaO1Mms3jLmrz4qJXMmeVUMrayCaVmbYRhPiF1iIZ81roQllqz
         bBwRGX484nqpSL2dZLJvYI8OXhupLPAxMXoL6BxxIItSx+DnHqjhH6KMMBE5CfpFwiTl
         oD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uMZ3zlE67H1xJyjQXnFG+Ey02SH/DzZoKeRWABYZWy0=;
        b=R+HK0SqiEGCd003lvfgqmOfrEOoVYch38sbxCUbOngKwqJomhsuvu19fnFzQoHptGZ
         82KhSjhVJOKhPEM2FFHl+AqfaG39kOi3RUMPwjOUvwetGHoABJxg1ks8XLbsfe42QZWG
         1Kv19uFlFgLNR1tHuEnbI7cO8PBrQ1ykWmmNH3Hn10riY3fDUN0wEl1ANRWdxvQ16dPz
         mhpu0XYSdWjY0/JUaEVE3WEwi6/mgN2NHeMj72jvcxYXxhdSNKSKb9HZvvpp8TEXRjms
         UnraWpP/XCu6hvWARX2cQbnN1SMK92c/Jh/sT2xZCYbvrq1G12UuOk0hZ+VsvkzyqNUa
         DFTQ==
X-Gm-Message-State: APjAAAUN1Vydhzt3lIGMLI+YmYtGuJRAk+TBuFX9LWAFAj59fMKRQMHg
        Axo40nSF+mtXI50cxbHjlHwdcRQom4k=
X-Google-Smtp-Source: APXvYqx0uI+K6xggTvw/uuswwdTBnd0rlgoZtwgtlGSCdC7Oq6LcR/eZj0BuK25RSxeveSHlzSTJ+w==
X-Received: by 2002:a1c:d10b:: with SMTP id i11mr11345666wmg.8.1568573424874;
        Sun, 15 Sep 2019 11:50:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z4sm7440173wrh.93.2019.09.15.11.50.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 11:50:24 -0700 (PDT)
Message-ID: <5d7e87f0.1c69fb81.c7e75.f1f6@mx.google.com>
Date:   Sun, 15 Sep 2019 11:50:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.14-37-g4a69042627aa
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 150 boots: 1 failed,
 140 passed with 9 offline (v5.2.14-37-g4a69042627aa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 150 boots: 1 failed, 140 passed with 9 offline =
(v5.2.14-37-g4a69042627aa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.14-37-g4a69042627aa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.14-37-g4a69042627aa/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.14-37-g4a69042627aa
Git Commit: 4a69042627aa0ea1a4ba10ed63abefff2f334d24
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
