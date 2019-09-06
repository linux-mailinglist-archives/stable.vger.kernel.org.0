Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2621AABAC6
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 16:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbfIFOXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 10:23:11 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:46615 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732899AbfIFOXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 10:23:11 -0400
Received: by mail-wr1-f52.google.com with SMTP id h7so6797623wrt.13
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 07:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tCJkBUVlOAw9acKSW6n8LxWh2sSaYX9GZN6E2JbpXQs=;
        b=AIvGVkgm5+LbkXFPey5jekMOYB3kblHjMTdXdpiqjOijAU+EpCPH8FbrczOoJXT23a
         ma5cwz+N0TooE13135HvG6qa+IjevqPaVpzNTRPcHYYHOo4ak/wbMZNJaVRO3UuUOqVo
         LH6w2ozzbbTmx+LHI+dEvZKn8GG700zwplvvfikPqaoDgeV9TUOhL3VNiYRLKhXDNMbG
         KN6Q2EOpTxvGQ7W023UWPQsHQhpGj5pN2njaK5CZwhZPlbubUqASwtMLAaSdKbiAsx9m
         4GGQMlUh/mRiwkxQQYhcLAKRwnq3wNv2CpcRlPqMVJnXisWcGDRc0ngt349nfAzqT1yZ
         A0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tCJkBUVlOAw9acKSW6n8LxWh2sSaYX9GZN6E2JbpXQs=;
        b=aqSSpIs4EjIWxdUbDh0twGKiy+rwpRfZ9JGtXpEaWonb79L6IPniL/a12FW6sRmgyo
         +PBrbV+ISnLanBUFbi65LGfsrhDrS+YgXewxSVNLBPIBd5uSyTnd2TQFhW7rSQRfva8U
         P2/ZxhSc/ObeGRsv8MY9e9ljcEiddH1ISuxjeCSY74fqcKsIZFjTvvwg0X2UEkJQ5qpJ
         LWO7B75DVoogUiLqek8bl96T6wSIBGN+0pKaM/5k+GrS3e4Y+igRb2KBG/siJA/XF/kd
         gr0FQCeK0sKdQRSKENlCrBfT4DJ0m1t8+0r/HjQwqeNY1WlM7UVaI40dd+Rh/X1Iqxoe
         7yWA==
X-Gm-Message-State: APjAAAXhiw9Givw8j9F3OkEDEuAriOhSmtcVWtucGp9KlpsiAKgjgVJl
        5TKkDXw4iY+1G2PgDGhBANYaGcLK844xIA==
X-Google-Smtp-Source: APXvYqw8/ODCRVj48cQa34OTqKbVrbEa7nagsQdyoIjAmTO8Rqo/jwgPUfif54FCvovHLnqrlbNwOw==
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr7152908wrx.156.1567779788730;
        Fri, 06 Sep 2019 07:23:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y13sm10426449wrg.8.2019.09.06.07.23.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:23:08 -0700 (PDT)
Message-ID: <5d726bcc.1c69fb81.7c68.3a2e@mx.google.com>
Date:   Fri, 06 Sep 2019 07:23:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.70
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 99 boots: 5 failed, 94 passed (v4.19.70)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 99 boots: 5 failed, 94 passed (v4.19.70)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.70/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.70/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.70
Git Commit: 0fed55c248d98e70dd74f0942f64a139ba07f75d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

---
For more info write to <info@kernelci.org>
