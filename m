Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405F2122242
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 03:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfLQCzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 21:55:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40140 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfLQCzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 21:55:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so1379016wmi.5
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 18:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aHd38S7r+i+tsknAkaWr7iqVppkS4U9Bw5IQiQmWwG4=;
        b=c0var23K2E62BSUbcrg0tLwNRTejKhbKXBcCt42uNDL+lXSq67j7e0Pr9l2iEpdIyf
         MrhtsclstICmyN6PBq6H8KYtBtBEdhrcSnp0nah1pIbEpLOyVZH6rhSc5HbOtjUXl0H9
         5lcIa7Y/XEmgry5gV6pI5iDa3fwgS+9/3Tr0Dg13QhnvUl8hskLRe541XIAIRENjYFG8
         QzF063XtjOOOCmS9s6hEYIWG5nVnX9eh8mNvBcQThhbzRR/CUhxJa2wcTZ0zV9puCneF
         dg1Ssaqa9C4wB9cAq1VORxxBY3U4QHwsvlozmqHRnjOb9iLa+EiAlzl6zUK+b9Xesa5Z
         7FGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aHd38S7r+i+tsknAkaWr7iqVppkS4U9Bw5IQiQmWwG4=;
        b=CtTBWKkQll5iLZgtpND7scfIka7N3D8zCX6zYrn7RQPiWeJMMmW4pAq0lb1iWgdp65
         z/4jeKMSqJLIWJaJVVEiKmAMeyXDgpMmluq/IHwCgrYInFJQJZQ++1/we45XyNU54A2Z
         2hrQOo04JVADdXPtWhGRfLOg0vsIDbQk2oQnH8Znul468ck+VF6QI9b5uDIGxaITViVX
         2SpPiqVF6ZCRt3FFgQoN7JCwNuVlHoftxdiSaUfCQ1F/aeBlP4XP7S1qKTk2stW8NMr5
         key8Z/3xMveAwDiOIWIXKnfqWyjEiGzs9wY0GjcivM58Oz0apAPcDEDNB/dLuZHtHyJ/
         e00g==
X-Gm-Message-State: APjAAAVhP6oAkM/G/4HvxnMsDSQQ6V2EiJGyMKMmIyqJUNkxQfIkJ+9g
        HnoJ0x5f80SRfIClx2NCURcERS8gcjE=
X-Google-Smtp-Source: APXvYqyrG7R6T+JJ5GxocdCrXzeHdykyVyDbM63L4D6qcbJ5GHbgRgB/qqPQoM846vceYGII5oUvOQ==
X-Received: by 2002:a7b:cd11:: with SMTP id f17mr2594723wmj.48.1576551309206;
        Mon, 16 Dec 2019 18:55:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r6sm24040380wrq.92.2019.12.16.18.55.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 18:55:08 -0800 (PST)
Message-ID: <5df8438c.1c69fb81.dc29e.d19b@mx.google.com>
Date:   Mon, 16 Dec 2019 18:55:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.89-140-g9cc8b117a993
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 130 boots: 1 failed,
 123 passed with 5 offline, 1 untried/unknown (v4.19.89-140-g9cc8b117a993)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 130 boots: 1 failed, 123 passed with 5 offline=
, 1 untried/unknown (v4.19.89-140-g9cc8b117a993)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.89-140-g9cc8b117a993/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.89-140-g9cc8b117a993/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.89-140-g9cc8b117a993
Git Commit: 9cc8b117a9932aaa067980374b1de1145afc4645
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 18 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
