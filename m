Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A778153FC0
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 09:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgBFIID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 03:08:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34604 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBFIID (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 03:08:03 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so5975359wrr.1
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 00:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1BuQm5tNx1SL1KvmL020navqBRvOcnZdta/Xi3n2zKg=;
        b=H6FGyKS0OjwZNlAUj7T7wAH3G8D8PVXu5PLZnKBquqWuzqzdZtKhxR9bR3N1tjpTYZ
         3SlBGLoyxfaPefBlLOXUZEqWy89jnItNopyY61fI9itlq0PyeiP85LBZ0cuq9MZqs+Xt
         GOY4NXy4JlYz9TeSKb7RoSppfks8iTV5KIC8CpxknKm6YPD0Hpz/j6QIXwEGFuTe+Ucc
         EXhxhwT6//NaZ0DHKOauPUa/cGB6ouv13vY4VP4jwl6ue4kbsUPYIqCRAh/JMAXd77XN
         q8GFRr8pgmKGbP5YJOHB5ja83D0R4WGoNiL/1oT/Oe2vKRtGaiC11jcbqPz4GU/wULzQ
         QNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1BuQm5tNx1SL1KvmL020navqBRvOcnZdta/Xi3n2zKg=;
        b=h6Srq0++DjlCYAKrevD96yr5YSLTO/lXrrr/ArJhKB9mA8o03suzxnHXG/9g7bHuja
         YunMMZw8+ID90BuKcYi3hxhYaDqQyb3abeHUqTKz+GLi70InaMrttAFMlEZFGFK61dBw
         fqKm02Hx7EsWYSO/I2fB1H0bUcfthagJ+Xuf4y3fMWoHBH5rCp/RjLKzM1zfAlquM61j
         WBUHqaVALv1/41gAhQiWlgwZktTGpkbdUsa5/hyanM3+7mHE+49wMh+F8aF46c4/JdtW
         +vDxteFDPUvUVVQoJKXROvMwI4jch4rBqMIoEd+/qzZTYpgCsTCm0RC7qWuaVeKxmxFL
         H1Kg==
X-Gm-Message-State: APjAAAVhgvJw2S7vFFZKFqxddXGlVd3xWTSp7AO7d5ocdHfG00JEJVkm
        iY6N9R/0Ot00/JiWIXyJNwNBdATji0vO2g==
X-Google-Smtp-Source: APXvYqw1CvwJUN9ZjnTsslPGrHPYNSnpX7xqz4GO9XmIpsCFRnepWP5I+nuytPEIS8rIIKq5waCmWQ==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr2480997wrv.358.1580976481239;
        Thu, 06 Feb 2020 00:08:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a132sm2746463wme.3.2020.02.06.00.08.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 00:08:00 -0800 (PST)
Message-ID: <5e3bc960.1c69fb81.a353d.b52f@mx.google.com>
Date:   Thu, 06 Feb 2020 00:08:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.170
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 22 boots: 1 failed, 21 passed (v4.14.170)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 22 boots: 1 failed, 21 passed (v4.14.170)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170
Git Commit: e0f8b8a65a473a8baa439cf865a694bbeb83fe90
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 9 SoC families, 2 builds out of 10

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
