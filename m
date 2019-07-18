Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9666CCB1
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfGRKVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 06:21:31 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:34684 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfGRKVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 06:21:31 -0400
Received: by mail-wr1-f46.google.com with SMTP id 31so28107530wrm.1
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 03:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eJHMpMyQvGFKo2nygojFRtwbeTAIzdIiFkkt0KkdNFM=;
        b=L/Y+poQI9juClfONRJT60aL1ufhW6mWV/vJF/7c99KY/7EffidGmWdKr7MHhbXLeJp
         vuMj9WsoyF9vqUr26LDRvfwBSDAz/Sn6hLMuWrHTiT03sVjPWvPrR7YrSJlLA9QIB1z4
         bI/2mcn0e4g8uE5EoZLoh67YuIKoZ6OJDVM+rPC8RrS6oJT9q8v6nVnU3+ZOpku0X/rg
         MT9sFRbUB7YNbDsPLs80kCdFISvlZ8w9GVJyfLDLy/mdYnuIiQBj4vmHD/gOkbPlvbI+
         P7gGgDwKp8dN5Nvz4T34lU6bDrIFrpyJDNn5iErwDwQkVcDmCIVtRqoH/Z8CttpnHEIz
         yELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eJHMpMyQvGFKo2nygojFRtwbeTAIzdIiFkkt0KkdNFM=;
        b=SZy115Qp7x3/eWRKdGy+378W4bcP0L/ymH6SkhaYgQT+dEjyLx4j5X0qyupS4WTK2B
         tL+X0dymrCssNroQ1rExxrkuR9b8mKlKRCVdL8kxdCWNiXpibX7m1duu6DmfGMFFdK0Z
         F3bKTX1cpVSoS6jgcuLOM8Fh2daNipGcwZ4c2YWYFy6i+ygc7IbI/I4VnLpvnNf2KgFC
         5CmW7ZR0QRjHqWT37tzq6mIRyGSRhPfdWvAKohAuvGxNhu1Neod+HA9BhnRBXKKM7X7G
         wm2tSpZNatZvRZswMKN3RkSDdpFzhwy7aq/btioAvxwaa8xcRCPjazRC4a30nnxwyDH1
         K2rA==
X-Gm-Message-State: APjAAAUEqIbfbylVQWfKjVKsC7m73ZEoac4BIbtNj21pOGEf5Xp0xLeK
        CXcGPrsolRFmk27PrFDB/6TZY8OX3cc=
X-Google-Smtp-Source: APXvYqwl6yRDw6WGCbKlpm+C2gk2nvAIp8wtgePQWbXdbEpNo0HStlSX3Cx4yP62UwBTzQZhE5meOA==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr47262809wro.60.1563445288800;
        Thu, 18 Jul 2019 03:21:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t1sm37937038wra.74.2019.07.18.03.21.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 03:21:27 -0700 (PDT)
Message-ID: <5d304827.1c69fb81.8c1f9.8a30@mx.google.com>
Date:   Thu, 18 Jul 2019 03:21:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.185-41-gf046b75a1ffd
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 2 failed,
 96 passed (v4.4.185-41-gf046b75a1ffd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 2 failed, 96 passed (v4.4.185-41-gf04=
6b75a1ffd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.185-41-gf046b75a1ffd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.185-41-gf046b75a1ffd/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.185-41-gf046b75a1ffd
Git Commit: f046b75a1ffd3ca49e30f811d72f9b907e11a5e9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
