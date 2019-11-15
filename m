Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C2FFDCCE
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 12:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfKOL6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 06:58:05 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:41256 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfKOL6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 06:58:04 -0500
Received: by mail-wr1-f42.google.com with SMTP id b18so9224560wrj.8
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 03:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xswx1TYcTCN/R8BEco33f7ioZ6ZLAVd47u0UZeI2jCk=;
        b=soevlNWrkuKDYLWYi490Vs4s4Yq9LKLmi4DOjTvClRb1OCcqy9GzDLGbc6icXtsSd5
         eIx/C1Unneu6X6ZrIBqCDVVPMZh+ziTIt5aASDwncppxxJ17ZJCRT0mk2DIHSzJDLIqr
         sZ4YX+kcBWm9s2d40rzJq6SoXpKCkLoxTSR/cTEhy/7JawFXlOo2FHFeMgYaI1a2t4Tw
         9PzAT3UoGTbyE8DpGtlNm8OFwrK+hm4mZKkPAQ+p1yu6/hVNsLtoyKxk2yo4mMAEn6vx
         47TJOMUHhPA6QXP9Xd6Bh2C8f/gt666e1ya/5zkWYRGeH6dAQv62iH3GAB+K2LDDA3w3
         2YWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xswx1TYcTCN/R8BEco33f7ioZ6ZLAVd47u0UZeI2jCk=;
        b=XPBh55XfG16885WhYB8B0m8JgJpEAF8szFz6OGfih7gIauNWnnOeSFKGg+JTU/Ml4+
         Z91ASMIyJBcaErs4JzaVIgvTR5eyih2VhWwz7H1+Ruqs4YMlPgViYmJa2sENL+y6luyb
         CYmCqfEzeJLELT9rtwPVMgxtv7ye4TciJyzKY3YRZwFWJzBvfouXz74RZqE5rjLiYEJ5
         i61imQI49sqwFt3jb6WGDqInDl7uGrGeGbnnrTQd5Lh4IhfzwSo+i6FAR7E/RJMiTRre
         76gcWpajjXrqObuBw8kDSKqMdke01DzUsS0v7mbtSe4zMMBMfdAGzz57ArsWh2/egK7l
         ukFw==
X-Gm-Message-State: APjAAAU2MujBZQxdrayDonQVjKkdTDw4Wig4OvL3jmetQaReh1zE1C5Y
        E/qYthJu8IDpHYA2zchQA6t1+qqRDoUuvg==
X-Google-Smtp-Source: APXvYqwwXj6T/GhOy5CM8p/d/XlG/6CQ67W29A2kWU9RwPRC+wD3xRZKlMRvim9+eGorHZm3sLhYzA==
X-Received: by 2002:adf:e74e:: with SMTP id c14mr14251851wrn.124.1573819081784;
        Fri, 15 Nov 2019 03:58:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x11sm11151923wro.84.2019.11.15.03.58.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 03:58:00 -0800 (PST)
Message-ID: <5dce92c8.1c69fb81.c5d8c.5ba2@mx.google.com>
Date:   Fri, 15 Nov 2019 03:58:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.201-32-gd7f83e4f45e8
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 89 passed with 3 offline, 1 conflict (v4.9.201-32-gd7f83e4f45e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 89 passed with 3 offline, 1=
 conflict (v4.9.201-32-gd7f83e4f45e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.201-32-gd7f83e4f45e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.201-32-gd7f83e4f45e8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.201-32-gd7f83e4f45e8
Git Commit: d7f83e4f45e886d919bc985bd225b8355ddd9284
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 19 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
