Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC1CB4D9
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfJDHL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:11:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46523 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfJDHL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 03:11:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so5657593wrv.13
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RdhJuOTEgHD8o5roy1R7weiRb4QE+YOncsOETWm4IUI=;
        b=ewSWsK4TYqMCBks1ubbgnAFU5dUHbEJAOhsZtdQ88cdNX3gbd54+cMZ33WEfo4zGgd
         90v/j6/aJu/EKB6fVj+CBYnmibHcIJYwIWskuqPT7lHrLGBOOQ+YD5e6c3OENQQSENNV
         DYpwQO7KI6L5lJ3FUBwfCajG9QiE6U7G2qA1KljSOsEGzmLT5/x5rYT3zcK9IHQNMju1
         2MdDlESSmx7LojGnzVysHDfzrVzEphTiY3Hirb7Vze0eIIV1lwloRWAwifqR8HcY1XV4
         aOB82YXXD8s3PPQZZIXGKa3nXXb9aHGqIDlPFV66seT+aVFltwE30Bup7tXfBb+qUdnE
         DsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RdhJuOTEgHD8o5roy1R7weiRb4QE+YOncsOETWm4IUI=;
        b=O6B4MtWvba+Vb7Mn5Tp7B3kXV7OtZPB0/FVdtqRikprfw3rLr436hR1RBMAGccOerR
         2uiaXvvQXYmBJAa25zczsSHJyyU3F0J0nd2PhkqRRZ/qNukbBxJeBfNxC560lnrK4aK3
         kfwcYQG1tQrHxKs/vvZFTEgYVY5YWbOYftwNtzpducgsuuegu1CKQbzg41UyTCEgOO1c
         1uRqbcpTLrIB7xjc64671l/wY7wEnEn0KJGuK77gDCHsbDtLemnuuizp5BJIz9GaG7uh
         pv6Y2BEf5+oWQQifiPdDcYXj2s43srpBXfPOL4jgKSylrRnfdcorzbSCXYfewrd2NejQ
         d9EQ==
X-Gm-Message-State: APjAAAX9H3nkYwWBN16dHF2D5N/uOTQIdXU4k3s9PWlqhHw6nr5yK8Yw
        hEch4JhxdpC6UIOvP/tVSRNWCAKj0gLKRQ==
X-Google-Smtp-Source: APXvYqyiU0xfbmDYAlHQ+vplfRw0qEfQsZDMhCP+BlSPtmPrqUWWBO9TWqJROquapB1nk+D+w/xiZg==
X-Received: by 2002:a5d:694c:: with SMTP id r12mr9826405wrw.44.1570173085179;
        Fri, 04 Oct 2019 00:11:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a3sm4320997wmj.35.2019.10.04.00.11.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:11:24 -0700 (PDT)
Message-ID: <5d96f09c.1c69fb81.2582d.3eb4@mx.google.com>
Date:   Fri, 04 Oct 2019 00:11:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.146-186-gb99061374089
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 111 boots: 0 failed,
 102 passed with 9 offline (v4.14.146-186-gb99061374089)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 111 boots: 0 failed, 102 passed with 9 offline=
 (v4.14.146-186-gb99061374089)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146-186-gb99061374089/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146-186-gb99061374089/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146-186-gb99061374089
Git Commit: b99061374089a66c2dd55bbea3299a602a4f0891
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 21 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.146-147-g=
990856f784cb)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            mt7623n-bananapi-bpi-r2: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
