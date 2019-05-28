Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B5B2D025
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 22:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfE1UQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 16:16:18 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43790 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfE1UQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 16:16:17 -0400
Received: by mail-wr1-f52.google.com with SMTP id l17so29191wrm.10
        for <stable@vger.kernel.org>; Tue, 28 May 2019 13:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n+eYYE3Frv/+gKQLU14/4/8y4Q8ZrR0YYhE3KjrSGZM=;
        b=b8DEFsmVFn6UL9KclmTXXrKJtxnQOi8iBKGSwRxVzOVuBP6say2zIZwrnq3nWE3LXa
         gpTH0v+29N5s1zVHQY1bWH9oW79qyNWYDF1FsarXSSfpUPTyaMY4gio3smabjasvCXjc
         nTMwzhBpfeEJ6pmmSZvDhUrktWGdOZFemFnWZDVgdL1++CJgE2nByjBVumvkT1UfOM9P
         Oeny4uP2dsdbruPtlT/Be0AFDIr5LGXEUFkCIDO31UDgzzZHDMqvRzOtegY/1VJVnGnl
         qbtzmUifmYw/ZNkqrrQeE3tyMQAasrQBgSxL3Oe3QeNufr/ZuJVEMnIvzdswY5ik+ypR
         /d1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n+eYYE3Frv/+gKQLU14/4/8y4Q8ZrR0YYhE3KjrSGZM=;
        b=spPfgmYeNRVKbtKaYX5s1v1TtXVDFi3t4NR3uJEOot9GWcO51UcCBgwAbt/yAGHZ+L
         hJpMRnuoo85+Ow9a7tTdY86Va9KBBlnYEDkgb9rZWIOgTtXHtOdMEVPq0fZnU0Iqqvc2
         G7+bptAFoimX6XV5JqQdkZSQcNm5xNHEjFfOo36H0V7kA5bQlz6L5RXmGzGA42W55UpJ
         PJ8br4eOekaXDEI2rLwxNGsarxHwbdsSSpYH2+7R+lKkvh/HWaA8OaxaKh8aAS8h6DHA
         LxGo37xC8k/aPC5nKR8CHWFjpc9NDuv5mDQ7G/f4NSpg/qq+IdlP28s+VK6aQ18ephTN
         +hmg==
X-Gm-Message-State: APjAAAUkAsAJpBCJHVdlL+zZ5cnJmg5YLaFcOaJNiF3czdMfpGJKOYR+
        g45cLK/DqsfO/8GYR3MNCuv2WX6Uw2Dgeg==
X-Google-Smtp-Source: APXvYqz+Hw7FErK6yyu8tm5aNY05Ps/idxUKoYaVv+F4bb6OvnaMwoPRoXfCfyQ00qMM4tMO7dzrwQ==
X-Received: by 2002:a5d:6108:: with SMTP id v8mr23888091wrt.150.1559074576177;
        Tue, 28 May 2019 13:16:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i32sm9216102wri.23.2019.05.28.13.16.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 13:16:15 -0700 (PDT)
Message-ID: <5ced970f.1c69fb81.fee0f.3a29@mx.google.com>
Date:   Tue, 28 May 2019 13:16:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122-26-g12045d2235c0
Subject: stable-rc/linux-4.14.y boot: 120 boots: 0 failed,
 115 passed with 5 offline (v4.14.122-26-g12045d2235c0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 0 failed, 115 passed with 5 offline=
 (v4.14.122-26-g12045d2235c0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.122-26-g12045d2235c0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.122-26-g12045d2235c0/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.122-26-g12045d2235c0
Git Commit: 12045d2235c089e819b8cf113176afabdd39e61d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
