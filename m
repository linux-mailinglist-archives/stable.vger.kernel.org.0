Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A75B1B92
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 12:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfIMKcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 06:32:04 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:53944 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbfIMKcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 06:32:04 -0400
Received: by mail-wm1-f43.google.com with SMTP id q18so2153269wmq.3
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 03:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jRlc6YgmNeRIC70B/QTjydwSoj7rhSiRz+gWeFYeQyE=;
        b=GzZBx9at2KwbBbDvpS9dA1+RgnTrROO+Xwgjd8zIdPH4hw63wwU+9wGTN6Is9x41mz
         dkflUWH1sz3BJMjLPftPTzP+9cAd6oAonZ1dfXZfddVt03aL0YhCd6Oa96LLv0Qv18Ld
         D25CNE2xizoW5olNopx3cE72WvmMpe0sGyKzcvguQ1bWxFDff28w0GeSJTiquGsV3lnb
         yzxwYctzR4ACHTwX3c9cZxKTIMwUAgU1OKvgJcZ893yyiSACDSStRyimMWqnyDcTuPyc
         DQIKXkk3tuQ4FlDrPZFWh7PEkPX0SMPEVlRGu56rLr3O4HgR/HJ/HzxWNiXIdcMR1fK/
         OXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jRlc6YgmNeRIC70B/QTjydwSoj7rhSiRz+gWeFYeQyE=;
        b=hexBDsKAnxFIuEo2TkoXPKwUvu8VwUbVYab5lyrDuDKJWTY5PPxAUxeqrhOmGjQhhN
         n7C4pt+A5Pdb3ccucteR2tcy617o47hG/HtWTWtIBePOk35YqZbDgXys8Qi+WHM5c8PU
         Fa03pRUPIJUACvlDD5TOWYZNspglsp7DVZdSGICKcYkvPMiQt2DQbo/vDYHUKnXdLpIg
         MAzWVCwVaC6YoSa7GtwKSpExGVR+3KRQkj/APbzypDSKoInytPR6IGnRjavq4pnsO8QF
         jT3IGLjiB6pfh/9Fr1huCxbD+rD76+SAzNMWoaw11jaNOogRooZoCFaMEGwKE4CIZqHj
         uKRA==
X-Gm-Message-State: APjAAAUKCsTTxQXEfk2tzKjvN7DI8Xyx7G3zXfMpmRM2ESTZhfa8kNsU
        1jw5ltJYtrhzUhl66QEvCSumh9fbnXY=
X-Google-Smtp-Source: APXvYqx+2Gd12oIDBdYHn6BUiEgl5Q67XPGK4xyTIh5CnsM+yUSjrpwfBGCtToRzE7Tz711lzPGFlg==
X-Received: by 2002:a1c:f515:: with SMTP id t21mr2545461wmh.74.1568370721834;
        Fri, 13 Sep 2019 03:32:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm33276087wrg.67.2019.09.13.03.32.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:32:01 -0700 (PDT)
Message-ID: <5d7b7021.1c69fb81.9a75d.19eb@mx.google.com>
Date:   Fri, 13 Sep 2019 03:32:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192-13-g8da69d43f5d3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 0 failed,
 105 passed with 8 offline (v4.9.192-13-g8da69d43f5d3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 0 failed, 105 passed with 8 offline =
(v4.9.192-13-g8da69d43f5d3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.192-13-g8da69d43f5d3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.192-13-g8da69d43f5d3/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.192-13-g8da69d43f5d3
Git Commit: 8da69d43f5d3f7f8787117ee78cfc4060c4c0d29
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 14 builds out of 197

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
