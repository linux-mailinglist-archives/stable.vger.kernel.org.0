Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493DB1F669
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfEOOUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 10:20:11 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:53852 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfEOOUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 10:20:11 -0400
Received: by mail-wm1-f54.google.com with SMTP id 198so225973wme.3
        for <stable@vger.kernel.org>; Wed, 15 May 2019 07:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K/lUybpYvYg1JgyXxJbdS2Ey0Btfjlwmmf2j+lr+5xs=;
        b=mZBJyrtxxEBnijp7o0rnaMMUYb+QsTEFkWRzRQnmI92KptKI2rp7K1fHSn7qbJFCRg
         EbvWo8ZzIatMgrfnUT7SzW+IbE7yJZ/a/bcz3cu/S7QcEFdOxuWvmv2naSi7R+cf2nAi
         QBy/KIwDvNtWwAY7CWQlkWXBNV3QTgKnrfQN0wOv2TzD8qHbeS42t4cH9TIiC0/I4mb0
         3x6as3gxC/X18STidMb4FaAc76tQsp7qnnATPGPfXP3EJArbQoZ/83kQBeCWQ1vyZeny
         8sTtCiFnajrbr0eFZnMWdVoUs4Cknr1DWDbo6LolM5RgEik34hey6rr//xhJX/xpWgzm
         0TAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K/lUybpYvYg1JgyXxJbdS2Ey0Btfjlwmmf2j+lr+5xs=;
        b=W1E2zoRmVpMdBQ1pcA3tMRhN2p3LpN1Lhl16NRrcMpAp1XL7TiML8BA5H5GPilgekM
         HfG7ZVYzAIKxdMx1oY+qeQKkmtjKDq5zxqNX6+rkf41PwqRT13JezDC5Jqzhh25ONRXS
         wTlRfEDapPpTsxxyN5PwNd8OrlfGeDHsOBo+748ffXHggslGNSMSFnmrkFoUjqiPXQtP
         DKh0XuCIukKGmuV5rczZBJZRRwspuGpaIhvVOc2njBXfy+dk9ZSDe8uLfsnSoB0Kl0JG
         elMoz2m1+9xDbPyIdka/LKWf7J6XBSP9BSmw+j/qYfN76GyaY1GYfO9UQPlBcRr8WpNJ
         azMQ==
X-Gm-Message-State: APjAAAWrBMsVngUZkqqBkcTL9mnDqXJQpFD+rdbGmhhAyiSOlSS5y4A0
        XNN5uLlnPg8mzdTUnMyW6611g4+p2Onzxg==
X-Google-Smtp-Source: APXvYqycMkf1UBVDhlcQUSxakRY5W0llE+lw/PZab8ILsRWskh1Y85OWwRRElCXxgjzcl3GENdzYPw==
X-Received: by 2002:a1c:1f95:: with SMTP id f143mr18583854wmf.16.1557930008723;
        Wed, 15 May 2019 07:20:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y130sm2751880wmc.44.2019.05.15.07.20.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 07:20:08 -0700 (PDT)
Message-ID: <5cdc2018.1c69fb81.bbd5d.fc4e@mx.google.com>
Date:   Wed, 15 May 2019 07:20:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.179-267-gbe756dada5b7
Subject: stable-rc/linux-4.4.y boot: 98 boots: 1 failed,
 92 passed with 3 offline, 1 untried/unknown,
 1 conflict (v4.4.179-267-gbe756dada5b7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 1 failed, 92 passed with 3 offline, 1=
 untried/unknown, 1 conflict (v4.4.179-267-gbe756dada5b7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-267-gbe756dada5b7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-267-gbe756dada5b7/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-267-gbe756dada5b7
Git Commit: be756dada5b771fe51be37a77ad0bdfba543fdae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.4.179-254-gce69be0d4=
52a)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
