Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C795EE499
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 17:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfKDQYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 11:24:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35230 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbfKDQYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 11:24:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id l10so17816382wrb.2
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 08:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5i1TXwFSdLilES+By8yAsv0zl19aA/kEW0krApB2hOg=;
        b=ke4Qpp6la+lVy3jA1xvZvkcvz7MEcRk39DYIuwBxq1C/K9hjdVeQrtwTmfJqwCpb6L
         zZ7nM6FZKqE+Jw8+Xf0WhLpbK6H34TGZl249wAVFlPE4ThDHoR2LrJqQJIEZuvXgD1Fq
         aR5rX2p1wCN7NVJLC41Bz7VYl1enT4jTl/xoMar1HHi2QCmy7uYV6yV/yvcoJtR2Ok/Z
         cf8M6f4n1/J70skUYooZ3Etu8VKspfU9H5wdSbKyT1J1f5SYp3bHjWsOtNbgw9cWkiZp
         hliZO4J9VZDh4aOncX/ktd/AxvAgGMPU0+Z45okKe5912KAKVfLgksAOS137EVMbP0CS
         GmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5i1TXwFSdLilES+By8yAsv0zl19aA/kEW0krApB2hOg=;
        b=dXpwWQi6+TkfW90P9DrxgcLfj7h4Q1Pm53DpTkEJWGa4N9oL5/28MuS9UpwOY/YGB8
         kRjZzgsYk8whPreWjxWweFgOuGxk0ae0hHoucuo+yi9roG+PM+4jN54pFX7cNXJTNPYL
         9wIa9fYxPU3cBYu3quo9R1wSwLBz43xeOkKhzrJWMTB2kNZ56rfPFL40PLA+9VDdvthd
         vS2zPlN0SMf5NMTWG+v1Uo1nGGVxq/0/5hPpQYnRCbj7m4rUbH8xPkt00c4uLSBKYruO
         /vPB443WCJ8TkYSQIX6deeqy8aSW7dZS6ZKdEo8ZUwqA5bpp173UGDb6B52VmGldX/kL
         K3dA==
X-Gm-Message-State: APjAAAWqaM3zkhp8NFluZdXpeosiGQD0cNNmUUy+ZGmSzKu+ZZSJtlgo
        u3dBvBAeYpY1zHcPxYxFCb1kVCi2zLR1Ww==
X-Google-Smtp-Source: APXvYqyNz7YKh3SAtwSYfVzYN8x4G1+ru51aa4Nc/xM6fX1VCbD5qbN+cLRZhUFKP3RZ/rnbsqSefw==
X-Received: by 2002:adf:c58f:: with SMTP id m15mr23433808wrg.362.1572884673638;
        Mon, 04 Nov 2019 08:24:33 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g8sm5174802wmk.23.2019.11.04.08.24.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 08:24:33 -0800 (PST)
Message-ID: <5dc050c1.1c69fb81.9f0f5.e095@mx.google.com>
Date:   Mon, 04 Nov 2019 08:24:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.8-160-gff21af282725
Subject: stable-rc/linux-5.3.y boot: 120 boots: 1 failed,
 111 passed with 7 offline, 1 untried/unknown (v5.3.8-160-gff21af282725)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 120 boots: 1 failed, 111 passed with 7 offline,=
 1 untried/unknown (v5.3.8-160-gff21af282725)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.8-160-gff21af282725/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.8-160-gff21af282725/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.8-160-gff21af282725
Git Commit: ff21af282725ae2ebc3ac4298513816f760c929e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 16 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
