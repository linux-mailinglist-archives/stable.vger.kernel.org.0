Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439B1ACF2C
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 16:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfIHOML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 10:12:11 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:56137 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbfIHOML (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 10:12:11 -0400
Received: by mail-wm1-f43.google.com with SMTP id g207so10962371wmg.5
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 07:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w72fgQ2SkN0VXzypK4Pf+EIssYa4c2KhHlbI9Fzqb0M=;
        b=SAMywYeU8fsKmnoPD4gtPSwaEMXhlTUCZnJN9FUI0IP7mprg81DcqRYD24UInXMMh+
         Vs+Z/o0ADdRqUfvArWviGUoI4+OhowEXCFtRIi8sCnjPLeWX6jxqQJdR3gTnLR4W3OJa
         XRjjg8/uzPnhemh8m7HiaVNNNF3YgnOWtkROdxOVK3XB1BSCBXcgxNyBZuC5D6mVYK8s
         E23cgVQ9RbC6an24sAzUZ+g1bgOnDbN5WFJR+2RViD7TNYqLP4aR/0vFwEerdXE1rtKE
         nztHphPnV0+ocS/CtGXrvh1bGol1K1CNQHyfcQ2aE27SY0GyrollSxJNwCGm/+AwWral
         sXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w72fgQ2SkN0VXzypK4Pf+EIssYa4c2KhHlbI9Fzqb0M=;
        b=CoRHA9u7mGrx+j62ofQqor+JFXtErxH330Eq4iq8qcvC3zirqyPTe8JmhJe7N5CudV
         uXvncrKii/5iXz/fsR6624aTqJ56XpDWS5s6kDmPsMgJThJdmKprzGTqqGmGrYapsXcu
         olv5RDbeQLiY9iJak65y32PeKOZ2rP3RhLK3lMc/VkGWUtTSmOcP9DRX9phAmn9F9Eo0
         kxE04VLm81a6bIm3o9RIiBEmch8grxrRE/nMOzh2fqetRwnWDNWwNa6FHZijK/z1hluO
         EkaFi+fGFO4VfeIUCANtEJs/XRStH6pGLqlXcO2Nx/gqDuyEUFWl+t1VpzmwKUE08C4o
         a1yg==
X-Gm-Message-State: APjAAAXlBRjgPz3V+++agiDwalFNI2sRz8w406z75R6nRYomqQohxXiX
        htvvn16BiUgFLX0IH8m+jgsGLsL2fio=
X-Google-Smtp-Source: APXvYqwjbdbaOhEcl1qqex3wHEzu3kbDGCfCYE6Rt+h/zZ8x1xIOKn87g2WhQOXkQBmqkSbsMZt0Sg==
X-Received: by 2002:a1c:f01a:: with SMTP id a26mr6955026wmb.170.1567951928828;
        Sun, 08 Sep 2019 07:12:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h2sm17391627wrb.31.2019.09.08.07.12.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 07:12:08 -0700 (PDT)
Message-ID: <5d750c38.1c69fb81.d4c68.2663@mx.google.com>
Date:   Sun, 08 Sep 2019 07:12:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191-22-g15e471136436
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 106 boots: 1 failed,
 97 passed with 8 offline (v4.4.191-22-g15e471136436)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 106 boots: 1 failed, 97 passed with 8 offline (=
v4.4.191-22-g15e471136436)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.191-22-g15e471136436/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.191-22-g15e471136436/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.191-22-g15e471136436
Git Commit: 15e471136436de0ba89cea2b2ab7fb35a00aaaed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
