Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2914341B
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 23:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgATWes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 17:34:48 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:54293 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgATWes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 17:34:48 -0500
Received: by mail-wm1-f45.google.com with SMTP id b19so971524wmj.4
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 14:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VVXIdvVpGJvfa3ZUTK0vI8s3lVGb/PIiG3aruTlsPJc=;
        b=BgSa0k0399rFyLEekssIcZBxysoSbng0OGNYu/ippmnxtFU2BVoETQ9i8FfX/e2+HX
         jrGFey9Jm45oYelfIGj9ZrFxheh5hWrx3gqkq5lcIzBeycS7DXHDutdS2iB9IKfTx9lC
         0LezgiaQGOzHdae2ZU6eIF1pBDS9Ou4SN8ihQ24/cEI4ZswrGRMWUtZbU4f50kj7yNnL
         mIrnudRCoK7H/lOuHBmeuzKU6qF2N++fg+nznghDiwBLb+52t1a2WhmnVNR816V7qu2S
         YzvKp/3ifdbLzeJFDj0IzBgRi8Ld6XLkK0AFGKjdCExMM0C8r2Cb1Fm5OYf39+qtQe4K
         Vbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VVXIdvVpGJvfa3ZUTK0vI8s3lVGb/PIiG3aruTlsPJc=;
        b=nfrfVs0nIMW2/m6zooLX876yxVjaDwkyX11MgxYnkMSJsPdw19oQWqvMN9RvYKRq/I
         X9uRzkXPKL7gETPrHTof674qNqiUO7jY1Tw9yiy3nzHY4M1tJTvyHRt3IC/U7QN58sQx
         Zowb6WsqkOYem2hSMifG+VAdffJpX83dgrAXuIe33hMLCyboCR7tdzdFuQyBkvukq6uj
         6mNKsL8MIj6V3CUsVSTqKIdirsRJFI8ol4z176gXMPq/mv9HAVyDSv25GQirBsf/Rgbm
         hgI6lYM/o5KKLwE3IhvjOjEWyNsAnAuhT6gJ/fKAtI6BdvOz7r78gkS5NEd0Yt/bLL87
         7gpA==
X-Gm-Message-State: APjAAAWWcZSIR9yX0LZOz+I/qVOwZD9IR2BxeXrowfwLgeoGq1lILcRB
        xM5o6ClfmSEy7fvTa+5PaZ2xf/3sib/3sg==
X-Google-Smtp-Source: APXvYqwfhl4O8Vw1JiuO47RKyu6O9yn8ITG45vv7JMrn87XNhyIVIuXH2tUGhaPqSQRIFETQi1ZfAQ==
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr903260wmh.164.1579559686601;
        Mon, 20 Jan 2020 14:34:46 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t131sm1068734wmb.13.2020.01.20.14.34.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 14:34:45 -0800 (PST)
Message-ID: <5e262b05.1c69fb81.5fb1e.5018@mx.google.com>
Date:   Mon, 20 Jan 2020 14:34:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210-63-g97203d960bdb
Subject: stable-rc/linux-4.4.y boot: 79 boots: 0 failed,
 72 passed with 7 offline (v4.4.210-63-g97203d960bdb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 79 boots: 0 failed, 72 passed with 7 offline (v=
4.4.210-63-g97203d960bdb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210-63-g97203d960bdb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210-63-g97203d960bdb/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210-63-g97203d960bdb
Git Commit: 97203d960bdb2102d5358b0d18b25fb1f2f74345
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 15 SoC families, 13 builds out of 179

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
