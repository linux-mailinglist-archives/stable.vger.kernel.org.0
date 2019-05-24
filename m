Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC128F68
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfEXDIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:08:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39004 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387559AbfEXDId (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 23:08:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id w8so8339361wrl.6
        for <stable@vger.kernel.org>; Thu, 23 May 2019 20:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=hWBioqGdAhicwfVnDJ7CU+jAbGNSq11bdhgnot7t3fc=;
        b=PcLRTreXkgb9rlIoWn4mWuvzpdK9RW56YiO2lPjeC4Ues7GL1PJpRMlmMrc4sNIQQW
         unoObt5Wea7JNWBhX6LdNVz491ocg/KtEy9cJaNml4rv05ZcOCDvQ3gtpMKXfRRSZI7/
         9R3hzSdocbojxXTT3i0D9Sz91NNykklOjWXK419evKkvAbOSJJH7emRsETPZDd2arluw
         AracvoBkDugHjTNDm3LEY64vAHzN+jcPQUShBcv2bEqrc8XXcNC4fcWCZqojCWspRl9p
         urIQwfCkGs2nxAPk0Esv5fUjG+3k3c/wCIOQAHfPX7aqiTM0Kr/lK4PJA2tRk/LtmShF
         pwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=hWBioqGdAhicwfVnDJ7CU+jAbGNSq11bdhgnot7t3fc=;
        b=lk35UHq83WVZvHmNCTxBg2onnVnsfZlIgGIjxZ+rdUrouDjRWas96YVW1hskZ0j4fb
         Ho8vn5D3oaDDc7lSwlMu0UNer458GHAxEk9tsMIxHVGjGoAftf07AFE66yEufFW5CVD6
         ayvQ1d4imLvoBoygJLAjF2mR8ipcSjIGIgiMJKq4ldz8rn3cDZy4xlmiJArYXczqhXq0
         VwtyLAzvru0C6Af/TOxEOiWPjXtOnyK5rgUbM9TsnjjScrCV1b0LLc9ytheDec2P6IZi
         m4dahZgFSyUTxHn7pmzscF0mM16FJ8cITYNEm8t9RBmTP6/+jFdCwhzOtXNin0y8ZRvg
         JRKg==
X-Gm-Message-State: APjAAAUQMPVODHpTJ3+2qVPrHbkvUlieVDNU57BXX1tDpmmaxgPDfEcO
        DEfKGsYzbRSuXlcWGTPLwbBu4A==
X-Google-Smtp-Source: APXvYqxdMbDNlNwINk99wOUI2dGejct+6P95hqgqYacR46/tjqnWRYamAJhaSxQX+E7aUHBsXa78AA==
X-Received: by 2002:a05:6000:1209:: with SMTP id e9mr61818403wrx.205.1558667312392;
        Thu, 23 May 2019 20:08:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j82sm1027411wmj.40.2019.05.23.20.08.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:08:31 -0700 (PDT)
Message-ID: <5ce7602f.1c69fb81.adcfd.54f9@mx.google.com>
Date:   Thu, 23 May 2019 20:08:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.18-140-gc7802929531b
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
Subject: Re: [PATCH 5.0 000/139] 5.0.19-stable review
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

stable-rc/linux-5.0.y boot: 133 boots: 0 failed, 118 passed with 14 offline=
, 1 untried/unknown (v5.0.18-140-gc7802929531b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.18-140-gc7802929531b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.18-140-gc7802929531b/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.18-140-gc7802929531b
Git Commit: c7802929531b3fd886283d78a4f91f1e522cbdf2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
