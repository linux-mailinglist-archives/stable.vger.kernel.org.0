Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B671427F
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 23:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfEEVWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 17:22:36 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42107 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEEVWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 17:22:35 -0400
Received: by mail-wr1-f42.google.com with SMTP id l2so14737820wrb.9
        for <stable@vger.kernel.org>; Sun, 05 May 2019 14:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lLJW1Xw9e2hSY/z9IikopuHdsHFujAAxXBVFOusT/uI=;
        b=RIM67fuyeDr28LXDkKF3/tAQSmE9SHDjkrgZ+BtOq7mT216WQNdoLzQ4dRavYy0KAk
         4eLBrPUmXDbsXrS5LlpEHmiwYeBjdTi2xxj+Vo5pZ3DUX10pJrLbsk3CFdpuQT6hLpE1
         Iw1CMZIE2aD8NrECAwdNbk0G8L4Y+9MftnUX6ETol3w9Ma3zDIBqV9VV8+F7b8GxGtNU
         yBsfPRyub/tZVjOfT5B0Q5s7AnUdAuDNZqUwEg0zkD9/Cc3TI4KMySqV6VLU+PeG2l3K
         rl8cngWu0njqQapk98lxYTDnb6mtZ8QUvWzRm8QvRJMPt3tALhOpUBMxkoW2lYOFOUZS
         LtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lLJW1Xw9e2hSY/z9IikopuHdsHFujAAxXBVFOusT/uI=;
        b=OgdDX04HrnULfRfpnwBhG4DKdQa41XvwF30khNWzqXpX760OLQdiX1LuXPOx4UYw9O
         FajoDq1a3kluUJXB1ZmLkyE/2BdO8Vtxgf1q15JA3Wz/dExu/f9QjLDocC+LTgm/qp28
         vVTjZb968WWqGKO9cPddX8x5CbeaD4UwPLfDif945Yro++qh3/ndHf+XE+A2uF1vwHxo
         xe/LGld47KzX3OkE1ocHVWAr7e6rxAOoZHnpGICm6ioNTQdWbTIXDLPVbxx8x2WX1B8s
         U7HNrJYQ2ijTZRoNBJYVzRRkYbo5uthp0j2iNnBanCOBcGVoar3enrtjjiAYlhLoZy47
         86/g==
X-Gm-Message-State: APjAAAVTTqVlRq5Tr7OnxaBklgOt74jYY660TWKP18K3jHfxEbaNLklm
        sq25v4/ryeomUN9kuiNmiagKEu/SGkw=
X-Google-Smtp-Source: APXvYqweGohZpNOVLSc6Fi72MCKlmi/YANWTnokD8yGzb9ZUXWAh4a0SYd05OSsynPwC1eoq19R4Yg==
X-Received: by 2002:adf:fb4a:: with SMTP id c10mr15164329wrs.309.1557091352932;
        Sun, 05 May 2019 14:22:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v16sm9452763wru.76.2019.05.05.14.22.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:22:32 -0700 (PDT)
Message-ID: <5ccf5418.1c69fb81.7c34c.0d32@mx.google.com>
Date:   Sun, 05 May 2019 14:22:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.13-25-g98904e7fbc93
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 135 boots: 0 failed,
 133 passed with 1 offline, 1 untried/unknown (v5.0.13-25-g98904e7fbc93)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 135 boots: 0 failed, 133 passed with 1 offline,=
 1 untried/unknown (v5.0.13-25-g98904e7fbc93)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.13-25-g98904e7fbc93/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.13-25-g98904e7fbc93/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.13-25-g98904e7fbc93
Git Commit: 98904e7fbc93fdf5da442720f4363e0e3d5f601e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
