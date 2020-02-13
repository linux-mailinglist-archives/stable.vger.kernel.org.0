Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552EC15CE34
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 23:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgBMWkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 17:40:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40874 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMWkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 17:40:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so8717427wru.7
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 14:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0W8T9N33AWMy+gRpi9ZI19DUqPLhfFke5QjD9RusGNs=;
        b=OQcYMg1LRSe1ev1CSXPX/ED3V3sIHWDwBIFzha76mdrUiiPdzJUfXQAJvl7L0DHnjv
         5WmG7/8ks/B1c0pF3/7LvoHawbmdOlRpkH+QKo3Cr9uFMcgUNk8GIV4rSPfXb5zT1ucR
         SpAfZfDOAG9OshK456NhZCd3FzQDQnbqRMFO2tTAKyND1MbWFM+0qKQ6yxCqbMSRYCZj
         OmCLdu3laC4OgaYv7yJWEujzFX3oF0oKhMg2ZRXPH0fbs2Stzq8kWiq4RqNx9hFbHDtK
         La/9jjRk1p7JO12CPfqh42yOiWQU2MF7STUElPk1VxdqNzTg8aAkaXFndOh1aNnSJeGJ
         Mt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0W8T9N33AWMy+gRpi9ZI19DUqPLhfFke5QjD9RusGNs=;
        b=MQmiy18NfjIjjmciyrhVQ9E0/x9VFKbJBj2mbtGbOJrQ2p3G4eZrbyIH634+S5JPiV
         DWvHJ1QZramsJqtWof8lDNJmRKMsN2EbZnAEHZXgqjz8eGlatOsjE9qCARXkPojWq3ro
         nJj8OOkYUqv/q1xN5WagIe/C9ycHkzsamD1+egRWl1hcw1ogwU51DI6qgECR5tJcZ2Pw
         hsHvVvkeHClfAZRr9A2yWaMqrRYtX/A3i3o5kGk40re1IUN2GnL6053ftVdhTZ2sbHcc
         x6ExTsbrQNoPYXR833MtxGABYc4vwmU/xac1kPgQcu3RHn0l24fKOfYhK6ouXY/MLEex
         BKRA==
X-Gm-Message-State: APjAAAVOV68wLPqYagW8fZPqFl7K39u3Wt50h/ciDZEzipAQjj6TyboB
        xw6qkh8YMR5l8yF3jxxuyujLdFuml6uYGQ==
X-Google-Smtp-Source: APXvYqwmU5siqCbCErI6Uw/AyZv21r7F9OMns10C2DFTme5uBMcA9BiA5wYUMuZTekCPR10VEoz1UQ==
X-Received: by 2002:adf:b7c2:: with SMTP id t2mr24038523wre.269.1581633606422;
        Thu, 13 Feb 2020 14:40:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o15sm4687612wra.83.2020.02.13.14.40.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 14:40:05 -0800 (PST)
Message-ID: <5e45d045.1c69fb81.93bb2.534e@mx.google.com>
Date:   Thu, 13 Feb 2020 14:40:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-117-g41f2460abb3e
Subject: stable-rc/linux-4.9.y boot: 77 boots: 2 failed,
 72 passed with 3 offline (v4.9.213-117-g41f2460abb3e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 77 boots: 2 failed, 72 passed with 3 offline (v=
4.9.213-117-g41f2460abb3e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-117-g41f2460abb3e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-117-g41f2460abb3e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-117-g41f2460abb3e
Git Commit: 41f2460abb3e46bd15371fb219a2145f02251b08
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 18 SoC families, 10 builds out of 121

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.213-96-gdf=
211f742718)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
