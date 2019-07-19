Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7936E9EC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfGSRRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 13:17:20 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42301 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfGSRRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 13:17:20 -0400
Received: by mail-wr1-f43.google.com with SMTP id x1so17986975wrr.9
        for <stable@vger.kernel.org>; Fri, 19 Jul 2019 10:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HbloDMykWMJg5GWsUcNK25kqerTy7WxyP9EHxQarjPs=;
        b=bjsLQEImzE/ZjPzR6zzc4wUkFwZ49GwRZtXv9gvne2n139pLX2ebtTBTGzrxae6ccw
         zCdoU/n+/2swADMcbB+oxBBP2/IDCYppHstks3xawNXcAeU6TZEBh/E3YhbZTRGwp99M
         U0XmFbfhuTdHnpC7lWVVSXhb23Uv3cQVA+MxO8dNuPJZWD+LakC5CRGr48zsZFlx5QTp
         OmzXk1jX2+kxnJTfQQNp2XsaEjZZHFDonGIs8aQUlaloVlM2eTXYAIiEdJs5QXhFI9j2
         cxEIBqYlavke4nu6o6qauUeZpDwjDytGkKeRy2NCIEHX+G5xH3Nz1OB9pElGXphBhCAh
         UB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HbloDMykWMJg5GWsUcNK25kqerTy7WxyP9EHxQarjPs=;
        b=P6WzRaV6h+7Q5ZM4g0aSn1eqwg/Pij5+7IF8jW/7tZiMEODsoBYGB6sHwAgAhN/AaZ
         ktH3+eNhPzddlhgTuIyka4fLR6nDzuKD5l7GPfpvQ+6j9bmbtcWi42qQ+uZIxIqGzgOm
         yJL4sfNQX4EUwmpbqPeTfM3hkews+syea2rGy+VkhuMGYRL6kW9MqK2Siylo3N2PeF+A
         4mhGwu34awH+GK7mN1kJgFTbhB8VF0NsU0hN5FqNjygoQ6B7L91DnjEznBdYQGuh3OPB
         m27al5Ghm8H1VDjXXc6nbzSVR1Zqve22p+7gultCF9Pl6Ar0z6E+DYUMvnkx7eXj7g44
         5Jcg==
X-Gm-Message-State: APjAAAV1lFaXb2ypzO0/Y+5I0017j10Xifjz8WLlI5NgFcqcrScjIlMB
        iu7Bs0xDQQegKyVW3nSUmsRO4npnHbk=
X-Google-Smtp-Source: APXvYqy0V8tlAYCQ5N/tkC6o4nl5p2A8dR5Nhmf4JpMxAv1GEWwCT2hy/pc0h5jyA4EZxEfM4Cl0hQ==
X-Received: by 2002:a5d:4212:: with SMTP id n18mr55720285wrq.261.1563556637850;
        Fri, 19 Jul 2019 10:17:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm38791850wmf.8.2019.07.19.10.17.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:17:16 -0700 (PDT)
Message-ID: <5d31fb1c.1c69fb81.85fd7.e582@mx.google.com>
Date:   Fri, 19 Jul 2019 10:17:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.1-22-gcc78552c7d92
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 135 boots: 0 failed,
 134 passed with 1 offline (v5.2.1-22-gcc78552c7d92)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 135 boots: 0 failed, 134 passed with 1 offline =
(v5.2.1-22-gcc78552c7d92)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.1-22-gcc78552c7d92/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.1-22-gcc78552c7d92/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.1-22-gcc78552c7d92
Git Commit: cc78552c7d92a2d16d8fba672a91499028fca830
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 28 SoC families, 17 builds out of 209

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
