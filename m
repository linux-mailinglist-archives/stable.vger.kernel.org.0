Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834964DD9B
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 01:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfFTXFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 19:05:24 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52894 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfFTXFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 19:05:24 -0400
Received: by mail-wm1-f44.google.com with SMTP id s3so4597514wms.2
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 16:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3f8EQr6IpqxlK6htBpTRWU1RPubDDqlZ37f781HG9oY=;
        b=pZVvYhb/Rt/Rr/CLFxfawGF8/ict/7PV7PWDyr9NznwZHuM6sYJgGQtSASz+GGugru
         YUbR+ewAJMxSEsmH5FfPuh+m5xnAJ0+QF8rRKtlD+WHKZCkixhmDCQB05vJ8uj1EWvTn
         uMYrNE2F0IWwo7OfMNDDsX/H0fmqH8RHH682CDPTKkfQfJbXVgnIX4yvxcI+uWrk8AXH
         Xf64mk8lTNktqCyWvmy1j+yw8rYGllyo/J6yLT+Ec4ZQgtJJjxK/HPMQtFT7LqMkZ/kn
         Xjc8cz5Orb7N1NSr2qjnZCGIEr4VaLn6smwv0hVF8CFKnZXDNcel9AFE5A1mXVuOXNHv
         DhYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3f8EQr6IpqxlK6htBpTRWU1RPubDDqlZ37f781HG9oY=;
        b=klJlTMN49h2LLqSZubnartcDaWnYxdGCgcRlsNwesxWlH/DOVy4sXlja3hwBgSGTsL
         nrMV21x5+wCOYKqLm41ue8HlKYf+Q7l+myUFFnLA771funl+gCluDMLB3HtK3OzsRDzl
         QpVrOWGFxvw/uZiVcVvGJaNzTT/9Qt6k+1LM2RdGBRywDUfuLVBcGjjAfKM4iksrxWQx
         gKW7zm2hbW0ymaNcfAx984ekM387aeqoOM88a2cisCsI0XkFQmZ+XgonulUvyIFrwum8
         BUbJHCjeNR0/gmEfXB8AqIL8iJfZh2jJgiL0l4DefnjgxioU56lUrv/hWI2KuklWyOzA
         6GBA==
X-Gm-Message-State: APjAAAUhfx/DypTQ6rYJlfpfvqxfX9aYT/h+wgmwpG/cF0fyE2mwki8p
        XoiIft9OnYcCMgZBgHLH9bxEKRu7Pyg55w==
X-Google-Smtp-Source: APXvYqzMkQ3h6ABsIckXa44iA/W5Ay4O01ZAeCO2XCmT4+l6hbcd9o4kPC+45A7UxIFRLy8dMcNkSQ==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr1109243wmd.54.1561071922469;
        Thu, 20 Jun 2019 16:05:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm1959616wra.75.2019.06.20.16.05.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 16:05:21 -0700 (PDT)
Message-ID: <5d0c1131.1c69fb81.882b4.bc4f@mx.google.com>
Date:   Thu, 20 Jun 2019 16:05:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.53-62-g8661e38ef458
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 122 boots: 1 failed,
 119 passed with 2 offline (v4.19.53-62-g8661e38ef458)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 1 failed, 119 passed with 2 offline=
 (v4.19.53-62-g8661e38ef458)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.53-62-g8661e38ef458/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.53-62-g8661e38ef458/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.53-62-g8661e38ef458
Git Commit: 8661e38ef458269230688e503c5a1c50232e5fa2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 25 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: new failure (last pass: v4.19.53)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
