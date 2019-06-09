Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A357C3AC4B
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfFIWKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:10:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38852 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbfFIWKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:10:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so3921828wmj.3
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 15:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=2SWyFvEavyrqCv7g0qg3nkQ1nJujvkYSoQyWpe8waIw=;
        b=p5NiaGiNdXu7fNEnbzJcsx/hI7yPrtMTqAPo/7q8yjSuqspmC6SZXpXzrb7Ff7kjN/
         P9QtRYdcSsoDfa64Xb6zjvoiL2LcWcU2fYVGPe/lkdaHYMK0/834U2Dd0z+/XcPA4c2E
         Yb0r/SAzYBTm/vTAtkdHiXTsXZxuQgSluJ3q1kaYyaG7YLG4zTWsgESXtmNp5cecmWIG
         WjkZPBgGdwWPiI5/wwneHLEbrD2WlgRkicLS55AZh0DfI68VnBWUXyetDbm7c/JgTV5k
         nikwFT6AsqfTFjU5gavLHm4acFc9eBu1C5CJfoUVzi2RmoQQpyi4V3iSQd1Bblq+Dujg
         BqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=2SWyFvEavyrqCv7g0qg3nkQ1nJujvkYSoQyWpe8waIw=;
        b=m5WN8YNSXXaD9A5C9pqScu0NwqNBNf6v084dGOcikec4rUz9QRRfPbrVD4+6ccjgKC
         aK9Jnr+w2r2OcRLcKLbgA1p6lpetiBQpZDIxY6tLJiTDXLUYobt7wBbEr8q1p07FjiVu
         kzDcYyFImRT+DNCdi76e82ycoCjEVcRgE20YtCe38cZo6M9MllLRvzR9TyJhu/mNVUvk
         xooQnPBcrDB36sSyX4L3Y2EOAaRRRYrRZDfRQAzKK5d1Wz5JzhgPXDaz0W+wpIpDQqbh
         VQcCyHi7Z4KvDXo/SaA0aXDHa+gZsdPNMH+CjjuNDFEizrhLNt69I6X8r/YRfL9t7y8+
         SB6Q==
X-Gm-Message-State: APjAAAWKXUWDTIMDFRuVGhHS59+xC2kVMYMQyBZKMN5ogogNP80RzK2u
        y9tQkjatrE9ue45DGDbzri5vCg==
X-Google-Smtp-Source: APXvYqzfPrnPPLX/mv7/WIGIEWVS3WMTOL99Xq2g0PTcKkOud2YRsXiHDnatm+NIEmLAzXuMaSACsQ==
X-Received: by 2002:a1c:e906:: with SMTP id q6mr10980343wmc.47.1560118200838;
        Sun, 09 Jun 2019 15:10:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a19sm7064532wmm.46.2019.06.09.15.10.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 15:10:00 -0700 (PDT)
Message-ID: <5cfd83b8.1c69fb81.447c3.881b@mx.google.com>
Date:   Sun, 09 Jun 2019 15:10:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180-84-g4fcf72df7bc7
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/83] 4.9.181-stable review
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

stable-rc/linux-4.9.y boot: 107 boots: 1 failed, 106 passed (v4.9.180-84-g4=
fcf72df7bc7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.180-84-g4fcf72df7bc7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.180-84-g4fcf72df7bc7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.180-84-g4fcf72df7bc7
Git Commit: 4fcf72df7bc71264d86e616874a0a0cd382f1b12
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.180-62-gd9b5fd7ab1=
7b)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
