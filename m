Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1D416B484
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 23:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgBXWsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 17:48:50 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52741 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXWsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 17:48:50 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep11so380464pjb.2
        for <stable@vger.kernel.org>; Mon, 24 Feb 2020 14:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CF69ZQElF5CK6mfivUiH43J5x0+bLb9TXIUZbjTAHow=;
        b=PGcnHVklLDLhYj5KanOBNAQKIKg4L9/AcXYlT0O9+tipbKkhxaSn4aeK2hlE9OFIO4
         QrFKQNvf6nD/naNB6756+0PV117UZFHBhbUDMxLakJwfLooR6sStL5umc9DupCQPjNjP
         cQjtZQPWOSfcqz+yqH4Vl4oBMsppEY/do33mq82/Fj21meRDkZ7DiYXVcLcHdHSWmQIE
         JgSr0J/SGSJ8+QFmeQyCh7EuM1GytudHwxHpjOPWxWe1UH1+g1gaqQBRBpDVzyGQNRII
         /l2OCKrBVrIoGdrUZjvwbQCTx6/CUnkz8Iwa2zEkR4vxY0HC7cqRbJbdqgOb3zkg3p9l
         kzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CF69ZQElF5CK6mfivUiH43J5x0+bLb9TXIUZbjTAHow=;
        b=mX7+9UGTIZU4x6pneViOUbXUc0rApsKfEJY7+XtT+BxbRZ8lFqv+VIJW1x6O095ZXC
         8MaLyJGeievfoQ1qwv/09sLjhAMr58PmmInkKNBUPUwboC9kuvgNLSM8kJMdFZ9nFlC3
         iXlYSEJ9kczNq5ekZxBx+LBzkph09Yf7DZu61crEmhkGc+G6vOSFfSe0YlYG42biBke6
         42tm6Ug3T+MndIWuzEAmf7b974gJBtTJV/46Wm9xmVIYdUBD6JUb/c2FOmYFLLttcgTo
         0GZpTs7UWpTMtbGenAm1qwc99iteX3HUPdh40l691IvhPr0enuAeiTnSVOUttwH2TwGO
         5hpw==
X-Gm-Message-State: APjAAAXuLjyGz8n8YNd4ceithxwmcKL7he5OXLnEjW5R7Lar3GSF7Gd7
        V4mT60surQoP0+seQid+lgYDs1ehy/M=
X-Google-Smtp-Source: APXvYqzJovcCUvZH6nbPb0ovnN5cRJdYKxsSBUhXyxKthkTaLzgPrNxURuEHSbezrqOKm4c7JuCogA==
X-Received: by 2002:a17:90b:90d:: with SMTP id bo13mr1570793pjb.54.1582584529477;
        Mon, 24 Feb 2020 14:48:49 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a36sm13847524pga.32.2020.02.24.14.48.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:48:48 -0800 (PST)
Message-ID: <5e5452d0.1c69fb81.627ee.50cc@mx.google.com>
Date:   Mon, 24 Feb 2020 14:48:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.214
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 58 boots: 2 failed,
 55 passed with 1 untried/unknown (v4.9.214)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 58 boots: 2 failed, 55 passed with 1 untried/un=
known (v4.9.214)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.214/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.214/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.214
Git Commit: 7ce439266f602f60f05dccf964a8685e53684a9a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 13 SoC families, 13 builds out of 189

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.214-15-g4d9c5d6bb1=
c1)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
