Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E377B124A7
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 00:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfEBWlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 18:41:19 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:37961 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfEBWlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 18:41:19 -0400
Received: by mail-wr1-f54.google.com with SMTP id k16so5481152wrn.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 15:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g6FM6BX6quz7URMn/7flOYiBBxPSluiY4f3/RPV0lAo=;
        b=2QdkevF9icc8u6qe5Xu4SKxDIgi9fKlkYKryTnXE9l6NqVy+4/Agqps6mzO9ML5ODY
         92mDYfs+2Q8Yk2P7Vw8HhTHJxiu3bvijXLAPSTom6h3Fg86aaq8OUqd05gb0i0NqnDoi
         y/F+3QEmB3ZLxSt0kXnHCK6wcbSFXgI3yFFTUIbyc9g6oD8duw6ITLEIA3lPgr4OMdxo
         eaJS6Qhz4x9EYG8vF6BCPsuAWzsSLQl6/AIUmWQTHeGJPaG/K1NKdAznsc9cZFOflXqJ
         A4rBc+IblzbLSwXjVzz1FzKGLbfwmISBheORP3fORwzklvxd3x0iUD+xpHu7B/w0WQG1
         ouMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g6FM6BX6quz7URMn/7flOYiBBxPSluiY4f3/RPV0lAo=;
        b=oAsyG4M1muAtQHkNM3tfW3iCRxhegOSk2vF969WBSIQLsSDlTv799TsFrM7H4L6bSP
         ND6hDkgYNntpA/7XEs3XS6urV9v8xm++8IQgn1oZ+t9L75qE6lcRz1XAhPA6iiJka2Tu
         xsNEdAojWDBjYJTOpWQNkkYWeF4820PyxhVR46jGnCzcX4BvzsoTVj4Po0W86n9c5jnm
         rtfXEXDWo2W/SAQvBq5SPxregmPowFWKIN5ImTofbO0h+cyAYt2XY4MGJ6TjWM4uJCzC
         8iMFV8G+dXSOOoNyiKpqBroAnBga/A7pDNtqzrp7EdPsAr3fEwW7MsMq7j6B92yM8UyH
         L4FA==
X-Gm-Message-State: APjAAAWkRCOmJ3Q9tYT5YDZJChAHscXoVFUouglvByzamxKaGDvA82pP
        cKlk6ttDwoD4zVrvSX3grbH/c+dgRVke5A==
X-Google-Smtp-Source: APXvYqzpdfsPPh1OrQ4eNZ9X2S51vCW96JGkWNjU/QWk3Hf9ME71KddVgge9lDTMFsMA3P/+EUkq/g==
X-Received: by 2002:adf:f7d0:: with SMTP id a16mr4350491wrq.211.1556836877532;
        Thu, 02 May 2019 15:41:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s7sm303464wrn.84.2019.05.02.15.41.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 15:41:16 -0700 (PDT)
Message-ID: <5ccb720c.1c69fb81.33d61.1ed6@mx.google.com>
Date:   Thu, 02 May 2019 15:41:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.18.139-28-g66b56c184318
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-3.18.y boot: 49 boots: 1 failed,
 47 passed with 1 offline (v3.18.139-28-g66b56c184318)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 49 boots: 1 failed, 47 passed with 1 offline (=
v3.18.139-28-g66b56c184318)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-28-g66b56c184318/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-28-g66b56c184318/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-28-g66b56c184318
Git Commit: 66b56c1843185c1c766fe92fd61423d6919ddd64
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 13 builds out of 189

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-7:
            minnowboard-turbot-E3826: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
