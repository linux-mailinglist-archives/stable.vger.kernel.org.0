Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B9151245
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgBCWQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 17:16:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37455 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBCWQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 17:16:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so20390391wru.4
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 14:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eFQxThRtHqaEG7b9qoP1K43MIggKKeg/hZ0K14G09GA=;
        b=c6UeqFhjpo3Fypz6Am0g8iG66lVfo+jbfdxMFqkart5Op1tPun3Uv35X9SyM+jZ4wo
         P9Hf3B9AIydvV9HQ0NgYtuaJhY24C6OJewjzwYcym7JlGe5wTO+DT0iLleNCqgI4y3sN
         SrXDEi6zmlt6S1TL+elneseAULlBZ/UpsFG6pOMqAaJewDtxkgiip1CemFtw/j6sPx+Y
         LqVnzDVhC+/0sVN/eSOaTNtP7T8h//QpCe2pYy8Z9+LjqEBfaFjnjJrnsFrTalkzoHT1
         MP8zeCz1fykYq3/jOQYM7RyB+Lxda7El/2cZfNCicxoihjkQ0Qvr8/TNzINKmWWgXWXr
         vDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eFQxThRtHqaEG7b9qoP1K43MIggKKeg/hZ0K14G09GA=;
        b=ZQ3xEjekC6ijCI1YBoc1D5vl5rngNyAQ6FPPD611roFqhiTS3J/pl3zct6V5C/5DlH
         h75ce3Ika2OMVEQzaZUwIq8BfBiCp+9EhP24t63eGVxco6pD5VfC8Z34EKgzY3bG2UGT
         fVbZiz1NxBG8gVp1ok04lOupxP800NrhsmFgxT/OBGJ8JPNHQ72DeWaSkQ8Vx3QmhLjA
         xqY417rL2GCSkN9AcWcXuxZvOxZ5FuN3J5hX2xdGskzjrfSuX1co2vrYg3375vrJnSa0
         p9pZiiSR4hEHy7UAFbDjSEXZnqB5pszdA7UaPuo48LlkCAvGYotKfK3NHsPYXrU0XVf8
         ScQA==
X-Gm-Message-State: APjAAAWMWr5j5nPCbcRcuckacNmzCv3YyD4a9Pn+eRW5aGjhz5UzCndw
        +Hm45JLgyeoLbz7t5k1g6zONhlC2wH/1Qw==
X-Google-Smtp-Source: APXvYqzrQsbo/pKmi5gkVeNfsXRPba13B/G6RpsDl11EdN//s//1Wu5k+1zBxuZb+EgbG5c3D+yh9Q==
X-Received: by 2002:adf:f20b:: with SMTP id p11mr16644449wro.195.1580768183037;
        Mon, 03 Feb 2020 14:16:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b10sm27789977wrt.90.2020.02.03.14.16.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 14:16:22 -0800 (PST)
Message-ID: <5e389bb6.1c69fb81.c6251.a166@mx.google.com>
Date:   Mon, 03 Feb 2020 14:16:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.212-69-g056575131d28
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 49 boots: 1 failed,
 46 passed with 2 offline (v4.9.212-69-g056575131d28)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 49 boots: 1 failed, 46 passed with 2 offline (v=
4.9.212-69-g056575131d28)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.212-69-g056575131d28/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.212-69-g056575131d28/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.212-69-g056575131d28
Git Commit: 056575131d284c9c9bc6b3d5823fb3668b44cd47
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 15 SoC families, 15 builds out of 156

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
