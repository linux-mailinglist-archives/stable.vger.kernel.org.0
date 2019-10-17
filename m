Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28424DA524
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 07:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389356AbfJQF3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 01:29:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54684 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfJQF3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 01:29:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so1069562wmp.4
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 22:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QD0Oq1mMexeJoWDFiZuSQtfzl590WmYV767SK/emmVQ=;
        b=Dv1Cb3BOSOB8wmZL2SkRomfYSUQO3W1DC4JtwEgdZRHSGTYu/U+QkqpLyCQRBlMPFO
         GG16+zoCM6B0JGuIgB5shMr1LvxT0214bVOLnAxhML30s3gCgVQY1y/R2cgyebTh1+4X
         P+u765BhTmTNNby+xtaaTny0TE54aZBngosD4fbdjIKQgnIELLaEg90BI1XCEvwlBKMx
         Ywm5EwjQtwqo4tVT/nWRUbKsRwk31nqv7z22a8m5grg0X+oKURI1D4uCCtE+4sOnyOar
         rsUYL6piGjuWJ0502SPJHSt9p20Y1zX5VBUr/1AB6+LBLlsGzXYXMSxdj9uLCCKpgUF6
         emEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QD0Oq1mMexeJoWDFiZuSQtfzl590WmYV767SK/emmVQ=;
        b=q7Clu0LLn1aQSzpm3cVFHjP6B82P/uRsuk1yw6pO+9xRKPR5v3tOFxdyr6YubSOq7k
         bGqnF75hPz8on5QAfOhGLhT4/RJtJdQAK9oHTo1cyxWTJ9ub7LabS1TKSPGBjvQnhLtC
         hU1TNNxQPunQ4IZokzc+NOaIuz3dPNV79pPzQ4B4wyF3fNLhJY6uji6BSYpEWqSiE6LJ
         8l/STXnoXXTHHi/kb46mx+GLrBAbcOLT5iaWOqVboRaGpthQ3QzHmnw7/JBEpFxx7UzK
         71oRSNM7FfIh/5QJUIHV1CrQv+g6DXwL6xgp530Y3jNWIyKaziOQhKho3K9joe2F5G1f
         /inw==
X-Gm-Message-State: APjAAAVn5tH4tfzAIYIAtvZkwwiLeDyIYnCAC16G5wp31mJqlZ07nTnK
        qoMpLfs6N9d3/EFOIhoYBUzxKPNMyiI=
X-Google-Smtp-Source: APXvYqxcU50pexKIshM1XVcP2wRZ+zdagNaTQpEznaII+Zh3Nup66npxcx1GK1oho/HSAU/ep698rQ==
X-Received: by 2002:a7b:ce8f:: with SMTP id q15mr1108408wmj.3.1571290180993;
        Wed, 16 Oct 2019 22:29:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q19sm1355012wra.89.2019.10.16.22.29.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 22:29:40 -0700 (PDT)
Message-ID: <5da7fc44.1c69fb81.80711.5c14@mx.google.com>
Date:   Wed, 16 Oct 2019 22:29:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-80-gcb63cd392f38
Subject: stable-rc/linux-4.4.y boot: 72 boots: 2 failed,
 64 passed with 6 offline (v4.4.196-80-gcb63cd392f38)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 72 boots: 2 failed, 64 passed with 6 offline (v=
4.4.196-80-gcb63cd392f38)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-80-gcb63cd392f38/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-80-gcb63cd392f38/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-80-gcb63cd392f38
Git Commit: cb63cd392f388e3874d4bc23b0090c3e137bf22d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

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

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
