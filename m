Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1410814249
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 22:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEEUQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 16:16:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52631 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEEUQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 16:16:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id o25so2152642wmf.2
        for <stable@vger.kernel.org>; Sun, 05 May 2019 13:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XE1tl1pMH88K5yCLkzG81iGRP1oh+ZzibNUjnA3DiJo=;
        b=Vvf/Cq6mbFqnJpaWxfzf4ebOEoirWtCulzvsOsI3v5u8lXApJeIoc1SEnRyHvxVQUE
         OJBdoNc+ALDWmv6/o46uVAyS83AzYmkYQ7cmbQc2TL4eSZ2plNOagKaG6re8Timh5A7Z
         5Tll0/+pmYfuhkjHLWYidEbqDM4S60An6bsbIxYuUx+oTm7v6qj/68jIH2gkMkRzbnYp
         GA5YUZRXs0SBWhMTGXtpapNLCuBmIwYfyzlICdXCw2222SS8+xqWBatNWReaNfwU5/x2
         eXkG8iKJOTafJ2jW39HdaJeqL8TKYqDHPrcmDP6lE3Yuad8qwb/i+woxRz68SToIKxRY
         PWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XE1tl1pMH88K5yCLkzG81iGRP1oh+ZzibNUjnA3DiJo=;
        b=Oj5Dmf31LusXhOHhmk2R6vItbxe5ZbJt2DcAww0XBdXg/FErauzwQ9BuvK3MFcg5zG
         NCU6OrAJsyztmOmytDY7rs9lUe1oZeiG+CSMqcMtxxX/9PPO0SPAPxBnuR/YG2fJHLO2
         OQPFI0HSNe7/UaO9RbA49D09ynhIA/8UANu4r+mbtu823wPdF0S3k1uEQrXHEdQAogxm
         FWrUoyEpktlIZAmoZ11GBkBeGkXenw+pzArpN12Ych89iSEpW4P3AeyymGdg4uUAUCxG
         UD71hC/+gAMAWppvMIpR+v0E4kZtdXKfUDjuVrCiNaaumXa12DeJMvyc5i5OlFsNWQq7
         vN6Q==
X-Gm-Message-State: APjAAAXb00s+3MepM+5ERwFi/nfgqkPSPsuH8A2BHqdZ/M9l7/I9vNso
        7dZU2Uq18vsuSVewJjrYGUONu47p/r4=
X-Google-Smtp-Source: APXvYqy+5miAa36vlMbU0DIjGM59RreRrAr1Fq2VFtisbKTUYrbhgsUbY2pYiK3Rt5o8giuIZeNC8A==
X-Received: by 2002:a1c:6c08:: with SMTP id h8mr591782wmc.6.1557087377502;
        Sun, 05 May 2019 13:16:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e5sm6303526wrh.79.2019.05.05.13.16.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 13:16:16 -0700 (PDT)
Message-ID: <5ccf4490.1c69fb81.a8575.fcf8@mx.google.com>
Date:   Sun, 05 May 2019 13:16:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-120-g2f22b9644d76
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 91 boots: 1 failed,
 86 passed with 4 offline (v4.4.179-120-g2f22b9644d76)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 1 failed, 86 passed with 4 offline (v=
4.4.179-120-g2f22b9644d76)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-120-g2f22b9644d76/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-120-g2f22b9644d76/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-120-g2f22b9644d76
Git Commit: 2f22b9644d760c16024b9ca6b22901e67d61787f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 21 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
