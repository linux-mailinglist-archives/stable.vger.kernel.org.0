Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F61F156E83
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 05:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgBJEwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 23:52:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33224 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgBJEwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 23:52:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so5853682wrt.0
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 20:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9xLA0rhuzwKmWbfyOR+bnjhGhAVV/QAXF3/fj7C2O8k=;
        b=OZndUBuhh9zhnrL3vhwhx9M+2oLEHiIiKN9U4+9N6qlrfATdHVzdR4X/rn6xciOFLP
         SoWpP1KBT7Qvj6TDGOX06mOPwv2vZDGdOvVLA7pOBW4hNw+CXy+ZKwx78MOGyyKLOuUU
         WsH1RdjAQZqwycZtZEtbW0g0a7vZrxJHuUZ7aWgGMldwQdNYKPB4jGlFSCQo438e976t
         Fhwv80Gll+/dvGVYN8YyYrlWWscZYeHbEmGevfJy6f9BYR/r8PjNyitVn7Oy+LFpMYBp
         HvKoj9dhZPlGb+t5KyfR4jZwjlOC9Z9rnCrgaXX7/CWxf/kjmybq+tMnM9uQzm8h4huP
         JG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9xLA0rhuzwKmWbfyOR+bnjhGhAVV/QAXF3/fj7C2O8k=;
        b=mnPqUIiS8WS5D/tExBt+CtcWvm9HUrbu2qZfexLxxxItTC6ZFXkmBZEeidppAS6Aku
         WNgxCbOgCJxs9sTg6tKidXR50pCvnD2beOZOjoMAgRxR4ZXL4UWJ4riyA+eZnv6adPG4
         wTYRh+hRd7QLJCqj6+MxuOaKKy+zehGiyNCHX0anNjxNaRoA1fOKeAMCK9alcLifQ64b
         2O8eFgCOTcRXLp7qh8GqipbmGddu/IfRXd741Ubyyf4pFQjOhZH0FmLYTzOz2PQLR2Mv
         chsv8i3suJk1wTq1BxwwkekuIKJ0jPrze/BxVtGE5fI77gB4KFDNHTar7c+fAv8RRmBQ
         eaEA==
X-Gm-Message-State: APjAAAXbA06PdRD1eMab+gEhyGFYsgsROP5x7G86QIqMBeWjO6lYqjzF
        i4qDrNzD2xrIZICYmDPOY6DHF9u00l4=
X-Google-Smtp-Source: APXvYqw/oCxQW2mjopHHGR9aNNKfNHDSVH3dknFlTvtphyIrQwVj/ynlyBEWPvFbyeqnf6xRaQ6bvQ==
X-Received: by 2002:adf:e610:: with SMTP id p16mr15495280wrm.81.1581310363231;
        Sun, 09 Feb 2020 20:52:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j5sm14949783wrw.24.2020.02.09.20.52.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 20:52:42 -0800 (PST)
Message-ID: <5e40e19a.1c69fb81.cd02e.ecc6@mx.google.com>
Date:   Sun, 09 Feb 2020 20:52:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.170-140-gbb01d00d3d36
Subject: stable-rc/linux-4.14.y boot: 89 boots: 2 failed,
 84 passed with 3 offline (v4.14.170-140-gbb01d00d3d36)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 89 boots: 2 failed, 84 passed with 3 offline (=
v4.14.170-140-gbb01d00d3d36)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170-140-gbb01d00d3d36/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170-140-gbb01d00d3d36/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170-140-gbb01d00d3d36
Git Commit: bb01d00d3d36750e338cb76df7febc1f725a1cdd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 7 builds out of 135

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
69-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
