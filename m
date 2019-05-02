Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C8A11FB6
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfEBQJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:09:24 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:39982 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfEBQJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 12:09:24 -0400
Received: by mail-wm1-f48.google.com with SMTP id h11so3331072wmb.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 09:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OIzI7FLCdvJafcJyPHMGbrzdsD5WofQBsvfTttRfsbA=;
        b=DccZyumzpHuJ0SS/QD//UEum9uA6TNHlqk8h+MqaNQ9G1yqa3VzJJsmw9REPteX9hO
         OiLd+O6gDkCVLPGo/IXNsETx57+sni+qf+qk8wxFlFOzQlM637GXuHp1xXZYr/QHORcw
         j9G7ztK3dIq2pJg8STC7wZ9IHki3QHep8R78JP4LgRw9jgMwKFWaZDtgcsWWT3uyWtHf
         sOISAkZJy17myR4ToiENXnmf0sB3QpTl545JUyw0AfuRu0dmx7NUYWmpDjmIeyp9zVhR
         kgEnvR826rz4kA5iW/M6EGDG+UAd2Z4iAKiMdAPoQDb8ER7fX39G25BhUdMisyBmBVYd
         58pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OIzI7FLCdvJafcJyPHMGbrzdsD5WofQBsvfTttRfsbA=;
        b=Vr93H1qmCkY7xwGne11jd4f5ztk5qr5RaPUAXN/t1Uterw6sJRaHFAVuH7EK3MkuGX
         1AOC9c6VbGCr9zWgoRV3oNYq9b3fQQzHgpdq2KQxVdrY5HgJQe9AhiplOgi5r0bpGqlu
         dXA4VehS8mX49gH6rfhdOrVHHOkx++zvU+kZxwCPGeou4AJ4n/b1ex622TudESj7g9Pa
         3PonpokSKhAV1IpOu+dJ9qtm0ytbJMVEmusLi+2u9kf9Sn3FxkiQTNSTyWVSs4wEaJIo
         vES7uRffMx1hSBnEDRi/SYS3hVXTo34JSvH17bMPwrgIMVFMGItNAMWixmEb7GMHzFGX
         fTzA==
X-Gm-Message-State: APjAAAWvCSDJQetq+ic5RJ3pvz+kqQG7jk/FIfPYnsb9ndckp8qozcnr
        yndxGNrY8yMXVtw/33qLromvSKfSvP41QQ==
X-Google-Smtp-Source: APXvYqxZbRlmBqaY5NZqpkk8zM60v8yLbsneP6Vl41iTBcMO3lzDwHnyo46MjCen6lMdsD155uw/Yg==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr2938575wma.111.1556813362670;
        Thu, 02 May 2019 09:09:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q24sm8772420wmc.18.2019.05.02.09.09.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 09:09:22 -0700 (PDT)
Message-ID: <5ccb1632.1c69fb81.16e2f.0585@mx.google.com>
Date:   Thu, 02 May 2019 09:09:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.11
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 129 boots: 3 failed,
 122 passed with 3 offline, 1 untried/unknown (v5.0.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 129 boots: 3 failed, 122 passed with 3 offline,=
 1 untried/unknown (v5.0.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.11/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.11/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.11
Git Commit: d5a2675b207d3b3629edb3e1588ccc4f8dfb5040
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 14 builds out of 208

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
