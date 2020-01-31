Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B435B14F209
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 19:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgAaSTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 13:19:21 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41482 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgAaSTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 13:19:21 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so9770246wrw.8
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 10:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TTU7MDr2I512V+qfhk5wI+Vzac5IONeON8gcOkEXPI8=;
        b=ig5JFHs/ISL0saAN9o7u7+j0F6cM3aeR1b+d2j5f9AXDJoTI6C6MF7GSbeCHw3t5yO
         sDMAHTuGFZXUvGxYbennFN7NuuKnV1l8oZ/oX8IcpM415m5RxUyURSuQpjPUhNGoSLfR
         jq0QGiaSr8n23gY0MaEBgrXEaz/jy4oBR6mCM/BPbZ5x3NbUD0+Hk68ZcD85WAWRT7U2
         m/Ov6707qiy11fwanqb9i3YLXb1Kz13S8ETuQNLwzTANQ0m/6zd4/NaY9nguDCbB8CkP
         t8DIA6qyrbfxCU0n21rmEf5fdfhEck3BweM5TBgJ8G9UlLfZ1tMUYv7oPby18DntrC+i
         mAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TTU7MDr2I512V+qfhk5wI+Vzac5IONeON8gcOkEXPI8=;
        b=P91/5NSIyc+EiEqv7+mPKMUqwwZGseWLAUVy/6lh9OMyOoAFE0UUxM1HcBxjFhnSiH
         TPgwkA9SId7Io5Z+MFn4O/8Vvq1dsXLHLctBWToFabL1q9KNzivIZwlaCmNAc9M/Si4h
         Wryjby63LsSip88LyveX3SVWQJUqxY4nqwmCaIIUlF+XyB+1nDXZ5t0CeTw5vBM7V3CK
         o7hIfl2THOrFHhdVuwSqHpiIXVPjQyfFuH6xA90IDFckmI8TEXR9pOShoQ2ZtpRn42cA
         SxvRS8PZApD4S2ikTXxg6mlRrvzeWFSdKyRCAI27jNWM4aBp3C5sIJwoVkJ9Gh9VuIO8
         j99g==
X-Gm-Message-State: APjAAAXyJVTyq9poQ8gi2v+eH+u6odeaTblzbvG3QohKRQDPL2Tex8eQ
        c2fMKwA/BgsVva1FZ+mGwGVGnpwxaUdzDw==
X-Google-Smtp-Source: APXvYqw2Amv8YUm2nPpmIb2zWPyAo5fjk+f37aLuD7p6fsXL10LrQtYSuSLlmVANjpIldDaZfpDu8g==
X-Received: by 2002:adf:90ee:: with SMTP id i101mr13217865wri.417.1580494757454;
        Fri, 31 Jan 2020 10:19:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b17sm13202951wrp.49.2020.01.31.10.19.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 10:19:16 -0800 (PST)
Message-ID: <5e346fa4.1c69fb81.43a73.b3b4@mx.google.com>
Date:   Fri, 31 Jan 2020 10:19:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.16-111-g1bde1c513887
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 85 boots: 0 failed,
 77 passed with 7 offline, 1 untried/unknown (v5.4.16-111-g1bde1c513887)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 85 boots: 0 failed, 77 passed with 7 offline, 1=
 untried/unknown (v5.4.16-111-g1bde1c513887)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.16-111-g1bde1c513887/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.16-111-g1bde1c513887/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.16-111-g1bde1c513887
Git Commit: 1bde1c513887dd7bac46be466f1cd06fe3a64292
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 20 SoC families, 16 builds out of 162

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.16)

    multi_v7_defconfig:
        gcc-8:
          mt7629-rfb:
              lab-baylibre-seattle: new failure (last pass: v5.4.16)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.16)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            mt7629-rfb: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
