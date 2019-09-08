Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E9ACA78
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 05:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfIHDuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 23:50:11 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43323 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfIHDuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 23:50:11 -0400
Received: by mail-wr1-f42.google.com with SMTP id q17so5548273wrx.10
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 20:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2WO+9oHaRGQIbvFtGar19THhSno6YDvY4fdyoD+he/M=;
        b=WJpe/nc4dPfoLPzq/XsshjUl7VjaF61eH1BgVRFiycRQzXZEad7t+57T17BEczVKvU
         lAOp6+81w1A1NUr7XWOGouUB5NDBRqggZond409ebYWw+Jc//6IU1VTVenMbdst+kG4G
         DP4xIQv/ioboSqMKgKG3uz9rjsDW1fR+24jmjMFV/Bl3qL5BvBQrXBVVPq+D7sf+Aik9
         wlztxCsePiZMraSSgpjTq0NtsGrcUeKKIUgaQC3IFgPqg1v24xtGZwHxebz5WsIOdfmr
         mBwpz2a0I1p2yRMI24cCTr5R9QjCLztfi/MW7TctJj/mUmK8pPPySOObloStaCvxsipY
         Gdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2WO+9oHaRGQIbvFtGar19THhSno6YDvY4fdyoD+he/M=;
        b=kI3tu7Z4oXIFFIAEOQSQhK2RmlNXNps4kRJ3MknWX5mKfyJzIjDus2Vt4+iBLLzOqy
         1mGp0HiDREiHsJCKYVPN9fTLy20/p777MBXH6mURCe/vPCnVB4ujRerrOpHd9MoxHrmU
         t2M8R4d1sOX6/1MDJ/8Crbn2qsyJ5PCLfCHP1z3LKkQ8Ah0Wj3zS+LnU8K5YOI4wE4sh
         dOhgSRMw+7/8bw4kEdPPvNme2zW+3li7wpeVJWHXhCkRhXV8ojlCj+Rc1o25vqMlx/jw
         6kCs4o7KpySVDqY1L+w9/7PcATrtDo640D7yMxUhZEBv0LaQXQI1M+17M6FM5BLOm2GZ
         wXqA==
X-Gm-Message-State: APjAAAUg43IXJpSea3lAm5GzjapTulXEENksqcy1EwlDwP8lsVqgrPMB
        XCWhFqgfaEIo4ctaGVxsa9RSlBBRyNs=
X-Google-Smtp-Source: APXvYqybbmTIqtCrw7XWNja3coaAYDVy/kMd8/PaWXzBRHaLuNioBijuwr/bytGCaFBYv7HazoLilA==
X-Received: by 2002:a5d:62c2:: with SMTP id o2mr12772076wrv.350.1567914609178;
        Sat, 07 Sep 2019 20:50:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i93sm10629096wri.57.2019.09.07.20.50.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 20:50:08 -0700 (PDT)
Message-ID: <5d747a70.1c69fb81.2dd99.1272@mx.google.com>
Date:   Sat, 07 Sep 2019 20:50:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142-33-gae63f164b35d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 133 boots: 0 failed,
 125 passed with 8 offline (v4.14.142-33-gae63f164b35d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 0 failed, 125 passed with 8 offline=
 (v4.14.142-33-gae63f164b35d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.142-33-gae63f164b35d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.142-33-gae63f164b35d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.142-33-gae63f164b35d
Git Commit: ae63f164b35dc3e258f232e6ba8c7db2ed021bd0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

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

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
