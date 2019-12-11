Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC211BDD4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfLKU05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:26:57 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:36963 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKU04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:26:56 -0500
Received: by mail-wr1-f46.google.com with SMTP id w15so111497wru.4
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4ALktzS4L9hzga8oPmqumPYP1pQLfPYD6YettLi1U6k=;
        b=kcHIKC/7BuiSy5d+uZtfowtq3ct6C6yD+TNj2VYC4vjX9LfcnIYPVQm7D3GUAWH/Xc
         niMIsMGSk64ZJzQloZhldpNTRJoYKOuJZESerL3YzsHAxlkaHr5JvZ6reFfEvxGBcoJ9
         pixvg6GA8No2PtFB5/C8/Q4+neZkt0RI2oH1GXOHy+6QJeWwhHGJqzQOskxY4uuDOQIm
         G7vK6/JjZkdOq479B6jnZ9xbzV81IdC3HbJFZDPHLX59OxyIPzLWLyIRDV/cqTa/gfjR
         iQGKzoMjjm4c5ElM/yA5b52busC8Lq75EYC9ZBcv9vSb1eqU7VQWGwkkg3s8N1jlurlR
         p/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4ALktzS4L9hzga8oPmqumPYP1pQLfPYD6YettLi1U6k=;
        b=ej11saS4auVV5267oWiiUuE5NvC4/pdqT37xAzXoacXzk5XDKIwT3ULPZyb8NPNEoS
         0CQCDDVmC9Wark0n8XbLddyGnQlU0Ny/SpSIqsB8yfBUUhucs/CSgyrjLpQ+RCRX10N/
         0djWUXyqAgtv/AKuM0DxG4hAsmepOIkLH2VotXl8LgiRPnctI8yf6x/fE2+Vlj1xzLda
         Pg0haK62gAkzTdQayDKHpAO50AoQXo7BDp3Teq0NnHtHqTHV+/dOp6comqT5IWoq7ZmV
         u/lA2XNXyXFRbWLfUZAlGgOsoz0C/vkJ2UIQCJEp34fYdHN6ZuG6uNCu1m8fxIhzniOq
         fa9g==
X-Gm-Message-State: APjAAAWYp/o9eF05S3SXVUpwznWhf5VI92+kA/KfAmYNALHoyBj8M8tv
        MNQbrDRPtuYkkOZ7NmRdfu6Ts7c3niwD9g==
X-Google-Smtp-Source: APXvYqwo/VrhvGdfTYxGNAYuNCJRchAK1LkZNU7vFGUTUshW905hm/BdNYQ8awqm7r3FUZv6crZhYQ==
X-Received: by 2002:adf:e78b:: with SMTP id n11mr1868803wrm.10.1576096014790;
        Wed, 11 Dec 2019 12:26:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm3589034wmi.26.2019.12.11.12.26.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 12:26:53 -0800 (PST)
Message-ID: <5df1510d.1c69fb81.787a0.2bcc@mx.google.com>
Date:   Wed, 11 Dec 2019 12:26:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-70-g680ea7f4b671
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 99 boots: 0 failed,
 94 passed with 5 offline (v4.4.206-70-g680ea7f4b671)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 99 boots: 0 failed, 94 passed with 5 offline (v=
4.4.206-70-g680ea7f4b671)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-70-g680ea7f4b671/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-70-g680ea7f4b671/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-70-g680ea7f4b671
Git Commit: 680ea7f4b671397be095319bda4f20c832007bca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 14 builds out of 190

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
