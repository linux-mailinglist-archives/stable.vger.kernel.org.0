Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F86B3B3C2
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 13:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbfFJLIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 07:08:40 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55936 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388373AbfFJLIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 07:08:40 -0400
Received: by mail-wm1-f45.google.com with SMTP id a15so8060173wmj.5
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 04:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rNNUZhRSfqF5lNvriviHHh+ZTxZr/g+Ka5HnUUtuRRQ=;
        b=ko3EUh7KO1WngtqNWpT2OV6Vx2GPhpUJ3NfJOQ9gjgHQgtFzhIqClGY7x1OIc6K0v/
         ogL6P8BFxBGn3Q+DusLabeb63zDMqrrcuTacj+ifk3eKCZgC77MEnZH7IEwINM+b49pX
         FalPAjOuBLPrMexGJ/+9RdmyphNC49XDuI2TxVwljCtf4OWz+RMohaozE8weerPy6m7s
         7xNUPoRbLQKrLvQOGQ+GvcuyVTGFSBEj/Bmu8x7e4Fse/B80Mh75Mv7vRHGPRZxUnO7i
         WecvkoK7EGk5zJ2QgKJIFhWXrgyFtxYPxppOi7NTrrKIo9HPRvZjNdfhsk+V1JyZ+8i9
         YO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rNNUZhRSfqF5lNvriviHHh+ZTxZr/g+Ka5HnUUtuRRQ=;
        b=BlEXUNbCJ4v1cDSDisyeSiK0QpQB4GKpUz70QdevGktIMsVscBySD19JoDABn7cXq9
         I9qpU1p4SbN/umOPJ92r8UMSXajnFDeZzWMELeyj8/hKG/kHQdvIgu/4i4Y9cTvmJfne
         jtp9NBBiT1Odnw8vrWWhZFIGPinTt+6YPmEYX+yCFrFzhahk2nFAsqw4h650Qb0YpFgv
         hNL4oZFYrAkcft2XmllUTYUiyeaHEsDSPByXcZGqdiXI5QLtZl5dBAoOy2ZjC4A3DpmR
         cTb/B5l01rtDPNRiPmIrcI+eNhQjZ1xz0gVHkiOqTqTHiNdYC/KQVt+2CqBHivoW5qq0
         f0dQ==
X-Gm-Message-State: APjAAAXbkk30IFnXOE9dQOOetFZ4C+3Gc3Ki9HzasfZuPJBJwfaVKoWE
        qxFJG5H/iN66RxHx7CKf3Paz+mYBOlOPvw==
X-Google-Smtp-Source: APXvYqyXXFFNNhi4ioP4PDCzTV8dXntgQdcrT3i2z1wiW4WEWrt85liBCBQlUW/55mPXdhWKSyp7Hw==
X-Received: by 2002:a1c:4041:: with SMTP id n62mr11473028wma.100.1560164918042;
        Mon, 10 Jun 2019 04:08:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 34sm11778431wre.32.2019.06.10.04.08.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 04:08:36 -0700 (PDT)
Message-ID: <5cfe3a34.1c69fb81.15962.2e40@mx.google.com>
Date:   Mon, 10 Jun 2019 04:08:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180-63-gacf4f65a64fd
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 58 boots: 0 failed,
 56 passed with 1 offline, 1 untried/unknown (v4.9.180-63-gacf4f65a64fd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 58 boots: 0 failed, 56 passed with 1 offline, 1=
 untried/unknown (v4.9.180-63-gacf4f65a64fd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.180-63-gacf4f65a64fd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.180-63-gacf4f65a64fd/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.180-63-gacf4f65a64fd
Git Commit: acf4f65a64fd9f2047b397598ce82792ef46c481
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 18 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
