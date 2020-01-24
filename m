Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8518148BA4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 17:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgAXQDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 11:03:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33157 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgAXQDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 11:03:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so2620086wrq.0
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 08:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PHE47lFq5/fvGrizrAL8jv10DagdWORFMqLhZRUXrA8=;
        b=OoDNy4rdorklhLDwQ2YsGs/NYjCDDlGcoY/HW8dNfUd77rw7TDiDjK5BkK6My9iPK6
         dR74rSqDTAV3SX1WBmfTSkfM2t6a7HZ1GpkSQWCUNkRwlDjsFUdwiSG2xARqWqKmFJ0p
         afZ5MLtfAIRf4C8leZTxtxc+dP/fK06f7qEG+Be7FyL8Py7An0lSZ7BK7UKS++btKbPR
         9u8fDJf8HayEEaMMwPqIxiE8RW5YLKH28MpAOATY3tCAOKixCEiD15DDzT/YUS//BTa+
         kTisRokJaEnzTKrlBhsQleUNe2/IAHciSi1Hlp4J1JaoHm0AKvnJf7R8O0Xniioc49VL
         +TWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PHE47lFq5/fvGrizrAL8jv10DagdWORFMqLhZRUXrA8=;
        b=hSRB7CYJRe761uGuCh40gte8cc+IENJ/lyKihkwTK2xG/oxxJv3wMIuUcWg6usJTXr
         wo6qUoOU7QPPxYhn+I/nNhqNnnkaVAMoVQlZdcYi7WvIhF0GFEoFjL4tcRe6AAIpHgfy
         lZ0lbOUooEbJJxpz7I6d9MK+zcjtPmqc3VlqYKqpezxsEz9F24iXLDyq93+kr/GL1BNC
         siGNcXE+qFGaIEAAhkGoMjqoaDwyQB9m2MonzIDHuf1hwnxyrg1/cBTLyIAQ1DtXJMK+
         6jnmY9oRSRFY95exQeUFRizxsTC1/EN8WBwPTBDbd8iUdY6FtntqC8otZ3Ug9OVhdb3i
         zoMg==
X-Gm-Message-State: APjAAAU2sUXl2K91MHlS0pvqELvGgcpsqCNqlyS7prr78PTi8QGNf51W
        HhFDmfEBwC9JOvKfDEnfDDp5vYSlSTseag==
X-Google-Smtp-Source: APXvYqxUprLA/i5pTagfOmsyAAVY6hBpqycrpiFwF5L+fQ3jgyZ3ya0Rmuv8fke3PdRKIpOl4K9q4g==
X-Received: by 2002:adf:e887:: with SMTP id d7mr4979359wrm.162.1579881796961;
        Fri, 24 Jan 2020 08:03:16 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a1sm7830985wrr.80.2020.01.24.08.03.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 08:03:16 -0800 (PST)
Message-ID: <5e2b1544.1c69fb81.208f8.0f8f@mx.google.com>
Date:   Fri, 24 Jan 2020 08:03:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.98-640-gd521598bed24
Subject: stable-rc/linux-4.19.y boot: 135 boots: 6 failed,
 121 passed with 6 offline, 2 untried/unknown (v4.19.98-640-gd521598bed24)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 135 boots: 6 failed, 121 passed with 6 offline=
, 2 untried/unknown (v4.19.98-640-gd521598bed24)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.98-640-gd521598bed24/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.98-640-gd521598bed24/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.98-640-gd521598bed24
Git Commit: d521598bed2464511b7d1f1dd553132c7b658394
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 23 SoC families, 17 builds out of 193

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-h5-libretech-all-h3-cc: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
