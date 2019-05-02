Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10030118E3
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfEBMUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 08:20:43 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35008 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfEBMUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 08:20:42 -0400
Received: by mail-wm1-f54.google.com with SMTP id y197so2361944wmd.0
        for <stable@vger.kernel.org>; Thu, 02 May 2019 05:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cy52rSJzzivxljOHLWomcy8yR5XWBsQU5Bbag9d9VkM=;
        b=XtdE5c3cUWILn5GbMvsPBNkfsF59x9DNpdmw2snYgVYpQowdM2RFAWdWr67l3sZhPb
         A765ahStkWpQuqb0sbYMWx6HWIrnHZoI7cxRAKwsGSi3iNebWwAninQwcwyaXWf+zc3Z
         rlW2tsQ2zYXFFG7fRy+RZVhAnlPRbbymjeSjQLFNzRp+XW61mJDL4OjJgfwuZffm7Di+
         Q4dZU4O3VPNs5peXIEPuv9er0rPh49sbINAXYkU/hKo1OsuLFNu0elPlEhYZ4WwGfXR+
         7aKGTXvInzn+x8kjnoGgEkrA0y1AmbMloDemM4IEr0deqrlbnFZBdeWyeu/2rcGPmm3N
         BSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cy52rSJzzivxljOHLWomcy8yR5XWBsQU5Bbag9d9VkM=;
        b=K1i5daxvbU31wtX81BTXZfVJSZMzvnrztu1jPsKLCam8DDrd7B+0PUuR6ldKA9UZ21
         spwZABiqH4pbJFQ1STOz/foTigy81FJtxY9aHLPFhpCpjIcsWt5c8ilLdhUrppt2nCEz
         bXNKKXFCqgmcCLBDh+yS9o6mYfayCk8KOPM8DfivOApsrgzq72/7bX7xFWZ83ZrGuFhG
         NGp144V8R8CIXPZXudr1wCs6gfSBAeaE2w4CM+K20gwKwNSvyOQaNVtFr2yr+OjuaGau
         PJB1CU8MwWx5FkOA0W+PONSQK+hmLI9GeSljdAz4ctjmnN7brjaMVEaSaNzE328xcER1
         n/Mw==
X-Gm-Message-State: APjAAAW7jm3QyWQZKosvHLOGeiFfGv3qhETHk+N73WLT2Zu9juZhBzjC
        cLkD+TG7Pr6DGoYpNFYrloa4EZ4HPgTksQ==
X-Google-Smtp-Source: APXvYqyqRoVkPbSUZvwEj0IbphJ/WuxrUshi2U2N/IXFF6yM8mbXHDPLujEWVaCxVA/5vLRyfs/Nig==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr2244353wmk.9.1556799640938;
        Thu, 02 May 2019 05:20:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u17sm5747958wmj.1.2019.05.02.05.20.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:20:40 -0700 (PDT)
Message-ID: <5ccae098.1c69fb81.c36e5.e219@mx.google.com>
Date:   Thu, 02 May 2019 05:20:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.115
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 55 boots: 0 failed, 55 passed (v4.14.115)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 55 boots: 0 failed, 55 passed (v4.14.115)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.115/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.115/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.115
Git Commit: 1c046f37313210e0c41b036fcd14c4bdb1581d47
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
