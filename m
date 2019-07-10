Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B104646DB
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 15:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfGJNPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 09:15:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38000 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJNPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 09:15:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so2433938wrr.5
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 06:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YQg63vYFknVlZO25/1DwKyK7CmG1RZRFfuT+tAtVCSE=;
        b=hFj+kqtmgEOr7jkvR0wP3wrxlmnKOR6CNbXqpUERQRAXBc0N4iWYcivFA0V6FEyFhW
         cWtir8wqwubV+i9Y/Iw9vY2quSb9XI3WM6Ud5rAEqQUb2+rjyLbXpH0ay1Mtwy1VSBP5
         Ez2dmuYdJI+sBIaE3UBOVYy0zzmU9vOgdG4obAl4YVQk3IBpyEFjjN9wVexZbtHuxkkQ
         IEuce85bkTCyigVx53TRfHgtZ99JrYP8dcp8fYbHua4LHiLwhrsFMUUMcQmMP97UpdIO
         K/ztg7dzzG/xmlKyLllmpo9dPyOmiMNykcu0miVZYcictcfAkbKlT7oNGJiRpyMLcBga
         i8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YQg63vYFknVlZO25/1DwKyK7CmG1RZRFfuT+tAtVCSE=;
        b=gb+gHh2XsQ8pv3uaSzkFRurgQBo9hBxeFJMmBfI5U7RL0SeWGmax2MWFS5k97sK0HZ
         aQCTYiMvD9PIFAdsJYw6Q8ZvQmhvYs74hL5SaBjHABgS+PWlDQjX2A+3rzGCeHsXUrYm
         5pv1DDwF9CLF8ICTvy35lRfFHnGlejByr4VRjQEu+dovjWpPYq6qz5HFG1ReUrg4yUIv
         zGhhsWctJ5s52VDBOaFK8czjeGyzx+sU08YHYgD3MeBHxFG6781AHQfpYR2rZrEd3La4
         m7G62YbrC67RYBDIKQuEtIr4ptIoJksfrOCWHbsnz+ZrgdWxqmO1GJfYEewdNKyDqXGk
         oKdw==
X-Gm-Message-State: APjAAAXmn5J1HmlWv7kIc2nd3Z8TMHZr6t8WzS7cpO6UiABEeDBNvNdM
        gP9Km8h+bTZ/eVkmK07jnJ8vbOX6Rbo4PQ==
X-Google-Smtp-Source: APXvYqzANwWZQz5JtsohXqmJ9lSQU/HM25Vyob+kL2vo2n0JPXsZePdT/PlUx3iPYdfkYoj7LspIkw==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr7172986wrp.258.1562764545252;
        Wed, 10 Jul 2019 06:15:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r21sm5170013wrc.83.2019.07.10.06.15.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 06:15:44 -0700 (PDT)
Message-ID: <5d25e500.1c69fb81.9a3ed.c358@mx.google.com>
Date:   Wed, 10 Jul 2019 06:15:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.133
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 70 boots: 4 failed,
 65 passed with 1 untried/unknown (v4.14.133)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 70 boots: 4 failed, 65 passed with 1 untried/unkn=
own (v4.14.133)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.133/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.133/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.133
Git Commit: aea8526edf59da3ff5306ca408e13d8f6ab89b34
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 15 SoC families, 10 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.14.132)
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.119)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.14.132)

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.119)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.14.132)

Boot Failures Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            tegra124-nyan-big: 1 failed lab

---
For more info write to <info@kernelci.org>
