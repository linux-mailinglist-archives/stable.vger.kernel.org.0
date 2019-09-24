Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0391BC9E0
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409715AbfIXOKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 10:10:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38946 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730778AbfIXOKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 10:10:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so2126846wrj.6
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 07:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5mduAKge7IHsbdrkZ6k0HKeFRGLej9tudRnPcpHaYeM=;
        b=Z/2hFtlCR7H8sFRsfE1is0S84pkDv3jjpYwDAHu+rLB3hSrnGJWmpZPgwM8hqu2sGO
         5gNvzBve/sTqrOpvcJmGX+JtotawQG560fGDRYfpB6GAJCT7Tz4/+MTAbNzsnzzKiAVD
         aPoOycNZ/dPCvQvbmohGw5tvKmf85rTJhIeEWmLlgtoHsu8h3j+s3LOlkQbNUYE0MihV
         Ww+PNXsk3ODqEE2lJNY4SdwcjFMe5eeBg7p9IliVAtvGiaZcqKEJAHaQ64X/A3Jc0w5r
         U6RepmaOL6JllDbKPlKqeVWYTUyWtA5d9Y24DjT2qoxOKVn4CBkaqrCMNWKN7dmW2jgU
         EAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5mduAKge7IHsbdrkZ6k0HKeFRGLej9tudRnPcpHaYeM=;
        b=lDsNHOHc5fnBTFvB1WdoevRhO89I1PXqsl44DYsdFVhz/NzkMKPLhW39L5vIx3f6HW
         BoWrhZtSoddfKxJ0fn908rqJiUclFg4OLX+npxulbiC/AiqInfKtjpeQrMDb7TEH7wcL
         d6YXFzipvz23thW7WeqUBDrL+RiTw5DHIqY+KMzQf52Ui+XlmrjZMwTTKXjuPCBFWKaf
         SIVZ2NmpzUmuRZf63thxiqiWdIbdWePgEp9oP2j0EOwCST+yeQTHMJqHic2urt7kNiih
         JEzPGPChp+A9OWsURvb3WpKJQHkxShsP5knKFZvdzq+f+c2eqejrTBGE1ZiJhPJ6dfnt
         J0EQ==
X-Gm-Message-State: APjAAAX4201/U7vgDG3qc5wpIR1dMtroEh9EHirE1Ofahwk0lPB0ClvR
        0YAGZ3DTXncAuzQEmBGk7M0/YUWFsAk8Hw==
X-Google-Smtp-Source: APXvYqzQtdOdbSWDGm5mptY8AGZ8iucEf1IHOfMNo39InfaE5RM0DHMl7uOrewxCOrJyRfAvkAxk4w==
X-Received: by 2002:a5d:6049:: with SMTP id j9mr2630415wrt.213.1569334240238;
        Tue, 24 Sep 2019 07:10:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r13sm2678389wrn.0.2019.09.24.07.10.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:10:39 -0700 (PDT)
Message-ID: <5d8a23df.1c69fb81.215d9.c48e@mx.google.com>
Date:   Tue, 24 Sep 2019 07:10:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.17-19-gd6054a8738d2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 139 boots: 1 failed,
 126 passed with 12 offline (v5.2.17-19-gd6054a8738d2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 139 boots: 1 failed, 126 passed with 12 offline=
 (v5.2.17-19-gd6054a8738d2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.17-19-gd6054a8738d2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.17-19-gd6054a8738d2/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.17-19-gd6054a8738d2
Git Commit: d6054a8738d2bfaa10b73bf69530578f92d3efda
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 27 SoC families, 18 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
