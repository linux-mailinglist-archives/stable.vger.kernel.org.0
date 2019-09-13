Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D330FB1CC1
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 14:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfIMMAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 08:00:43 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:40040 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfIMMAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 08:00:42 -0400
Received: by mail-wm1-f49.google.com with SMTP id m3so2475192wmc.5
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 05:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SEs2it2giKQE9ycaIscHwrqsbpxk5Hga3fQRoFnoi/A=;
        b=PVegpzBfpr+gHMDPZGzsgQAUYhSxyZnGgEulQHHEQK3kQCb01+K40ReOz74ptgtQ69
         AtKHtSDqkk4M7jxlqBT4nC7aQHlBVDiC4oRCL0fAeV84eaw6oBGBLVXHUagW4lYvuKxI
         ty5JqDfXjKtMLOFOawXBYhY3DvhW2TCVLFY4XhRt+QZMU66GtKr6yPgbCGDisjDXAKnY
         bZTbON5rLJa8P38UGoC5rFp7ngo70JTenJ+gV35i/jMx+KdlO0lsjKGECy8g8GJsC+Qo
         xg3ExgLGMeVGQw62vKVLMZeSWzGeFrE52LXJ89UDNvf0FVASt7QMxS7q4akeIvJMdNrw
         6/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SEs2it2giKQE9ycaIscHwrqsbpxk5Hga3fQRoFnoi/A=;
        b=ulu+r/U/E8lNusDSiflBOwXxx5FmkZ29F5eVHfoRfUS0ltrTj2OUPF80rR8P+uFfOZ
         16uWs4jGXb9rlkbMb49DsJNIkZ83a4oxipXb2WF/kH6QYkR06eigXllFCN9K0SbBrNc+
         Ag3v3hO0dzj+/VYhA11YEttgCqKSl19TNSkLMd1GdxkTimGrQkX6a/bF+c+usqSV+3KG
         RKs7+xINxEtNNPlUWC3/OWIqB11HBtoXqwb6twGOhrFhJyaf6CoMOxwCPVlib7HcmkQ7
         i61DLFRdgF2byi1e+q1DxcGdfVLDXCi+FCgpX5+wE0EcYkfbzAP8MHnbP2cqjI8vwLaJ
         FjTg==
X-Gm-Message-State: APjAAAWzn+xy4T5+V/hCfdZjSI6wiwxyEH9FeBgQBlglA89fflvQUWCC
        JsUFfKDXwgXjyWN4TeklOA5n569ZY44YoA==
X-Google-Smtp-Source: APXvYqwPQ9RheaaO/VDVSS3GKprVVgjNxxg8xt7yLnBHp9/CZLgVc/XsDkQhdiFHM+somsjiIKF8sw==
X-Received: by 2002:a1c:7606:: with SMTP id r6mr3186343wmc.78.1568376040269;
        Fri, 13 Sep 2019 05:00:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v6sm3640382wma.24.2019.09.13.05.00.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 05:00:39 -0700 (PDT)
Message-ID: <5d7b84e7.1c69fb81.d28f6.1c81@mx.google.com>
Date:   Fri, 13 Sep 2019 05:00:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.143-20-g6e4882db0a08
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 0 failed,
 118 passed with 9 offline, 1 untried/unknown (v4.14.143-20-g6e4882db0a08)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 0 failed, 118 passed with 9 offline=
, 1 untried/unknown (v4.14.143-20-g6e4882db0a08)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.143-20-g6e4882db0a08/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.143-20-g6e4882db0a08/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.143-20-g6e4882db0a08
Git Commit: 6e4882db0a081e884c684513eaa7b89d7ad964a2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
