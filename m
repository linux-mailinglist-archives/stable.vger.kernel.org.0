Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6481A641
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 03:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfEKByD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 21:54:03 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:38090 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfEKByD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 21:54:03 -0400
Received: by mail-wm1-f43.google.com with SMTP id f2so9034567wmj.3
        for <stable@vger.kernel.org>; Fri, 10 May 2019 18:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4G2n37Bg3JVFAGPJZvSZziUB720rH0GcaMlDH4UDI1I=;
        b=X0PuDXqXYxiCCj1KC07Wwmg35mZ67dCgAxKmyDzLlw6hp40NySjfLFIdIDCVMolfGK
         LzkZj0YTPfMYCc0Y6bmMFwVun0gseekJQxDm3n8fNTSVXu2DI68r8za5/1LvDrtNpt0f
         vhqoZaBpdnOv9XxoeAa+J1Ar5/y9kSo+WTuglb5rDIEgmQTX3b3qe4G4vj9892fuKkUJ
         F1YYo18a1hJujzkFFmP5DZWNxEAvR5vJSJhQzJWw28eNus19z1cCmSTc3/h3b2MuKQtX
         /DT3ynEH42Budscm9Jdwq/ooLpuc6CI//lkI+uT4jpsvS9YX00AXarnd0rplUHq6IyYc
         /PPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4G2n37Bg3JVFAGPJZvSZziUB720rH0GcaMlDH4UDI1I=;
        b=hRQJd+L29njswn/k3SgoKiIguiwI1M2EC93ddGbyR8miuIRnQNQ5ymYY38bxpQA+rN
         zNuCmOVvUMHSFXj5s6lu7U7W1sJ4jaKyPBfLUxy6H7WUCYfY1Y3KPSSgFghGtw9dbheP
         kK3b8zGSG0ALvdsq3aDIP0YKWUY6A2xaUJU9J7aoNhYt8ElBbQ2okHxvWiOvKZpyZP0o
         2NoGl7bZ17Qagtr6G2RfcIUxhBWQNuFQu0/MgAkfG1OZvlEeuesJ7cHfQ68cdfPkg6du
         16p8ImUgcTHAsyjkcpZdk+kHqHigPRSl4GKbFkpiWvxZx9gGRneuCHrLK0oH0n07n8e3
         Cdkw==
X-Gm-Message-State: APjAAAW/OMj2vQ+TsEjpUVHP4vDmdMqbc05LabgIEWeifp2sKH6PDOQI
        ucMLEWT54VTWgHkHMnEQMpvSBtiw8OCO9w==
X-Google-Smtp-Source: APXvYqwdIwKnNFJ0BTI5zho8XUXoR4TGfx0Qj+YQ5I5geII9GYZNgUzKrvpfYXi8ePVKen1CIRTQXg==
X-Received: by 2002:a05:600c:207:: with SMTP id 7mr8876101wmi.134.1557539640717;
        Fri, 10 May 2019 18:54:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm7632493wrt.66.2019.05.10.18.53.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 18:54:00 -0700 (PDT)
Message-ID: <5cd62b38.1c69fb81.ea312.888c@mx.google.com>
Date:   Fri, 10 May 2019 18:54:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.15
Subject: stable/linux-5.0.y boot: 70 boots: 1 failed, 69 passed (v5.0.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 70 boots: 1 failed, 69 passed (v5.0.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.15/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.15/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.15
Git Commit: 7b13756d2c328e35f0640d16b68541e6f72339b8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 15 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.14)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
