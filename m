Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE05EFA5
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 01:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfGCXgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 19:36:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44620 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfGCXgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 19:36:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id b2so3357996wrx.11
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G7UqnRaAm8rBW+gn96rLD/ZddS/fL+xt9QrjXSI7Kqg=;
        b=zLdziHSov00yIzmXB6D2NwtGriGZz9FnDo6BjjAgoaXFZyOYmZzkwdBrq/D+gXO/25
         EzjV02+GSYZtNTeVdeI27p818hXMJ1z33RLKYFjFx086/hvzOA05xXmbMY096XlsW9Sj
         qrNmEKoCmwMqxZojKTyBlWGRT4YH5V0FhnShwBLHyE777DVfaSxCtuFC4k/ljGJjEo/I
         pAy5KV2pH9T7O8jTGUtKafyLPxKLphU9HdQadC+XQ/ByGpq1uA19sEtUDW+J5HziDyk7
         OlbqkLbn2qlFZwWAUMe4JEJCLLRRfw4SOSTawKZgsOvNVxXWwbYediA2Z+hEMmGx+WIg
         MkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G7UqnRaAm8rBW+gn96rLD/ZddS/fL+xt9QrjXSI7Kqg=;
        b=caVkK013O2fhOcLsazZWs12wEtLHBVz/R+Dv3pFOmTRKZanhx59ekZhiflymi+dwFy
         DUvwurJPXBUNqFcYZrHat9iSlLagOU7E8Nk+DJjYch7J6tB5wB0d6BBbFYfuuZo59fzX
         uzSIGWyqMq0ak5eedIJBrTyvRmHuwDx3Od8qvk4obLkBMO3Ge3AiGIGUgHW2KWnlpJf4
         LHU10IKYQSpwoY8LXhAYsaXAYRWBo05RHB9/Wsf39Jj06cE3T0vncNtkBuQY+AwPFYqy
         OI+L71l+W8v9qx8WJaAv8nuXj4A+nFD4C4vrAgTilFkiUx9foN2blPmO9fvrYCMgxqly
         uvUQ==
X-Gm-Message-State: APjAAAWYE/WmyUyoWDYYUdBDZjYJLAwoDMcBmPpwvKMocS7O7P55SVpe
        /6b09FRcP2dm7KJaRn9sG8wwRTBGPDLRyg==
X-Google-Smtp-Source: APXvYqxGQDORCepyaRS6dNWbTAeVeEfWWlHNtoC79p73SYaCMST0UMVo9l4g0thcjyFqcZDhoRFa2g==
X-Received: by 2002:adf:e2c6:: with SMTP id d6mr22864085wrj.326.1562196976266;
        Wed, 03 Jul 2019 16:36:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d9sm6164255wrb.71.2019.07.03.16.36.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 16:36:15 -0700 (PDT)
Message-ID: <5d1d3bef.1c69fb81.745b1.4180@mx.google.com>
Date:   Wed, 03 Jul 2019 16:36:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-8-gc0b2467c02bd
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 131 boots: 2 failed,
 128 passed with 1 offline (v4.19.57-8-gc0b2467c02bd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 2 failed, 128 passed with 1 offline=
 (v4.19.57-8-gc0b2467c02bd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-8-gc0b2467c02bd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-8-gc0b2467c02bd/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-8-gc0b2467c02bd
Git Commit: c0b2467c02bdbd6d49d9165e4097bbb83da01c35
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 26 SoC families, 16 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
