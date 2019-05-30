Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671302FA16
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 12:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfE3KQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 06:16:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35844 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfE3KP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 06:15:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so764443wrs.3
        for <stable@vger.kernel.org>; Thu, 30 May 2019 03:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UJxPjDVPTtrssnfg1ZQ3ktKHAmxdLWyX1YJpyxzMclE=;
        b=lYd5AIxoVegqNPlpoW2D6M5Fhl9N91Ihct6kt4n0yvCXl4LU+wOLY31UwjW8wO1FAU
         ljQ/VuIrReFToPd99MPAkDewglfQyQd7RifT3k02krfijcbutYNRwI6EC6HjgRpDIcgm
         M6ibBRSC3oIdYBMOHOBNKmr7uU3P8hTsTvR5wDOwwJx4jsx4AVbgQbrNhb6tGoiCELjA
         L9TjLC7Byyr+xsRbONFQV5lJLv0dxWNhArtp+Rd3jNNcwnrSIsubaNYEAsurRuAr6wNn
         NE7zMvVPZ+ozdGAb2ZdP41dTch+K/MyzWrJxhtraDY4dirJ69g3Z264gvxHAY66RV9rw
         4GSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UJxPjDVPTtrssnfg1ZQ3ktKHAmxdLWyX1YJpyxzMclE=;
        b=QyzHTn0KeVzL48HiUz/Cgj1OqoiQZgBx26j/bWOO1xKvLIIqIhnzUNzuHckOudyqnI
         R/vNDS4kLfY+O4ar2aOeSQAtqo2uXNs8RaDdTDGMgpO+mOOY8WWD2L+MH4U3sEYszocO
         UrC+VPnrd5AG6qp0JGP6MEPSCNd28JBe7EtYXB/H44/gv34Fbq4rCUt3c0SzcglE5VuR
         kUc0c21KsoMniQujruKaDaZKhh5UdriZYg3HJdgjQoGzS4Py2Izrdgv6ic8OOrqrdSWr
         x3mLTYKRP2QT629BxbOdsOVNPwzh2bpJyro0Tn/1qkaU99vFcJgXUNocewehJQMC8tOL
         kdVw==
X-Gm-Message-State: APjAAAWu8NRoUqUcMz9YtEspBtBMHG5n/waT2MCyk+/ZZ3SkYPPYCVru
        jGy/YbZkyCQ1Yg/L3iNiV4RKsOh3/y/ZMg==
X-Google-Smtp-Source: APXvYqzr8cxSWEiMZffrX+hMUdWq98G1knlRL3QAyXtPSWDwmy4BbhdZJ8euicexfElWxG4CEsycFA==
X-Received: by 2002:adf:9e4c:: with SMTP id v12mr2061869wre.312.1559211357307;
        Thu, 30 May 2019 03:15:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j123sm3746773wmb.32.2019.05.30.03.15.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 03:15:56 -0700 (PDT)
Message-ID: <5cefad5c.1c69fb81.63b61.30be@mx.google.com>
Date:   Thu, 30 May 2019 03:15:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5-406-g6df8e06907e1
Subject: stable-rc/linux-5.1.y boot: 124 boots: 1 failed,
 122 passed with 1 untried/unknown (v5.1.5-406-g6df8e06907e1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 124 boots: 1 failed, 122 passed with 1 untried/=
unknown (v5.1.5-406-g6df8e06907e1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.5-406-g6df8e06907e1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.5-406-g6df8e06907e1/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.5-406-g6df8e06907e1
Git Commit: 6df8e06907e10b03bfeb68d794def0a11133a8a3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
