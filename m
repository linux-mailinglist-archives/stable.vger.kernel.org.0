Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE61FB3B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 21:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfEOTru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 15:47:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41752 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfEOTrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 15:47:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id g12so503269wro.8
        for <stable@vger.kernel.org>; Wed, 15 May 2019 12:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=0WW703pVcAi5qG/en5h0bzayogRvn6kb9J/fL/xA7i0=;
        b=hgwsxbStiVDb528o2+wADxrHQlduzvmbNkKq33XGSpnYq1K5MmrStbajrs/r+GxnkK
         nvoPfGVWfbWi3+MSlNDnYond7MBuT5WcqnOqzbUT873nxQXPWgUWPg8QdBw0MRtDnfGK
         VKlntyKwXjSSbe/RGb1z0k30lwHSngWk+yUcebsGUSUWCo5Nh/MwOxftxuSjlec6xA5d
         oe8ohPRWJtG/xqi5392ohxVJQDsSibqu2+UmRFwCgf7Uj1DoeOKu9izEiaRecPxCeqsx
         2kwRKZDJ/oHzxjGAptRmekPQ3PaJOrFRpNazgYLl8t7ZnTm/phRnpjEogUKVFpYLZUyg
         M+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=0WW703pVcAi5qG/en5h0bzayogRvn6kb9J/fL/xA7i0=;
        b=bcLQNfxubwsBHN+/1ynWTWElpfWc7Gi2C2ooP7aCTPRtOIgFm9mfJ3Cl9u2iCQNXie
         eL2Q2pNohHVaWpAl6yCmZjWtOx0h0QVLIppcyZwhBH4sw1PSoqY41LzwrVYoyYwJcVj3
         OEqDPvqv6SjQAswHWGLdqeonJF3Wj9AL4hQeqw3+2LrdUxov85ffXSsXkRZli6ax2v5k
         mISLBnvKj0oHToRlj6rYegABcj8TV/yrN0ELbCrCKd9u8SH5Q1ywbf8RHMLURXsbkRNY
         pQcJw1QcgH2luqoPvxNB7YbTaDgUv77luqStR5gEmyb2acLWQcMnCWiu6EwTU/aIg4e/
         smYw==
X-Gm-Message-State: APjAAAWzZWUZHj+QhSIiSb2/fL7vHNtjVhkYqV6MMVVIplmFI9mWP+IS
        1VWQETzR9OqL736mwb2x7lxi1ZSsF2RFkA==
X-Google-Smtp-Source: APXvYqzw8lU7qs8baxSFI/CULQBQ7pVqFe2bLV5JK/UwtwEXby6jNw+QeBun6jsp8KUKs54GIDjQlw==
X-Received: by 2002:adf:81a2:: with SMTP id 31mr27186734wra.165.1557949667875;
        Wed, 15 May 2019 12:47:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o8sm4199362wra.4.2019.05.15.12.47.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:47:47 -0700 (PDT)
Message-ID: <5cdc6ce3.1c69fb81.41d83.893b@mx.google.com>
Date:   Wed, 15 May 2019 12:47:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.16-138-g174f1e44d016
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
Subject: Re: [PATCH 5.0 000/137] 5.0.17-stable review
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

stable-rc/linux-5.0.y boot: 139 boots: 0 failed, 136 passed with 1 offline,=
 1 untried/unknown, 1 conflict (v5.0.16-138-g174f1e44d016)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.16-138-g174f1e44d016/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.16-138-g174f1e44d016/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.16-138-g174f1e44d016
Git Commit: 174f1e44d0165ce68f4e520718847304556717e3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.16-105-gcedd923508=
e9)

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
