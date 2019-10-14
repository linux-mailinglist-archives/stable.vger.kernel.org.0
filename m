Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90EDDD617F
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 13:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfJNLkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 07:40:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54593 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbfJNLkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 07:40:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so16911144wmp.4
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 04:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/ZAzpFF94MFcOM1A7xHHwbwXE5Q5ThtJyyTHhlam+YM=;
        b=c7APC/eX4DPgYFSVnExK6+xD4SMELE/gLmua1fwy5UyQloUqpyI9xWZY5epKbZMnMd
         8tPOLzKiRYn5GBRq2PlYQmxRyw93ztvssIs+2JOf+YlOiVC+rDpkrSPhLq7h6Gw6J5bS
         KMguGW5+ymZ2iJnfWsz/u3R7u5AngXRbFgucqcP1j3OfE14qU3w3qvkBD6zCvHzplFB/
         +VDeQLnoXb5ReuRQ0F1PIizfT92FwrOQj4M5skZW33Sqi+K2RB9Yf2GnuNYvxnlr59mT
         xKJv8ndoSgw4HkurusF3aoLr1X2zSiMJMEPapk0jty+AZBtGYOvLq0igkkjNZrIua3YT
         nk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/ZAzpFF94MFcOM1A7xHHwbwXE5Q5ThtJyyTHhlam+YM=;
        b=HhZ54C5iUdK2iDMTsKA892v3xQdQvoU+eKb1+zlX3grRj5R7KwHxWiWt3CkUBLOZi1
         tdfpVPHSTH/UjuZ1Gn/9H2FLHyMRdydD37WQSBIP8B97OZmvsuc1gMkbHL0RI/H7V1xF
         uoKRPWVoJBfBryUdPO3npyrkq+PNMVqeouRPveBTOzrtr37MdXqlACntKiUJ7JzpTia9
         jVUWdPGGniNvrXuRak8dF17Pf+kdG49bpQ7MYQe9W/sDuM3wnfWwHKmT3cztBtPusrIr
         3atjde9PvHWaJTf/DLyJS5FoFVhIL8mlM1qGzfLnPwd9rja25fEBg1ch0KPwuVtkUv6+
         nk+g==
X-Gm-Message-State: APjAAAVl5iTlZmGZuky/nU/MWz/d18P3xIMExsO4oTPyLs7UBeHvqxZK
        9Dm/p55fmkLFO4LAdwkJx/n7DuUTkJQ=
X-Google-Smtp-Source: APXvYqxJomMTw4m7//qiDV778TKQHqjIWlgPVUIzgPGwYhzMbkJmshnD7TAeFLB2KbNoMB472J4G5Q==
X-Received: by 2002:a1c:f011:: with SMTP id a17mr14242928wmb.18.1571053229443;
        Mon, 14 Oct 2019 04:40:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h125sm25092933wmf.31.2019.10.14.04.40.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 04:40:29 -0700 (PDT)
Message-ID: <5da45ead.1c69fb81.5a1eb.5c73@mx.google.com>
Date:   Mon, 14 Oct 2019 04:40:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.6
Subject: stable-rc/linux-5.3.y boot: 138 boots: 1 failed,
 128 passed with 9 offline (v5.3.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 138 boots: 1 failed, 128 passed with 9 offline =
(v5.3.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.6/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.6
Git Commit: a2fc8ee6676067f27d2f5c6e4d512adff3d9938c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 87 unique boards, 26 SoC families, 17 builds out of 208

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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

---
For more info write to <info@kernelci.org>
