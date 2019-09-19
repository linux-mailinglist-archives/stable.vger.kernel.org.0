Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B7EB79AD
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389446AbfISMoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:44:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36018 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfISMoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 08:44:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so1358270wmc.1
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 05:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W6+l9gdQd07oOGauRdTL+06V7I0CcxijKmiNXGOWrmY=;
        b=T00lehzN8Pmf79RrNDFOE9cqW1wMw/dhNwltoT4qaJ04II+JfpUnIRKm8/ojWYaetX
         EVOalwhufLC5fhbkN/6sg5BasLGY6Dv4af6+1fs4Td3CDHl5z8yJDRZ+qZahJF1HqBiv
         WuoZKRhACI0Lg0OjHiqdZu9XAtGCAXWiYr8eCAPxU/oSLPnlXaqymjDaNOO1cYuNqzQT
         q5K4lF56v5PBCF9Ak1jG99aDW5/oKF3bdfTS5MuXbuphowM134Dhau5xuSi+bAYVuGEU
         6TJTokbng9ppiDD5dH4GjlGgUPTBGPQ9Ec0wNrgN3i4/F0bM2cd7bZ/Gr4Asge9k2+M5
         adqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W6+l9gdQd07oOGauRdTL+06V7I0CcxijKmiNXGOWrmY=;
        b=HaKsAcPFH5QD905Luuv/+jlnEMsA6KwedLF+GITuKBq3Cbmp/9x+ZhXEst/w+fed0Y
         +jCauahdSoKj8Jz2NjiQ/X9gQFThjopn/2rF4L/QpXAJj2/D6jLEDZM/HRmJKZEhOXTl
         vqgIl8VuRQ8HJzZxnGFpLHALGPv2mO/5pn0LifWw7TRxB/FfXBMhbfK7nlGk1yQUivu2
         cCkA/6I6dgouP9oEOXA2/pT4hDQ7Hz4Mv/6gh4vZ0mcRlRm4dnECGKQzkf/NHO10Qadw
         04oevOTcHWoIgt0uvDAxdAvbXo3jMokImtqUwjIwYM7iHLYZjBYxOhYu0MtQM6vfwd+F
         eFAg==
X-Gm-Message-State: APjAAAWZZU8ZmCC2HDH5yJZTw+jgPQWpXIlPIovi2f/HvMr1GvKFw7oe
        Kcqo/qoRq3NEvd7e9l6ApEYcgXh0YQWx7A==
X-Google-Smtp-Source: APXvYqxDFddAyue452jueYQLDHQk4QdQ8ispAdvmAmu7RsMIcF2yrduCG0PhxI2YLYA5HPffCu4jAA==
X-Received: by 2002:a05:600c:20a:: with SMTP id 10mr2955049wmi.75.1568897054076;
        Thu, 19 Sep 2019 05:44:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n2sm5023913wmc.1.2019.09.19.05.44.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 05:44:13 -0700 (PDT)
Message-ID: <5d83781d.1c69fb81.1734a.6a3e@mx.google.com>
Date:   Thu, 19 Sep 2019 05:44:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.145
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 81 boots: 0 failed, 81 passed (v4.14.145)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 81 boots: 0 failed, 81 passed (v4.14.145)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.145/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.145/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.145
Git Commit: b10ab5e2c476b69689bc0c46d309471b597c880c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
