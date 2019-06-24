Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E321350F92
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFXPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:04:09 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46335 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfFXPEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:04:08 -0400
Received: by mail-wr1-f47.google.com with SMTP id n4so14242084wrw.13
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fJV/AcYuI/WrQZFZuWwjzMZfBeu58VJGLSIoXd30SZU=;
        b=BmM8ggWdRc/UWQoGKrRmeaZjRjqZypVHTBOd9tm5bE0dlWaGNSRacwlVG6EMqjIzKt
         VCA/2ISkcNqh6Ccxnam4n7FSjW9aNGTOIUO/OZ+YyR/dDSXVbLdKbXVothzncD1pyLeE
         ZTR+VL4g705PJBcm47FWN8iV8vEsPkQ0MVl5Y/n10HCqRgErpoY2Si/hmsGN3PO0UCc9
         k6Jl5w7cdvexJ9bVBjGRSyex0IBb/E8Dwcrl2kRF8v5mqagjtAuTMFdjtC69E6Dbggp3
         1iczXlieL4t7lNbUYW6dGm5BqIVL5qRih5DqwPfBZJWV8qpjEwbbjvYT8g93664vBDQb
         6Ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fJV/AcYuI/WrQZFZuWwjzMZfBeu58VJGLSIoXd30SZU=;
        b=WbyKQxq9adX9CEq34hUeBpkBvcoA7hD2dtOinK8IvobY7eEEiNfkTqmkhYU04mJ4bj
         Wf+FxUTDNQ+x3y22uv+70wzsER+v2pbBVFuP48PbJVK6YNOVJgaFKt1zxuWAWsooBNop
         cmGd0MPZ9kgd9wu03wcaSyMlFcBbaFWCIALpvfrThNoSkMf3JvNgAMXuEy1pXPILZ5Y1
         zjH+kf8+87y/6DiZbap8/nWCo02klMv9S5qX+T6s5H1uxxNWpmJoyWkdU51BOPOsoB6s
         SIPir0F9WThOhqwHuj3732EkZXZ4I9PzU3svJeg8eNBrr+mtf5oM1AK8Pv78/TGtODXm
         HcVA==
X-Gm-Message-State: APjAAAUWegAE2q4VAESwj4/lGKGJKX3NLQHGXlMRroE0xh9/G9tcvG8v
        ce61L2IvR2XctAWjeMNWtbIK60+IRawSJw==
X-Google-Smtp-Source: APXvYqw11qK23gVMj1vP5ybHXx6uDJZaaO3tCGXHCTeZbT1sDjT7LmKH9g0bzIS9P3wXV2CBNU/ZBw==
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr38137582wrv.114.1561388646508;
        Mon, 24 Jun 2019 08:04:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l124sm11283088wmf.36.2019.06.24.08.04.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 08:04:06 -0700 (PDT)
Message-ID: <5d10e666.1c69fb81.9deb7.dbd8@mx.google.com>
Date:   Mon, 24 Jun 2019 08:04:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183-36-gc40261803d2e
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 94 boots: 0 failed,
 87 passed with 7 offline (v4.9.183-36-gc40261803d2e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 94 boots: 0 failed, 87 passed with 7 offline (v=
4.9.183-36-gc40261803d2e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183-36-gc40261803d2e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183-36-gc40261803d2e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183-36-gc40261803d2e
Git Commit: c40261803d2e63f08dbb8ba38b4dcd4b4f838bfc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 13 builds out of 196

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
