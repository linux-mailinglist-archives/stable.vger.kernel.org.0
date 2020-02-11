Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2755159558
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 17:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgBKQtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 11:49:13 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52352 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgBKQtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 11:49:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so4450776wmc.2
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 08:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jF1GdTgffiRsLbQJf8GzT5DZGuv/lpMo4/69aotPJM0=;
        b=O+MC+beDYP84P1ZPezXW1YGgFd7Ff0kdd2hB1Og4TafVFAcfKdOFe+O442Wrvxl57P
         iYdDPL2tv5mIndr6X5+e9jxVdw4FvXZ9140jwQTdkoSGkK7mLWYps6Prd0lKYFut61Fm
         3n0grly9JNhUb+M17j0AcWgSMjTb4iwlQWEfJSceUmB9RzRs5hLFdrUTvMqzKuzEqaS/
         21IllSSDTzjrdXB+N9BcXfLOttfdeQoBNTijqSE6+Ioo4ocCQ4bsiUWNFR8Qk7mGez7i
         Nnc0x/aGjSKty4AektninvJ1XEViGtRGn22jZSV5byrF/p4MmdZZBVBni71mcIxV0E8N
         JlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jF1GdTgffiRsLbQJf8GzT5DZGuv/lpMo4/69aotPJM0=;
        b=L9XHwYqOwOHo1g8I451Hxwpj0205CMnERGmRoZGhb6bmL7icOmco3XGgwSfNzoSoVt
         A4NVFwcO6tIL6eaN7DZ2PcCUQjO5cUEM0p6SDWMSOmrUgyjpRXDucV/JQvXtcHnxhiny
         /ZtdiiZ9gy/kbVPR6wAFz4DNUxqRpat+D+IbyZyWcVyuzvCB0okn6gKgF5pFarr9VONV
         +NW8eT10VWca2FMditZHsa9DgOdSIeCHuSEsthO/xTBk4JoW9UOR3si5IfuxYqFAuT+I
         G5ivXRWYw5Rpr8hitq7iXFiCKzaO1M8ZpeRX0MCXevNG9SbxO0Zx5UkHX4jBU2xbQFTb
         4PEg==
X-Gm-Message-State: APjAAAWOmbj+IQZi7kaG9ZnoJ9OAkXHx7TorvV3Mjwa3VWWNz0sSTm+5
        IwgYbKHlEmFVEuzs36lvFoaT7UABSYKZ/w==
X-Google-Smtp-Source: APXvYqxMuQdlHqBPoOP7g8WF5sJDKZqv2E92OnnRD0skt7UOCDOgPN/bDzuSt+I3mskIP9poo0PWIA==
X-Received: by 2002:a1c:9854:: with SMTP id a81mr7355wme.1.1581439750227;
        Tue, 11 Feb 2020 08:49:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w15sm6220436wrs.80.2020.02.11.08.49.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 08:49:09 -0800 (PST)
Message-ID: <5e42db05.1c69fb81.c7e32.e2fd@mx.google.com>
Date:   Tue, 11 Feb 2020 08:49:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-97-g7cabedfff38a
Subject: stable-rc/linux-4.9.y boot: 72 boots: 1 failed,
 65 passed with 4 offline, 2 untried/unknown (v4.9.213-97-g7cabedfff38a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 72 boots: 1 failed, 65 passed with 4 offline, 2=
 untried/unknown (v4.9.213-97-g7cabedfff38a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-97-g7cabedfff38a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-97-g7cabedfff38a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-97-g7cabedfff38a
Git Commit: 7cabedfff38a71e90e1bd9f85efdbdf827c3ea86
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 18 SoC families, 11 builds out of 129

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.9.212)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.9.2=
13 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
