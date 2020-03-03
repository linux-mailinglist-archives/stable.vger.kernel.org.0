Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687451785B0
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 23:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCCWeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 17:34:24 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37660 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgCCWeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 17:34:24 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so2237085pfn.4
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 14:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=37NPOvf4CIrzkEknI3/AHazlAOBjzcYVugZSr5qpMyU=;
        b=UoQOgB6+EqJ8iSvodbaVAUyvkgAUTWN9I4mf37XQqGnc0wZ18GoIYWhuJiSPfndXco
         H5ZDaxPdZACfk/RBMo/UhyqAaGNzU5Nl26TEhGlFp9VnXkkq/eftH01vHVbVo96TpYwr
         IVePb6hvZy4scTIxqG1/uEarVo07MFpOkurpmPdadK4HtsCGtKRKBYAhaqitWiqBKrUB
         14+iiz8SNwDrG69Qv8T4NQX1JBONsknz4wVTr/ZyyRj3D7pZY/QnJZ2rkP1RknIIqaPx
         HLzMhjrm9wSlcXLb0DeYy7tUKhltw7yASZbawmgyk+wVdJ4aSQNYFzKKVQ/Rgn2e4IOz
         A+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=37NPOvf4CIrzkEknI3/AHazlAOBjzcYVugZSr5qpMyU=;
        b=L4UJLQIQFfecAgFnPToLDUoLuVFcHOzYHx9uASoivVH5hIjPkpdhntAL4S4xF490rx
         BHhKonnjG4F6MWGnQGZ08rI5vbucul2edzQT9WnICbb7shiqpKVyrULK/3/aZylEciqh
         r7LWGykNlU04mwovL+kaH7ffaTV/fLcIf3MpAAGrvjAul1clzaOkudrViZSTHt9hNWDQ
         qHR0SwNCI4CAjPIpFcf5sptc0aBaZj1DYZPv4brNUyXugrcn5Q495ox7R/w5Bd0oiSwb
         g4sUvEzhT/Sexg2To8xl1knJ/K1eBf8Ey56Qbxj5Rnffm4uzb/HsRMZZ1FyvsTXJ/Hhy
         2dzQ==
X-Gm-Message-State: ANhLgQ2zOwdhJmqNODP2nvuD7yHEhtUrl4X8RY4ACs0LxC1JzbCZaRij
        0IWe3ld4XwDVl5ssTfOvdifk3ZEz5Ic=
X-Google-Smtp-Source: ADFU+vvRNNjhId8zMj39VfrUeKv4YWgzxeDKD4UfGjOTyur/ATE/MiPPlR4tH0NlYPvuycIl+VKpXQ==
X-Received: by 2002:a63:4a58:: with SMTP id j24mr6133411pgl.166.1583274863293;
        Tue, 03 Mar 2020 14:34:23 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q7sm11200320pfs.17.2020.03.03.14.34.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 14:34:22 -0800 (PST)
Message-ID: <5e5edb6e.1c69fb81.fc20b.f144@mx.google.com>
Date:   Tue, 03 Mar 2020 14:34:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.107-88-g619f84afab6a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 60 boots: 1 failed,
 57 passed with 2 untried/unknown (v4.19.107-88-g619f84afab6a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 60 boots: 1 failed, 57 passed with 2 untried/u=
nknown (v4.19.107-88-g619f84afab6a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.107-88-g619f84afab6a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.107-88-g619f84afab6a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.107-88-g619f84afab6a
Git Commit: 619f84afab6af6b99d65c2e2c76cf7b899fca40e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 13 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.107)

arm64:

    defconfig:
        gcc-8:
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v4.19.107)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
