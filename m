Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABDEAFFB2
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 17:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfIKPMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 11:12:47 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:33036 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbfIKPMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 11:12:47 -0400
Received: by mail-wr1-f46.google.com with SMTP id u16so25042115wrr.0
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 08:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bhnRwJ6+1D7ulBJm1TMr6GvUhXXDbWZ4qZRYoGC+ow8=;
        b=mnOc+EQp1kQne0MESamAVPYIbPE3KLBXZf0IYP4hyoInywreN3JBT6nj4LLs9G7D6P
         Bi3JvC40EC2smJAT5BfuUej6cfVN7EUcg+8oqgJx+UsqBnPaPe7n6e3Zn+V9rQA4esky
         /UNchdKvr+YQ70MlJu/0ODEFpAx8cI9smohzrZmBqNYd71m9FOjSoZnO/YL/mBOb0AKy
         agSQ8ouOn1jtzlnji7uJZm5mFnEWpARa02EdxIfxSHXUM3tFLfec3Nd46H1Q0gpl+iqo
         6rI0GTTSVACNKhNw86/LJwp2I9wqVt8n4kMNJlpekYTzoJ8aJe3tOGwljUcE/LZo4t8J
         1yKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bhnRwJ6+1D7ulBJm1TMr6GvUhXXDbWZ4qZRYoGC+ow8=;
        b=ELd5cpAG6IRtwEBb3kH6VqNXLv2VnPM1OS7Dj5+DvYhylJS4HKfiGspmDv2AsICHRk
         Aq8Dnn+N2vJL/SRmOMgO2zX3FnNneRWGbM4Em4lWYnfkzWIzlsvGumR0FHl8tMOiqg2x
         LfUxuKbxHX05m6eHAtvOyMtqKTfAl8n/Qg4dtvp3oHDPhXtzSFRNFMrB5vBZxuhE8wjP
         cOb8Zffx9hRZzZsTMM4hFEj9tU2UBusu4UVY/XWIOBT5rBu7JFiWGxt9N+vew/CqiNiY
         vyQO4PSxyFbD2To4nFescTsQ6LqU0JUxnFmNA2VB/biBx+eArZiCOvqr+vrU3zQ8kwVn
         fqFQ==
X-Gm-Message-State: APjAAAUjAqpLngb+gplQiKKgnf4wLTshk/1OYFlb66RWfjKwT47wvfy7
        oT8/WtQ8BCTDdRwCJh70E6YmGqSPbfP4FA==
X-Google-Smtp-Source: APXvYqxyb4h/faSHmzboI3fWhkx6RWdOdoYFvWe71Ckf7yqbrBoDZSIJJLcF6Hc35EbB90RnDTfXYw==
X-Received: by 2002:a5d:5689:: with SMTP id f9mr28942229wrv.224.1568214763679;
        Wed, 11 Sep 2019 08:12:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z22sm3672810wml.38.2019.09.11.08.12.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:12:43 -0700 (PDT)
Message-ID: <5d790eeb.1c69fb81.61223.267d@mx.google.com>
Date:   Wed, 11 Sep 2019 08:12:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.143-20-g570d97484537
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 0 failed,
 114 passed with 9 offline (v4.14.143-20-g570d97484537)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 0 failed, 114 passed with 9 offline=
 (v4.14.143-20-g570d97484537)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.143-20-g570d97484537/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.143-20-g570d97484537/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.143-20-g570d97484537
Git Commit: 570d97484537c5a83b2e252ad55e56f1749d8c6e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
