Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1CF5BE9
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 00:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfKHXkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 18:40:31 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:36297 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKHXka (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 18:40:30 -0500
Received: by mail-wm1-f43.google.com with SMTP id c22so7882744wmd.1
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 15:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8H3+XZQf7y0EzQqLefOV5zH9jSqy7tXDApOEueZQ9Xw=;
        b=LTiPiVtsIunXguyzBqejRKAuJilNe8KJtXLC2e6s9f1TvYKlPWJHpsU028TKJU46G6
         5ITldKINbkCG09wSRXFbuPK635P8F7MlvnRw8VflPojNnf5lKZJVRPOJ45P7Bh4GxV+s
         GxX8oJZd5JRBxG2oW1SfScS4f5qgPxAJWhEyDO2y83GoGADD24e4AJBJJ/LBv6YF4UXb
         xSraHmQhlLpRb8F36+LeKBWrktB9LuqA94hKHBjBaUTKEUGKspmlVm6A24LyKGl3BE5J
         4sPYBUjn5H1dstwCUnGI2zFnsDn663Qh7n1TCyTsL8oUf4Gzpt94YeSg6QdUt/UAcEzp
         GW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8H3+XZQf7y0EzQqLefOV5zH9jSqy7tXDApOEueZQ9Xw=;
        b=pB+QckpUevFaOr1lfHZwRnN3seJQO1jGzi9CmYQJghjUeggXAHRYRNKCnTvb1Dq4Sk
         UK0GWVQ5mqM6CyQ26U/l04jSapJ2tdWalukhx+qUR/OJA7Clp600Sa3TkXFaVeVJSsnm
         DULe9doYNzzDFkrmhBojHHmlRThRHNWgv43dGPWijAdOy1hQhH8LI8xSnXjxBg4Qyy6j
         A29k0RvUpy5eSyhIZ33nr/jkEX0cTzRwHIrvvrWWRBloiF99+LFXUJnAonop92CGUJ+L
         ltCWkIP8KhQDJdu5h0mwuh6uKfs/8zfPBnuzm0vKTc4Gyoy2vyUOyLwYeSg82XdbKn9H
         iV/g==
X-Gm-Message-State: APjAAAXT8g+i3w7ngyICBad6PF8GnsSsidQ58TxHzeUq6Ogo3k8/+Ex2
        lfsuE0ZZOu1vi6Cyw2xzhbqtXM1Iy5sMJA==
X-Google-Smtp-Source: APXvYqxha6WiRRm9mV1qwxp5xElUNkSurerTSAtG/dulzw+mt0Vot5SakgTV+IPVlCsa2xHr5YTKmg==
X-Received: by 2002:a1c:21c4:: with SMTP id h187mr4663558wmh.46.1573256427294;
        Fri, 08 Nov 2019 15:40:27 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v16sm8901496wrc.84.2019.11.08.15.40.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 15:40:26 -0800 (PST)
Message-ID: <5dc5fcea.1c69fb81.185b3.e88c@mx.google.com>
Date:   Fri, 08 Nov 2019 15:40:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.82-80-gb56f5a59d51a
Subject: stable-rc/linux-4.19.y boot: 116 boots: 0 failed,
 109 passed with 7 offline (v4.19.82-80-gb56f5a59d51a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 116 boots: 0 failed, 109 passed with 7 offline=
 (v4.19.82-80-gb56f5a59d51a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.82-80-gb56f5a59d51a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.82-80-gb56f5a59d51a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.82-80-gb56f5a59d51a
Git Commit: b56f5a59d51ac99b2c9af3df39a0a7a573053bcc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 14 builds out of 206

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
