Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57BDEAD046
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 19:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfIHRzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 13:55:39 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:33500 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbfIHRzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 13:55:39 -0400
Received: by mail-wm1-f49.google.com with SMTP id r17so11206213wme.0
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 10:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rKlUQtobIwiUX86hH1QmaOzRxllMNlr3I+PdO9iSpis=;
        b=v+mWdFEavfEPLDg9cHHbYTe0kfn6MehsoQZBZPQpAlRW1lJtLkj+RoymlEvQR7g5f0
         FUMArEuwjLzR1pb2PbTjSOz8am2qOmXhNkUV5YBsAlyb0H9r+Ki5WxsaOmPIa4k9zB9W
         IYnaBm0awSfwS24plYjPvDg3ah4CXESUpBIOGUtMSkaAJKsMXXEAPinGqxICHWCX1jY6
         mmVFc4hokQm44LVkqSr8jUsRPSWedi+ccCf1S8D7NB85w+mdZRNwEkQ/hAWsY8UtSAGK
         2H+5yelIEn9kZNOIJRPeNfTWdRnPDfqQ0plFPO1jE6USOB1yOtFD+0mRrCgoAzIOEs3P
         Iv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rKlUQtobIwiUX86hH1QmaOzRxllMNlr3I+PdO9iSpis=;
        b=dgke6IyBU+fEQU4niwhcGgZIdyk30gEqf9Rlc+VwAuI2SzRhucPmWLJManQeFxx6cP
         zfrQVG+Yz0mCCuNJImQwdyIGw+Le/hSYbuWAFihh+EzlBaiCjZUtq7SBPPRPKoGBZiZh
         toQEJiBcJZEOOx3ZMou6sjscTvbhUXBHNWZFndbhct73p8xtz2qlr8LwB4YZ1FAvUQxQ
         SMfocAv8eIgRxxf5F4Y2Z6EI/SfhF9/X7El/VNWbDlXuUnkDE+kevnUvEQgFSkY16rQo
         8dkyBEjd4iqLmG+vFNEM3Ize5G1XiPD7II38Wnc9Nv+EM93d3sLCWe4PU9kYMQHBPyU1
         Iz3Q==
X-Gm-Message-State: APjAAAXFdaw+uVL8QCr0Awedid4OERwozSbkxLk1QIlJsSqhLnYFzpUE
        OScNPifXwbEvKfJP5n6a9eiP9HT1BTs=
X-Google-Smtp-Source: APXvYqyaYEa8usbv2oPlo0gRZtqFz4uvhID87GALX2lh58Ex6NKa8V2EWhxJtJm4UQvOQeKcDLcAFQ==
X-Received: by 2002:a7b:cd12:: with SMTP id f18mr16245005wmj.111.1567965337997;
        Sun, 08 Sep 2019 10:55:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u8sm9386827wmj.3.2019.09.08.10.55.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 10:55:37 -0700 (PDT)
Message-ID: <5d754099.1c69fb81.3f19d.9b5a@mx.google.com>
Date:   Sun, 08 Sep 2019 10:55:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191-27-ge2a45fc6bf15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 117 boots: 0 failed,
 109 passed with 8 offline (v4.9.191-27-ge2a45fc6bf15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 117 boots: 0 failed, 109 passed with 8 offline =
(v4.9.191-27-ge2a45fc6bf15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.191-27-ge2a45fc6bf15/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.191-27-ge2a45fc6bf15/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.191-27-ge2a45fc6bf15
Git Commit: e2a45fc6bf15db630000dee73d525ccec5cf6617
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 14 builds out of 197

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
