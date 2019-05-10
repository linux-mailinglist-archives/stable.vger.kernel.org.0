Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC82019625
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 03:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfEJB1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 21:27:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45081 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfEJB1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 21:27:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id s15so5501391wra.12
        for <stable@vger.kernel.org>; Thu, 09 May 2019 18:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=ftpViN5j8NFAV54qkkJMS7+epm3RTRKzoNYTV0PlOJg=;
        b=YsbrPpzThe4ctLjXBEevMymgL7213QNtGRyA4NrhC/5eFu1pyt3lW/UZ9d17gTCDTe
         cxjxY5wuZvYTvsPg63uXO6fb8U2qf2Z9W6szny5MPL+YlAgyy6ccdGA+ar7+cZFO9McZ
         y41ypt9ziLd8y7qNcRXbWU2h/+PlgGG8U9JSGEoP9VByZ5Jyl2Z8f5aRP22ZUcSrvaRo
         /yFeAYlKjku7bjVMt9rpSbt2hKQj3HXZ20RvInP61VxxC6RQan4LlMUzPdm3e7SIjr7A
         UvGEb/rQyFNedzX+6b7nXTX7TtEWxDu6/K3yp8xoM/5TQBxrcICMrXxYsxTJTmtzLr2k
         zc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=ftpViN5j8NFAV54qkkJMS7+epm3RTRKzoNYTV0PlOJg=;
        b=GmbI2k1uamakDi2lcawko0Nkh18biBxYTMra/seSih9MkR84GhoJhqTIQcG8jsQI9L
         vN1ce0lXXc1qX+MHPFmTYTWfuXDmnlYd1luD3w5kRSbNobtwZUr3o+K/tLiO5Nez9eIb
         wRexX+LyN2PYnnv0gdrNDlxAOEJV0SZYerL7iamsBrFk9SVrBmYQUXVbb4qrNxnG32MP
         JVzufWsgolb01seWWXztB1UbJGmW/iPB8StJ58uz7G6mIARfrlmWgd/a9MjbS+CHvPtD
         s6ajLpeaBQopRwQbPDuYKvGwn3gFRZNkeEko3QZfXv5tv4y1L/xbnxAo+UKZ/Zjt5ncp
         dX0Q==
X-Gm-Message-State: APjAAAWUGTsxiEZmJP9b2c0wBD4nIREVdwYMODXFld2/5zc9oy/LEEhM
        2VCPPbgc/o7ex6l+cOsGnx5Mgg==
X-Google-Smtp-Source: APXvYqyarNorOi0XwqzYDk1kJrd9ttGSJJRIcSk1u7eamncDsxys6dMt/bwjjnDvEdJygFoWQSRtPA==
X-Received: by 2002:adf:83c6:: with SMTP id 64mr5627489wre.81.1557451634115;
        Thu, 09 May 2019 18:27:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x1sm493646wrp.35.2019.05.09.18.27.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 18:27:13 -0700 (PDT)
Message-ID: <5cd4d371.1c69fb81.c575f.2868@mx.google.com>
Date:   Thu, 09 May 2019 18:27:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.174-29-g50bbfeb1e2a3
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
References: <20190509181247.647767531@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/28] 4.9.175-stable review
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

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 107 passed with 2 offline,=
 3 conflicts (v4.9.174-29-g50bbfeb1e2a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.174-29-g50bbfeb1e2a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.174-29-g50bbfeb1e2a3/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.174-29-g50bbfeb1e2a3
Git Commit: 50bbfeb1e2a357db99ff35681cfa95341b33103a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.174)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.174)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
