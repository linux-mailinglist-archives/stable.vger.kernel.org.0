Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363332622E
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 12:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfEVKqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 06:46:13 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:36506 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfEVKqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 06:46:13 -0400
Received: by mail-wm1-f42.google.com with SMTP id j187so1684239wmj.1
        for <stable@vger.kernel.org>; Wed, 22 May 2019 03:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7cnZDsEgyfhewDwxcElGZ4BEsbq6fTIdS4jBAkqwMu4=;
        b=JLMinoHVxjLwWAL/zP0gD3eOx0TNrwy2sONvGCiY8+QlDeuso+hxlGc7osl/dDKZzk
         /ndbFbzjZlUncEZ3cP4Y3xSLVh+z81J7Rg5wRrpDtQDa0nF5d8lhiA2EQEEWvntsdSDp
         AtD671Mt+ghbhtMJnctZXBc9BoRHXJfo13w8X87UDnxhrvn+RbYKZCr/+b2qJKk3dwyL
         nO45ZyTZZqGLpci+KnAR+V5DmXzeGJqGKCcr/TXDJCPPjx40Gi/NFNaeMT/paBMO/czr
         MynhFeNWJt9PJNLxsZbYJC/EKwT7l9w/N9l46YrvZF+rvcnK9u1+hK7yY03jHk2KqNRi
         53cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7cnZDsEgyfhewDwxcElGZ4BEsbq6fTIdS4jBAkqwMu4=;
        b=g15AmCs5MK9ASiow/wqlMBhko7Y6ZZI2cG61vPHtAptcdjKF6obSzwFyf8O+aEaCXZ
         v+0tYepm0oQj0oCMDVqtEo/WNaBlNc0/8qmvO0QAQrDCcAxB52iRlQ1cyQlJn5+zRVUg
         Y2C1dm+WqsUxHP1McAN/aZmc4+yzGR/CDLcsped3dn/84yZ7tQICfZhsUtdwMFPKk6PJ
         xseOGTht672LEsEqfGdI363gV7t/CacMKWL7hfUe4cmOFNTn1sNnM6JumDvFlLWmEaOw
         l1Zd7Pr1LRvnjZL8axO1I6faQTDQUPF0JioEsFhGKrqG4Az3mEPZU2yQEJAM8+lCY/H5
         vtsA==
X-Gm-Message-State: APjAAAUqMnv+Ada6pSGN7p9bRn9rTPF2trlXWBVlisYrmbgjWy8i3T/o
        qYyTuPzGcqiWFGkU8IgPfdn/eGh7T8I5Rw==
X-Google-Smtp-Source: APXvYqy7Pwh+7CPzJek3PPURfy3FQvzUonTmP5W2bmkzUPJa1nfoC8nNwcCWM1jW0ShNfvqxzcfVxQ==
X-Received: by 2002:a1c:2c89:: with SMTP id s131mr6737036wms.142.1558521967382;
        Wed, 22 May 2019 03:46:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q9sm5548668wmq.9.2019.05.22.03.46.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 03:46:06 -0700 (PDT)
Message-ID: <5ce5286e.1c69fb81.ac855.b380@mx.google.com>
Date:   Wed, 22 May 2019 03:46:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.45
Subject: stable/linux-4.19.y boot: 52 boots: 1 failed,
 50 passed with 1 untried/unknown (v4.19.45)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 52 boots: 1 failed, 50 passed with 1 untried/unkn=
own (v4.19.45)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.45/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.45/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.45
Git Commit: c3a0725977484ea2d7f17746d7e168d2b19f99a2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 16 SoC families, 11 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 11 days (last pass: v4.19.41 - fi=
rst fail: v4.19.42)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
