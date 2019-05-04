Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14FF13B86
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 20:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfEDSQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 14:16:17 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38208 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfEDSQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 14:16:16 -0400
Received: by mail-wr1-f44.google.com with SMTP id k16so11872913wrn.5
        for <stable@vger.kernel.org>; Sat, 04 May 2019 11:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6rNsj0ZT+uN2F+lI52cSsaVO+r8mdkB1QltZ73Xyud0=;
        b=f00kqVn0ZDNo9RiJD9Ja4fXsFFM/h18TR8pAroJxNv7ebxiiFVSiUMd72rdgE7IOQY
         MAgKVPceAY2FUgfpWrQ/O5+/jyZYf+UpkG7ULjuqhdA88t9B7PXcWa4hcs9ttBH/NKGd
         Uc3CHWyCDC0LJeNr9L5vITJrBsZlZWaa193VNCa9OKJhTY9uJ5cr4HOKirj9ylDBIbG3
         uoG1x91v4V/QzJFecwEChb6E/q+JBJUcYfBxdGHvzZZy5z0+f9awBwgbKNAsiT8ZpvSr
         PIyW8W1XRadHXbpetTPryzoYOHg83SyxsHGJWW8iL1Y7rAGPybgofIPzgp+MLLz8WJs3
         7hGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6rNsj0ZT+uN2F+lI52cSsaVO+r8mdkB1QltZ73Xyud0=;
        b=cq0A0fPxIGOZ6IZg6nxvQAbwYkG8CQQZ51Kqx1DyO6dp1JPD+S9CRPGj5oCF4feEV+
         UkULGFOWESCJ6t+jh+IxqYfLZEDXrpWmoir9tdrpy0uBxlN8lp/tntwtMn+nizvaBb0R
         fy5KNzC2ZY37h/eOYtuiSdqo9nwo4rD9EBsCWUmAMquV73R9+L6wyWg/SvUtxXc2jRRo
         Vg0GM2150ea0RTUebIPs633mK87d0bVyTXD7roW+3xJy61Dzof5dU5zJlGEBEBKIYeEg
         RnaOrc6hxgM43BgSU+KZb6gCzbTwNGmRGLwB4DW8ywK74HAHnZfrUSJlWOq0Yc4yQuM/
         9vBA==
X-Gm-Message-State: APjAAAV6n8jz7EtHjXpG0HeIXyyoGc+xTCQ/lbNXnya25cNrfkAC+dFu
        wrWxs7vViy2pWx+NWZWR0xLFOFWaLwQ=
X-Google-Smtp-Source: APXvYqw8vSvlieAYejleJruz3EJY5xrofhn/uucE7znBgpD/MVQXiVel/StDFGub4QmJP5Wff6FqxA==
X-Received: by 2002:a5d:464f:: with SMTP id j15mr11872913wrs.265.1556993775593;
        Sat, 04 May 2019 11:16:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b12sm8452415wrf.21.2019.05.04.11.16.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:16:14 -0700 (PDT)
Message-ID: <5ccdd6ee.1c69fb81.4a303.f7bf@mx.google.com>
Date:   Sat, 04 May 2019 11:16:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.12-33-gc6bd3efdcefd
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 136 boots: 0 failed,
 130 passed with 4 offline, 2 untried/unknown (v5.0.12-33-gc6bd3efdcefd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 136 boots: 0 failed, 130 passed with 4 offline,=
 2 untried/unknown (v5.0.12-33-gc6bd3efdcefd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.12-33-gc6bd3efdcefd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.12-33-gc6bd3efdcefd/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.12-33-gc6bd3efdcefd
Git Commit: c6bd3efdcefd68cc590853c50594a9fc971d93cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 14 builds out of 207

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
