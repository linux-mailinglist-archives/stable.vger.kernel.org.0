Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5352ACA76
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 05:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfIHDt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 23:49:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35366 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfIHDt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 23:49:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id n10so10997752wmj.0
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 20:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cUpX6bUl3LwH8Uo35TxMQxd/1bGTeqp64Dz3j4z0jNY=;
        b=WD85a8l5/xzAYr+XYN//WRVd28X4GxvL8BK/16128HLkJlNfFY3xa/ZV3t++bbG0Qu
         UHdmdAD/AWp57HYxhktj8iMRyhZ35XgGGLYVCZ4SlFlO7s0UHJy/dCtENWcanM5dXB5y
         m0dZB0rzCcvvyQjvqO/cIaa7VaepWHeMPy4NDMO8NsmY0auqLD62p/uD/yHLIF9z432L
         8bXKa/2CvuXUeU0ihp41Xxd2KrzXwTPd3XstuTMuuHsBkl/TpBtnEWiwwJP6xLik9P/2
         clYTJOxFe7j01s8XfzcJr6liCAjFPiG8Nyplx4mlYc3rbLpEXQrKrdKbP0iSMa6UCSXw
         WdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cUpX6bUl3LwH8Uo35TxMQxd/1bGTeqp64Dz3j4z0jNY=;
        b=ceKiC/OGcVJAA1lMiyIn9vMWGnEZLAktwZY6KpwfeTbi6bKPyMlGM6c+f+vjwCe5N1
         zGn5BYGVb8gW1LeZBEfLVC0oe1QuyRW0Ijkjb/sp+or8DE3ss59c7kNGyFBDr5l3Y2jZ
         ru7nQBSPtB8r/t2oFckqRtJ6DZZYBJAuMR3+VXkt8q6r6P3UzEKMwpyzb91QwtY78/UU
         lwTPA5whWhBGRb9lwTI6XeQztZ0FngBRznZK74CDt9XUACRrp0nij/Hl5I4kt13OJgzc
         vFTEGLmWKZOrUedYHnVpDczqqw15GjZlTOyehL7Mi4kaYqkXWSk7KsUSMNDk+sa10dwo
         NofA==
X-Gm-Message-State: APjAAAWmJjpn1P4WTrq3/krcfBSB7XEszHgGn0cig/n8ULy8kNQdnGS7
        rISLPiEfJQksnhBUKCk9yAVOMDLfUmQ=
X-Google-Smtp-Source: APXvYqzp+uSIlyfGxyPfPklbtBXyyOc6Doe8MNtf3f7CHoGuPFwJt5g6s3UZA4mOkiHpti6mC5wKaw==
X-Received: by 2002:a1c:4d19:: with SMTP id o25mr14038259wmh.52.1567914564706;
        Sat, 07 Sep 2019 20:49:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u8sm7947442wmj.3.2019.09.07.20.49.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 20:49:24 -0700 (PDT)
Message-ID: <5d747a44.1c69fb81.3f19d.3d70@mx.google.com>
Date:   Sat, 07 Sep 2019 20:49:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191-22-g4d39ebdeeabe
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 104 boots: 1 failed,
 95 passed with 8 offline (v4.4.191-22-g4d39ebdeeabe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 104 boots: 1 failed, 95 passed with 8 offline (=
v4.4.191-22-g4d39ebdeeabe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.191-22-g4d39ebdeeabe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.191-22-g4d39ebdeeabe/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.191-22-g4d39ebdeeabe
Git Commit: 4d39ebdeeabe4abb102fb7dc70b913815dbb9eaf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 18 SoC families, 13 builds out of 190

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

---
For more info write to <info@kernelci.org>
