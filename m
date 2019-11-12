Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B553DF8F0B
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 12:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfKLL6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 06:58:24 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36249 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfKLL6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 06:58:24 -0500
Received: by mail-wr1-f48.google.com with SMTP id r10so18235909wrx.3
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 03:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SnU5u4y1K/VPwTC9oVm/EV0xv4fgHNd3NVhThOYJTdM=;
        b=Csyvh2jHDt6mfC2QLmHEoCU5MG9qlQLySmiCZ6DWHQma4jJ64PmaOVsrhwCF8n1grk
         hsThQXq5rKDNP/Y3N9NtJBzjTTU97JhxWFbc5MMs2VfoN05gAydhx6/YKPDTBxFjRm5p
         zUFyh20IfdH2FKiYHH0JVreP3ouf1na+uYekjE36Xw0Vbc0+PllIX3AiGUCFHogq4zQC
         d2++BVPGmTQiwCQIgpial9p26PuF+Wun7HQkHJhYUl2+sQyncrMgsPyqc8/EbzSzrHLZ
         jaGZY2zYKtpZEw6vdr9/RO+p6ywSS+vA52uHL4DgYoicyxJaxikfdj408srcV0xY4swC
         UZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SnU5u4y1K/VPwTC9oVm/EV0xv4fgHNd3NVhThOYJTdM=;
        b=QZM1zHhiEbQxGivRClzv+uXLRkCcWiqKtBXHnRMu9KBL59n9nyNPZNdbXo4bzyIvw/
         2Fv/hhSlq8jjgk1+0tugq/R0LFiipAAmgAAwIxcNcolAddvfwrUyMBKB3e72BbM7kzPQ
         vwoPx3YNZCpjXgZJxUE7WaDRQqmuOduW8Z/UT2jW/fuB4jHgFa4jI6G5SgeR9dosaT9q
         fy0Uq8HRGiW53nrVo1TZaifllIzdvndJV7QLPYeWobXiDIojYHszGQpP0p87vQoYadQJ
         itpzXDeZ6RfNV6/yGIZDC8wodCd6VKpqXDuNUGOVipJ7Bqaf8cnoqF3/qLWZJ6SGpsYr
         l0AA==
X-Gm-Message-State: APjAAAX1XUuHIdVmLO8ZvksQIpXUXHDv266DDIAF/8nWH7opS1HnlW+T
        daH59dTX3C7iZn1IgqZisQK0DYNsF7tDtw==
X-Google-Smtp-Source: APXvYqwqEZTeHy4+wply+n5WOpvCK2Znx5Nc8EqMq3FbZZDpxjx1Io2JscF+r+5tVOQglKR6TQCV2g==
X-Received: by 2002:adf:afef:: with SMTP id y47mr24763307wrd.190.1573559901676;
        Tue, 12 Nov 2019 03:58:21 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q5sm2567225wmc.27.2019.11.12.03.58.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 03:58:21 -0800 (PST)
Message-ID: <5dca9e5d.1c69fb81.93211.bd65@mx.google.com>
Date:   Tue, 12 Nov 2019 03:58:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153-105-gfc7e45ae100f
Subject: stable-rc/linux-4.14.y boot: 105 boots: 0 failed,
 98 passed with 7 offline (v4.14.153-105-gfc7e45ae100f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 105 boots: 0 failed, 98 passed with 7 offline =
(v4.14.153-105-gfc7e45ae100f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.153-105-gfc7e45ae100f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153-105-gfc7e45ae100f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153-105-gfc7e45ae100f
Git Commit: fc7e45ae100f042a6f3e1cb7bf47c487b2d5bf3e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 20 SoC families, 13 builds out of 201

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
