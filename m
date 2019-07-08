Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6151D62A34
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404066AbfGHUMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 16:12:34 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:42692 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbfGHUMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 16:12:33 -0400
Received: by mail-wr1-f51.google.com with SMTP id a10so17408038wrp.9
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 13:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=syf2dhShrL/kMYoCddf7SCM4SjTLCNMWG5Ear4/4D/Y=;
        b=kh4LUE3+Fn2tt2ETJsAz+/jFjhYZoDeNejoLxelVvXsV00bUGThxh0heYs+JEAslXp
         DI2c6h0zJUuxgxNzFTAP1ecrD98qc+LM5n3PvbAn143aBJLohU2vJoS4fUrzLrTP1jwd
         aeLDrczUdSqCmCjKQm0dZx0V1yXqammkzDbg8kpb9QA9K4Vuo+SnSiQoWx97f0JKyEgh
         YWSYfexHZhJWfRVKlye2U4VbldqwxYMZQ7i8R2R9UhwbCAOik3yI8kltAKFS7xf2M4VJ
         cYFHFyRjiOOLFd96Y71pKfDwmVsBKNnDZOPDwi8sJ4H93mGGYNefcQNMqfpmh0kgSmow
         ZH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=syf2dhShrL/kMYoCddf7SCM4SjTLCNMWG5Ear4/4D/Y=;
        b=i8pVFvla2PlALxhOrDBahufYpO65dfIjN4+Ut8J2xkj0egt38y0u/exKcdwJ37r12m
         nnbm4UQIF9BuqqiUUzAehvk90pHpd59Pv7d6SGRqTAc6FV/5Qnso1DiL/y7dJSxSLx0/
         Tuzpsx7mbzSi9UbQaJqvyeza7WVYbwg1IfwWu7rcmJGvzhIX6a3kpOkoo5IF+h7l7Tcr
         g/5u6SRvF0mnpUvfref6PLsBWCyk8nnNByfZ4o6hnvWODzUX35QTeBn385+a8QQRkQsw
         n6InvsU4PUowQixjA5uMUqnlRuA0YdY2K0hBsG1YwllCuhlvgUM1ThOAKJ/nh5TZvQFT
         N3iQ==
X-Gm-Message-State: APjAAAUnkhS+F5vbJnRN6p+x26K/jMPtAQLw5ACIfLi+GRuYY83N8vZr
        cfB/13+EJ1NaNCQNadm4Dp2V3oKN9h0mVA==
X-Google-Smtp-Source: APXvYqx6DSfREGc1pujbja07+dTFMTCheOnBaoKXuyRNQnzGdirGVx8+7NSa6ZrEKd/yuaaDF6S+9Q==
X-Received: by 2002:adf:f601:: with SMTP id t1mr115350wrp.337.1562616751791;
        Mon, 08 Jul 2019 13:12:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l9sm389340wmh.36.2019.07.08.13.12.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 13:12:31 -0700 (PDT)
Message-ID: <5d23a3af.1c69fb81.efd51.2411@mx.google.com>
Date:   Mon, 08 Jul 2019 13:12:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-97-g16964bf47d80
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 108 boots: 3 failed,
 105 passed (v5.1.16-97-g16964bf47d80)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 108 boots: 3 failed, 105 passed (v5.1.16-97-g16=
964bf47d80)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-97-g16964bf47d80/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-97-g16964bf47d80/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-97-g16964bf47d80
Git Commit: 16964bf47d80c29d28ccc8f7182bfa3e940118b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 15 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
