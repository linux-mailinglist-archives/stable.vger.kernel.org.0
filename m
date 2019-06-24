Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A650F4C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 16:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfFXOzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 10:55:21 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:37845 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfFXOzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 10:55:21 -0400
Received: by mail-wr1-f50.google.com with SMTP id v14so14262681wrr.4
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FIItinavA9eIiwybMWsRJobHMmdz/PIEXj8oD2br1+Y=;
        b=ApNxupbHxMtIMlwXXO3+Rlfeb+n4VDSJoOStUOnMDNpe3PLd4w6vGpbjDgaAq+ENGK
         gl/UIEPIXwBG/91LxNViQyN+kj8wWbn92kYt0VPbjCfwHuieNX/U/6JrpnIQvQpBdJIH
         segK+92k6ubi86UTCC0BqhMjn8SYqQyE/0JW1U9q0gTIVhGdfnvnbpyJUXsRf7xXMrgb
         NYbblppF4TtS0+roeoBCqA0MLJ0Oz1saVqG/GZu8wt8n13J5J/bTqozwG2zCAKxAQrzL
         /e5kDC4LzODCWszKvG31i6pQHXPHyMFiRl12XUJiLfr9a1z3FVWgjQy/5g2zmgbXomg/
         uE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FIItinavA9eIiwybMWsRJobHMmdz/PIEXj8oD2br1+Y=;
        b=qwgBMrFWvhEO+JPHCbxvJnh2S8vXA5aYV0+TVgkk9qEm9rE2um7OjJBIuOGFfbwvpb
         kh3Hfcq2/ip7A4EJLq3iZaOcVdHAcLtFalnWkzwlTkWmTqaQemAOaN2fGnPgel14BwkI
         zeuLFUzRUFROeDcLq8JsxcJAyNW607ygTfiEiLmU16krWbf2wz/yXofWKQt/M7/p0BC7
         uVQe7+wr3QPRCHb3Dr5vUajIZrOWMuSF69j/fz+3TmmKlQAyT2ZeqVVwgEQcQl8PAKTI
         198Kppo2s2mFAEJHlh09KCxO9iu7Rn+Ntjqxbne69y5D+tRPWE+4P/0TWsA3hwtbEOo2
         MJeQ==
X-Gm-Message-State: APjAAAV04g7/wlmrjo0/KaCZ+N65/aLB3GV46kAcx83nUCvGXmuRjF/O
        9y7Kwo321W4f4qGN8W6wLXJO0scHyFBE6w==
X-Google-Smtp-Source: APXvYqyjDWWIrraRO1aDSUHAzDdzvUV0EA2kmxLi+oOgytTKFIQijPmkjYwUdKFdl8eANFMABLMNCQ==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr34965608wrl.130.1561388119093;
        Mon, 24 Jun 2019 07:55:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm8310266wmc.1.2019.06.24.07.55.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 07:55:18 -0700 (PDT)
Message-ID: <5d10e456.1c69fb81.2f5e9.c234@mx.google.com>
Date:   Mon, 24 Jun 2019 07:55:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14-122-gd74a88068af9
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 128 boots: 3 failed,
 118 passed with 7 offline (v5.1.14-122-gd74a88068af9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 3 failed, 118 passed with 7 offline =
(v5.1.14-122-gd74a88068af9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.14-122-gd74a88068af9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.14-122-gd74a88068af9/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.14-122-gd74a88068af9
Git Commit: d74a88068af93d3fb0042f1af40244e76cb49dc4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 24 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v5.1.14-13-gb82=
58e6be3bb - first fail: v5.1.14-13-g5c276064ec4a)
          rk3399-firefly:
              lab-baylibre-seattle: new failure (last pass: v5.1.14-13-g5c2=
76064ec4a)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab
            rk3399-firefly: 1 failed lab

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
