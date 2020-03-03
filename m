Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38AD17850A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 22:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgCCVm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 16:42:59 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42367 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgCCVm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 16:42:56 -0500
Received: by mail-pl1-f194.google.com with SMTP id u3so34790plr.9
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 13:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sq0/H0DoD3Kn09hKX89HWp4Tjpwd6GUg5aTGOJDLlWA=;
        b=I7MEdJdkfUEbLBBKs/UepBgmGJ6IHhrnduh6NfE/m7jgVABVn01HLH5k9K+BG/lj7b
         czrEFR7jTKF1I2ZHN9KiXMlgaztBdOdd/zm0BAEc4+vzdvKUKZRhyx7fQEU6oBBLvn5f
         oFkHif29e4grBU/BOV0/2GiZspyW89YIfv+iYF9pYqxIGagmxn29tNDQBVXIOC8sxNIZ
         9qJW+daFqq8tI6Zl6USuxyerwgB6KD9LqOa/xndEM/GP3V9OBCuM9YZFjzRAI1TT87Gz
         ANnQRnUZIZDe7Ncz7Iu4JfKuQ44MAy4dk7lN5baVdBcJ7p+HAq9C5KQSVCDUOwqQT+Kq
         Ndrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sq0/H0DoD3Kn09hKX89HWp4Tjpwd6GUg5aTGOJDLlWA=;
        b=pmlpvmam4QOPwGLclPmXMaAavphtX4MFITgfIpS7dwo6Rl/6gggZ13FK8gTJD4nfCU
         5hzYMTEcAyohoWZwei/1nyC/dcg0WW7pakNkkwbgRws0O1Jotn5PB2PaQwVoDg6wzuZB
         4GuMWk8LxBZLW0whZ1Qm6FDV55GeZppNeQkC1Az/G3QhoV2/OtnjI7MxCSOOUfVkd8Z8
         9atLmAFwS+dCEgZZAdLt/FKZdtgkikEVui9RBFpkGpM0HjNSpvrUoRXhD71gEEazR23f
         byqiiRG6e5xmQvBbj4Ooj4XbhvHCIiu9fvbllRM5n+mSNU8gi6NMJWQpApQmDP8r8ntX
         mDug==
X-Gm-Message-State: ANhLgQ3/3/X6eQvwc9QWqaTtoqlSaDhRVywBjGSLRS6AI1TTKd+X40Ew
        OuSsUk2/EAeiuun3wZTv4vKx6AYD6cA=
X-Google-Smtp-Source: ADFU+vsFjpqO8kdCH083jpPx/NTiz2W74kAWio2AkVc2G3bXSJ7cSTRu9fROeLrUJlpHzPUN6TxTtA==
X-Received: by 2002:a17:902:44d:: with SMTP id 71mr5948365ple.95.1583271775484;
        Tue, 03 Mar 2020 13:42:55 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u1sm25654662pfn.133.2020.03.03.13.42.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 13:42:54 -0800 (PST)
Message-ID: <5e5ecf5e.1c69fb81.31d33.50eb@mx.google.com>
Date:   Tue, 03 Mar 2020 13:42:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.23-123-g71926bbb9dfd
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 72 boots: 2 failed,
 69 passed with 1 untried/unknown (v5.4.23-123-g71926bbb9dfd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 72 boots: 2 failed, 69 passed with 1 untried/un=
known (v5.4.23-123-g71926bbb9dfd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.23-123-g71926bbb9dfd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.23-123-g71926bbb9dfd/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.23-123-g71926bbb9dfd
Git Commit: 71926bbb9dfd36edc508871d883662374a6b0ff6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 15 SoC families, 13 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.23)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.23)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v5.4.23)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

---
For more info write to <info@kernelci.org>
