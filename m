Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3411D03C
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 15:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfLLOwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 09:52:51 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42430 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfLLOwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 09:52:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so3014608wro.9
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 06:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NO6QYGGUr6HONnaPHTV82vubl31iE8JrwjIhWs1ryR0=;
        b=XpNEoEXeoSHCWyJT4dmwW6UsHOQEJCm+eZErBHPvb0zYCwNj5tIJ2hiGrJ7C5WPlYd
         JWnBFnMRrd5uHg+HoyvptkWV4mQWZxrwMFdOZoXdP6EzyZ90vGczymAUmHKrCUI+Vwpe
         ATkB3UTCp78DktC7qytGhUZKp7jR0ANYqAFs+Pt7q+Zx0o1lts1UszG9BcgnMy1tFT0/
         q3Ywjv2FFkg/V868+fh4wfuyJkImZNKn9qzeac/mdRo0PlzYhhnHw+9JHTAxD1CGcpos
         Wh5ehu6Fcr6Oqukqedtqlk4NvqlBgWxrDU6zWaPaOjnUqFvglsnmpSONJc3kMPodlnTb
         u/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NO6QYGGUr6HONnaPHTV82vubl31iE8JrwjIhWs1ryR0=;
        b=LR31oqA/k7EBDgv9CymeuEVv+jJ5xMRA9ljvYKf6bdoB2Ss61Jp3Sijcs9n69/K/Va
         RZFGl4rEiYQKpTFjF1jyfJRM8u/OfuVzxSa//BZo10+MLqE69WJX25nzBhuATHeAQAM2
         DB9sfoRTRNZlwcpyHTALLKE4Ija/1lwjoxPOGAiKtbkCJoztolpSnP+5V2JnEgYkZXSW
         cV+ukZ0u+DAhxwiPK6eFmloCWuI50yNLtElsaWWuofpvyf3zYguc6FtYa5pA/DWGJr54
         44hZnBgSQYZrbjPDUmZPNoVJNPc6+j7WM5BFCcdiK8hY/KkOWvW42MnpYZMf83yXg4ea
         tfbg==
X-Gm-Message-State: APjAAAXjBZLSsXE1VJJv0vQcS358aE79NlXVbg77vNtSENanCgFDsHS7
        OINjOp5wK36zMAdv2OBgWoAezgLdZfixkQ==
X-Google-Smtp-Source: APXvYqzKWNeRCcAyBjWaLk69AHWhyM6mP1WMMLBdNr8FL80ZOADTjngUmLunVV7e6SLz+D1M2yJNug==
X-Received: by 2002:a5d:404b:: with SMTP id w11mr7097670wrp.171.1576162368123;
        Thu, 12 Dec 2019 06:52:48 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p26sm6355848wmc.24.2019.12.12.06.52.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 06:52:46 -0800 (PST)
Message-ID: <5df2543e.1c69fb81.80ee.fb06@mx.google.com>
Date:   Thu, 12 Dec 2019 06:52:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-75-gd7e776aeb147
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 52 boots: 1 failed,
 51 passed (v4.4.206-75-gd7e776aeb147)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 52 boots: 1 failed, 51 passed (v4.4.206-75-gd7e=
776aeb147)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-75-gd7e776aeb147/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-75-gd7e776aeb147/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-75-gd7e776aeb147
Git Commit: d7e776aeb147e4a2090b1c66f7d81c61498224a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 9 SoC families, 9 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.206-71-g9e88c306da=
d6)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
