Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA75135D35
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 16:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732585AbgAIPxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 10:53:32 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56230 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732573AbgAIPxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 10:53:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so3455327wmj.5
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 07:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=12sMvYOqnWlNgBhFJdsg2j3irRJmY/Ly0pZKcu8kVNM=;
        b=MkZkf6p2bCB0dL2EIbKs6PH+ycH0Ta1qUVzf9g4XUNRwT4CKJDB6q1iMbR7xCJScJk
         tfMeAWjCai2TAw7fbgSwsX6TPLgGG89oIj9WYjY2LyO32zNZlPORJS9Zz47dBR6Hm2eH
         kaMEpi2rYaqpPyepEB29GOqi/EFCMTQiWeuVQcznUGPdH5I9peo7RLGAgyaoSbFV1gep
         dR8ULmYVj60UmioWm1Jo4m5ZinPCt3VfV0S/B1ewq04DLpfGAN3BBOPIz6kRrfyVr0jW
         jMRj1kzM5k44YLqk/+RlacDSasWtkSsXpIrrKVr7hyckbP55muZNny/hiVutQoVnFz29
         vWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=12sMvYOqnWlNgBhFJdsg2j3irRJmY/Ly0pZKcu8kVNM=;
        b=XSOHdL3+Zxf9EhRqHX7w6KhAGaCO7jzHoUy60QlVIDncXs5/aHH3Am5T4HDpBP/Iwf
         NpexPoIKzYCYJioJbcRVUdAJH14vHGTnNHFniRKkLzWR/8MJHI46yEmerIAQp8aQ1aqN
         GJUn3htYSYq3KjQVcGe5rUVOHDjmB8GQ6kIwqCINaA0k1jGbOuGuV7ANGCQ1UX/n8CP1
         wluWyjyWHd1Xr4zTm8IAxZ0u5zWHTJN5Mx53BlId47lcWxSLiqV0fLOdNwfVUty7r3s9
         BSPoOjzoHwnrGnZpwl4fqdyRAOTNF52VIzL2b3yE+/71uq6AqEllF9XZXs89XIIcwfmG
         lTng==
X-Gm-Message-State: APjAAAXIpto5uxpwu/odbA6OcihYs1QS5iS33TcRNTzBeB4bqrZDa2gG
        WUseNpg8DSvNXkcafAb4D1bFP5kUqUQlfw==
X-Google-Smtp-Source: APXvYqwZvv1m+vvjBdCmYFxKfOXBTs+x0bEuDU7Uzw/laYBq5Ke4waIMKJLti7QqOh1FnyB/T+mPbQ==
X-Received: by 2002:a1c:9e15:: with SMTP id h21mr5350824wme.95.1578585210018;
        Thu, 09 Jan 2020 07:53:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p17sm3302081wmk.30.2020.01.09.07.53.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 07:53:29 -0800 (PST)
Message-ID: <5e174c79.1c69fb81.9e1ad.0ef6@mx.google.com>
Date:   Thu, 09 Jan 2020 07:53:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.163
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 71 boots: 2 failed,
 67 passed with 2 untried/unknown (v4.14.163)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 71 boots: 2 failed, 67 passed with 2 untried/u=
nknown (v4.14.163)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.163/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.163/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.163
Git Commit: b0cdffaa546e24acf92ab3b0d4e917a51aff6a82
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 14 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: failing since 1 day (last pass: v4.14.160 - first=
 fail: v4.14.161-163-g404399b2e7db)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
