Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C2714291
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 23:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEEVlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 17:41:21 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50694 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEVlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 17:41:20 -0400
Received: by mail-wm1-f50.google.com with SMTP id p21so13398204wmc.0
        for <stable@vger.kernel.org>; Sun, 05 May 2019 14:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q6Di9WMohcxu4tTvHbPIbz6ZabKFmyz1gXWVYE8qa1k=;
        b=oAWbSjNtUYe6ixubnf0KWD35dmaB7rDgy9z2rJZn3a2rfzs7gnBmwPXykaeU1ECPlm
         lwJbULGCxaYZEPjldu77mR5+ETwBydpeRc+PJ8Z3ZxVUY7L9dDs7S+/B90gldm27OWQ/
         BmSoCcblpZfO6jIBoS7KMKAlkgBRJW2mY6nEHMrq+s7PHmwQ3kYRT1CNPuSnQ2hLNO0V
         jM6VTCeHximgAuvoJkZIpwjifmRWAm49qnC4EdjUjobg5QHw2Q5HyoQoF/TxOaluZZ21
         hyLjfLzpUiOGhraAPud1UslOFr5sIz72blbGNzfpw93rTJFnpr+9RveQfMiKuC5J/4vT
         VkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q6Di9WMohcxu4tTvHbPIbz6ZabKFmyz1gXWVYE8qa1k=;
        b=elXCTFmQtlqbyL5hpH0zWfbzjQBDbsDpbMUKjGXrlj4Q7Qn9emU1P5MRdVWpBlcvMK
         EJyT1VCpQFqux4nKS/yIBlZsdAMtxVwOEdoagUOXijwCRuRPmasEllBy1U6RamQ5yZBM
         gNdZq/h4o07vGe9CszVv6sPI9WBQVUTY+miDNL4R9b7hOQ70iRMlRT0qGWaLq+r1/3gE
         ED5il38n05PHluRL7A3cbLccPYhIU2aQsqYw4VP3aTToCi2+LziUgci4E5SYif54DH4a
         JZD2eYpndupQp4Q1vB4nV7NbbylEulVbTXb5azYCzneZBXSWuQ3hdXU0HxJLVX+u2o0v
         5fUw==
X-Gm-Message-State: APjAAAV6d5THywmeg4bTgw8Dt+4SIFgB0bB7/gbssFZQSBEtz0mUygQD
        H0cmjgVVP+1WJJyt24rAuU10pstvXck=
X-Google-Smtp-Source: APXvYqywoNhg0cggGFPEhK99cyWOYfdoO18a1wUjFxayPdFJTB/qAuZc1eOY4DH7vEzb1N2EbfzUlw==
X-Received: by 2002:a1c:701a:: with SMTP id l26mr14125792wmc.50.1557092479145;
        Sun, 05 May 2019 14:41:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z140sm16822335wmc.27.2019.05.05.14.41.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:41:18 -0700 (PDT)
Message-ID: <5ccf587e.1c69fb81.8ab47.d048@mx.google.com>
Date:   Sun, 05 May 2019 14:41:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.18.139-37-g42d96e8e8e74
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-3.18.y boot: 53 boots: 1 failed,
 50 passed with 2 untried/unknown (v3.18.139-37-g42d96e8e8e74)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 53 boots: 1 failed, 50 passed with 2 untried/u=
nknown (v3.18.139-37-g42d96e8e8e74)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-37-g42d96e8e8e74/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-37-g42d96e8e8e74/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-37-g42d96e8e8e74
Git Commit: 42d96e8e8e749465ce284b199d8505ded15a25ec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 13 builds out of 189

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-7:
            minnowboard-turbot-E3826: 1 failed lab

---
For more info write to <info@kernelci.org>
