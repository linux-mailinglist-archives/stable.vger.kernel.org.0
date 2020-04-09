Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9981A3BAD
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 23:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgDIVIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 17:08:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37895 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbgDIVIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 17:08:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id p8so56815pgi.5
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 14:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kRTMrrmsNDzEw8eYmhPT1OaKOC94CF0nr1AjJq3zTok=;
        b=ioc6B/7u8HqKgZAOzE/rLxCegn/NJpe5uuiTOx7euXJlXahQxRWgBXCge/mlGn4O6D
         qRhzTAMBJPZUgqvbc0oTgDXmYytADDmG5QzqAW8RLjHQhl4MkFx17ZAkNkVMmDdMdfqR
         9M7UexbmGZfyRBQzZRfDmPnXnT6DyZIupAoOURjdULe6Nt/ywG+0seJTaTZ2IglJo46S
         7yOY7B2KxVp7kBvPsSHqrXZ7yzCUeY9SvlAG+3Pauv37X0zLNi+0yuP4DcOfE4SRPts9
         0CTOWfsdiIVTO8fGswybPazoa95xQYMomcyopfF/TBILMzKq0qQb1gwZNIUfYqXXNCS0
         rwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kRTMrrmsNDzEw8eYmhPT1OaKOC94CF0nr1AjJq3zTok=;
        b=RDZ4NvCsHPBegC8E1KP8chl9gqvd8Ljz+SYjPzOm40UNFsb35uERavxDtYzFVRLubT
         Hv03hBIyC4nc6TQ0R9MRjUirq5306XwTOLJ7NKktplBSVCRhhHkHxf0jHIfiwSeQE6Th
         p3+0eW8S8p9BY29nsUatFD5hCsKZFAI81VL4iWozFhtauQPUHCMFXOwkU9yQfIf6XxmC
         HjeA0XOb+P2SQhtmlQfzb1LK1CJuOyHWjQ/x2bXtVMnzeKpzUqaWi2bWhz5OudQSvZhD
         rWvzIooAuEYD5esmAunbyEWUsHqK77ljwkAwuZYyss4jVy3dFzWeC8Ki7G1XtN7eyQB6
         VGZA==
X-Gm-Message-State: AGi0PuZMcHiZMHDMJiQ4pvJLI3A+VRWpwPV9hDpbm72d+jUGXdC/Ai2P
        jinaK45hXDaS/QwpIOlx434nyZ8JiUU=
X-Google-Smtp-Source: APiQypLLpTPqdHiN4QqKYv/8E8P+a8V/0r6J3KsQBCfEcBANQVnEyxO8eRppsQGL41bJqzSZgJrHFg==
X-Received: by 2002:a65:4504:: with SMTP id n4mr1397607pgq.374.1586466533177;
        Thu, 09 Apr 2020 14:08:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15sm31316pgk.59.2020.04.09.14.08.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 14:08:52 -0700 (PDT)
Message-ID: <5e8f8ee4.1c69fb81.40270.01de@mx.google.com>
Date:   Thu, 09 Apr 2020 14:08:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-19-g07412f086bd9
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 2 failed,
 104 passed with 2 offline, 5 untried/unknown (v4.9.218-19-g07412f086bd9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 2 failed, 104 passed with 2 offline,=
 5 untried/unknown (v4.9.218-19-g07412f086bd9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-19-g07412f086bd9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-19-g07412f086bd9/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-19-g07412f086bd9
Git Commit: 07412f086bd926b2ecfd03bed97e8b3beef918e1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 61 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-16-g7211f9280=
6e8)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
