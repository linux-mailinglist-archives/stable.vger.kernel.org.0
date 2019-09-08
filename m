Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3852BACFC2
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 18:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbfIHQif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 12:38:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40234 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729653AbfIHQif (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 12:38:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id t9so11981005wmi.5
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 09:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=S0kAixsv5Ss9XN3UyIhqxUQ8a9FRU1URaKsRKak3iyc=;
        b=mco3O4AuUtrzllXE8Bh5xiCHvbD2JVaFjPgxUjlijVVMYFbpQ7bK47a6BYlP/akBVE
         aftJ7z39dfNApRBhxJPxwGLlXZAGV3X9h5QMjB+6t0JUOV555rSa11jl2XPmz13V1buP
         V6RSti7/074OIuteZ/ayNSq3O4J1H/Eovg2w74oVPRhfknWDUEKfcz82epiP43hIyO4D
         yFlIOpb2cyMmx9HEQq6s83ob2m4L774G2b85rQh4215u6hufbo4iW4aMo8BnHEl3Ixp9
         66YVRRHptnLzkxmfJq/1WF1ysX7Di/wlNGS5WaNEe7GGCjfMaym1LmQVyX+sKVQIG667
         tQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=S0kAixsv5Ss9XN3UyIhqxUQ8a9FRU1URaKsRKak3iyc=;
        b=slqgW3o6At7YtVRWDQ3aY1nU644YPF4m3yiDzQHXDIgmTpWAUcRivBYo28w1obYlqp
         RNLkBih4Xv1xZ9RVVyzQl1X+z9oowWYNRU/jYp+esuY5Ocw85nvXRL5XbjKzdHeDgL0o
         C/a7EdPZflLck5d5BhCn7GdIANaUHH4CSwbHA4PYjCmH5IZQVLC775fbVt0fwTBeHHF3
         8xwfUN9ddrmx/59yAHcrtZZRVrNa/ZT0LEDl5pvc0XLZME16E5YHc5gTOQO+yzae3e64
         chwhrGaeITRdZ+C9XoAiGf5Fk/Jn5UECwgrqDeue3VxHyEIJu+8Pzb1n5PwEZr1VVemW
         GS+g==
X-Gm-Message-State: APjAAAWFPebSWsnYd3LLgWDuumI6Ou6TnvpAh+IlzCRR8PF3BR+wD9JF
        pfiM0IBxGNGtPSTz7sArqrs0iA==
X-Google-Smtp-Source: APXvYqy84UX29Uj6iuydnGdjhA5g40N+4Rch6z8ykezovnkN/Kuna23znHDqNj9Bu5rO2WDr7PFWqg==
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr16087769wme.16.1567960713191;
        Sun, 08 Sep 2019 09:38:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e20sm22902354wrc.34.2019.09.08.09.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 09:38:32 -0700 (PDT)
Message-ID: <5d752e88.1c69fb81.0f33.990b@mx.google.com>
Date:   Sun, 08 Sep 2019 09:38:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191-24-g6128caa0e308
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
References: <20190908121052.898169328@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/23] 4.4.192-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 106 boots: 3 failed, 93 passed with 8 offline, =
2 conflicts (v4.4.191-24-g6128caa0e308)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.191-24-g6128caa0e308/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.191-24-g6128caa0e308/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.191-24-g6128caa0e308
Git Commit: 6128caa0e3089f1c7c5ca695cb9e4737f77ad413
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

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

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-linaro-lkft: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

arm:
    multi_v7_defconfig:
        imx6q-sabrelite:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
