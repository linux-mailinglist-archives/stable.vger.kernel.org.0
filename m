Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78C3D411
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 19:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405987AbfFKR2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 13:28:49 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38999 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405786AbfFKR2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 13:28:49 -0400
Received: by mail-wr1-f46.google.com with SMTP id x4so11310807wrt.6
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ni0xigMuuO5Y8ouO7ze1+0WyolT1YXq99bUd2YwKEus=;
        b=ZfMX9xAbtrppK2pq9PXFydxpLbfL5/yOD3RDiWDOQvlNYnJB+WiOrwXv9l6qMJHUEE
         rlTlnhkBtXAMbWka2uMXiv06QYv4Hm4gGdhgsBjBf1u/vvbDcZqxq3qhRjxevCmN6/ah
         rNFzpY3zTB7Waa5pFLnSvTvlWbd7rXIUUp6bb2YKGcVTBPRE5SR7pU4XAqw+aMy8jIn6
         0Yahs28N4Fgz4gtJv8xV3s9bfFSCxIDewI9F+Bj4bIvKY9PX+UGWznNdCnbU9PkAlWIV
         Wk+MVszNgnpu3ma6uG1pDR5QeWT2KYVZspbt6lUr74eDBsx7ZQnHWXsEJHIEirMd/av7
         uLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ni0xigMuuO5Y8ouO7ze1+0WyolT1YXq99bUd2YwKEus=;
        b=YVX6KeG3MuOOoSfB+UtPwaeSdPcki/Tlddy6lqIWlZGbgVdhvmG28Qi0Z9m+/SXd4W
         awQ7f6dOzx62w1rZjyPjN/I8ut/WdMI//Md8sp6Ydb30tZUGWS5p+7jmc9P9Tuula4eJ
         qUucGOvVQiUquoNcjGid6HIJRVjk4ws9a9yPXc3VcHvYkGrnRuBwSMiLYeygxYH6Qq0s
         kQh1YzJALKZgEKtjVURNZkQzsTfpArv6zkCkFzQF9KM3FXiZr5fmSO0XKMsXPLBUL8zu
         JPXieWQQB4qnBY/vnu7wIDmBFgZqrz4egD3NR4xAdNGYREWtdcCxjoLYrpQHsaDYBVt2
         uSBA==
X-Gm-Message-State: APjAAAVOXKO0Hj5KIO86YSmKzn6tmO+AvSt+2S+sM0S6NMglJpVkKEUZ
        JXvgdf3Eq4Sj4mYD21IQ+psmtMAgDBbZ/A==
X-Google-Smtp-Source: APXvYqz26A4ypFCQ7zZxZ6TwTUwUdfopTBrsTpcKLI6/maFm/4oSmkdGJsp7vM9qHWuLD1f0w/0MYw==
X-Received: by 2002:a5d:480c:: with SMTP id l12mr26378375wrq.1.1560274127463;
        Tue, 11 Jun 2019 10:28:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j16sm32196535wre.94.2019.06.11.10.28.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 10:28:46 -0700 (PDT)
Message-ID: <5cffe4ce.1c69fb81.e2d7b.3bb6@mx.google.com>
Date:   Tue, 11 Jun 2019 10:28:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.125
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 118 boots: 0 failed,
 117 passed with 1 offline (v4.14.125)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 117 passed with 1 offline=
 (v4.14.125)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.125/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.125/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.125
Git Commit: 2bf3258a12af6508d9c0cf17bfa895c5650d2dbb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 15 builds out of 201

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
