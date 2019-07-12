Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992D667709
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 01:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfGLXxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 19:53:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36597 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbfGLXxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 19:53:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so6190174wme.1
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 16:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=AS78fkGwPznrOvf/DrMdaP9ctBPtIVJwOugMvrmJs4c=;
        b=fwj5TEDemEpyWBqtQq3+jA8lBHtoGdEc58oA7J/G2sFnVoXcFQiYIN5a3Ez08/bTZk
         aWjxlPR3Ml3tqBy9ChhD8/hyTUKrrkJKMt/G2jYIndBlsqYrf8Cw9ls/S6Tg8fnydl3w
         F0BD8Sxs1dlQcFXCts/I/8djE+q67q8xTrCk923RwtO5Ueq6zRHnwi8dNTbWU5VeHEQL
         m0RhttWyRD8u1PFKBH4FewGDn++vUQS9c+56a+DJh8Ucq6L0xVLwaQjjVUsfIQE2hRNz
         uXA7ZxftngIWDusXeOdFcx2jDQg4iGt0UJGbDq1hh9FX7QPIXxbslXZgqYjFgqJZN+Ap
         5kTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=AS78fkGwPznrOvf/DrMdaP9ctBPtIVJwOugMvrmJs4c=;
        b=EQMNtubBy3GRYWeJtbWiuDy+8Y42DG6f5+Li0A1j5/MVI40nqgUlGbwuaMHv9qpeDe
         PfTQKWvdmfBrkNE5VH3prZImDYWTI+4Wd5hYY3bNEEUB/LeMBR5qDnGOMmxF9fD7zfU7
         A3FwhKXqPRLsMW3wIt/d1J2X2/UIWwdr3mOWjd5oo/bBzK9kIENWpvbl5ugyyORQRCbr
         DsUwimJxlT+ljcaVUeNfB4Bw1LBSpzH9oBbSYQ3Lq0VRLcvx5YpXI3go+qI7Bq/3DV6C
         ctSRgwe/C4CEcFjfxn1CB3achPUzv6aHaQaCJQSqpYTb1vgHXU8xV8aKe515uot+yg66
         rTrw==
X-Gm-Message-State: APjAAAWose64iHR9dGwjiqw7r96BmpYGYU9k4qX/gqcHlnwdTdEPV1th
        kPiXBMVuRVwejNgeGmSJIE1pk5CyIyA=
X-Google-Smtp-Source: APXvYqy6F7KeeoYQq36of+L4xIICXeDHFQZtRhLC/q0YB0+36Q4D3e+h2JCbn68XR2bAKUYRpOdQBg==
X-Received: by 2002:a1c:f018:: with SMTP id a24mr11198037wmb.66.1562975584601;
        Fri, 12 Jul 2019 16:53:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm12182171wrn.29.2019.07.12.16.53.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 16:53:04 -0700 (PDT)
Message-ID: <5d291d60.1c69fb81.ba0a4.8774@mx.google.com>
Date:   Fri, 12 Jul 2019 16:53:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.58-92-gd66f8e7f112f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/91] 4.19.59-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 4 failed, 117 passed with 1 offline=
 (v4.19.58-92-gd66f8e7f112f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.58-92-gd66f8e7f112f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.58-92-gd66f8e7f112f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.58-92-gd66f8e7f112f
Git Commit: d66f8e7f112fefe0c1d2a0f77da022a56ccde6dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: new failure (last pass: v4.19.58)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905d-p230: 1 offline lab

---
For more info write to <info@kernelci.org>
