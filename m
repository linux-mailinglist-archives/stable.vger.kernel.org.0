Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB23ACB493
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 08:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfJDGt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 02:49:59 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:45768 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbfJDGt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 02:49:59 -0400
Received: by mail-wr1-f42.google.com with SMTP id r5so5586177wrm.12
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 23:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jc/WrDTffdzMOLmQCIoEtNdtkjgf6yNFeVahnwheomA=;
        b=R6n68Nfs1LD8l/lX8N1wo90RIahDYdq18ue3eOU/Wu49D8Ti9P+nkEC4HU5jPeg2IR
         paULsuFC6zvYREt5LZvQkNxbd7B6IBZH/LIMAjXRUnh47/OBI7Gg/RW2MoCpC89N0L3t
         yyRjXwlX5WCJP8KgTwo+cFNR3gDt0eOsg9H2qRRfbdsbyfGUpkSMuglvfStmzK6UZtwq
         J6lnBLROFDxX4mWK5yMKpUALB7tnGjPBZ5K5fDUashlbfMtjlLfen8mkpDu99KU0rzki
         AZgiLToNfh4v1n8aic/8LN8rBon/Oou6sCvCVC8Cd121xcIUfgiZ6DD+f/AlSNLaFNJj
         1eBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jc/WrDTffdzMOLmQCIoEtNdtkjgf6yNFeVahnwheomA=;
        b=tV5wTWs59aVtw/D66e4jljpcEhXlpO88HEEf+6eLkk3zWqwVcU9ORKhl4Qt5de8ugA
         In3Rw4AoTi+rYaavqOADmJB88ur8SZ0AZOAsFHUyjumje+Nyp4Plh8srD99JL87WnDOX
         BAa0XRV4AZ6n2oeKYIjq6lmNP0LO7yulo41pd4LDhEJO9tMoQTsR2HtPwPJ30q09/7OJ
         bSZ+JU72y0CqucbZZkprPEJGJQndGGb1U6ctbjgOlYCkDKnD0uH0Ww7wGFmG4ooQuvLo
         2JPZE9dxnlW/gtfYGXyyN11gwCixtTxrB3SSxF4AaeAklKdSZKd04pXxdKOsI1v2XoeS
         WfBA==
X-Gm-Message-State: APjAAAVbaNrgVGAuzbVMpnACyRdwr4Qhv1S4UKhqonw4vlMC4kXOSdoL
        mVa/E5kwYalFzV2ldQhcJJTX+eLMf7xs/Q==
X-Google-Smtp-Source: APXvYqyuzuM/XGt6x3h8gD7XwIQQNVUs7z4KgROhaydR89mOdyxy0tgO8p5kMrZPGB4LwCdaBOhVZQ==
X-Received: by 2002:a5d:5052:: with SMTP id h18mr9799726wrt.397.1570171796992;
        Thu, 03 Oct 2019 23:49:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j1sm12340866wrg.24.2019.10.03.23.49.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 23:49:56 -0700 (PDT)
Message-ID: <5d96eb94.1c69fb81.d1a5f.8889@mx.google.com>
Date:   Thu, 03 Oct 2019 23:49:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.194-130-gc1fc11455620
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 99 boots: 0 failed,
 86 passed with 13 offline (v4.9.194-130-gc1fc11455620)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 99 boots: 0 failed, 86 passed with 13 offline (=
v4.9.194-130-gc1fc11455620)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-130-gc1fc11455620/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-130-gc1fc11455620/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-130-gc1fc11455620
Git Commit: c1fc114556201dc059e2c202e99eac038af8495e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 20 SoC families, 13 builds out of 197

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
