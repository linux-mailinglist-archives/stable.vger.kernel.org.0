Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8208E29062
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 07:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388445AbfEXF2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 01:28:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50815 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388051AbfEXF2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 01:28:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so7954618wme.0
        for <stable@vger.kernel.org>; Thu, 23 May 2019 22:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=RFTpgKRph5hKN4zTxKUj6Kr/SwTVEIL9u2TwViKkFZk=;
        b=vAvXIxPjSSPQJ/jwSn2ql0sbGOYI+N9VsW1Ov6qe4KCrNHZL+o9rxlzGT+/kO/9vv8
         fxT5wSHIue1K8T9gju+d306IKXguLY6K/oHFG2hOZ4YTyvM5KLKetDw38ifnvIXPeY00
         E7vh6XelLoC7w0/PepM6VagNMQWUmgm6hZtrvaFxeleMIueJycikrA3Inp30/sbsTdil
         MgAUPo4EQIQfhZFmR47yw9QFlE0TTwOuNZ6UUTWXuMddKUa3Nc+/Zr0K8K2r0n2oGPfR
         vAwpnZmiuDkKt2XNPTpezDxjn/B/ZRQM3GEJQ5APBE6NxvLrjPyjg7ZAY5PIqZHGikWI
         SYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=RFTpgKRph5hKN4zTxKUj6Kr/SwTVEIL9u2TwViKkFZk=;
        b=qurNhFb5jKXWUwV+xtom4H6VBJ+U60GtpS34FYG5vJpkSaG/m0BXDUXYOY+fE4lhH1
         4xkvdjFerXf3wGyMXcQLx8OcN0JAK4Bh7fLQCrd8NXRkOaYha4jXDByfRYFjEP//pIKV
         Wdw4cJihU7Gwbs3CpBzHLiaDOycTIgwfS0OsEV0Bs8fZYMDnaOck8DtpSNm3UNwjHet3
         +d00EC7gHymzL4ubsv/JNZlKdpk+zEHrG9EQYJjK/qdvvV3oVJjrvXoYYrE6FqjUic9f
         T/5got2/TPoOJ0C7WoxdtgqHmD20w7oEyYZ+eRwbxCZyPGSUp+cVYr07kwVr628Z59bi
         XiaQ==
X-Gm-Message-State: APjAAAUJqa1oPtV57Sa7N0KrtRMazbq6Oa0ZDWvzIS8Xi8l+5fk7YgbR
        47k1Rdekq0MP+IOTz5Rms4xnfg==
X-Google-Smtp-Source: APXvYqzwao2EN7hiFW+Tv6d4/ftSGcUlI1GVkPFKcrwoS6nS6JeY/tv8y/IfU//6RKQQsqjoAAQqmg==
X-Received: by 2002:a1c:80c3:: with SMTP id b186mr14376002wmd.43.1558675713578;
        Thu, 23 May 2019 22:28:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a5sm1058730wrt.10.2019.05.23.22.28.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 22:28:33 -0700 (PDT)
Message-ID: <5ce78101.1c69fb81.69b72.5337@mx.google.com>
Date:   Thu, 23 May 2019 22:28:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.178-54-gf6bc31d8c3be
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/53] 4.9.179-stable review
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

stable-rc/linux-4.9.y boot: 107 boots: 0 failed, 94 passed with 13 offline =
(v4.9.178-54-gf6bc31d8c3be)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.178-54-gf6bc31d8c3be/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.178-54-gf6bc31d8c3be/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.178-54-gf6bc31d8c3be
Git Commit: f6bc31d8c3be3e5ab957341b3f99f8b45fcc646e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
