Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FF1386ED
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 16:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733070AbgALPlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 10:41:46 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56251 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733062AbgALPlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 10:41:46 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so6969482wmj.5
        for <stable@vger.kernel.org>; Sun, 12 Jan 2020 07:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rf6cAg8NvfHOt4rC0WMmwzdiesIU86lAKhO2f1b10iQ=;
        b=tz6GO6Ykjjt4cMqjug6kpZpefglk5H7RnEoFka7tZ5oX/wQ7Ks2Xh6AA3Q04vb/OaL
         h+iClMzGaYkWzEUIUk3dA+DpX/VkCgEP+m5k4zghrJqdeOYtfK6pTBIFBj289n56q3Dz
         toxkgKr4LRmHn0zoqyYqSqRf8Hu536z1RyzOHhopC7dtGFfL9zM2C5MX19UiMpwt+k3j
         7XD81pm45Kw+i+2EtK8RUdIM/Nk3gP5hpHxrB/XrH59yFX39CJKXxJeqgekZE1GtzJwI
         v1AJ+zAAeFbfIyzG2WhooqoQsQBYx7jutHEVL3pAGPy+2JiK3RpGwsPqMSnhcr1UlKZM
         /deA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rf6cAg8NvfHOt4rC0WMmwzdiesIU86lAKhO2f1b10iQ=;
        b=Erq/is4EiNraiSa1p8GIiLYMh/qtAfi58GJm04vUqNgphGhp/V2I+BvI8WcyN8aASu
         gShZeCzRNIkyBVsnqlhNvIIAkRGPrixHxjOnMQRgNxrowsPt4BOB+2e4SA37YhmwsJsV
         /p+F30e97GYJxZ8yzRLFuDRJK/gnaUszS5ZenrYcwnPEu+3yf3v4FJG/HFDyoTOufpup
         KTf0ssczsSkwHxtBif+vB5nNqLTqo/lBCnVNmDjn6ff0PuEItkXdhuKoJkec8Byczpg+
         KEEWK3JThPfhDhGZgiSe4Xko7o9wcRSK6ysWUHfYTMIHp1+jVQqLO/l5dPQoNbib21O4
         aKFA==
X-Gm-Message-State: APjAAAWpwOQjwOUT1J1IrNaJOYb99tRLmG7TPWWZurndWt3oq69o0Jzw
        +esELs9bYAw+3NxCc73uOyNeNqhx6+ZWRQ==
X-Google-Smtp-Source: APXvYqzrUg0ICGxhywIez9MIKQTBWkel6vnjRDw7UbnyUiQttOzLRi0nNQBTnYvS/oyn8nGorGK1Cg==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr14834771wmk.131.1578843704126;
        Sun, 12 Jan 2020 07:41:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c9sm10480004wmc.47.2020.01.12.07.41.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 07:41:43 -0800 (PST)
Message-ID: <5e1b3e37.1c69fb81.bb630.b15e@mx.google.com>
Date:   Sun, 12 Jan 2020 07:41:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.209
Subject: stable/linux-4.9.y boot: 28 boots: 1 failed,
 26 passed with 1 untried/unknown (v4.9.209)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 28 boots: 1 failed, 26 passed with 1 untried/unkno=
wn (v4.9.209)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.209/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.209/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.209
Git Commit: 753a4bcdbe536620ecfc66e8ba7f59389edc6304
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 8 SoC families, 9 builds out of 197

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.208)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.9.208)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
