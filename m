Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C999F247A
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfKGBqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:46:12 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:51945 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfKGBqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 20:46:12 -0500
Received: by mail-wm1-f49.google.com with SMTP id q70so612620wme.1
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 17:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BSprl8evJ1t/X3PiVBszfB1TNimV/BWSl46JjWglFNo=;
        b=tadeudKu6sSj0xzVhKtnjyLd1NuVzB4TsiZLp223QHxoq1m1Cy8HvUxQrudIJPCWX8
         ZaLkYUMkoM7+a/UPjl+4ze78BzDj1c9hfwRsh7siXpWetPQwRETWrQRnAZsQESfIS9y0
         kdrfOEN4R8G3CBRtdMUQrZYjMW3RyWnFBlcz1+zrHcTs/7xs4gc7K7v4Tp3SfGZpFwxT
         ecmvYlTm7miukOqp51ZanLE1ap92ojFVCQ/fUUtknSwhAz9qf+d/w1I5djQ0LEtE3nO3
         uH3ZlZnF5JMcJv7YmX4WUsSygjl9uVg6PlzQfgunALIej7yJp3xtq3/T/NFFv2cBIyCs
         2/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BSprl8evJ1t/X3PiVBszfB1TNimV/BWSl46JjWglFNo=;
        b=VbULd0De053+v9uVg6/pyjy5dHce+oJSejX8e6c3hu3CDxK0JMm1ATeQPjsxh6JXHM
         waOFggZpgK2EpZ3swaTNX2YFj326C4lbATzTvg4rlIYbM6SGtTyG+tai0DMtL1Msm25m
         kAvS0u5EFaQHHnZjeRBaHcXwAglziNfxgnsJBGw3SaE8wjM/qqftvMiS/BZGNVj55jFw
         KGreTGNP8F+SbKzuCqvXh6cEV3mAYngdczBc8f9IkQDfTCIj9kCSWLf+TJNA79IlYy+R
         36CcY+UUAv+VtlqqRXbVe9qTgoRkx1Y4V8B+MQ8LpAGbGMwvEZ/eSA0evCGw/V7cq4XD
         Hw1g==
X-Gm-Message-State: APjAAAXvHRpmnriXpX9c/ORtFakFqWoHcHLh5+D9ohLVE3Hs7LjnDxKs
        GZ3j0S1y5Hfsfe7zoVgnWUOL8SdcAEimWA==
X-Google-Smtp-Source: APXvYqxUpg0Y1WTBy2SGHWHKoxW4uSELIqdtCtXuA+XrEwqV+uveVmA6rkCZemI0Pk9ozjEgTECLug==
X-Received: by 2002:a7b:c0da:: with SMTP id s26mr472186wmh.6.1573091170138;
        Wed, 06 Nov 2019 17:46:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j15sm779704wrt.78.2019.11.06.17.46.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 17:46:09 -0800 (PST)
Message-ID: <5dc37761.1c69fb81.14ae5.479d@mx.google.com>
Date:   Wed, 06 Nov 2019 17:46:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.82
Subject: stable-rc/linux-4.19.y boot: 119 boots: 0 failed,
 112 passed with 7 offline (v4.19.82)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 119 boots: 0 failed, 112 passed with 7 offline=
 (v4.19.82)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.82/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.82/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.82
Git Commit: 5ee93551c703f8fa1a6c414a7d08f956de311df3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
