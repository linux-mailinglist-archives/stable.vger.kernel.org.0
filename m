Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF5EC462E
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 05:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfJBD3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 23:29:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39783 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfJBD3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 23:29:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id v17so5263821wml.4
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 20:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eNIrfJnQrPIqtBLRdRWoV0D2z51bXG30nQ2AElFFYwc=;
        b=tIttB1eVU9X66LRLWWpHU0f6IwduuH6264gVnDyqQfEr2IVWw3Zh/QhuLWVJuGwA2z
         xKy+hjGwXfsFVyjlwExcvmtSDFrETGkUmQIBGHoC53tAMt8d7e4ZZnTViCU/Pob8Z9ir
         9nfv4hqdKxEUPwFwtJbyqop1Vdb+MY9RYjqaGs4a9+qPO73edsabq+rUMQZIUUKaLYAS
         0/Gpwg1Zap+9FzRcglN9Gh0Dl22c93a/2HR3iBUReYpA5/hb04Dd02nlwyPBcKfPzQSS
         5LajPeWZLA6tb10rku+T3U49LXu726J1q1wglgtxGP2+iijqgRMMv0/39rT1Osy/JPgl
         fgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eNIrfJnQrPIqtBLRdRWoV0D2z51bXG30nQ2AElFFYwc=;
        b=Uz94y8digbGz0yIKT24q6052JvG8ohPUhj18VP38MROaFUdqxFOUa991UHrvNnrHqS
         vytiGPNcizbX16VLPlDqMpAAiixnv8SLzwq8HaqN/dyJaJIoXUnW1SdSNj9wYTMDeIon
         jU250VlqBQdidsK/0wse8u/cvVIxmhUw0vkhHysQybpAiUZWD4hMrkj9ie7vnT8gP/G1
         fc+EWxSxY3yAffqfAowHSyLD/+z6S/wLugHRITb4mTQiFFaIJjmjE3rY57oLmTXCX4N3
         jKNtN3SLARAZoOWf3lLS0NXyN1lQPxV4mshsBWAQWXapsxyXvo6VSM60XlGIgs6Y7A3w
         KTFg==
X-Gm-Message-State: APjAAAWysoB1KWFYfdeH7KAtHO3OCXvGRb6mXZfk0RxelQB50QyloH9L
        0IpcDhg55FktxU4EGR5nazUfkdpeLzRoKQ==
X-Google-Smtp-Source: APXvYqxQc/HG++h1jtuStiEyVFavCfqjnwW4Eh8F9XFkXLGCoU+mg9QwJwgHZ3k3fNI02HwQRF2YbQ==
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr946979wmm.141.1569986951236;
        Tue, 01 Oct 2019 20:29:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a14sm3786031wmm.44.2019.10.01.20.29.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 20:29:10 -0700 (PDT)
Message-ID: <5d941986.1c69fb81.e2e1b.2928@mx.google.com>
Date:   Tue, 01 Oct 2019 20:29:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.194-78-gaeea3d149ec4
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 57 boots: 3 failed,
 54 passed (v4.4.194-78-gaeea3d149ec4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 57 boots: 3 failed, 54 passed (v4.4.194-78-gaee=
a3d149ec4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194-78-gaeea3d149ec4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194-78-gaeea3d149ec4/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194-78-gaeea3d149ec4
Git Commit: aeea3d149ec486033aedbb124201b572ae0e61e6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 10 SoC families, 10 builds out of 190

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
