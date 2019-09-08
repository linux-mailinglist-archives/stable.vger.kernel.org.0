Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F82AD04A
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 20:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbfIHSFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 14:05:22 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40891 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfIHSFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 14:05:21 -0400
Received: by mail-wm1-f41.google.com with SMTP id t9so12114557wmi.5
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 11:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R/tMouH/+kXiKuWJxWAzZqQZL8Ha5GnHrKRcNsp4f2k=;
        b=uMI2V9c5G/DTJm76aq7R5dGXFwWSgyzfFYBQ2kzARyiBQAq8MzOxURoJrDIE9HE/H+
         K1kLdwb/hygEMfi/NoRy+cw6hcqFxXG1/PjPV48FXcRlKqamnXbVvOMZbIEOlix/tCSC
         bLTIMNuN052yYs9ACofl4VFWRocaUUjAYdrCqGQ9ebFJcWJ7ShgPdtr4YftuVRCYEff9
         TRcFy8sHssH/TEYBaDWceOA5tONptc4zA/luIlhn4Srz6rKaqX3KCSgqEh6XEfCCTuXB
         g2E3Q3R0PE060HiqojOY6ly/uTpPaCf1XfD6Bb3Eu5v5Ny3cIeknA99aU6WR9oewnqQG
         P/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R/tMouH/+kXiKuWJxWAzZqQZL8Ha5GnHrKRcNsp4f2k=;
        b=HAISRa+oAxRvqFSykAnc5tln2eaSutdx6ZnFeGoGUPnQaknLZDQrklUTOGvu2DpKW6
         /zbfnqI/gkZ5TKfCZbuyim86o770uWl/Rkm/cr/EghtfDOScOXiN6I/1na+r2gagY63j
         4Tfo8mNnQ3cEcMZVOb8Zt65pHu5XBtnf5Pncnd4z6plfNcQSAqrsn4z8DQPsGwIYoqOz
         lrcm3qwzntirtIHtzsaPyGcLwYVOFBJvoGLXHjWE8BycQ390TLo3IJvauLv3CzhX7BxX
         TwpFBneONe7nlKJ0LE83STSab80cvGhhPVYA5pJo7zyVLvZARIDoDm0hhOsgZiR4uUsT
         Ukpw==
X-Gm-Message-State: APjAAAXX7pXKrkhDBjjLj/JkmycPJp1+LW8mdhrSckLQtETiGoam0V4G
        VG6SjROP0Yx6tn5Y98gsiP0DfVXykwo=
X-Google-Smtp-Source: APXvYqz3TKLlRzKGiXk/GRQ6zyI/HCb9Hd3wfkDwu3kBFXnj7vP1snrhuV5HRP8mUFOD33UCK937cg==
X-Received: by 2002:a05:600c:23cd:: with SMTP id p13mr14212629wmb.148.1567965919366;
        Sun, 08 Sep 2019 11:05:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i9sm15451002wrb.18.2019.09.08.11.05.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 11:05:18 -0700 (PDT)
Message-ID: <5d7542de.1c69fb81.799b5.838a@mx.google.com>
Date:   Sun, 08 Sep 2019 11:05:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191-24-gfbce796fcbec
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 106 boots: 1 failed,
 97 passed with 8 offline (v4.4.191-24-gfbce796fcbec)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 106 boots: 1 failed, 97 passed with 8 offline (=
v4.4.191-24-gfbce796fcbec)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.191-24-gfbce796fcbec/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.191-24-gfbce796fcbec/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.191-24-gfbce796fcbec
Git Commit: fbce796fcbec98dc9e077846a5b7ba9c0f42d0cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
