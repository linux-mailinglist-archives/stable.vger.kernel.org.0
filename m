Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB4FE74
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfD3RGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 13:06:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33329 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfD3RGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 13:06:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id z6so2822804wmi.0
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 10:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Mn4S8rnxAWXrqwzwzVKs0U8dS7gV9+cUXMTKHHNHoTQ=;
        b=zfqjuz4fKkLrqCpLZ50XHs/0LyZaEvKKCViqeCyBd0Mlrjv7lsISpUNTpsasuBkHDL
         vDoLwhdMaFWfcp/ooj2Bc6wurv7iPOMqljK4RukgZ3i7JRX9FqjUUlGcU/EU6NDD6bTv
         hM9az4gLyslH7iGba3+wyc7MbP3FxqOzMSEfh0oNWAs7CP7TBgogBFJziUEtjlnLhOm5
         g1bviBvNrXF5MrgBDMQHny/TK3Be5Fqb8/X4WIS3q4yqrQa3ulpjrpKmqVdc4kmZLFBw
         1hK0m5TWiiYxJfGcLT0k9vj1YOVaEXZbMDBBdMeba7X+mTlJR15eSh8pIh0/fUgtsQ5H
         oZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Mn4S8rnxAWXrqwzwzVKs0U8dS7gV9+cUXMTKHHNHoTQ=;
        b=ilNQV+cEFRjfUom2IMgYgrLZ9NEsEPzbSTScb2scI5leH4YNxDJP0moAvz6HqhoIvg
         6R+Ix+vpunJWqYrBX13DARR6Ga/GK177Se6M7uXUZiEdXjyqaTGM0gXppBMQHpcAN9PT
         w0Oa0s7J0HNOvKd4yTUeZNhi6gEFbbjVKUcqHP3tWG5KzHtD2TwnM5y5TXTGj2x3Hcl4
         oLtK3hl4CwzqHFQKbijOGF4+EE5sNuL8pkCkSOCk5W9LQDG1fi2alO2ZGEbQZbFimjDR
         aW6FO9n1mnmGKz8A51CeKBv+Pt2+OaVnsvNqoHew8vvXSEWp4YLe4vh15F6bwSq2RouZ
         4pAA==
X-Gm-Message-State: APjAAAU+swx0CHWMGr6xjCN677PlY6179c2jXtol+lGCheVkFWcblS5M
        aqZGSz+eqwceWqdzJ6DULFPfmw==
X-Google-Smtp-Source: APXvYqx4NQ+1Y/BmlSvop8HPxb/zWLn3py6MzO23lYnevkdGmoa1z2r1RGcsiM6rqqbwkXPyQGUlfQ==
X-Received: by 2002:a1c:c142:: with SMTP id r63mr3993541wmf.97.1556643979107;
        Tue, 30 Apr 2019 10:06:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c204sm4738454wmd.0.2019.04.30.10.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 10:06:18 -0700 (PDT)
Message-ID: <5cc8808a.1c69fb81.d69ab.b13f@mx.google.com>
Date:   Tue, 30 Apr 2019 10:06:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.10-90-g852cce372723
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
Subject: Re: [PATCH 5.0 00/89] 5.0.11-stable review
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

stable-rc/linux-5.0.y boot: 128 boots: 6 failed, 118 passed with 2 offline,=
 1 untried/unknown, 1 conflict (v5.0.10-90-g852cce372723)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.10-90-g852cce372723/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.10-90-g852cce372723/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.10-90-g852cce372723
Git Commit: 852cce372723872dc1e9f40fef3bcfd2b3215420
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-7:
          hip07-d05:
              lab-collabora: new failure (last pass: v5.0.10-72-g49e23c831c=
03)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            hip07-d05: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        exynos5800-peach-pi:
            lab-baylibre-seattle: FAIL (gcc-7)
            lab-collabora: PASS (gcc-7)

---
For more info write to <info@kernelci.org>
