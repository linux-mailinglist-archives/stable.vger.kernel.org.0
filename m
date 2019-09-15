Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E59B318A
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 21:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfIOTF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 15:05:29 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:36341 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfIOTF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 15:05:28 -0400
Received: by mail-wm1-f45.google.com with SMTP id t3so7803036wmj.1
        for <stable@vger.kernel.org>; Sun, 15 Sep 2019 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UcQqOkMbf16vo9Ls50tuEuJ3waV3wJ3p3+zNilpQR/c=;
        b=tz8GwPfhJSW+DQMOf15yymu4TWyr8ks1ImxmVygdaXyzPbZ9gWs3P3RQqGn4zx4c45
         3KyTCpfXN/2tL0ML41nMeujaivAk2fJcR2IFFzRU4xWieQATK0vqJC6H/O+sfKkyIePg
         Lmdv6LzLBqBoonN0KtMbfTuoXBmLmUZberWYhXuaqEW0Vrw/meRxBy5WgPUhZmAfm7vC
         Oi7AmiMDS/g02wJSdp8QV2QalSZ88vUBf752IIR/R0suXPQVBe61sqs+5y+iARaei+JD
         evfjOBMdQJ+OMy91+GHBE+mCzsyaXnb8BSGO/w6jCDxKRvRFzAamCMGFHGYSEaW38+x2
         x3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UcQqOkMbf16vo9Ls50tuEuJ3waV3wJ3p3+zNilpQR/c=;
        b=nT9qF4UYOJmqGsqC/4uG/1xRSX7uM/tuQxxd4qq+lD15RxkVeEi+oN1XMxCRYvB8U7
         bUz8Fk07pQoyaTHXiXPu3bVTYz1pAhLmNy8I2yHlM+hJUUhBNcRefMhFUuXUTO8UOI0n
         itZZghkn+eNjEvHsvEeAhQUBC2BoB5WorLbrOy35nkP7woL/Yq0wlEk2ik12KfzrffnG
         o6o8xXZFqqLNvQpI1bbE1FZfwBJEcY7k1+WgwXRkT5koj4G7mKHNVgJEAo85cuZ4z1Fy
         XecQCXWK9PYIdYDkBuoXKEfaFe4KQtL4SwoC0bxYaOsL9Zfgwuh889oIVVl+TPMQAeIW
         oRSg==
X-Gm-Message-State: APjAAAUMm0zzweoa7MKeG30GEczyoVY0O7gcNg/IMJ5PKNCiXCg5LZoy
        8Up5fiuXWkLnFPHRK7XgIh6RJkslkCI=
X-Google-Smtp-Source: APXvYqx41t90JnhG3wUrSn1aOZL8+T55MUFhh1I9R5/Nh92ytjF7u341isSKBZ38jsIkPdkZnAWyJQ==
X-Received: by 2002:a1c:f515:: with SMTP id t21mr10298029wmh.74.1568574325290;
        Sun, 15 Sep 2019 12:05:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u68sm20129132wmu.12.2019.09.15.12.05.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 12:05:24 -0700 (PDT)
Message-ID: <5d7e8b74.1c69fb81.5dfbf.822e@mx.google.com>
Date:   Sun, 15 Sep 2019 12:05:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192-14-g61edd63129ae
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 119 boots: 0 failed,
 111 passed with 8 offline (v4.9.192-14-g61edd63129ae)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 119 boots: 0 failed, 111 passed with 8 offline =
(v4.9.192-14-g61edd63129ae)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.192-14-g61edd63129ae/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.192-14-g61edd63129ae/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.192-14-g61edd63129ae
Git Commit: 61edd63129aea7800898aec66b9a420f765883c4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 22 SoC families, 14 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
