Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AA6B6263
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 13:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfIRLoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 07:44:39 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:39310 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfIRLoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 07:44:39 -0400
Received: by mail-wr1-f53.google.com with SMTP id r3so6556041wrj.6
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 04:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l5SPa7LkaGBpWjiTffXKsIaeS0FMurpSoHV4KYencAA=;
        b=nxcVr6n5z+jCTGQzZf7euCMzY/iTVqWo+tAUDS+QD333izbdWOi4WTxkvYNBAZtp2a
         jX7JxcmQhx9LM5x5gMSL+75rgPWeDCkN3EOtP5+kVWsY/l8zt0gAIfNG94cffrEC280K
         sysQQhDFE8+CAWnANu147ltdXLRHUODxdqYNMijKn8M6aR6eQV8Tw3xIBC9oRhDDZQ//
         9p4paNBQi7R4GsU+4CBLxHI5T11YwPkm+FSMrBqcI3qhDsWdBfvfHeJRhdRf0T3jASJG
         5hnScadLIWeVvZ9/gGsXb88PAhqXEOklDsRM86UFDuvgwnQLbkYRk1549UeLy1uicnQT
         i+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l5SPa7LkaGBpWjiTffXKsIaeS0FMurpSoHV4KYencAA=;
        b=RoR+cV2q3jlX16AEqgGhKxsb5Z1sXgc2Ng7QXs+zhyOBav+EUtnEy0rCFEyIyySiz9
         +Ah7BeeaffhIzvRH9oSRgGD0TywiJFcfKXXOwhx0bPoWBpjgttZIge5wrecUmTCAYpfy
         7T5EUZ+a1CPUpew2Szsbq+9cD/ScuMRrRmkrkdvg5dZMxCXFYfucbUlmMpEM91C540yP
         +POs02BZNyTnevxRDTAL7FMrQftqewdVkfx8SQnb/bCqJSzleSuGFcLENGXRzTL2Ch9K
         Yw80k5Cb+HDheeJyfH1qbXtRuHHBPJ2CzIt2jIF91MXwJt14JHKwaNjBuo9/7xoqUKK5
         FWuA==
X-Gm-Message-State: APjAAAVOObRmH0k9YOjcHs4BULkE2ioh3VQB7urci7QdusRdWEXQJxj2
        hAAt9CJNqcWePisLUCGcZNl1/sQxxToKmw==
X-Google-Smtp-Source: APXvYqx5u0tXN6VCh62SY+YgmWE8PGfmTAckGR2pY3cCwGS8S+iBSe9Z0LYEHTiMa/XsgALNOpvLuA==
X-Received: by 2002:adf:e48f:: with SMTP id i15mr2943978wrm.26.1568807077727;
        Wed, 18 Sep 2019 04:44:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s1sm7846946wrg.80.2019.09.18.04.44.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:44:37 -0700 (PDT)
Message-ID: <5d8218a5.1c69fb81.a1144.4af1@mx.google.com>
Date:   Wed, 18 Sep 2019 04:44:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.73-51-gddb7a3337506
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 133 boots: 0 failed,
 124 passed with 9 offline (v4.19.73-51-gddb7a3337506)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 133 boots: 0 failed, 124 passed with 9 offline=
 (v4.19.73-51-gddb7a3337506)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.73-51-gddb7a3337506/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.73-51-gddb7a3337506/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.73-51-gddb7a3337506
Git Commit: ddb7a3337506cd5de6d52906c5291fcd90b955d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 206

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
