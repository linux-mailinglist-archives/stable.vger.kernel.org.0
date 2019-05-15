Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84551E662
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 02:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEOAsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 20:48:09 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:54436 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfEOAsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 20:48:09 -0400
Received: by mail-wm1-f53.google.com with SMTP id i3so812048wml.4
        for <stable@vger.kernel.org>; Tue, 14 May 2019 17:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2iCzu71lOoBcoLpd3Qv32XsJw0P8tV0+HkD2oQh/QO8=;
        b=N/GowtOGVvp7gQzEt5IAWq5lXDFhlg6rvYyCysup1O6/s9j6H8MU6WCzP+Qv3x0lua
         QiPCRL9VbvfvMlrhEeqzFawhJmtYrpUiWAXAGJlCSEWsjdBHDadGT/XI6C4xvQpTAqGO
         ze5XwVuSmWkDOOOWartlac2RBOg6S6Yo9FGX7QJOjQ0nDMHmr9vOtt0se91UPsXmbQrs
         m13r6nxU4FCRnwVGSb0egsGPF8ykSo00dSWpyCrKysYd8v+Bnwx/OsE6MA07zoz2fflt
         9sHo8zvlPBhJpsfbsGqYIviCwJWQXolByioHPy6xS7InujmiyfarI/0+MgpXBw7mzk+t
         +8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2iCzu71lOoBcoLpd3Qv32XsJw0P8tV0+HkD2oQh/QO8=;
        b=k7rfS69bR/VDfe3WnVRe45vRpmpIa0YR7mOvwqNY6XUvYqarkVCQWAcNer8LX/GwBr
         R4vNiu7vHwj2UeV7K7xu6yjIxk9vXScheahAb7KmVlJX0+H5H70YDUuRi/43T+DeVdMK
         1JwOYv/oHuZjShH5Wq0sk26ch2aPxXN0WBCOM92Eu3+4MeazWgiHHkmapLDfjK3b3usE
         fsKjam+mGTCR/lU8ZAGRW/ZpCDvTnuCR0Ve2OW1exA0GgycRD9iBiXkLyYabQzmKdGP9
         oGUAmG5gYNXcHj4P/taixtPf+DHqgE8tpRgNT1V4Jlynf3URcIyuDd6kz5G9lIsjr4/e
         S49A==
X-Gm-Message-State: APjAAAUz4fta+L83BFilR5Epw4IL8TGBUOB0K1ulTCKHEMYmWOYpLZrq
        da7L3utOffxHvtJxBz1oMZ608p9Awi4e3g==
X-Google-Smtp-Source: APXvYqx1vDkHncLV7a52CSeIbQdcahEkDb5MZIS6QLn5UxNNlxpL8K6W9iB34x11KLMGtw0gk2pjcw==
X-Received: by 2002:a1c:a745:: with SMTP id q66mr11971744wme.83.1557881287494;
        Tue, 14 May 2019 17:48:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l21sm418406wmh.35.2019.05.14.17.48.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 17:48:06 -0700 (PDT)
Message-ID: <5cdb61c6.1c69fb81.8909a.257b@mx.google.com>
Date:   Tue, 14 May 2019 17:48:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.16-105-gcedd923508e9
Subject: stable-rc/linux-5.0.y boot: 139 boots: 0 failed,
 135 passed with 1 offline, 2 untried/unknown,
 1 conflict (v5.0.16-105-gcedd923508e9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 139 boots: 0 failed, 135 passed with 1 offline,=
 2 untried/unknown, 1 conflict (v5.0.16-105-gcedd923508e9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.16-105-gcedd923508e9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.16-105-gcedd923508e9/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.16-105-gcedd923508e9
Git Commit: cedd923508e9e753fdc8b237f2344eea4a84fb57
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.15-106-gfaddc6604e=
c4)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
