Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F9CFB83
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 15:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfJHNno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 09:43:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33444 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfJHNno (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 09:43:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so19522904wrs.0
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 06:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c8kcWUAfadtCN4Xb4q0OD1Jf6vwT54HWporY6S9Lg0U=;
        b=GwL6i9PrE3KZATdeQMThsXWoyqa7LvFSIdhZX5B5sJ41G+3PWwnSLpfdGpBexxL+Gs
         upEznj9kO/4S9GJmi3AvRb91MzsDy7h+IDQTppHBKWewFlXFbU788MW8J30cVntKojVp
         AhfDI+ygyCpSRfQfOwuX4gAJD69fjNMDc7tTA8GRRlObLzUf5dk28pmEvcMLaF3rEXBW
         +A5WOUdIdSLgBXqpKowOgoqm3eSv9faI+oKD2KI1XuMch9zTukZuUgiVoz9oAkqxtCZD
         ek4/A9/sqsNurirJ00k2Hjapdis895OdrPfgAgEMd5hiwePaasCBLxvrExQTgWjjXwgj
         njxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c8kcWUAfadtCN4Xb4q0OD1Jf6vwT54HWporY6S9Lg0U=;
        b=KS5sAk/8j+QXt8y1wZeNzuLW3k+rwnIdySCTxNs64bG0BiesELXRzcxj9SqctEm6xI
         9TBdyMsqdnlivGlc94/O3ByDNvJgFCZyK48mMh2i4ZYgJifNoEu9W/Zcng8D/RjOZunK
         zl8EJrwNZEbDj1I8Fo/nY+O4saJBNZgq4E+Cvp6xGNGpPihDK59R++8hXCe7W6auaQVh
         Ih+2C+eoHvo6okFGYTSGr7AQ1/GUQxF2Hckw1LoXi5mQTXDYaAXwCJp+14y7lRI8puJ9
         c6FV6NyuJFymD/tIGlUuEdDbRHAKyswjbeGOoOYPOXPtgDhM0fpAay1uwqChHNzzDX3Q
         bp9w==
X-Gm-Message-State: APjAAAUoBhUphpk7WxxxI5HEWvQxfyALKDq8HG5g6u6mraUQ4l1p+p70
        50nd4Fyw7sYal8okVsF+VLVJw7pvdIIgHw==
X-Google-Smtp-Source: APXvYqxrjHZF5dgEFjUpjPXedHIU3NWVSh5OZ4gH6Qj9EqvtzWYNmIU+E0JbfS60Nuw4ypuryfh9/g==
X-Received: by 2002:a5d:424d:: with SMTP id s13mr28755906wrr.26.1570542222375;
        Tue, 08 Oct 2019 06:43:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u7sm19983265wrp.19.2019.10.08.06.43.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 06:43:41 -0700 (PDT)
Message-ID: <5d9c928d.1c69fb81.f9a5e.9427@mx.google.com>
Date:   Tue, 08 Oct 2019 06:43:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 42 boots: 3 failed,
 37 passed with 2 conflicts (v4.4.196)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 42 boots: 3 failed, 37 passed with 2 conflicts =
(v4.4.196)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196
Git Commit: c61ebb668f2ce3c22d1cfe6df28bd3198eabbdd7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 10 SoC families, 11 builds out of 190

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
