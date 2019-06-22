Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEE04F8DF
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFVXPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 19:15:48 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:36655 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfFVXPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 19:15:48 -0400
Received: by mail-wr1-f49.google.com with SMTP id n4so8790679wrs.3
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vya1wTMK6cI4BnWpnsuJ8vp9yvYKtuLAG0+yYIYNWg0=;
        b=Hyq7DI5FjGZL8hbxg3Y2+C3Do6BfAMP0ZAfnIAbNz4/LHCSbv5yZlMbRM+4Q9wvKxL
         AXdfz8PN2UmU9+Ej5VpFmaXvg2KseEHzA6DikiUnu2auaMCZ0ZdkSKfoqME3NN06JLJ+
         Em6Pc1AuVy00bH1KQhibgq6BC8EPSLsXmh8XR/RclEpzpf1zCUhi0sk51BjgPixZ/DTJ
         hABYP6B718fDTf5eDRM8IYCJhVZA0Zod5f5DpiIHlOE0e8m2t/l/C/XERJEO8c+N3rTz
         6DOW2UlCZuPgceOUjSggVWXIWPX9anQDijV63OdYrh8KqAwldqKCg8oJ+da765TMSG2P
         KcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vya1wTMK6cI4BnWpnsuJ8vp9yvYKtuLAG0+yYIYNWg0=;
        b=srxLAx0Us0HfN1MHC7t1ejO90nn4bID2KKDd+aLF1PTJkQLhorwrybZyEgvL/G8pIg
         W7nPwBFpirHsdZJRCI6XtrJ31bBxk7qU8jOiDoJdpC8S6rF2c23zj2SFu5/t5lPO80p+
         rBOCe2gENnuwL1QlOmOsTm2WTC2kdkSlWXP5CuL/0fdKchXSmz9dvAn1v7p/VddInsCK
         YjFQPGQ+1vtYWAj/FYWZ8HctqeZij9Cz/EbqXw7+6sGvtdpL1mGi5mbxrtkaAEB8nDNv
         xxpnHVsVH7b+okz19bEHYFjVlFPq1wXFOGVEnghHwqtofpk67ELjk0uVmIjO3OtN0TOM
         Phbg==
X-Gm-Message-State: APjAAAWvKzswWZPTjzhraJ0wkRjT6vioF4TNAbmvRVnQVM/DC6M76OQU
        AOq/WseDHu9RVn4XTfS187RJWsfDjio=
X-Google-Smtp-Source: APXvYqyqcG8w5J8yU9oTWrULlJJ0FQ38UC5ytJL+ycODthwmFL7kxKiI5cAiEqlJfxRE+5f2JOLlDA==
X-Received: by 2002:a5d:5692:: with SMTP id f18mr44561163wrv.104.1561245346613;
        Sat, 22 Jun 2019 16:15:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z5sm5355999wmf.48.2019.06.22.16.15.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 16:15:46 -0700 (PDT)
Message-ID: <5d0eb6a2.1c69fb81.9fa91.d3c1@mx.google.com>
Date:   Sat, 22 Jun 2019 16:15:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-4-gd0fe796becb0
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 122 boots: 0 failed,
 115 passed with 7 offline (v4.19.55-4-gd0fe796becb0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 115 passed with 7 offline=
 (v4.19.55-4-gd0fe796becb0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-4-gd0fe796becb0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-4-gd0fe796becb0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-4-gd0fe796becb0
Git Commit: d0fe796becb0d4ff5242ea8166eb4c59a877763f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
