Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70BC188F8
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 13:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEIL2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 07:28:52 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:42831 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIL2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 07:28:52 -0400
Received: by mail-wr1-f41.google.com with SMTP id l2so2514909wrb.9
        for <stable@vger.kernel.org>; Thu, 09 May 2019 04:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q6P8lbXt6pr29gCHsFVPNyriUY3dnA10ZLeh+FAZfTQ=;
        b=rWTFfR/PCNPnT6NJlK8CbUAJOkFfCCdcsCUDN6lHZfz4sTwFFRrqGIWs0tRsG5o4aw
         43kRyf0zNHiTqmHW42VAr87XGtW6gcaR2DBzg4atE5a9VTdkYn6hMtYhp9chxvlABBBT
         8WZ/AMZnjOxGoOuPajxAr36TBZi09bFstjsASJASZTslKoxpu28oowwkXiPDd5WUIm5P
         B02DDPNqdKUyBGRhELfsW2p+JTGa4Df58ITdJGoNUuhLTThR6LFZQDm+odJMo6D23dbC
         ogLgLM+QE74M8InHGcpzexS3XUYGJ86SndfG8j1Azj1jq4HepjbfDVLObCWnsEoEgYLD
         gLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q6P8lbXt6pr29gCHsFVPNyriUY3dnA10ZLeh+FAZfTQ=;
        b=qRIlYAR5Im11hwL9rrefkUmr5mi+Zbo2ZsalgH1RARtfHto9uTKr9Tbw80mMg+ogeZ
         DGUdp9MpV8oEqRVOtI+tlgLxUTo1kDSunYkhNgi0cd6vq3vKWgqk1hbGaB2AIFfK3eLk
         wU6E/Fmf1T88svxkIotb/DMc9zJLUQtU5suGXw8YckqMaREASA5WKLDFrLXmi+/3y3wQ
         la8MLIADQvD96abRcCPg6aS0PNwypZ95C6Y6dpcycusVN9dNfAKjNIvVNJkz/aXUZ5Vd
         C5qCzhxM9p1FnGsj800z5xWPW7fi/8r5r0iXUFTnqhjeBQl9oVyUIAjL3JF1wZhPmGpu
         4AoA==
X-Gm-Message-State: APjAAAXbd39EE+Gza4G6Cu1rQRdEyRuSTyjBiavFapKsZyGwt8q2MbCJ
        +Ir6V6dFxV0zOJb4Sg5Z1Ll4sFnRFO+hUA==
X-Google-Smtp-Source: APXvYqxMuDEncPhFCVBRfbaOS5+2Lemd434uzxmF4tIUNv5mgnNc1qwsdqKg26cdOw7mOaiUPjgG2A==
X-Received: by 2002:adf:ce88:: with SMTP id r8mr2716802wrn.191.1557401330105;
        Thu, 09 May 2019 04:28:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a8sm1700939wmf.33.2019.05.09.04.28.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 04:28:49 -0700 (PDT)
Message-ID: <5cd40ef1.1c69fb81.629e.7b7d@mx.google.com>
Date:   Thu, 09 May 2019 04:28:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.117
Subject: stable-rc/linux-4.14.y boot: 127 boots: 1 failed,
 123 passed with 1 offline, 2 conflicts (v4.14.117)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 1 failed, 123 passed with 1 offline=
, 2 conflicts (v4.14.117)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.117/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.117/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.117
Git Commit: b4677bbb658d54ad29c8122d61bdcc0f878030b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 25 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.116-76-g2e004f6ac=
b80)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
