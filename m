Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694385C639
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 02:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGBAJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 20:09:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42120 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBAJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 20:09:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so15635732wrl.9
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 17:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t6fIGuN7B62Tpnmq5BywD/f3RcTkG+SvFM2tOCRDauM=;
        b=lrwKFluxvJd3Jh+4nRu5UxJgoX9HZqBktZDhRRaf2UFpTyNht14SQITV2OiYEvpnXf
         NLiWnRaX+gZ+2TUMv1vNQM4LZOkH87A32yPQcg8MNsgKrcTWZzEpat2JSLxe2Qj9brU9
         XEZRb8YpuhkAMqjAlHyCMh6ln6lAStyWv5YC1xJ8HyynzX54GZ1mUru/tufbuJj4fOEe
         IBh7jgbYS98Zc6HJ9uZqoiMJvqpviXAX5CO3aOVXTvb/RhZekb+2LxtiVm8YOVSU6lla
         8va73m7uC9pUx8lRFOrcUU6OPVjJzayB6HbaJ4KUo4a7LFiAdvnpF9RDxgXG8MnYRGas
         j/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t6fIGuN7B62Tpnmq5BywD/f3RcTkG+SvFM2tOCRDauM=;
        b=AP7vNkfGw5va1KV9tvI5kCbixR68PjxPQVPEame5IoMTqgyK4WVkYCNPvnV/2m941r
         aElJG292MNBA4uv2gCop6Wd40nRW+aihLMeXcrdQ4BEc1/cfh4rZ2usH/qGSfPvB7Pfq
         S5BF2xywbPmXzeOtfvSSalXRc63BLVkg86BdmhmXlp8IY8MUDkRuk0BqcNxnqh3hRoUg
         ElXD95VNT1rxu+4tPxoXUIB8iTBI1X5mxC5WJfJatWvyHc+8OsaLes4OJ0gGNnomLiFb
         g3UlsmoWumGrCSRnBfMYZIrh62yCUOotB+UeTqQ/1+SBdr2kt2DKfWoduFHlMYwzSdWS
         DDJg==
X-Gm-Message-State: APjAAAUMViS2znZW3bjzfkhMbzy6nDp4enTabX1xyv0Cbhwnar9oIh/t
        Mk/Kr6IA6wujhrqXYSdCtuUXnNHEdRjFXw==
X-Google-Smtp-Source: APXvYqy8YtYDpq6VoRyW9o5mUcqL+8ft2CRU+6erL27haHOJMp7p+i5h8JExwgLqRntu9pmN9Y3W+w==
X-Received: by 2002:a5d:5607:: with SMTP id l7mr22029347wrv.228.1562026191167;
        Mon, 01 Jul 2019 17:09:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t15sm10847977wrx.84.2019.07.01.17.09.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 17:09:50 -0700 (PDT)
Message-ID: <5d1aa0ce.1c69fb81.b5874.00cd@mx.google.com>
Date:   Mon, 01 Jul 2019 17:09:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.131-27-gaedf6f1832d9
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 128 boots: 3 failed,
 124 passed with 1 offline (v4.14.131-27-gaedf6f1832d9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 3 failed, 124 passed with 1 offline=
 (v4.14.131-27-gaedf6f1832d9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.131-27-gaedf6f1832d9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.131-27-gaedf6f1832d9/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.131-27-gaedf6f1832d9
Git Commit: aedf6f1832d918db6c3652feda74206aac56c1e5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
