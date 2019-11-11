Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2475F745C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 13:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfKKMzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 07:55:15 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:38323 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKMzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 07:55:15 -0500
Received: by mail-wr1-f54.google.com with SMTP id i12so7611145wro.5
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 04:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i6501adT4wKxStsaLMlgeD1eHsBV9BE7YYAdlsX4LG8=;
        b=HgJKial7uftP4b4fqefSJRc9zCw9ep2/9QMXv7uQcVQi6gHyU86/vociS6o1Kpl//Z
         8qlXVYh5adDkqEUAyDu3TaIeEIZiTVidxJcSfhtaSmTPBzt2rJ+cfaOzZPixqPC2REH5
         5X2LQ9iaXEffZMjFFGiJudM3A9zjJBl7IT2Cgn/5PJMBHsWxJPKq1D4jYCeqGsGEWH8y
         Do2PQzzAoeHZPXzQzlveBlXF+nNj4yghMBHG5izVOF8BXvbSWn/Cv62h1J5CuT/2m9kp
         gLHta0+8NrGvJRTfiuIDI++clp2B/XX8irV3JP+3vf3k2u2t3EcSulTDxKXxGbnC22Az
         HQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i6501adT4wKxStsaLMlgeD1eHsBV9BE7YYAdlsX4LG8=;
        b=G4HhhCvgy2OYz1vtkCxA3svgPWhmP+wpzV3UkXdLOvOtWIP6EtBgABf3LVZzPW46zD
         gN0APJHv6c/UfVz65SwkT4rpNNbB1UEqkPXK7PvJO58KE3KNi9yPEK+oY5eeKk1Vjo3I
         HDwqZlp1tWldSspg5exXr9Tt2hS7YYh1HSZlsZM3C23sv6vrdXWIUemdslbxD2oqBlVD
         EwP8fudRLVKvryuYhGsf3ZBBYWDzroPMcKv+nmwFNs22cSAR3zp4tKYFFoY8FBze+yAG
         wHMm0uSEXD3A7eFhOBihMgjUUstci/ZGAkAHhawAMcvPDiw6E9jpyY2Tl40UIwdU3eRM
         3gtg==
X-Gm-Message-State: APjAAAWpmnOe4AHQMcC9PTgKKc+8G1Q6B9k2CqeI+gB+IHNnTksFbY3t
        qHQ/LWeDPEEwxLTWVia9HmEJWd/FjbWN/Q==
X-Google-Smtp-Source: APXvYqyZIn8AwTcTXn2v8ambA0Cp3KQHxIrKoSUYKUAVxbLe/o7r6myXpVmzLqii/nRBBRCwGOuOEA==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr19410215wri.298.1573476911309;
        Mon, 11 Nov 2019 04:55:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a15sm14488350wrw.10.2019.11.11.04.55.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 04:55:10 -0800 (PST)
Message-ID: <5dc95a2e.1c69fb81.e666a.5d95@mx.google.com>
Date:   Mon, 11 Nov 2019 04:55:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.10-81-gbbb78de6ace9
Subject: stable-rc/linux-5.3.y boot: 128 boots: 0 failed,
 120 passed with 7 offline, 1 untried/unknown (v5.3.10-81-gbbb78de6ace9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 128 boots: 0 failed, 120 passed with 7 offline,=
 1 untried/unknown (v5.3.10-81-gbbb78de6ace9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.10-81-gbbb78de6ace9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.10-81-gbbb78de6ace9/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.10-81-gbbb78de6ace9
Git Commit: bbb78de6ace961959a7801d01d6d9dc07fcf1af0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 16 builds out of 208

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
