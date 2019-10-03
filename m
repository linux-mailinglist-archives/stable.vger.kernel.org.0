Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470FCCB1EA
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfJCW1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:27:49 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:52774 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729219AbfJCW1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 18:27:49 -0400
Received: by mail-wm1-f47.google.com with SMTP id r19so3640853wmh.2
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 15:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uOVd3X/wZgzEB6V0Fr+tNeKdOcBOeAY72FFGJ1MiF4Y=;
        b=JuBN9sidCZuwg7P51JzzQ1ZQCuQEBzy9iyfKHxFmFyQj62I6vanxzFbjfc9abyr7Nd
         LQlGzY7t2kALFeRg9cAmT4a9RRX+FlCdbSho+sIiYGnmeez9MEWJzmZOH8M+dsW4O1N7
         tjhDUuWUXLTVAMhwteGL193Wc/V4ddrZzDAHLtWk3h0pBun68ecN89VJMqgJFfeMXMyL
         DM7v28Gl6Tqa6CBBZAK2S1NpnBeER9TWSpNI8zfjV6hhpejBTdaLPmmrd5+mUB4vU+eA
         aBgIuFJyg5so0aZTIpb28GIpp0OweOrUWDLo5oBMsNm0TLM7aSyQmZNQ7OU579ABCDnE
         pJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uOVd3X/wZgzEB6V0Fr+tNeKdOcBOeAY72FFGJ1MiF4Y=;
        b=pVHwwgaKlhjnXiaKXLAy9l3ZXpNrbDykNomxzoPL5NzGX6KDE5k+EdAcXBgEM/m0jz
         WcAHXACph1NcHM4La4dx4fZ7aWnaiG3mz/Z+YDS8d70LvMfY93zg2UiYZbBsZ8MbQPre
         9lxPKPtY7KjbZ2vSTUE2KI1H+kvVtzhV/GCmt560RNP/kqcCRQl+NtJa/OsaYe0gJo0l
         bdyj1knUzuWmHlI563T0AivcCl8JmK7BqE5G/yfiQpuFHl5vIGXlxVzqjlCRjrDrrl6R
         0N/BG9qMZL4RShCFfBSxhP8Di7TZeTidWy/nA5ph4p0uPxdyKoEC6QFBoZ3KWo0uQZ5r
         DHCA==
X-Gm-Message-State: APjAAAUrjkMgHvrKV+GP7yO/f7NHeoBz1kTe4RkqAKuZbi+dRV9Y77Ug
        v+VTe7Ub1R+MsMXC5f+4l4xOWcD6YTt+Xg==
X-Google-Smtp-Source: APXvYqz7bGKHyzC4CUg6a1XNVIg9Ot4CA6BPomVkirtKEZbVSq4MzOKcZ1nKaqWi+ucbU3AfXhyxKQ==
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr8098479wme.83.1570141666601;
        Thu, 03 Oct 2019 15:27:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b186sm7295882wmd.16.2019.10.03.15.27.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 15:27:46 -0700 (PDT)
Message-ID: <5d9675e2.1c69fb81.8c202.2922@mx.google.com>
Date:   Thu, 03 Oct 2019 15:27:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.76-212-g319532606385
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 124 boots: 0 failed,
 115 passed with 9 offline (v4.19.76-212-g319532606385)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 124 boots: 0 failed, 115 passed with 9 offline=
 (v4.19.76-212-g319532606385)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.76-212-g319532606385/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.76-212-g319532606385/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.76-212-g319532606385
Git Commit: 319532606385c7221dfbfba6f857bd03e97e20d0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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
