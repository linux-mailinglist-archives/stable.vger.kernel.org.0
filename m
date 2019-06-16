Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18ED64753C
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 16:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfFPOkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 10:40:03 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46755 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfFPOkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 10:40:02 -0400
Received: by mail-wr1-f42.google.com with SMTP id n4so7125222wrw.13
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 07:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wnIUpP5ksqriFcFmuhWDfhC7Kn2CqGkzmykJOkPJFJo=;
        b=i3HvWyiAgbnAOsZYgUd9G3t3ZKittA5VcIF4SgsuWOGkjCditkErhEt0bk8+5hUg2v
         /nhRGY+oeBlVMz1t+mMN1tBUCHQRbOWAKR7EVTHa2Z7ty5P9p67PpkDMkiZWatHrq4KC
         SQ3Hc/jKuSYHCOUY3SuhOKqC6f+/xl+KhL9uwYhv0uUXaTF/WGvvByr/APZWOnAGj2ez
         DzJ4jjZUvCQR6rXuHAliXjDREX8i+GYeDZOvOH8NW+snCBNZdnjsW7RZvxe2FaKbFMnS
         EyI6dtPabj6FcVdBYKNDaxeFIluOI3CM1p3XFEIDRli5xZoq5MqcqLP8EU6dL2HtHqH0
         tuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wnIUpP5ksqriFcFmuhWDfhC7Kn2CqGkzmykJOkPJFJo=;
        b=qS7RSqA+CLoU8ttyfcNZznv7ZqX5Smbn3x+JY4FcPN5GKzf5A8nrmjnBymQgetb/kU
         gRdhUVIPhfhMok4I7znfp2na0t97nKw1mRhe5kVtbijP3aRREdEFnfXwQpBTcHB13veT
         OR8c4scztKXFl2pYqUGXB4wHHxkNkSybXvFFcBN8NmdJduSPr3MSsHL9Xcq03FJWnfZX
         fFiegXFLFj7FUd4PRvGvqZJY76yXW/WcOdCPjDt6fkxNSpXSk76DYk2T8WajEuWuNfAl
         +SByedhhC1AAl3uFgYJIh1Hr6gs6KPPY5A/oe9rZRWPzw1lzXUwHTP5z+X1ZVKJDml4h
         VAYg==
X-Gm-Message-State: APjAAAXZGKlFNdxVXXNZE26GCVx57+v279FpBVJGFerjQ7SbzVhqeJ/h
        Cde1uWJlv9MJsavzwvD5pxsxsmljYC8=
X-Google-Smtp-Source: APXvYqzM7uC4/I4qgMDv31tdJzxR50bHk+nbrY7PMEh44XmCoTXLosCTAFWOnEpafB8J72cL0dAQlQ==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr10196083wrj.51.1560696000288;
        Sun, 16 Jun 2019 07:40:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 139sm10535041wmb.19.2019.06.16.07.39.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 07:39:59 -0700 (PDT)
Message-ID: <5d0654bf.1c69fb81.c6f33.7e81@mx.google.com>
Date:   Sun, 16 Jun 2019 07:39:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.181-89-g1ab361f0d5e6
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 85 boots: 0 failed,
 75 passed with 10 offline (v4.9.181-89-g1ab361f0d5e6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 85 boots: 0 failed, 75 passed with 10 offline (=
v4.9.181-89-g1ab361f0d5e6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.181-89-g1ab361f0d5e6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.181-89-g1ab361f0d5e6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.181-89-g1ab361f0d5e6
Git Commit: 1ab361f0d5e62b3870162276786c8800f577c9ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 21 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
