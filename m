Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E09BC9E4
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 16:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436897AbfIXOLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 10:11:09 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:34873 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436898AbfIXOLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 10:11:06 -0400
Received: by mail-wr1-f53.google.com with SMTP id v8so2135713wrt.2
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 07:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tl+jm+zSKm5q0K3HcE72vCoUXb5ZENakNKIsVBZrLt0=;
        b=w+NkPOQUY2Dx5IoUMLXiJBbvYrx89Qc7+BsTQhxHyO22cMY7QrrJys0+djtbDzMOVk
         b3LspSTs3IyO7bFHQZkniZHv+yalFa4rF1udT0kbpCqb6lnOrc6jldw6AqW1cuHfCvPz
         uCSX+4N80BprGtxih5oSOQP9wMicH2olhrLhOMhSshOyrlqdy3Ugq3ZJF6EiZatZmRdf
         E5NJEQFspoE3KW3qHMQiyAM10PsMPloULQzCjU1yAt9qhW6d3+NqDNXkMWsOjV9lRZWW
         OnoYwvrmDITvkpxMjI9PgsTqYACmiFwl3nccLB0rApVwdpJKwSagGUFMUFrA36bAwhnj
         COng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tl+jm+zSKm5q0K3HcE72vCoUXb5ZENakNKIsVBZrLt0=;
        b=XZjRSIo6ASpwBdnn68kDM+roMDCJrKQ+yOFmyy0kOg87ZLAgw9qVilivsDoQ1Pnggs
         1YnpJyS4Xk/UQ9sjQUGzsWzO6qIc1lHEnEkJUn8HfkZ7dsgMlMlvRLueb9MEqeO6H1Ls
         DYE1sGslIb2imOByl8GuTFJNqgv4AnoalQBtcyk+uNp18uVHj8bnrMqAkrcaFeoP32jj
         UsNlAmjhTwVYT4JZRDvc0jd916BipDth34JCYhpX5zFleZm+Dx8DwQfrzre/yGLNMf5I
         2rBSFl14GZMyomSiAbK4Px0rvGlttJ16BP7Fl3F8UdYXszw4Kirtu6/TJxvF2yGuE0aF
         U+Pw==
X-Gm-Message-State: APjAAAVQnDYfVTvL/hxskut7EOXtTeuD7vcYi/OUZSXTQAaXvlkZffH+
        eVZHASQhhjEd1XPGCZ4otXJVjBf828FJFg==
X-Google-Smtp-Source: APXvYqwRet2WdD7vOQRhMg75vcOMi235oIL1+wdIn7/tk/9wuAKFt3f+r1rEzR/GUm6uY6nqx20JlQ==
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr2427371wrx.51.1569334263231;
        Tue, 24 Sep 2019 07:11:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b12sm2079947wrt.21.2019.09.24.07.11.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:11:02 -0700 (PDT)
Message-ID: <5d8a23f6.1c69fb81.86649.9834@mx.google.com>
Date:   Tue, 24 Sep 2019 07:11:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.194-7-gc036679bf516
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 101 passed with 9 offline (v4.9.194-7-gc036679bf516)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 101 passed with 9 offline =
(v4.9.194-7-gc036679bf516)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-7-gc036679bf516/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-7-gc036679bf516/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-7-gc036679bf516
Git Commit: c036679bf5162083eb5b27c4b6626f551b1d0967
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 21 SoC families, 15 builds out of 197

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
