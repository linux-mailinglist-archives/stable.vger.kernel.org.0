Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343A3CF0D9
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 04:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfJHCgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 22:36:23 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33442 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfJHCgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 22:36:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so1300286wme.0
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 19:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+DC0sJzdQdnZYlU58EhKNqOiSIFUUpwAiTwDxcaV4BY=;
        b=aD7UZ42RW5wcaYDhGTnzt5MISxhPe7Bb9hPDTSD9st6JUHwQNS7Y8SlkKjrQ+ILUgf
         3CpFKSWjPekUnRFrWjvzEmJug4IWweyK5gVeJixxNYK3Voi0I51VrgfIb8dwJ0GESCpw
         eVeSOowcsqIa6EYAJCDnKEDcHk4VzsAU5j7Kekvym1x8s8ABoZGymRYlLh64SjJiz5Eg
         hQ0aESkupUPULgDbTlh1CoOpmHq+jKAtc4t19N4E7ygoh5vlhD1ITyTEhmatfegH66A/
         POoCVsov/JWNTfadjyBbAMjKGKClh3hXlszmwGO8JHQm3HacQt7Vww+XCKLVGYgsvjL7
         jm3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+DC0sJzdQdnZYlU58EhKNqOiSIFUUpwAiTwDxcaV4BY=;
        b=o0UJsYgA6ypXpf1/GhDqKJu2O3QtN23/AarcaSJx4KlEd2wo6bNq2l/CjjBsWfgWwW
         Mx5ZNMGjBs6nzu66g8D82xrkC2TfcY2JgAIMN+YfCbQdHNM1ALw7xU86v2Ib55Z/Cd3O
         U5I375NZNecCLKa6P1PkKqjGU6udH0raQn9hNnlbfofveUg9gwWJ0QWNO6S7vOd7TeQG
         VUdshATmdf+v9WHSjby7LXIhBPDz3V2a4i0P59fHDO9Lm16wx4sXjKxEsVZq9pikRvzx
         xHFYKn4QDjd9SmW0KjFH9aROLhBaHtu0X3wtivlc9Vt8jsQFZW4bLeORYdCRcS3CGuwu
         Bngw==
X-Gm-Message-State: APjAAAWfMJo24Xhmho1b2F43YjRpO5EDL5X1sD+WeyM8OcVe3rP3XED6
        jOyoGxvBGMBJBvoEYffI8ugsHd8PfWtOMA==
X-Google-Smtp-Source: APXvYqw/lpngzjDn5F5EPMMWXEKu35Kfgqo978K0+7QKbuKR0KX02BEHMcx7Yav7GUAjvMSE4I7U6g==
X-Received: by 2002:a1c:545d:: with SMTP id p29mr1845587wmi.9.1570502180861;
        Mon, 07 Oct 2019 19:36:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a9sm2692234wmf.14.2019.10.07.19.36.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 19:36:20 -0700 (PDT)
Message-ID: <5d9bf624.1c69fb81.8c9a.db93@mx.google.com>
Date:   Mon, 07 Oct 2019 19:36:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.5
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 79 boots: 4 failed,
 74 passed with 1 conflict (v5.3.5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 79 boots: 4 failed, 74 passed with 1 conflict (v5.=
3.5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.5/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.5/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.5
Git Commit: dc073f193b70176b16ae3e6e8afccee07a13df90
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 52 unique boards, 18 SoC families, 16 builds out of 208

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
