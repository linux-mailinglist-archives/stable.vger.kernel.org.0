Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00731D604A
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 12:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbfJNKf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 06:35:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41873 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731305AbfJNKf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 06:35:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id p4so3208708wrm.8
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 03:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1jRCezjyOIixVrmLYOxu97tIMAYFAAQuHO/HK3vNNGw=;
        b=ewlTy24rqMLQjmUmqcMplSpctyFLMtpt1FnyiQU6dOR1/YvNAsn+kChdwcto0JKjDo
         ylOaxgLFLuElLcOiaGJv7r/Img0OlImibzMrECIATrpQodVT+qGfdojSBpVZb5rWBmd+
         7d02RNBIvfxAMAnDoRdLNhR/2F/zOt599btF7B3AlcrzlemZa46whu1RaPlVu7Lf3/xE
         ZlOamywBQ21S8psQkG8CydlTESSE1o4nAiI49To1eub+QBkbR8yt0WKnyYMLs0/hCfl7
         ULLcai5juNJJ394SZ9MiexGXUYJ4gPNanRb9dDrWzK9PmK/nIG/fFkf4XxqeLTHKLaN4
         OPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1jRCezjyOIixVrmLYOxu97tIMAYFAAQuHO/HK3vNNGw=;
        b=FAxDwJ2+eADi+1q3Lz+TAVrEThVqlrCrdVnYgNNkwNi62mVRNsuiMPxC6YurWVR8jK
         S3fJw+PWOuRohd3CXgc+0n6quFTxMZXCWEt4IR+4neC8Aipg6Bw301hTgMdAAigo4dTF
         y4zxH8gwaKBke+rg47R6HXXpZLMPE/h4QfdlN0dzJW7tTpcCa91pOj23S8sJaiK7DW+q
         bY5aClG2aRo+jr28vvxqAQ+mV7NrdUZ0D0U46B0D3h3/pVKRJK/mYzgRkMGC0qYbYYvM
         600e9bPOH/wnyb+ZsuArmMfEDEF6ffcBM1RFyDYqdcuVrDC8JMSWTYA9sQ8sAFxgWAS0
         /cLQ==
X-Gm-Message-State: APjAAAUKIWl7WnxrdUy+p80clSuYE9ozlMUPTpGkCSn0ILDvpd23fpof
        1rdmBurPmnaoIpwVzcSh925nKb2XKj0=
X-Google-Smtp-Source: APXvYqzAp/LT049w3y3FAaV9ZWgwRYPUeM/COmWHaOYu4n867jBvybqDdF6iwkURkq7Av6txFlk7sw==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr25140402wrr.167.1571049354839;
        Mon, 14 Oct 2019 03:35:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n3sm7876828wrr.50.2019.10.14.03.35.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 03:35:54 -0700 (PDT)
Message-ID: <5da44f8a.1c69fb81.23669.0d23@mx.google.com>
Date:   Mon, 14 Oct 2019 03:35:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79
Subject: stable-rc/linux-4.19.y boot: 124 boots: 0 failed,
 116 passed with 8 offline (v4.19.79)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 124 boots: 0 failed, 116 passed with 8 offline=
 (v4.19.79)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.79/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.79/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.79
Git Commit: dafd634415a7f9892a6fcc99c540fe567ab42c92
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 23 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
