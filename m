Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D526299B
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbfGHT3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:29:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56040 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfGHT3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:29:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so632783wmj.5
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J5dTldBwl6NsR2LVgHxl+xPzZvrjm7ld84Ntr3nLKJU=;
        b=BohvZ61iwpaJuiwVeNNjcPHapfRXUClUNPpnjecTfVCRp42MqcZXLiTuePCZpGqDVK
         6Ne4NhfJHCMfJsOYJr0LzTdBXkrQUt+I/gkg86Aqy4BO5q6tVzmlDDgC9W4TJUvV042M
         rXCI4+49hCWKkduxh/4aaz0Wsht5/JpuZR2y91sLvqyvhx5Jka03Q2zVg3Tg9SwGzqnC
         0EDLm4cErr0gNuHkWcbJWqNktPMWrjmjTmyj/KJmgYBIj7KiN2rGKjImto3Ho3kdC+ty
         8MYxcdHOmKl4Er6Or40PTwU9USvF7ZVUs5DrTGqix39/a7wChYBW+rmNVXJdUcGzv6P9
         QwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J5dTldBwl6NsR2LVgHxl+xPzZvrjm7ld84Ntr3nLKJU=;
        b=pZ72JNPP7TCe+YpRZzGrAMRpp6KYruw+pJUM/lVIUl/5DbStgQdLqYuF5YamuHdqgt
         J/F+5qU4ylixsnYhttO0RVXhNtxEeeCLSZKaESBqN5dSbyM4EKcKlGuHOO0A3pNlI/6e
         813DAruwvyfQ+c4mRv8l/81cmrcwGCUeX+Gdo/8gSqRrBRGs+47296mKcawVePbsqb7M
         vU5dTMyKd72zE5GRao3XfMF5QW4T7mrjH+kwD+UUIWOyr5GgeS3y/qttZK9V9+AH4KWe
         q/+YYV+9Ftcqx3/dUsxgHagnBvJRt0sWASiWxEH/qEY1HuO1peEasAr8IT186GQBoYB5
         T+7A==
X-Gm-Message-State: APjAAAW39Gh14/qMVg4oNVDK2cISyrdLcRl73vGmejIAj/kMIisoENd7
        xdWkYLk1m8uHM2zzx2qSeOdtmNW7i1HF8g==
X-Google-Smtp-Source: APXvYqx7LpVmU54y0IpgYU/HZIDgSqEgzuuThZZ2ZZrF/zpE+MweUDzugjSdr+zyzcw8QvVncJHD6g==
X-Received: by 2002:a1c:9696:: with SMTP id y144mr18092026wmd.73.1562614148220;
        Mon, 08 Jul 2019 12:29:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c6sm417011wma.25.2019.07.08.12.29.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:29:07 -0700 (PDT)
Message-ID: <5d239983.1c69fb81.1621a.2901@mx.google.com>
Date:   Mon, 08 Jul 2019 12:29:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-74-ge691784311bd
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 86 boots: 4 failed,
 82 passed (v4.4.184-74-ge691784311bd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 4 failed, 82 passed (v4.4.184-74-ge69=
1784311bd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-74-ge691784311bd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-74-ge691784311bd/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-74-ge691784311bd
Git Commit: e691784311bd144893e77a5bb7624bea60369f00
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 19 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
