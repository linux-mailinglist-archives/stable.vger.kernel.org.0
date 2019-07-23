Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9323722B3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 00:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfGWW7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 18:59:16 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:35986 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbfGWW7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 18:59:16 -0400
Received: by mail-wr1-f43.google.com with SMTP id n4so44895471wrs.3
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 15:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mo1LWihnzBg5ER5fghcMETwraWQbrcbCV9rgqbhaQVI=;
        b=Qf01Li8dXHMJy7LyWGFpS5rrAfHt1/S4fRvp+D9WqDjvIPtxabPpyorTmHTDM17Oyx
         1Pcb4bPS6ph13z+OQmBz8ZQgcO8MYhLmuOy6QIuxbOUxaoEKknA2fh7C9Ri0PeQVH3i/
         SBmlRN/asDELcG0lGUPqWObkCypCI0JELlfzHfPztW314CWTLlJp2YtHLn0V/YkTPMhR
         yh02zeX5Y2VkyVaEGRwE7bt4I8YgyQJrQHykrrXTJK156Ub6tnikGHQh00d6SjJykiBW
         QphJUHqOPwvzpBdJJjx/w7G6uJIjeNamX2PErgmfT/WB6cXklIete75DDHpGsDjkQjcA
         9Pmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mo1LWihnzBg5ER5fghcMETwraWQbrcbCV9rgqbhaQVI=;
        b=Xik57Ow0Y/eqnhVD7Bsn3dY8q7M99FJqtIbtuRBBrkZs0zyqFSyXYCBGSutahiccB5
         y/nqtcyffzheQP1MKJ3xeg5cJRpggPgq+szXyA2SRNVkAJr4X4dRt/Ihkqawg2+2c+cv
         svscP7BZGiuyOztS6VcrhK27ldK2qCyvlzco2ZibCPJXNQw5g4pjQGuO9PSSkU7m17P+
         sDE4VYo3Y5so8iiwf9sqMsYXegcFJqR2mkzMnSOkBA31Hbs93sAHijLRuRAdZPDUnBvY
         NedToL3bEQ1MdooK2ChXQidHeNaw6AsB+wwHeH0WzUlYXSo8ZBRsga/9D8Uoo+gaMK29
         M2gA==
X-Gm-Message-State: APjAAAU9K2t71GrdJdRRych8K4urunBzO++vGlGye+xZMu6nubEzYeOd
        YO3hx8QBfxuQ9H/Cceh7P+tdFSeey7g=
X-Google-Smtp-Source: APXvYqzDcRVSPu4PLLHIUSh9zvR7qel8pplRxXPzcPTmA+P3yYXv8A19vvGAubB6UdOY4NXBHdqXgQ==
X-Received: by 2002:a5d:5348:: with SMTP id t8mr8126810wrv.159.1563922753782;
        Tue, 23 Jul 2019 15:59:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p12sm33795261wrt.13.2019.07.23.15.59.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:59:12 -0700 (PDT)
Message-ID: <5d379140.1c69fb81.3c153.66f8@mx.google.com>
Date:   Tue, 23 Jul 2019 15:59:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.2-383-g6532b0737593
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 133 boots: 2 failed,
 130 passed with 1 offline (v5.2.2-383-g6532b0737593)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 133 boots: 2 failed, 130 passed with 1 offline =
(v5.2.2-383-g6532b0737593)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.2-383-g6532b0737593/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.2-383-g6532b0737593/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.2-383-g6532b0737593
Git Commit: 6532b0737593f98257e72eb1f94abfd35473791a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 28 SoC families, 17 builds out of 209

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
