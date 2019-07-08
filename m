Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3D62B3F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 23:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405073AbfGHVzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 17:55:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44330 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732609AbfGHVzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 17:55:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so7570956wrf.11
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 14:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KbxPURZMEHnoY5kCiOtKwk7nv1oGJVS8a+BqCrWOMLQ=;
        b=iVQWRVkJS5M2y6p+8J7LbCX88vewo6rM1nIOG8Vf3EjgdoOL1HdlxLN7VY15MADWn3
         DQJ/2w05E7T5vCK56naJGD5mVhYKne919PMUjuuxFEGEREGkLyxpqKBHFm/aUDczGpe+
         qJ8W/NQxGy/1yo3W/nMneYGHRmV895zAaYUjjHxbykXxPY/chA32J1GEwRik3Qxx8UyF
         elQdfIBbYtf0PAKTpYWET/jfVjrLDnvEABDriUsl1bDgCHGgKfj2lkzKMr9/xqzXemzS
         dRrT2TaxRKyWrsVC+T69gnkPDlxfvsuztYwT3EAzvlCn11KOXTsjT9fV8o+Cff7C3gm6
         QfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KbxPURZMEHnoY5kCiOtKwk7nv1oGJVS8a+BqCrWOMLQ=;
        b=J2csmy7bevifaKi9WhkuNW05GE4wfJgZuyrU5Wbi6RSGe9uN/l/mLAPdw4NVG6ft+5
         dzokxqlAtfY4HkuxaETif2LepzmwL9rdneOd5SvauM07e5ATm/o269nCzVyTVntR+epF
         U+dvhq/4BEVS18vEFAmM9af/l+Z/scu5Z91iJgTDQxVtdh3/NOqc6kBZNkbndE0ngJHM
         OQ3yU6Pm6GpbDARKIxPImiDRvidd2ALcGzHc76+i3HDxRAqY9rAf3j8l1lw2xxWMvjBK
         OjXqE+ii8l+XugLIdx6YMadiOCWHsl/ZZ9RM/JLx7wvUOYQfWw7B2kd1BXsN/nlpDYou
         mv0w==
X-Gm-Message-State: APjAAAXoNtg+euMbC2+AFnHTx4kT19IL4S+npDvJhF6rN3sWzkiptUTz
        aQ9MauYlV8j+twaOfnyCF4T+kkpWUglFYg==
X-Google-Smtp-Source: APXvYqxBKY9JD8hAVNVPZecWUNNwXg8LIp/BCWbyl5yrsuSchEbYyR29Lz58Jc/IpZx0hTRYToQwzQ==
X-Received: by 2002:adf:f792:: with SMTP id q18mr19126051wrp.161.1562622933643;
        Mon, 08 Jul 2019 14:55:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e3sm14353020wrs.37.2019.07.08.14.55.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 14:55:33 -0700 (PDT)
Message-ID: <5d23bbd5.1c69fb81.d56d6.1a42@mx.google.com>
Date:   Mon, 08 Jul 2019 14:55:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.132-57-g5c87156a66f2
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 105 boots: 4 failed,
 101 passed (v4.14.132-57-g5c87156a66f2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 105 boots: 4 failed, 101 passed (v4.14.132-57-=
g5c87156a66f2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.132-57-g5c87156a66f2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.132-57-g5c87156a66f2/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.132-57-g5c87156a66f2
Git Commit: 5c87156a66f25c493e12b023972fc2ccae813204
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 24 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
