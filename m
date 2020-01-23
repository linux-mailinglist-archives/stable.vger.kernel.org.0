Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE18147486
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 00:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgAWXNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 18:13:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35682 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbgAWXNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 18:13:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so4397991wmb.0
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 15:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SimtZ39C6zvkuHhjO+WhnbilWAYLXkv1TZZnPDIh97s=;
        b=eVZzgseTQfw4b32Io0jMaOPZ6OxrNkUasD+IYTsuGZIhkXi7oaAE6j3EzgI9Dfa8+s
         8nUETNt4wcIK+4DCpunBK0+Xq/iX2xjTU7zLk6i3cFQD2PzwedyVJJgCPvsW4Pc2oHqR
         +tyi0cYbawBLqJr8oeXoH7rL0hw1rbZuBvylnOeeYqRXsJtbnEQgIyaWrZ5E4zYKRcDb
         i+hJ2Vw7xmDjpp8ms/+wTxc4TfyYa3CbMU5ruOEMLMZY57w/Xraex1ca/57THf4EGCBP
         QLIVkk13M9fXHnmH63IJb9Fjn9CnpczqHxU/o3L+rKLdQ9FETtF7Z1ax6p3nPqq/O3Iy
         thuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SimtZ39C6zvkuHhjO+WhnbilWAYLXkv1TZZnPDIh97s=;
        b=eoF95izrVNxbjp36TkToX/4pMlPJVzG/SaQtYfhyAEs01+uh2AtevSfxr4ueZOM3R/
         A0PhJEmXWx/6tvR77pmBF3vNdorG/YTucy9bJE5aJnRdJBJdBGrQvNnwr1/VkrZA7rin
         oxTY8rb3jZoENbFVn8Db/fsWiK7ULsf2pOQf3Z2STDGwzUsppPMr8lMzlCXbiyX2cG9l
         4lhhiQI0f++T0CjDqcgPbfx5T8KLoWLB5au/88LjD7UtJ36EBeivvtW1eCdF0gvy/86n
         FxG08q5mkndTb1j4HDiu1ddAY884+WaXdgwTGXw/1lGO5nj64ZqBEGbzOoToswt5cliK
         8OyA==
X-Gm-Message-State: APjAAAVn5nE+9OL9Snn1153ZQkPjd83pLaExcN8euWy6j05rynRa/Yzw
        wpuPCykc2DFHVwF1x12TLbXSWiFYRSY4rA==
X-Google-Smtp-Source: APXvYqyUEe8JiFEayitSgVx1lqgCBujwEQLIqtPWPOFdpdJ4Bi3FrhmM5vOqkHAjjulZAkVbE53pwg==
X-Received: by 2002:a1c:151:: with SMTP id 78mr256677wmb.182.1579821225926;
        Thu, 23 Jan 2020 15:13:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k13sm4699611wrx.59.2020.01.23.15.13.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:13:45 -0800 (PST)
Message-ID: <5e2a28a9.1c69fb81.e507.47a7@mx.google.com>
Date:   Thu, 23 Jan 2020 15:13:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.211
Subject: stable/linux-4.9.y boot: 64 boots: 2 failed,
 61 passed with 1 untried/unknown (v4.9.211)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 64 boots: 2 failed, 61 passed with 1 untried/unkno=
wn (v4.9.211)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.211/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.211/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.211
Git Commit: 80f0831c72d498fb27c90de47e0f69d593000305
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 13 builds out of 181

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.207)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
