Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAEBA9635
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 00:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfIDWSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 18:18:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43844 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729999AbfIDWSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 18:18:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so395853wrn.10
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 15:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=TZPdAUlA7qNN6+jQmsqssp5ULo7w+saDdp63nLUEMIE=;
        b=y2fGzrIs50cZip7cAIKE9aecdC3tuGcGvKZ72RLSINAb47s5+pg0IRpAv88jVm/CsK
         lb0R2+FuzoZT1ZjpcZCdVGj2mmJ4qEHIevHazm50DXmiuW0Ly40GYsRHSEsDTElp+9vX
         kpmkgepHrFEQNHpDnzs1Nzz6OOPDegomj5fKZZ63qS9l12vwW6dO5IeSoPe+I5QR5KG5
         +boFfoQXg7zSmiFD27tzqWjL+Br9muAgPlG0Nph62KFXSJpD5yUOVbZXolGHx+JYDdGG
         SyORBZYMxHT6enIivjX8Cqp2ic/x7n8s0iFUZboQApl0sh82mV0M1yY9su4WWPJcakjg
         UkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=TZPdAUlA7qNN6+jQmsqssp5ULo7w+saDdp63nLUEMIE=;
        b=niSAF0R/1X/hJiXtM1Vxoya/AhmYK6mkKW5GI1ikfta1I5tngcS7id7B4T5GOX4hLA
         Wz1ZP0PQsKaZugHCiKx9mIFlx5UBO8f3SWiQIQthkZtmTIMrACimCGG7NkX80GT6liN9
         zR78STnBnVWk0KwH6CatKQ1MoqOMGoqYbVU21naJPrsqcbLlUgjUzebfYl6VupSzeXjr
         Zo2R6H3o7ZY3NDxoVNxwGEF+yvds/shwVn4WY0sg1J6eOX8sFdBqpoNs3nUVxBZKW0Dy
         l1NocX1btBlh8MOtOl/TgXpyX7xQnOSL8ZShDMxQprD0QZL0d6CCtLt51kzu6wh8GZBP
         PRlw==
X-Gm-Message-State: APjAAAV0RLuJTz69ZX9nJAj/LK2HgXh31IT+yVy9Ph4zf4BIACHvRL1I
        cslkbAOmUy45MBlp5fNlcEEYHw==
X-Google-Smtp-Source: APXvYqx5qP6ThXwf9hTY7IR6rPWqHtzAPFyAeKPQ1CJY59Bn3YKiccfWu5dAwK+8B0sUoKDwnJV2VQ==
X-Received: by 2002:a05:6000:1632:: with SMTP id v18mr396841wrb.233.1567635493684;
        Wed, 04 Sep 2019 15:18:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t13sm371541wra.70.2019.09.04.15.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 15:18:12 -0700 (PDT)
Message-ID: <5d703824.1c69fb81.90644.1c1a@mx.google.com>
Date:   Wed, 04 Sep 2019 15:18:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.69-94-gb755ab504136
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/93] 4.19.70-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 149 boots: 5 failed, 133 passed with 9 offline=
, 2 untried/unknown (v4.19.69-94-gb755ab504136)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.69-94-gb755ab504136/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.69-94-gb755ab504136/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.69-94-gb755ab504136
Git Commit: b755ab5041366b954c39bd97caa982539e0d1223
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 16 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            hip07-d05: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

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
            sun7i-a20-bananapi: 1 offline lab

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
