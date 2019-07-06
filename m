Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FCF6104F
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 13:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfGFLNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 07:13:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33286 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfGFLNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 07:13:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so12306504wru.0
        for <stable@vger.kernel.org>; Sat, 06 Jul 2019 04:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DtmSe77D/2SPbUtbF/5Hm89PBTMADawFHt+FcTkczUo=;
        b=ulsB4TQjCDXVXnW2wxlXOrzkEWnrlwa3HCX9wLhLObE1mH6LEh0m0jsabcUYnt3UAh
         pJMLGTUXPYectx0CHJl6AKKWiZVUpf6Ee2Kn1nXHZnaK6KY1Zm+3nTfnow4ve65bi/lO
         bFUPUCOTVwBUkb3aBEQMAMSC1HmQwumGYk6KjkRetwQ+LnVmaz+Q9NJz87WhId4LsU9+
         stl2qBimlDmSpqI0ty79GnMqPdVwvLnV/gR7ZgZZ8ioN4vouB8wHgSAxBAd/YWZxxHcb
         jtz5sCZQSiLpwfaVvDbVEm4JxLRPJ9opCQcdfGkS9NBrwjH8I4PaUuq3Jwo+aWtJjt85
         NQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DtmSe77D/2SPbUtbF/5Hm89PBTMADawFHt+FcTkczUo=;
        b=Cm7BJUPaG1AgUHNqTJIozRRHxG7z+RyAsD2RqLkGs2fj1SjVNmdqDZWqZCEtk11eSS
         dge/oZU6uaB4DhX88wCdBy2g3dp5pGcWYYKpK23ItqqwF4WLq+TJxAxSOEuty/2YWFLy
         l0+kVqYtz3NLWoJBKaK4cARjjUjBiGs1iIfsXEHf4pTn6jGbJlmd90x7ZwUAC9CLwMIJ
         l5SWgkYl9FGfiHZlrEnnZf+Ir5k+l9I6RT+PlXPy4ZHH5YEjR12XLR0oIsS1bKZvgawF
         JZ67sPcZwfw43bKdvO4I9x486EJp71quiVDDDypZ8d+FNCk1+vb38ahBhTHYHf5YR7Bd
         ta+Q==
X-Gm-Message-State: APjAAAVXrI1b4VGZBDBgMoGPaODHET7lGpc/AQ6/Rknme57rjRtZE1CG
        p6F89XtRZD/Mvzwc1+jj58JKv+k6rUNcTg==
X-Google-Smtp-Source: APXvYqyM9Fjzj1S66bA5ghl+61UVBT8pth15vsnP4xK3kMSO3/SDk30cZ0xHZqlrdwQ89wKfyUN1zA==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr8559341wrt.111.1562411579319;
        Sat, 06 Jul 2019 04:12:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y7sm7724488wmm.19.2019.07.06.04.12.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 04:12:58 -0700 (PDT)
Message-ID: <5d20823a.1c69fb81.6007.bd56@mx.google.com>
Date:   Sat, 06 Jul 2019 04:12:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.132-53-g9dcaaa6f681f
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 129 boots: 4 failed,
 125 passed (v4.14.132-53-g9dcaaa6f681f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 4 failed, 125 passed (v4.14.132-53-=
g9dcaaa6f681f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.132-53-g9dcaaa6f681f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.132-53-g9dcaaa6f681f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.132-53-g9dcaaa6f681f
Git Commit: 9dcaaa6f681f924b484eec519c4db6a3f4fc22f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
