Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5781E21D50
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 20:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfEQSbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 14:31:13 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35819 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEQSbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 14:31:13 -0400
Received: by mail-wr1-f45.google.com with SMTP id m3so7961637wrv.2
        for <stable@vger.kernel.org>; Fri, 17 May 2019 11:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WJWB2U/Z7OfMzE5ZRNIMzJsODZiNjQ+AfJ0TWGBCA8U=;
        b=mZLOhgKfK/vQPk/4vBSlLeAOLFFFi0mymXnI7m8mgeH7wqFj/SnDP3s2QRapUgPDlC
         eb5025f//s421nX+wOwyKZKStMM5c7VU380dnAcWlApwwBxVTz4Dtkjp9tlmmG0mJqyU
         /yWZCEDQAh/nqw/lD1T5op7sSgDFBJBShIPLFd4kVDMM8uRoWFhoNsYMhuUCiFwlJQhL
         9ylapDuMJTuF3ThdDzqQUvId5kOQtKwRtkPgV3PBC0+OVq5CtlJnMc10a8wMZpMMR2um
         4Dh8IuIpqX/kqJgasLFXf3iTZHJLbJN3E9RxGsUEfDKe8oUj41RofX5XpwdGKrkwHA33
         s+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WJWB2U/Z7OfMzE5ZRNIMzJsODZiNjQ+AfJ0TWGBCA8U=;
        b=WD7kv3XP8PNeOiaDOLx/U+ptTqohwihy+Z0I/PLIsTcbjRsPd3O3unLxz2sbLtnV7M
         HvOdjGKA222chZA607ZIX1YWdx/IcpQfdz8PPaG42eca03RST+8kd7UFL3B29Q3kvgan
         y1ktelIPYdSWmT3Ugd8x3geKdPOQgJVfEiWcY8IJfIiIFq/XR4ITwwVBpuyy5A/rTlm7
         JTG5EKQ+t8netcUs0sRh6MJ1QAirKO2/VOHgMjUmDY8y9gZ6g6KZgvudfPrg0LQD3CRR
         A7VvdXcmjV4/PnGa3679J/LW7GKMiCSz0UJU9MH82Wl9S9NgBMztbFC5QwaIxNEsBTGn
         9Q8g==
X-Gm-Message-State: APjAAAUnCZG4bulzY70YMznTwuVLPknfD/sa+cVbaALRTsyP6W20kUbk
        jdjXp74xIbUtyrNIhU12T1mok6M/hga7fg==
X-Google-Smtp-Source: APXvYqzJ5U+PasGZSnlXZqnSe2UScROlC2iEgRpe1YiL4N0vgW9hyRiwySGGS6XLRxfVcsQO84WKqg==
X-Received: by 2002:adf:dc4a:: with SMTP id m10mr34983243wrj.0.1558117871440;
        Fri, 17 May 2019 11:31:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t13sm16587799wra.81.2019.05.17.11.31.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 11:31:10 -0700 (PDT)
Message-ID: <5cdefdee.1c69fb81.e2b31.fb7d@mx.google.com>
Date:   Fri, 17 May 2019 11:31:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.3
Subject: stable-rc/linux-5.1.y boot: 137 boots: 1 failed,
 134 passed with 1 offline, 1 conflict (v5.1.3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 137 boots: 1 failed, 134 passed with 1 offline,=
 1 conflict (v5.1.3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.3/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.3
Git Commit: 7cb9c5d341b95274b4f1fccfc5db122f945f6730
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 24 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
