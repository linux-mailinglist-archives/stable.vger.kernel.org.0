Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A641146F39
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 18:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAWRJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 12:09:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44779 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgAWRJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 12:09:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so3927167wrm.11
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 09:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oltoQZ1ENT+WVEkJJ5yeIBFJg+ITfLvwJ5aZlxd8vt4=;
        b=s994+ygqiC5NKBLsFB+pMA5g6JAakQd/p84hsiNQSW2TkLajMhCdvNQF0pi2yYSWIo
         TqS68V5vOtUerk5yqO7sbF44daub0o2LNqPqE0ohswlnQm5sXHV4qP6QjH0Rs6Vfd6d5
         FP/rlkx0KZYtpDtjmUuXG48lRRo5J4amdTp3VNOK73WjC/Ro3xsi5jMUS3tZWbMhsQMC
         o03+HoIL58x20xXM84io7pcjF1kPiKMLqrYJNhAq3F1KUuwQSfvW7sGz9mGQ0oA+UT2b
         5cG5W4bS32062pAf9oqCM7n2ZlYeDcaaJqipG3TAHpOM5iz0jFNVaep4e/3cqclWSMFW
         AlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oltoQZ1ENT+WVEkJJ5yeIBFJg+ITfLvwJ5aZlxd8vt4=;
        b=k6/nnDJGro71cNV5GMlXsZVcTvMwunMLVw2DVxvxP94dF6iq/iWlN2upQdWqGV0V5x
         nAj1Et42nYI7Ki136WFds+aCJYkKW2l15TpRybF9vrUUCC/GZdWR9UsxobNvToeWlQeB
         21nke+QEQsAOqvaP/3/EIrKLS4Dtgec2r6wjkSWfwcE4b8SBGu7W4uTP4wQVLgkoGYhU
         AeoWKtiNmLgNQJwIOVEw0Ybe1Or7pvrejX9P7EdY1ThLnrXMB1P3v6DjFzGyIFNyHjy6
         it0V2EEHXUNDbVOkdutS9B9C1M4x0ACyWYbYF4g1pYvrffOa1SJRInARvTEjn0cBvpsw
         i9QQ==
X-Gm-Message-State: APjAAAWr7OW+eRl2wEqATmFOHtMHtEuUfnDReWQz9qV8H7EEWhJEfGWC
        fWb4BjdK6ioXpWyhRFY2sIlUBGorvXNPmg==
X-Google-Smtp-Source: APXvYqyCXQnxoggW9Q6mhVT3f5ihdAb+kLMKlioscBwdgYafeTiYoR28NGvlRN9WwyWzDJneyYhrtA==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr19500375wrp.71.1579799391624;
        Thu, 23 Jan 2020 09:09:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b137sm3571311wme.26.2020.01.23.09.09.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 09:09:50 -0800 (PST)
Message-ID: <5e29d35e.1c69fb81.b845d.ee63@mx.google.com>
Date:   Thu, 23 Jan 2020 09:09:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.211
Subject: stable-rc/linux-4.9.y boot: 93 boots: 3 failed,
 83 passed with 5 offline, 2 untried/unknown (v4.9.211)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 3 failed, 83 passed with 5 offline, 2=
 untried/unknown (v4.9.211)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.211/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.211/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.211
Git Commit: 80f0831c72d498fb27c90de47e0f69d593000305
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 18 SoC families, 16 builds out of 186

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.2=
10-77-g2f9a91e62a20 - first fail: v4.9.210-81-g0f7725a1298b)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.2=
10-77-g2f9a91e62a20 - first fail: v4.9.210-81-g0f7725a1298b)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
