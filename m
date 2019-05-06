Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2054214955
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 14:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfEFMHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 08:07:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45820 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfEFMHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 08:07:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so16880576wra.12
        for <stable@vger.kernel.org>; Mon, 06 May 2019 05:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hMPmVvKfONKo9ZLiC/vhS+UXfWBuTRQ44q6VDcYRBKU=;
        b=Apmu8GVUpCX01lprk7zC395Hjp1B7GSXnyn381McYQ2zTej5rnpaDIDQbVd9zLjIwO
         CJgBSYGpQQ0Ma5sthNzMcXGELm+8VRoV/ABGgXzjNqs+WbiIslCs/JlhPwBZ7QHRaEKx
         p9fkfZoRoFG7bJdmXXJPKW4z1fIDmuCJTcSSEpgBER0xawsT3+qkDLe2AX93KWYuDAR/
         1DR+3qtjDuGZaotW6jryn2uroVTb4OyP512+wD6fjVknU6sY6UG6qB7iIeqEDi5gpEQr
         lDF065AsG1g3nR+GPldHHP2LBaiBgxnWAEJ8tM/jrcK6hzbGJKFYd8ylXxdgt+Z07EVT
         E3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hMPmVvKfONKo9ZLiC/vhS+UXfWBuTRQ44q6VDcYRBKU=;
        b=FIVrOwQ00UHZsyKZS885JjY+lzIMqOx0JTpA1tpqWdywlUpYqumSks5sofTJon9QzP
         pMpXGk7ChcRB2m5HnvQ1L07SZfeWxaLQfKyG4b2QlZCSmoyq01CzblbuNz7now5Y3U1W
         b8TM908WYpKaioBWzHsWrqZB6RgiBlMqGSRoPdCGniKVM8+tA/uBVvBqSi6VmWRpgwoI
         Abj/GV47OqTgQ6/aY/zAFx8QKa1HnM9PjtjS3+L+GnRf6EPNSd0agUwtWE88AD8E6465
         faOs2baPpqCCSN0ikknlxjeKgy41LJPhxr1KSKXozBaYxQswta17h+H6khKwi/ElfIA2
         V10g==
X-Gm-Message-State: APjAAAXomV6Lipkg0bikEbM6uvRq8WSTcv7T9YqRiiqnGusiS0YVvKy6
        qs/uGCfU2D1qcLed8g31xQik5+TDs5nkLA==
X-Google-Smtp-Source: APXvYqxLhw88PJhPKtmj/IC/ozpYqs8qlxdWL8S/9hEJQumReezHtpjazkB/YOcsIC5qcBIrKiAAOg==
X-Received: by 2002:adf:dcc4:: with SMTP id x4mr1172292wrm.107.1557144439593;
        Mon, 06 May 2019 05:07:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i9sm7074377wmb.4.2019.05.06.05.07.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 05:07:18 -0700 (PDT)
Message-ID: <5cd02376.1c69fb81.9578.3a95@mx.google.com>
Date:   Mon, 06 May 2019 05:07:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.40-71-gb648d6d90f6e
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 127 boots: 0 failed,
 126 passed with 1 untried/unknown (v4.19.40-71-gb648d6d90f6e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 0 failed, 126 passed with 1 untried=
/unknown (v4.19.40-71-gb648d6d90f6e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.40-71-gb648d6d90f6e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.40-71-gb648d6d90f6e/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.40-71-gb648d6d90f6e
Git Commit: b648d6d90f6e99ec8323f9b3b70d5288dad18e36
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
