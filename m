Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4E621125
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfEQAF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:05:29 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39363 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfEQAF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 20:05:29 -0400
Received: by mail-wr1-f52.google.com with SMTP id w8so5183921wrl.6
        for <stable@vger.kernel.org>; Thu, 16 May 2019 17:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LPH1dnVHGcGDyjoBiaELfnb8SHkCpxzEd9iRTZhKjCI=;
        b=CfsYUma5k4qZ4wEFvPFT7QL44WSI1md/IEpr+oq7vTDlFWLA/yURDoXEy92vUwg6LU
         OSA1DO27pjrcTa6/vNqEpM/tbm6m/ipyYkTHA5Hvvm6x67YxXcNqFWx3fCw6loeMJWGk
         SjFJDCKMWfbdU+cVCPAwJx/MpUiUBxXx/OEzhqiDhbvNrqJhQ55BnDK/2WTk1+sq02zl
         PoPMCCcv0aPdl0N3Zn3KsB+fYbtmLfna1US63xcEAXlGTIkBpt/rnN4TCRW2zF9W/S8X
         d7PWVDj1NZjKP9fYy1O8NaozOar2MxPgHEpko/MdWt3PNHMlHBHRdAVFGcl4mzMXRNiC
         xV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LPH1dnVHGcGDyjoBiaELfnb8SHkCpxzEd9iRTZhKjCI=;
        b=lgb0UVZd4BPnrMsTmeiVmFfyg9wbMBu3rCjt8O3iAkFiYY+vITMNtDyigkw7PJD+2U
         PCkxBm/3C7uIYWnFsw03WVVHqcFTmRUJStlguA3b17WUnefIV5Zzkd1T58lSsbgGMUgD
         SdIF3d02MX7Pb++RuRcDczm9ENbOnv85NEDlfWrstUhl9wtqnDmTq5U8Ihk5GSAZQXiI
         CacatiNV6+ryJaEPCs0jOwAh1d3W2e94gapbJebQxPZHz9TLeee1/hPpDDumC2pmddG3
         PfBVgZfxpYchW0Xs2lxSJpkKHD20KR4ZZsXW3V5CSlTB2ndoKbMc08cHFE4Inkn4Zpuv
         Y/zg==
X-Gm-Message-State: APjAAAVvDqZQh9UGyH1vwAF5bDS+wdhTubNyaifCRWSAru3f65klqhaI
        6yoCohFiG+WsbIzN/U292ANtH7bNtF/Ilw==
X-Google-Smtp-Source: APXvYqyZKBZMSWM7VykOAQDkFRdlFfzRwJ9WEcaV9R4A+0M07OLUhIRFeC6FnKBgFD+QK1qgi1tAsg==
X-Received: by 2002:adf:f841:: with SMTP id d1mr11591345wrq.62.1558051527494;
        Thu, 16 May 2019 17:05:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 9sm316972wmi.24.2019.05.16.17.05.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 17:05:26 -0700 (PDT)
Message-ID: <5cddfac6.1c69fb81.939d9.1bff@mx.google.com>
Date:   Thu, 16 May 2019 17:05:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.44
Subject: stable/linux-4.19.y boot: 61 boots: 2 failed, 59 passed (v4.19.44)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 61 boots: 2 failed, 59 passed (v4.19.44)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.44/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.44/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.44
Git Commit: dafc674bbcb11c6a5c63b75be5873b118e2add17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 14 SoC families, 11 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: failing since 2 days (last pass: v4.19.42 - fir=
st fail: v4.19.43)
          omap4-panda:
              lab-baylibre: failing since 5 days (last pass: v4.19.41 - fir=
st fail: v4.19.42)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
