Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF27B1B95
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 12:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfIMKdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 06:33:44 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:38351 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbfIMKdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 06:33:44 -0400
Received: by mail-wm1-f47.google.com with SMTP id o184so2184225wme.3
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 03:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=98TX34I+X8TwFtQv/+uamXk5OmVQ2rqpHRctw32bRZ4=;
        b=NmC7A9VXwY49OOktiZC9vRmvt8yl1l+0aUX2r6yO9Qi1ddyk+MslpP/1Q2Yr0A1PJY
         b049nayEBOnzbzmWcYS0Kh1HpqhjYd/n83zy6AQPukuW+LAWA4Dwp2u8gE0440/GWJ/I
         pvANQ6WRaMXRxa1cI8gCtw/yz83J6D2QtQn47cklcs5cQwVQKYt2kGACrlncmLP3jePh
         88RSJG0TWFhOZkphLWm4barrYqxFE7PdqXHJe/aJX4nNgUDI5aqc1W2YCkOllRi+Boc+
         jyeoSFOmmVQxM7TppoAeXPw9u5/1V6JZv94fzgKVPRJV9v9zZZ3Mq9nJSTEay5f9H5/M
         Ad3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=98TX34I+X8TwFtQv/+uamXk5OmVQ2rqpHRctw32bRZ4=;
        b=tjXgSVyT5gdXPXDGXwL+2cLFUyZvgKv1U5mUNMzzMLWd8/4U/QG3bMjLSc5c6OBA19
         2EY4ucjxDt8gZCaGp98/0JcwPrRGD1wfv8ThDfT+k15qrjrLW3JFZnZccH8tv4XCiV19
         qivlbhFiDkOlYNMVfs2uvE5E4mW597TX9M02kZ6yLK9Fc2P0e+iz8h1HAb7qJ9CuWErT
         FrTJSuBS+PgmaNxLxRZ+Izj6iQZkxUk2YusCSA6Ov8KTH0soqvZaAMKO4Qw5h25K2i0a
         xBzqtFm0Ha//e0t1XVn9K78oB4eEWFhnCaczXyABwFJf2OJPk0S8yJQnbDV2h9CNViZN
         2KEA==
X-Gm-Message-State: APjAAAUZVtwkjgHbc8WixsAhyElIB00iv8HJk5d+f90RbgEmT9WQUV2o
        cBD+gO44orax9ateNEhMWdd77/ukyNM=
X-Google-Smtp-Source: APXvYqxJqKPMnWvZS3qitn92kCZRTxDxD4/3sIJc3HTD6gxw7O9XsFgI2xaMDR0M3oH0+0tj6S6Hbw==
X-Received: by 2002:a7b:c392:: with SMTP id s18mr3010787wmj.25.1568370821683;
        Fri, 13 Sep 2019 03:33:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r16sm32237158wrc.81.2019.09.13.03.33.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:33:41 -0700 (PDT)
Message-ID: <5d7b7085.1c69fb81.2b34a.aa06@mx.google.com>
Date:   Fri, 13 Sep 2019 03:33:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192-9-g160225f8cfe2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 100 boots: 1 failed,
 90 passed with 9 offline (v4.4.192-9-g160225f8cfe2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 1 failed, 90 passed with 9 offline (=
v4.4.192-9-g160225f8cfe2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.192-9-g160225f8cfe2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.192-9-g160225f8cfe2/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.192-9-g160225f8cfe2
Git Commit: 160225f8cfe282fb0b3ce73c781139b521b4b979
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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
