Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746231748B1
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 19:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgB2SeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 13:34:13 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42169 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgB2SeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 13:34:13 -0500
Received: by mail-pf1-f193.google.com with SMTP id 15so3439020pfo.9
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 10:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e245yvvzyals088QYLTI2BNenBbXMMQsLgeM0E9kK/A=;
        b=t00ocJhIen1u1y6c34I7L23+9q8T7YemnKBAvdI9o+pWbDPCKiPe6gjSxGAEwRtyH3
         lwiVVhKBvWkku9ryigXWFB2KyMbH5EjthmjjfyINpho38eU0tcQz34KH74XnA0x7JP66
         mpPKEGJ9NqnB1uSs7tgvE9i418JtL8D1knUrZt2z8O7zzPXaJ1fJnwvJ8oycjNX7aBKZ
         mle4H+2/RNF49FvZH+/ds/G8HaoSLNJd421gxzCEF3CAbi+F2OOisWBnQdQsen7u+uhl
         mf9x/zYVU89Cbz1X78k7w1wu8jI/fbhMlhFlT7e2HVj7SC0tMBGaWOta7zVYflVREHy9
         kvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e245yvvzyals088QYLTI2BNenBbXMMQsLgeM0E9kK/A=;
        b=AHpwcwi5e9MgbmXcdDTxJ8vPFTaxjvJGL4ffZJXzKoeGbVdmEr2/OqizdXIMmi1MT6
         tbT5/mhVW+Gqy2tNErWBJb8pVFp2IktSnNGzPQjMH8hoOHYPY1wSzkbwVerZtgbaMzz/
         c2HOHVbAFJZby81j6V62ZGoAG2E7kUIsqPPslNjBLljwRCy8OuZmpMmpm1ni8Qycalqp
         auAJc1wFqo2YQ6gAeY9C34zT4LN/Fju1m20ygyWCefi1eLiUip2bojOF2JsjYNVi6Q7S
         JUEUd9aFaiWstomzleAAwznuhgBd7cAGi4Pgw0tJB5sCsuXkGn5pRIApW23g5ZgwIxbJ
         iINg==
X-Gm-Message-State: APjAAAXma9H8aAs1QcgsmrB18ShuxZzGeqkIW41YzMEqXw/q7IxFU6nC
        78+VLP5Hwxc/2I+9JaBmazoPc6EupeM=
X-Google-Smtp-Source: APXvYqxFHZISPZ5Fz+ig5ZS8v3HRhI12lQkEaKuojJfOTfQEONEYbPEyrecr4HTpKWQDM8W3d00REg==
X-Received: by 2002:a65:6843:: with SMTP id q3mr10828957pgt.269.1583001252039;
        Sat, 29 Feb 2020 10:34:12 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m128sm15884213pfm.183.2020.02.29.10.34.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 10:34:11 -0800 (PST)
Message-ID: <5e5aaea3.1c69fb81.37ca1.8fa8@mx.google.com>
Date:   Sat, 29 Feb 2020 10:34:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.107
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 40 boots: 1 failed, 39 passed (v4.19.107)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 40 boots: 1 failed, 39 passed (v4.19.107)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.107/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.107/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.107
Git Commit: a083db76118d20d070794ecf79af17843406c3f6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 11 SoC families, 12 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
