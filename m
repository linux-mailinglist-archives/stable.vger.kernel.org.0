Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8549F8D7
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 05:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfH1DlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 23:41:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34986 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1DlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 23:41:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so911122wrq.2
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 20:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CrvUt4Ke4/GMH0wQTgI8SGGy4R2tk08cLnCa/44MlUQ=;
        b=P0wQ9yh0Gpm9K76SHn3yZDMjej8wOcGOFRDOtiTQoEWRdnRhndbK8IklL+4ms7GKZz
         1NS3957AbRBJVVWNR7bkFukUdYT6wclKrPpUtbzfKkpfVGF0WWTLYgM1zM2a2ECEUn9F
         kn5ZzQiAeKe9A6kbUJ2Dz9n5n3eWJf/p0DeR4Ymmgc6FsRTs2+tbwhqxZPXcaxNY6gJw
         ++YLH7yZHysGs6jA7doDNcjfAvU/B+DU2EREmMBV9l0Xq2TSzH52TE9w0DUzm2xUGXSx
         g/zpYW3QcNQM39/tN979XLPAaM2RYCu/1PoBuFf9UwMClzPaYg0XWBNHYv+SZXQcBi1r
         T3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CrvUt4Ke4/GMH0wQTgI8SGGy4R2tk08cLnCa/44MlUQ=;
        b=FjrAOgsPrA9HdSmCGG/m3g03WLJTgmVCMgtAEWCbW7VQgsJ+q88kCPW/LkDiANelFY
         tPzwbWo54zstpoXAgkEVBCqBYGfQzZSpNwTxL+RufC0gZlj84UctmJSScTVYXBkEJ1BM
         rV2dJVfg16q6PXfC0IaOb+yPJCXiEWMhPVQFU5YFu5D+futjrcV+ebm+O2a6Q38AL0ip
         AN/JZv5X9qjWUf/bxHOJiLNfbRvD6fkBO+V2jZQkNS1+8WV1u4xtrxqbpXd30sz1tgjO
         D8jAiHpmYYyV/VhxfbZE0We1BdNqlUP5//lDlNCvEcmsk+VoC3JspTUTh+c2ToEvl+67
         v3ug==
X-Gm-Message-State: APjAAAUAMyhT2rpdbuHX7M6v5Cdz8ArJcyX7DsC+P+gXhboJUuoREV8A
        vG2twQ7FSZVph80ElaJYday7nMn422P/JQ==
X-Google-Smtp-Source: APXvYqwEtxGOJ3M5v2uUmTC8SzNeXoANMow94pQf2UcNkcyg0rg0/CXFjh4YxxCOA0T/uFXpgvxPFw==
X-Received: by 2002:adf:9482:: with SMTP id 2mr1529574wrr.91.1566963675868;
        Tue, 27 Aug 2019 20:41:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm3450165wra.75.2019.08.27.20.41.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 20:41:14 -0700 (PDT)
Message-ID: <5d65f7da.1c69fb81.afc2.1483@mx.google.com>
Date:   Tue, 27 Aug 2019 20:41:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.190-34-g13e40d47f29c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 97 boots: 2 failed,
 86 passed with 9 offline (v4.4.190-34-g13e40d47f29c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 97 boots: 2 failed, 86 passed with 9 offline (v=
4.4.190-34-g13e40d47f29c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.190-34-g13e40d47f29c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.190-34-g13e40d47f29c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.190-34-g13e40d47f29c
Git Commit: 13e40d47f29cf811c8b8b7703c9066514101745e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 19 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
