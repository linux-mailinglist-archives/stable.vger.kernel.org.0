Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D062413AE07
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgANPxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:53:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42206 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgANPxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 10:53:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so12624732wro.9
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 07:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m2JtsPY8MDDHwyRIE4Q1hy7WbjhdeJj9lOxZhnANrlI=;
        b=aTGnxeGUizKlGZQZ8VNEhVhXLUetXY+6Yd+bbC02+XLx8BugAHhuY/4h+p1K4dqScC
         puPG1Ue5s/4Z9RlRMr7uys+9GkQO+js8M6YUtum462HhT9DMPS+lMPmMXRPNWIigAa8B
         WCvgWjmHEO5OFG4F2CsAVZ2brKDjVr1vm2/ce2hux5unG3+7T+L/6dQJx8oyhJx9jvXD
         XPFdTdo0MbjYc0zOSraxtp7iWrypIvbSj857zgfsvp1DotvspY8mM1t5Em9barkr4Zdc
         Kv9vGeb4uK4NdXNxfKISvxHasm7e69rg9sulULsESJssX1Tlf1cpvRAsurnoI3S09FnI
         5bPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m2JtsPY8MDDHwyRIE4Q1hy7WbjhdeJj9lOxZhnANrlI=;
        b=jIIHpMFhtgpijtabTaqbXBiGeRVaO6u1D40ZtDj2LykNoSwLRwcJa7w2OXM0MbOZhm
         cuR4tXNjMt0gD+GkQdZYy27H6iH1DuLWHstxy3w+nf+i0VNuPxBymjv3FJucujRbUQxU
         9ad9wrMO8IibOpMH2o5/i799Ed+ia1mFuivmcUmuNvWn3hGGAd2Xmm1Iu2pZmkxBAtww
         kqjQSTWZYkDCWDtL8cd2SEJ5B9o3kLauj8K3pZzmzMn6rwSq0SF5C+sMZWBFQBMPdu7T
         wa9bZ9Gc0cvuICOe34uWRpJ85sF8EOFI8qCQTHoYxT73jrFcG0g09oTRi9w2RSIxn4gf
         fsLA==
X-Gm-Message-State: APjAAAX89LV2yFGIBHT7G6HTs6cfBf67Psg+N0OGEl+G1DatgnJsuDXv
        puJMRya8TrNUcxP8zB2dmUY7JyVmZhLoqQ==
X-Google-Smtp-Source: APXvYqw+J/G9QVuPPKdlcu0yQBy0nl5b0yiWktB92qypVfzDQreUhm7uXO9pDPQVbJkCdjWILFkRgA==
X-Received: by 2002:adf:ee45:: with SMTP id w5mr25154684wro.352.1579017180406;
        Tue, 14 Jan 2020 07:53:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm20416138wmc.45.2020.01.14.07.52.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 07:52:59 -0800 (PST)
Message-ID: <5e1de3db.1c69fb81.83959.543e@mx.google.com>
Date:   Tue, 14 Jan 2020 07:52:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.209-32-gc5dc66fe8ddb
Subject: stable-rc/linux-4.9.y boot: 57 boots: 1 failed,
 54 passed with 2 untried/unknown (v4.9.209-32-gc5dc66fe8ddb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 57 boots: 1 failed, 54 passed with 2 untried/un=
known (v4.9.209-32-gc5dc66fe8ddb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.209-32-gc5dc66fe8ddb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.209-32-gc5dc66fe8ddb/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.209-32-gc5dc66fe8ddb
Git Commit: c5dc66fe8ddb90fc0eeeeb75880cf7caa26b6cf3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 12 SoC families, 12 builds out of 197

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.9.209-25-g575c30651=
ddc)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.209-25-g575c30651d=
dc)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

---
For more info write to <info@kernelci.org>
