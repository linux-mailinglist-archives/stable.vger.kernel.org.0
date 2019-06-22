Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDE34F81D
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 22:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFVUQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 16:16:35 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:44065 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfFVUQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 16:16:34 -0400
Received: by mail-wr1-f54.google.com with SMTP id r16so9736168wrl.11
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 13:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v6jVQiok2Q/siab6aCHbngZ0ea3/U3vYWPUzXs0jtAc=;
        b=1qwHfxEPKQO6xUQKPcuq0RdYkhhiGw17sPnErguIBl5J0ZQ88iKFO+qC0gWkQ1Kp5s
         vF07JBGaFH1KUum+Ev24a1jZgxhi5kNfCDnU91gPzEmj/u8/qP+tdApbVne3oJsPZYy8
         c5ZV8HCQgFz6Gh98z4lhIYAHnQGb+7hl7QcjF5DxWtDGHHTifrtGP6D9P2SYtqyHDA5w
         Y1JTwfoP21JHcjgYu+rHGa+MeCaURs9FMnOD453xmjb6irkHUUQFFlFyeQDyTXtDTW7i
         qzyNaMVCOUjzesGeHsxWPj87NB/Y/ciOviDi9BZgfF5Oad761dC0Uxe2XV2ka8P375R6
         JiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v6jVQiok2Q/siab6aCHbngZ0ea3/U3vYWPUzXs0jtAc=;
        b=hXpKNLPW9JdaOOPC01dyoRmlQbShq3jgWzGyg6zC86nP9dTO+/Ow/EKpuHzDlAbycp
         BOY260ZPW9o7dgIQJIRKhXBg3idGwhSrLSQGv3/jUevds9XQomXSO7NXRVmqwKKAfHXa
         FyELJ2JaviTTqwtKAvubmk3OQlWTd9kh3YqB44s63BSAI1mKs6sBz7UuZ2svgUkilEfG
         cFTnCjnhM7O21x1Ob6E9WQW2qwomUFiGlW/PjfQhl7uNmkV7EsPFvHXmq7twkfNPY3c5
         /AEes3KOn7u4wdEFUbeeqiOPwltOPMO3q51ZuTD2XvNBnMWUJH5k/s7Sz4BpRWjJ9glE
         ve8g==
X-Gm-Message-State: APjAAAXzz8dDs3VMZ+sLzWYMGoJ53g4UrE4amlLLbVkCnumZyrs9W70T
        mFpnVu+/WcnBY09PVbOdn9fDbMK0Hg0=
X-Google-Smtp-Source: APXvYqwp6/HQxW3UIeCMpjY+m21xRuX6xKeoz0i2Y63+pXuNnM0wiP3cGC0i/oDLoZpMjOmmTuy20g==
X-Received: by 2002:adf:efc8:: with SMTP id i8mr25708432wrp.220.1561234592688;
        Sat, 22 Jun 2019 13:16:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x16sm4636677wmj.4.2019.06.22.13.16.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 13:16:32 -0700 (PDT)
Message-ID: <5d0e8ca0.1c69fb81.e56c5.8e34@mx.google.com>
Date:   Sat, 22 Jun 2019 13:16:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 122 boots: 0 failed,
 114 passed with 7 offline, 1 untried/unknown (v4.19.55)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 114 passed with 7 offline=
, 1 untried/unknown (v4.19.55)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55
Git Commit: 78778071092e60ab947a0ac99c6bb59aad304526
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
