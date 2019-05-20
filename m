Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847A423F62
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfETRsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:48:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38807 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfETRsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 13:48:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id t5so217860wmh.3
        for <stable@vger.kernel.org>; Mon, 20 May 2019 10:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=ASi4P+vK/BY4xARlAX5okcCkAi7jUwOKEr1mT66lsfQ=;
        b=eBhoX0ptMhFEvGDGd4CD7W4J15ef0bRB51zZwfEEyLbRH3a8MaLiUGeq7ElGJ7nTAB
         zGjH2NhWOo1PEnqsPXkKCrCmTiQqIijjGexUgk1wl2QcMqH1hjhzp4q+TV3jhTpZKsDE
         4cMBjwvC3X4twDv8atsVikKEX5U5lZG2Ylbvqqr+2OL1MpH2F/J1GJpIt6xTvYgnmos0
         hTMjqK37n5yyFp1r06W1MLCXq2XxmbndM6igwCGS+190iPSQ1nfdCiKjeRyaKBsxRbCD
         ROdFAoWkPHDDx+TwQIGw6Uyl/yFyJ0neIWTzvIjiTH1FMy70Pb45A/zOi+rMMLYWYrmO
         uMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=ASi4P+vK/BY4xARlAX5okcCkAi7jUwOKEr1mT66lsfQ=;
        b=ATGOJOooJuAZ4spa8gX2hV9XVTApxyzZW4SozAbSUWOj3omsjQ/XQYGRwoBfOA/NRN
         xZJ+fNoDpuLI6oO1AVGaVs+1SDY3X7WrFCzwrhmsdgS0bED3S7XVfRNLArBxbcfpr9nh
         Cwfklr9qyk6c7pYwwHKJrBoJ4KnaWMB4bxddRANPdueMRv9yzjwCwLSPDkfainlTEAX+
         UKjE3Vc0GIJ8h4ZQcX3dPXSNHNe6yGYjzeDKYfC4i9h7DUbI0h9VFbiuOMtoHdSM0CXS
         w/KND6C5hFW8gYFuKkeHlfBxdWz7NiD5t2Iz0HoNRZPkCqIzTqa6Md/WPL2c4wKaFGkV
         ++mw==
X-Gm-Message-State: APjAAAWn/Hf8ytCJRP8MwB/RgxYEVYHl/8SxVvbonwP5OXxe1oAGh16g
        qxjZScj4cM/dfRQ5Wzh1fysrmg==
X-Google-Smtp-Source: APXvYqxhBojFsH32AKHeR1/kcB+5hpefssYLMXmgAYWw+YhxdLjndpVzpLs5H+/mfdRcv66/Ozhw9w==
X-Received: by 2002:a1c:9c8c:: with SMTP id f134mr214333wme.95.1558374495158;
        Mon, 20 May 2019 10:48:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b18sm16167146wrx.75.2019.05.20.10.48.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:48:14 -0700 (PDT)
Message-ID: <5ce2e85e.1c69fb81.1cae4.71c9@mx.google.com>
Date:   Mon, 20 May 2019 10:48:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.44-106-g6b27ffd29c43
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/105] 4.19.45-stable review
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

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 118 passed with 1 offline=
, 1 conflict (v4.19.44-106-g6b27ffd29c43)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.44-106-g6b27ffd29c43/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.44-106-g6b27ffd29c43/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.44-106-g6b27ffd29c43
Git Commit: 6b27ffd29c43f07e11cc906154745c4e9b3d71c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v4.19.43-114-g=
b5001f5eab58 - first fail: v4.19.44)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
