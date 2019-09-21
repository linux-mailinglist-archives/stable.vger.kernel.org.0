Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F0B9D70
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407511AbfIUKos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 06:44:48 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35956 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407448AbfIUKos (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 06:44:48 -0400
Received: by mail-wr1-f44.google.com with SMTP id y19so9197334wrd.3
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 03:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VkkcqZvtEWO/4yNouHZFK6uPIEogAbF6vditI2Z/610=;
        b=najcKemohPF97XvY0NT7x9GFin7CK+CHmOYdfBgWaI0jcQhVMEvw49XW4sCbD0+BEx
         DrAV/x3AUSItdXYzmrmBhB+abgyT4bX9tl4h9p7vTeYK0UB0DkhzZtKbYbM07l2NZrNk
         QzGt/sCsux1lmfCwg6BFxpvGAdpLQY3e8gcqDzZ5px2YUcjCzS7xQb41rL0NrT1rR0gY
         5Mknb6EAsSvRhd59X+C7L29RqEZfqK/FH4tCddrxR9ggc32wdcd4OU0QxZHon4gGEEsX
         gMHpQ0YpVaajFLEiJE3eAcOQwvFO6BXXKIz0ozHRmeSx18ikKealUy+Xu8EUpziF5QsC
         Wvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VkkcqZvtEWO/4yNouHZFK6uPIEogAbF6vditI2Z/610=;
        b=kCVdt09GR9A9tV9YOLyshFNgDfU+sSJyQt9+YeTqA0FsReg344CpRp/n2TEIZBgfKV
         9Z31z/qut/LpC0wI157USuY9YrqmZxsJRU1vPlOkr6P6v0Kp6EtF6hkWgy5T4nSA/f46
         De5jFvuMs8b65WfMipthf4VkISiNlS8DzlUVZvAsUZKJYQikolgpIGRcp/0rAbZ7vZtm
         r5CO5/YHRQcXcOyLC2YMqHYzfPx6Bwf/+XCsmwFMsWQt4ATyrMpxDAo3xfEgrcl08ilc
         QVJLdRHQEYusO+kq4wefG3Kmbr/HLlPLni21baNPRlzkjOn2AEIlfT1173ym9wpmY835
         9dsw==
X-Gm-Message-State: APjAAAXXinGDV7UTpn3vCeB6G7BFyJNcniRmi+JXLqxpl4FlRcEny2aU
        iQZp2xyyV6M/6MQ1Ua7n7ypPuVCskpo41w==
X-Google-Smtp-Source: APXvYqyCeb1q2hHh7R+dp9J8BL+XSxCNt3vNVpOGW7b1oLNMTeQe7fsO9rtsabAcguMlYTwR11ghUg==
X-Received: by 2002:a5d:540c:: with SMTP id g12mr15636458wrv.207.1569062684128;
        Sat, 21 Sep 2019 03:44:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v7sm5475243wru.87.2019.09.21.03.44.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 03:44:43 -0700 (PDT)
Message-ID: <5d85ff1b.1c69fb81.83d1a.c58b@mx.google.com>
Date:   Sat, 21 Sep 2019 03:44:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.194
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 56 boots: 3 failed, 53 passed (v4.4.194)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 56 boots: 3 failed, 53 passed (v4.4.194)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.194/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.194/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.194
Git Commit: 5f090d837b1f61ba12780a8b8196b69a00d7cd70
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 10 SoC families, 10 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

---
For more info write to <info@kernelci.org>
