Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE387DA2AE
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 02:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfJQA1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 20:27:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37113 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfJQA1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 20:27:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id p14so269169wro.4
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 17:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kymC8OowknjteIgjsl6cChrjFsj24dH6Kc9gwZgmelI=;
        b=WymdvCHIHbT2+zCKanz3NiCnVy4+Q+Zq9voSIFPDGVdeOoKKc9/VLorOobXB1nV6ob
         j8G2krYulaZHu78mAtFn6MlEWLGI0h6ck21NUUgwvULGYJg9x8m5Icz9cwnQh9PNT0XJ
         OxELLPuCv//YUCOPd1d7D3LeAPQdNnhgMLU9EsWgiPaXGC1UsNwW1IaiLt0rHxK2usIg
         LZDi963iS76me7ly/xRXf9UKldfYr+nxn+/zCfN1ZmHIb2zYJwQ6qznLuaIK7rljqAFn
         pQE3E8t/UARl03SNSirLdI7/F+Vwc4pPGFXRvyHkTEjfbozREQiP9nyjgo/+6PRRB7rr
         +mwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kymC8OowknjteIgjsl6cChrjFsj24dH6Kc9gwZgmelI=;
        b=bl4EQP3DC+Hr1nw+8+8s2/NJFUVQKS47tTy2YD0LgDHHNB4OEK00kqsuOnrO+7XQO3
         HhLvC1HjhGVePMx2QnPC1edAbu59tJKng3TbyXHjN5/spm7HcpFDrnX0SCDjY+FiTQvq
         HgeL5+6+M+fY4o0aZfEeNTDDuW45YfvN61DMmF48YueIVJqVTl48S9cVT5joJBZLH2no
         fs5se/1+kMKwhahtCydCAIDGOHHQyNfYhKL0XxF3LQ9rbeNGpAgH78o0WnCZ/BLBUiyK
         hssfLk/m8TglzPu1pUqKoG+ATpWrUNFwBM2mutGO4xHYF+eoTe+WeOCC3YTeFIeDsjSr
         E9Ww==
X-Gm-Message-State: APjAAAV2X2g87lXblEtcIZL+40lWgLxTyx3KtejOlRJwjVMsAE2i4zz2
        adQpz50L5/4GpfGonPjbLPCbVgT2TqY=
X-Google-Smtp-Source: APXvYqyH/nqzxkzPhQQLLrNtiDLyeWwAWCcq6BB0Kw1Q90tHUFqB2AYnDk6oIFfSNDYAE355y7GZtQ==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr469930wru.184.1571272065599;
        Wed, 16 Oct 2019 17:27:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z4sm390313wrh.93.2019.10.16.17.27.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 17:27:45 -0700 (PDT)
Message-ID: <5da7b581.1c69fb81.feb4b.1a88@mx.google.com>
Date:   Wed, 16 Oct 2019 17:27:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79-80-g33a5a6692be2
Subject: stable-rc/linux-4.19.y boot: 105 boots: 1 failed,
 98 passed with 6 offline (v4.19.79-80-g33a5a6692be2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 105 boots: 1 failed, 98 passed with 6 offline =
(v4.19.79-80-g33a5a6692be2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.79-80-g33a5a6692be2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.79-80-g33a5a6692be2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.79-80-g33a5a6692be2
Git Commit: 33a5a6692be225bd21a71badcd5b64e5ae89d249
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 15 builds out of 206

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
