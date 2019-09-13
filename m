Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826A4B268C
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 22:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbfIMUTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 16:19:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34737 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbfIMUTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 16:19:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id a11so23494828wrx.1
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 13:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=1EXHYqWuYUZbZDvA/e1+2lxe1TJHgdaE/HYVLCwEBwc=;
        b=uP2ingZw4+Nn8mHiZ1OS+P5vkQjApkaRTqfOmwPR7DqQ12RbM+ZWQJ5TGxmOYMwe4B
         jQDSwobodZ5P8dJdRs3a6cvxg0DjQG09yveBayjwna9TRvxfSIakuHNi7gpOC/yaNXFY
         EIcX95Uce1OAcjAAkgdQj5N72iE/nlaSetxRJ3dkD4y2R7RjMwCzfZkH9xyUM/rTCvuc
         vJnrMrS6g1qXyquYC9vO+zUhfwQWjk9Hq+ceGllNLo1irnhpZ9p/OJjhZAS9RB9YSvxd
         k2f+Jqw1ssVX9pP4sReDkSIORNwapU5K+dGHsGe4urMdhnFya95JhhOgB40dxK5qhkQx
         aKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=1EXHYqWuYUZbZDvA/e1+2lxe1TJHgdaE/HYVLCwEBwc=;
        b=Q+HY9tUg2oUP2rYLo0voB4yNb5mvRVNM/HeAmrc957QvrHUIvOaClerdFJCxSIVRl4
         Sel6e8nf2/iADub1PkDnbK1pM1KFABM8rOMQtP7d3MlyiF5sgBe87zV3qdEcMYjkTgNV
         OgL3XOBmmzyEwSFugCLMSAgzjqE3W6oWHY8tJ6rPMr5e4Gvs12W0uj8o5vpHFZte6ioT
         35TB7W04uHKMMI8LJ5wenrDlmuhUgqjBI0DP50XIaNqB/CjFwj8gc9N8wpAide2xtSp6
         xGle5gWyqJR3MoiwXbpOSnKH+9JwT6AiL9f8eIGHKm91RzPIBf0WLOGvtJB8e48xugan
         C1pA==
X-Gm-Message-State: APjAAAVyZZ1EGwVwaUOIA214RJ1SQF5W/U3xbte3K1fpAWmZaLYgRz/q
        3UlCuDmbMQDX/UXisHXCHvs7/w==
X-Google-Smtp-Source: APXvYqwWcE2RLum3BzRhMB26Ykpq9P1ru36qoHUfErGfACNlntG5JKw9iQuA6TYG3zMJNZ+ejhyriQ==
X-Received: by 2002:a5d:4582:: with SMTP id p2mr42751074wrq.305.1568405946772;
        Fri, 13 Sep 2019 13:19:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s12sm42231261wra.82.2019.09.13.13.19.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 13:19:05 -0700 (PDT)
Message-ID: <5d7bf9b9.1c69fb81.96e74.f21a@mx.google.com>
Date:   Fri, 13 Sep 2019 13:19:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192-15-g8e25fc1750f0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
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

stable-rc/linux-4.9.y boot: 115 boots: 0 failed, 105 passed with 10 offline=
 (v4.9.192-15-g8e25fc1750f0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.192-15-g8e25fc1750f0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.192-15-g8e25fc1750f0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.192-15-g8e25fc1750f0
Git Commit: 8e25fc1750f0dd9f378c153ecda509a578059b81
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 14 builds out of 196

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
