Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763724FB65
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 13:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFWLzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 07:55:17 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36700 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfFWLzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 07:55:17 -0400
Received: by mail-wr1-f48.google.com with SMTP id n4so9671212wrs.3
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 04:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YcA3kVfxXd7Vp0vMD9DMa26u4kog63VC01n0NuWOGxY=;
        b=X0UNGyzlSvjn6Sva9ONbebEvvK69Kkd0SeznRAk7axhPlVhvnAoQATNEPCYp+js+VK
         qOLv5eIeFvIU9xgPHFqubpmgB+8KWXhtO4C1baLLDunS7fMln/8q6kCSix9XnsUWEnW+
         Qjl3JlnLQ8WGywXs9HGxaVmUefLIj8jud5AZinkOXAJhUIaY2wvS8p/sDXYG1MPmWAaJ
         Dml4rOLTJdRF5mKouqXkhFqA6346aH8xUXOrK9Oaq2boYKcQahbUMIcW7kI7lnYTRWam
         /o8EYHS0qNAnrq1Hfg7ts1Xr3liq3MYAtUMuKxC6M0hJp/IiCdKmOOOo62sL2y7mqP4X
         lUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YcA3kVfxXd7Vp0vMD9DMa26u4kog63VC01n0NuWOGxY=;
        b=nlwJS7+54sty5kyiriacx+50sL8DV4ft6smaIIWLMuz3Ecrj+kHYFeElmdZ4woNoba
         KrL6uXHTRRGlG95yWrugrfZd/BJOPq0PUqZwdZbkYncak2PFuD3Ras0pAMIcf/DbAjxn
         M85/0U0K+7koh/8EsU/ALxoEO2452igceUcGsog3fu2r1TQ1hBb4equPvezHllFAT13b
         zMBvrn/Ak2PpmOZ5er37687UzFyLJkaMKT485LVv4AiwqVXFV+lM0YWmuN0zvxrh0GuA
         u2D5Xq65OrwA6wdvCjKMBpG6oADZZzN3mIjveZNBPSSX2lQmtJkU/c2wISHhfu2oZcM2
         OkmA==
X-Gm-Message-State: APjAAAWUTlnZXxWhlziLdoElCMlKkOxCEWQ9q1ssX0miE4gFcuvcVYVC
        EZS25ljitNEJASZ58XVEhNcW8CbMW1M=
X-Google-Smtp-Source: APXvYqzCofu94PAxRpTNJOogXR2Z2PuWK4nobWUV+Z8SbefSyxs9kf58Vz8MssPtUN0r/cQL9bFLiQ==
X-Received: by 2002:adf:f984:: with SMTP id f4mr16631929wrr.315.1561290915497;
        Sun, 23 Jun 2019 04:55:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm18648356wrc.9.2019.06.23.04.55.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 04:55:14 -0700 (PDT)
Message-ID: <5d0f68a2.1c69fb81.9efbc.73bd@mx.google.com>
Date:   Sun, 23 Jun 2019 04:55:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183-3-gc46c5c4c534d
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 102 boots: 0 failed,
 95 passed with 7 offline (v4.9.183-3-gc46c5c4c534d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 0 failed, 95 passed with 7 offline (=
v4.9.183-3-gc46c5c4c534d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183-3-gc46c5c4c534d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183-3-gc46c5c4c534d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183-3-gc46c5c4c534d
Git Commit: c46c5c4c534dd3026c854d24ac3424393e3c9241
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 14 builds out of 197

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
