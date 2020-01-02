Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68C312E149
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgABAUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 19:20:24 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36697 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbgABAUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 19:20:24 -0500
Received: by mail-wm1-f50.google.com with SMTP id p17so4394988wma.1
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 16:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TUKZM7h/ltKCXFh7pPgNqcvhF+ZQTNDBFYlVlcgj3kA=;
        b=Q59D6mt8fPzim3e8QklP7nsX4ktypXlNiU1hCFS/ZaId/STaDYs1inApHl/xWciVZ1
         nNUsAD86JbU4k6xWjIMG28r7zrR6bK6rObucoOHgTQVsAtalhyh0EqJN0ZLpmBeglNvk
         y8mkpaj726pHFCIOJyZZvpLL6jM69B+nSQqgnz7caXjQljaeo7j1suTX6GEjyHmYr9On
         Yb22i0i2R5wG8iNR5T678StYiwEOOTrMATqWVdl5i18gb7WR49A+zn2a0KagvcH1mY54
         10qfjLG20jWpCKeZLG8Ddbk6bqJ8B2GhobpffY4eqn572rH/8Vm2xM/0v6mXJUjhVm3u
         xbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TUKZM7h/ltKCXFh7pPgNqcvhF+ZQTNDBFYlVlcgj3kA=;
        b=ptBjBNJM/RkwlQro++Ca4IxcoetI4r26f2LFLcas8kI/4qcrSexf65RkjaPA0RxLaR
         8PGDvZgRUtcAnjRJzLIt4Hl1q8hxv5LvYKbUJ1OKof/hxvI1SunWGG3Zt9KgQdNO+cgE
         0Byo4HnkLaJAhQRN5vU+PjaohYDNa3XE/u2PhG1fFivFTMPPIKX/U7MkogB5H9MJ+966
         MVrPVFuAU3c1rp9mMP/VKgjTxNTglAFi0BjfRPriLjgbx1NG3hph9sNPBNBb8NivK7xa
         Im60z9RCEd2aTadmXuZCvmu6uuBI78Yg7Fkgag3OfsEjR4tv4PgP/l3EjSz4QHSH+vBm
         PXQg==
X-Gm-Message-State: APjAAAWEt5EffYoPsPUJZGXoD3J4GYGtJTyeY7sf7DDESTD/EmqVB6fG
        p6JYkggbmGwojiBh/AQqHqRGT3GTJfHLiQ==
X-Google-Smtp-Source: APXvYqy33P75A69ofgeR6yKUKsT8N7pvIrbMg/HZxYna/CWyr3oKuMJYYhrEgn5do8+hs+3++CbavA==
X-Received: by 2002:a05:600c:d6:: with SMTP id u22mr11772183wmm.77.1577924421762;
        Wed, 01 Jan 2020 16:20:21 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u16sm6886932wmj.41.2020.01.01.16.20.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 16:20:21 -0800 (PST)
Message-ID: <5e0d3745.1c69fb81.a02e0.f475@mx.google.com>
Date:   Wed, 01 Jan 2020 16:20:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-163-g05e2f5c48547
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 43 boots: 0 failed,
 42 passed with 1 untried/unknown (v4.9.207-163-g05e2f5c48547)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 43 boots: 0 failed, 42 passed with 1 untried/un=
known (v4.9.207-163-g05e2f5c48547)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-163-g05e2f5c48547/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-163-g05e2f5c48547/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-163-g05e2f5c48547
Git Commit: 05e2f5c48547dbea78a0f9fcd8e57eb8aa513c6a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
