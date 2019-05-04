Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0032013B88
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 20:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfEDS0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 14:26:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53241 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfEDS0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 14:26:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id v189so1954380wmf.2
        for <stable@vger.kernel.org>; Sat, 04 May 2019 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=6rNsj0ZT+uN2F+lI52cSsaVO+r8mdkB1QltZ73Xyud0=;
        b=syvmT+8IOIHV4w2ndD/mky7Wt9m7bzjiwYPiPxe/e6aH4/a8ksaQjsD4FaYITltiPv
         HevEQ5iZbI13YO831W3WorsJ4BJjqvx3xTdTdwWcIVAgdq8EGF6E0VsVIqnFmUxMzfOr
         i1PkTJLrhiS0xic2Vp4FpNeK77rM269XanPbcjLnmiZWqYgx0nZhnfidsLCKyqrR9/ZD
         aS+YywTlBfMRM5ugCe+4cvA0xw7IRn2P8EY/q8KzLFYSYxueIR9m+5+k0uWffghQQsn7
         M5+0DB8M0xCGyrxSH6ZASJ6gRDtoTbG1egm55/w5ur8WQ1CYj66bJNOio0OwhJrrnTPf
         SGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=6rNsj0ZT+uN2F+lI52cSsaVO+r8mdkB1QltZ73Xyud0=;
        b=HYfWsohXkVpkVpWfX/wcf0RqPpX9Mdejh/KM1//GY/edIVZG+FxAXWkGU2/20Q8rFB
         3IkVMf3/9g/BRjhLnCgqrne68fTVAWv/k8oHgr2LsyCUYmD0yDHJny+Rx7JG/i1SFzlg
         +qUWkhGFBIVAALhWa41tUvTfhRahBmubG0aUKODriYsV+NRjA0WmrhzOZo+1vWWHar3Q
         CvnLIgm+soFm3tTrJuXIeg0iGiOBYmpQbdSc/V8j6SlG+a/a8R0azV6tsx7M5O8Jzd/d
         fDmcpflVlJWb7noTuv+C7pl/pQ/YS51rIzrKAlyRKiZQFQgvN/pHC2Z4FoBye2fe9Ld2
         ncYA==
X-Gm-Message-State: APjAAAWgShY7f4O2oywZdyYCv1KeuFPsbkxaTY1BFbqvRBTe/1BiksxV
        gmqOAXt4P0ruoE6aiZjjkm7OYw==
X-Google-Smtp-Source: APXvYqwjY1p7llMSh39AQCydYzzc2pQ4gwAIycqwnYmUeHArXcsz62WSMIS3jWtnGCKbfgRhAPMfBw==
X-Received: by 2002:a1c:f719:: with SMTP id v25mr11046668wmh.90.1556994405333;
        Sat, 04 May 2019 11:26:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a22sm3972114wmb.47.2019.05.04.11.26.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:26:44 -0700 (PDT)
Message-ID: <5ccdd964.1c69fb81.47209.4cc9@mx.google.com>
Date:   Sat, 04 May 2019 11:26:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.12-33-gc6bd3efdcefd
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
Subject: Re: [PATCH 5.0 00/32] 5.0.13-stable review
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

stable-rc/linux-5.0.y boot: 136 boots: 0 failed, 130 passed with 4 offline,=
 2 untried/unknown (v5.0.12-33-gc6bd3efdcefd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.12-33-gc6bd3efdcefd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.12-33-gc6bd3efdcefd/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.12-33-gc6bd3efdcefd
Git Commit: c6bd3efdcefd68cc590853c50594a9fc971d93cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 14 builds out of 207

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
