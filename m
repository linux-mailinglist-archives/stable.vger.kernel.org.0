Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7EA11FAF2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 21:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfEOTbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 15:31:55 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:38079 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfEOTby (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 15:31:54 -0400
Received: by mail-wm1-f54.google.com with SMTP id f2so1151989wmj.3
        for <stable@vger.kernel.org>; Wed, 15 May 2019 12:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0WW703pVcAi5qG/en5h0bzayogRvn6kb9J/fL/xA7i0=;
        b=hD8cy9cUeIc3zl551kqkDiuldN/WhG7tNdT8WkGfM2U5WsbPm+0VFqtNa7YxQvMjff
         +6i0F5XkzuCAfsPQGYy7mkgq3Y4J4d5bFCThr6oGmvzG0Lug6GsxtQ+2TyZ3iHf328j2
         1tR4lcE+HMekSPxV5PTASTQrj8RFIGUYJF3lokvswVxW3dEIzkDaIwoN/PupLKMIWilc
         buBw35znGoO0g+PxunwiY22WZX/eR9RqeFT5XVlwBFwFbXvq5gGT8Z9mkzZwa27nB2Oo
         aC4e6nOFdXTK0eDR3DkYgdmc/YR6+fEh/Im39+dNGRcadlO6KshjVmtoM5TFWSguSFDd
         KREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0WW703pVcAi5qG/en5h0bzayogRvn6kb9J/fL/xA7i0=;
        b=ERc5YV4gMZMJ7hrUPG4kFm1PR+VVnP/7/ZWfZcwa4ule/StXZxyMEmvqDw0hZIKGOA
         W2XK8w+d/ArP4E9Ts6B6D0ZRYb3mSIyZBhC0Oq+mUMZyTv7JVKEuMDsImLXHwMIjOwzd
         91ryWgV2LIeHvrwruXcKG8wBCTKKkbofcqKv8RmCKS9dRznguG2slwzSaX48FnsxCF5t
         glfXPCIH0PIL3P1PE3YylYcnfnqtMFY7/gNJasxOK8t+Ag9jzxJ2wqLczrWflgVKCgL3
         /F2mhPNKtY2MqrDpKUidrxxMsw2E7N9qhu0Kv8zTi7FyDKA72chHpclJ4kr1LAGx7Ii/
         hbbA==
X-Gm-Message-State: APjAAAX2/gTMeHjH3CdD/5c5JYQe60pj8mXwyFTgkX47rGITw2pUnSeU
        iLSJ5/SrSQ1oLL1lJTZtMUz3Zb0cNOUzcg==
X-Google-Smtp-Source: APXvYqzm2j9w10Zyz0/u3JjVc0ux0n48a1yknyxH/S7deh5OecAA87E8QmsRA6lHNsGeoM9SFoMCJQ==
X-Received: by 2002:a1c:9e8e:: with SMTP id h136mr2990910wme.29.1557948713511;
        Wed, 15 May 2019 12:31:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j46sm5840792wre.54.2019.05.15.12.31.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:31:53 -0700 (PDT)
Message-ID: <5cdc6929.1c69fb81.a922e.1983@mx.google.com>
Date:   Wed, 15 May 2019 12:31:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.16-138-g174f1e44d016
Subject: stable-rc/linux-5.0.y boot: 139 boots: 0 failed,
 136 passed with 1 offline, 1 untried/unknown,
 1 conflict (v5.0.16-138-g174f1e44d016)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 139 boots: 0 failed, 136 passed with 1 offline,=
 1 untried/unknown, 1 conflict (v5.0.16-138-g174f1e44d016)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.16-138-g174f1e44d016/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.16-138-g174f1e44d016/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.16-138-g174f1e44d016
Git Commit: 174f1e44d0165ce68f4e520718847304556717e3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.16-105-gcedd923508=
e9)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
