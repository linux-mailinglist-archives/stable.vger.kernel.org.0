Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A17225E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 00:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbfGWW0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 18:26:11 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:40927 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfGWW0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 18:26:11 -0400
Received: by mail-wm1-f43.google.com with SMTP id v19so39825010wmj.5
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 15:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hhRDfDHxQQmqTqsi/pM3TOc6Zyt4OH4A9EdyWMwhlo8=;
        b=TP3YG9Vr7uZUMGHVcrn1i70dDu9fFOfNSBrlsjAyv0UxgwTAinykB3lf5lX8Dght2v
         khgaDMc4L62yldFegkX7uS+Kkvsh1eJAbk8O3cXNdt3HzCSCAo0qs6BgF2+JAiW/2xSR
         UMz9f63zRwrz4UwYMyWRKApHdA++jApPR5d7gc/FxYK8kTN7bbzpAdPg/s5l0qhj7WVm
         SN8MOJmdqwNTHtsj5Wxjm9j8NfQN70uxd1n3DpeRUeTjv9iRw3lofBdaHk9RlNhBs2ie
         6sOFTplBppujM9Nbx9qa2RHmZX9LcRWCMm9Cy0pD8gfMTqIJtqRtlx/RXA0tZSljJTRZ
         uODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hhRDfDHxQQmqTqsi/pM3TOc6Zyt4OH4A9EdyWMwhlo8=;
        b=br/U/Zf4d4bzLbzbiBYHHZKE7AXeCjUcPwtQ8PycmiZu5W64jCcfMcjM1vR7cjvUu2
         nLHQpX2T5vyo/5/RrC51mjmGq1IFiLyQqCriNX6kX4peYjfe9oT970S8cG4lNagR/DOa
         yfliZJ0TCl+QaUNKTt2dXVky1fX3N/AmJPKlwEsERx9T38OcLY1nUWxJn/utq93Aa3Jh
         tjXHjKRne0MofFWob7pCcuSBt7ioo4km8XoTu3nYH/wN9r9g9jDD3wu5kUde2aWWRcwy
         Tx47F1ue9qMT2ewIICOJHAXi1/1RwUbtdZNrr1zZj4wS6W55WjkLieH63Kh/VjzB5Woe
         mrpw==
X-Gm-Message-State: APjAAAUdqiKJvGBeMLFN3p96e9pi/UVGiMizQu1CjuLEY3F8KlLW4dDf
        vkTvfVf+nO2T+gq4J85TU5NVf3ohJlY=
X-Google-Smtp-Source: APXvYqxQR66iyXb4oJ5B79DT2cM98Tdrq6z65K0MGqgCaYTJwJaPM/fIKMc0WjobAO3+niqWtmM+ng==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr72599633wmb.129.1563920769346;
        Tue, 23 Jul 2019 15:26:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c1sm93999936wrh.1.2019.07.23.15.26.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:26:08 -0700 (PDT)
Message-ID: <5d378980.1c69fb81.f6d50.7c8f@mx.google.com>
Date:   Tue, 23 Jul 2019 15:26:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.19-346-ge63e6fbad916
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 97 boots: 1 failed,
 96 passed (v5.1.19-346-ge63e6fbad916)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 97 boots: 1 failed, 96 passed (v5.1.19-346-ge63=
e6fbad916)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.19-346-ge63e6fbad916/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.19-346-ge63e6fbad916/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.19-346-ge63e6fbad916
Git Commit: e63e6fbad91689d2cd7d7e69f781bd2c9e9aa3fc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 23 SoC families, 16 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
