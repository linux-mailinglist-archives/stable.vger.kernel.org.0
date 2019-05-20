Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44359240E0
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 21:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfETTIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 15:08:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44508 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfETTIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 15:08:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so5064633wru.11
        for <stable@vger.kernel.org>; Mon, 20 May 2019 12:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=YzAXxaOC5xqVMd8/F/Ga0LPRdXuar3Jj9JxMXvVw7Sc=;
        b=wMA3SnlVfagrZY+IrVonNezodI0Y22lIHeDsGtG0cIyAG7bEDsCTOZDiS/SDfK+s+X
         FOQnnL8LEOD/F4ccOmfGbRb/UhW9oA+elSFuvK/uO98RHcYb7p6SUIH56U7e18HCLJlM
         4f3qLVe+Pn2MmVRbHqdyOuV3c8dVShpbc97fO4zYV9fVchps1iWOVOXV8XT+kCBXNgkD
         H27bA40hFdSdc6Fw0FmnzTr4t46VK/epVSq9DZej0fXNXDS2NM6+oAponHdlznIjU3vZ
         Rp+OcYk4i0WsfeKCsXv12+VbXIhWj6Yq3AK8oACTdwYNMPal2VKDxoH28IPpU1abx+Zd
         M8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=YzAXxaOC5xqVMd8/F/Ga0LPRdXuar3Jj9JxMXvVw7Sc=;
        b=pc/q3pFKSIJOxRwVGlnsRyiB8y7X9CFuNiBroHvcAU3OLA8TGL9gkIBrOkh0ikGS0+
         hbV8Gk17qrcc14pgipzaBwrUHiRN+sjqjfPcXAuEnSY10cNvSJjlCoNXg7f56mn1MuGF
         27m3S/p047cfx1us3E3nB88+iP10bjq8AhnFVtq2wmpfHA64IHNM46ld9UwbuIvESzON
         CYg177l60hUXwKqhjw1JZApW2ErBGSqbe+ZLN6t3hyDFg3n3mJZadOMQQOYNFVokHvIE
         4ErBdFVIdKpb1FCGxYYyFiDQWl2+d+28fFkNT2YtiLSc+LQOta+dzV/+TOkTpP+Xdojy
         ZVYg==
X-Gm-Message-State: APjAAAV06BgeClg4upV4zzur7eX9kI8OQ+I4EoL9QP/GK7kwbLJ6fbf8
        D44atGF+Eq7Gw86ja9uAMNFgng==
X-Google-Smtp-Source: APXvYqwCDZdnaTgUywPY4vGp0YZHmTdm6mZENFhdUN3APJbFm6JQra2C2IIQqq2x13Y19c+6AXbpQA==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr7260238wru.316.1558379295861;
        Mon, 20 May 2019 12:08:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m17sm756867wmc.6.2019.05.20.12.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 12:08:15 -0700 (PDT)
Message-ID: <5ce2fb1f.1c69fb81.b5d8f.3a76@mx.google.com>
Date:   Mon, 20 May 2019 12:08:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.17-124-gbb2772791a81
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
Subject: Re: [PATCH 5.0 000/123] 5.0.18-stable review
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

stable-rc/linux-5.0.y boot: 126 boots: 0 failed, 120 passed with 5 offline,=
 1 conflict (v5.0.17-124-gbb2772791a81)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.17-124-gbb2772791a81/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.17-124-gbb2772791a81/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.17-124-gbb2772791a81
Git Commit: bb2772791a81b9bbda82fc5b02ac84b8b8b42628
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.17-117-gc76436debf=
df)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
