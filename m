Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79C915A764
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 12:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgBLLLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 06:11:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34880 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgBLLLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 06:11:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so1754181wrt.2
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 03:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lfg2rL0PWzfBufqhPQNBRJwvbqxvDijbN65HosNMZBs=;
        b=FmZlBDTkjdyi/EfNAkPeKgGN5/pfUAWzu+9nwKN3x60t028fxSKWgnQrOHwi+kd7Qv
         E7ePl7uX8JTNjgypWRKqEU+vTjyukZfEFRUcj72enPExftO7N1XaYvtt1vnZF/OGlOmd
         LITC9vYoIHyvnL7dFs//14NtuR2VghVzTUTlSy1G/wkw/Vi+Tu+s6wG/5DPvA3pD3Wxv
         h+/JE5VUgE51fUVg2vyfmK9Ydcxg8vYtEXFprUfQs/eUVny6Za6TVCRhG/YWAwcb1ekb
         7jcdkYxNCo5R3BtQyOf1znx+coO0MqREkGq6LP/CYqEOJlGCUXcHBD6IRFkCxHIveBbq
         afZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lfg2rL0PWzfBufqhPQNBRJwvbqxvDijbN65HosNMZBs=;
        b=to+kEh0ZTL9AuPcml/UaQUMLq9s/745B3n0kFg+AUT1yHdARAwsfL13jWA7OUiLGTJ
         6KaLPzptCFzTvgP6yKju1yKJgaw3QZVpfQdteByo9TJBgb4T+Kaxt7+RvXTsKSz5au5V
         NW9vXzEFa0ZxgpP0N8xnB0J56ZBnv4t8an7ft3sH1NjbrYo0y1N9ZW1rd29JxDlLiYqu
         ymbOjzGm9WDKj/26kkmdPC1tLQYNQCQxUDLvm+UJ4SHxdOsjO+4VWJPAFiFdR3ZtDV6k
         e/uEeXMcXkhkIkmNzIKc47lakVjeXlbOxlJOuyJ71lpfvB0I5oWrqIyweUiUI5pP7ZJf
         cv0g==
X-Gm-Message-State: APjAAAU97lm1ajYW3cb7j0y43jK8nOBt9XJ1/JLFdFGxPWAdYr3vvEYq
        iMuqefZlPWMe58fS6LqJKy1k77pF5iOZUg==
X-Google-Smtp-Source: APXvYqyw9Fe+km6NCoRDW06BYPkqgaq9W79iaZgcCaNRoLll7mGvEOPLXOUrwCfMQBLacvuTzWPsRA==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr15618787wrh.371.1581505867449;
        Wed, 12 Feb 2020 03:11:07 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y1sm245666wrq.16.2020.02.12.03.11.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 03:11:06 -0800 (PST)
Message-ID: <5e43dd4a.1c69fb81.98225.1791@mx.google.com>
Date:   Wed, 12 Feb 2020 03:11:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.213
Subject: stable-rc/linux-4.4.y boot: 27 boots: 1 failed,
 25 passed with 1 untried/unknown (v4.4.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 27 boots: 1 failed, 25 passed with 1 untried/un=
known (v4.4.213)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213
Git Commit: d6ccbff9be43dbb6113a6a3f107c3d066052097e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 11 SoC families, 5 builds out of 146

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.213-31-g79b2eedaa4=
6f)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
