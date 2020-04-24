Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9D11B7113
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgDXJha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbgDXJha (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 05:37:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F4CC09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 02:37:29 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so3543201plo.7
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 02:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hb34T1redQRwRgUmXJSmDRMPO27sLhgs/bYsuubkuNo=;
        b=ufCwHiAxY8PljxqBsfDsXwmjNdHRt1t0FweP6dniIiOQNZCZI0C3wOEoHGXs/GfaUd
         434AfyRffDBLPksBEM4W3WYLTLU9cxIp7XJptJIVGp5/hGLHcM4LUsYgHClJ/7kVlCgm
         uMLiaRCW+bpxWjCXjCxSdNrz95k9HEYWn99Yq8i6Dt7aC0rdnYlGNAAm+wW2Uh/M/ZTm
         kN834rNyzA8QKOnGcdbXi/kEQXpPGvJuhze0DqglxRSH2gWa36DpQqZv4yZ7DSW4iDM6
         UBx7akA6JVE4279LDknGh3FnjdrqRYFA2NY+3gJHB/K1peeASaL2Xn+ZAITlBzXGH7W7
         KzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hb34T1redQRwRgUmXJSmDRMPO27sLhgs/bYsuubkuNo=;
        b=lrNrLYWOEgrgITaLPbrC9yBqREgb1qJikTYzN1CF799o+Guykdg5zHt6ChApJLYgph
         q7YjXx3J5SS3/9BdqAKAWk05Coq9WZI+gNkUmBRAyJIU5R5XCbf19xVTmvAPT0t32Bsp
         1cpgss4+CclqDnIucn37Ze5f9xkZvyKrHKSz4jjmD3OrHsr43npCwgq2Ntzc3VL6ArLE
         AZlmBIQOpvlsUEbLeGg8b9+VaiDwxy/3HCbB2V3RoUD7Nx3NZsTh1XmQGWvPMQsZ6p6+
         26ir+bl4nRwwh+g7VgLNVulduTKt0sjOk/dqgU2dyE7psuMeP19MqayJ3XH/BL1jREtw
         oJ7A==
X-Gm-Message-State: AGi0PubxsnBmBtAkKW9w7hKhMvDaLHU693HcrLDkDGoDNsrZupBsFF+d
        saHOBGaUEpNe4d26rfiTXS8LK3fuHYQ=
X-Google-Smtp-Source: APiQypKf4dyrDd8PtiRnZSbY9ViclD1+EjDoKRjV+Wc4Fy4YsVrkg4f8dFbAGTD9M9hkyqAMQNkuIQ==
X-Received: by 2002:a17:902:7285:: with SMTP id d5mr8314635pll.239.1587721048779;
        Fri, 24 Apr 2020 02:37:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm4318814pja.26.2020.04.24.02.37.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 02:37:27 -0700 (PDT)
Message-ID: <5ea2b357.1c69fb81.58d42.d50b@mx.google.com>
Date:   Fri, 24 Apr 2020 02:37:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.176-199-ga7097ef0ff82
Subject: stable-rc/linux-4.14.y boot: 58 boots: 0 failed,
 56 passed with 2 offline (v4.14.176-199-ga7097ef0ff82)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 58 boots: 0 failed, 56 passed with 2 offline (=
v4.14.176-199-ga7097ef0ff82)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.176-199-ga7097ef0ff82/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.176-199-ga7097ef0ff82/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.176-199-ga7097ef0ff82
Git Commit: a7097ef0ff8203c8e25ad7d3b996e030c083a81a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 15 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 75 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
