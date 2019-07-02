Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431165D1C3
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 16:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfGBOaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 10:30:15 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36392 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfGBOaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 10:30:15 -0400
Received: by mail-wr1-f50.google.com with SMTP id n4so18119993wrs.3
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 07:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hghNClm75/4KZJdIxJf4/GmQX4sIhC6S5l42nPPIEdY=;
        b=y8F1wlaG2Cjbe8pbKZgOEeHAJSKRkdELH+I9eh9HWztlKugyznCXGR7PKgCG3GjA7M
         ItVCkMs1H+rh04+1LynM0Tlf0CIwf1bHg9k6L0gtqZzz5/1ZFksTfFVhut3McoPBczXr
         RWUSrmTMHmDEOfPnMLSw1eb8UczaGfWu+LFHWnJ2SYIUEqt31gNwFEB28XIT/ZnTVkpl
         JFsWmxuGVqm4xVJrS/0v6OFw0xx2ibN2yECKpLkQb292inqRn/dHNfXXEhYcvGomk7MD
         RM5G77xXUjrysSsujqLjNufeZ92nrF9+uL5WzF05u3qvE6nwnnBWah4eQQLt5biBwDc/
         Vt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hghNClm75/4KZJdIxJf4/GmQX4sIhC6S5l42nPPIEdY=;
        b=WZe4MmdF8oWeYJsj9zjlK99Fnqf0opombKLpYOs4yYCw/+DtrujNsvK6sECFqlP6QX
         05ykaYTzYoHdoOLsXabSgXqSwlrL9hj06gG7dPURy42s/zlE3r51Cc06D36PPRkRw05d
         w/4fjAjtYxhHVcUvJwGoAqjBWgmN0vUFMEzqLYXQKdXCkVv1wdIqtoC2CpqboY4vVK7z
         i77GKFw3usaOt/onKexeU91M+8PlKuhpuUFRttFdY8LGG5UwsVybBOzLXJQpC4805Dna
         8k4oFA26zt5EU9c/amGooxAebV77z+XwwfAS+xUE0EQdGRJaUTbMwOqjjjrPf44JINiO
         +f0w==
X-Gm-Message-State: APjAAAVzn5iccvDvrU9ctT9YggCwawb4AkfxXuH6XB94/mFcb8pV38mX
        UNOo2EhJGkazvqRiZkxjEuDMj4mfgVepSQ==
X-Google-Smtp-Source: APXvYqwFHUH+mwSw/0+7+1q3mEtQtcyP0dTkcqjNzMrxhLIdDTHW5SoMLo2nB8QBsP4UhPLGHdzvtg==
X-Received: by 2002:a5d:670b:: with SMTP id o11mr14202711wru.311.1562077813122;
        Tue, 02 Jul 2019 07:30:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x5sm2942294wmf.33.2019.07.02.07.30.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 07:30:12 -0700 (PDT)
Message-ID: <5d1b6a74.1c69fb81.8d6a7.172c@mx.google.com>
Date:   Tue, 02 Jul 2019 07:30:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15-56-gbe6a5acaf4fb
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 135 boots: 4 failed,
 131 passed (v5.1.15-56-gbe6a5acaf4fb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 135 boots: 4 failed, 131 passed (v5.1.15-56-gbe=
6a5acaf4fb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.15-56-gbe6a5acaf4fb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.15-56-gbe6a5acaf4fb/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.15-56-gbe6a5acaf4fb
Git Commit: be6a5acaf4fb84829cc456c77af78ef981fb6db2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 26 SoC families, 16 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
