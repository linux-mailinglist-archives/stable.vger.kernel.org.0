Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28768122A0
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 21:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfEBTjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 15:39:16 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:40601 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBTjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 15:39:16 -0400
Received: by mail-wm1-f49.google.com with SMTP id h11so4104303wmb.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 12:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PPKlM6ilF+RkuSDVJ6SNKmbFhrwgZfo86vIcplrjIGs=;
        b=Pcz7bjgCOcXUyoBsrjm3/bXfyjs5hsWGyc4uEsljAiunWHs0rn3JAx1qozDWs6Q3u3
         hqHs6tcqhFEAy4Ul0ZARfHsln/VZ+6l6CIaCHjWmz9M//gtr+sfdUSEzZRaeWvie1ZhK
         CTR/JjWApw9xRNBRIo9N6IMXQHWBAJVFhztbGsjADsY7WbWBNWt7bmaeInngWuUhTdEK
         KBMp4nTOexNcCd2p0lFFqWWEKisEy4SsEIrEsjPvZJQzWXcW6v4J3jSwjHVYx5oXB7Z3
         xwMNLy5XVvmz/brxOaoVfLWbRO8w6UEnfKkQEiQpb2u9zd9gH3gg5dK7vaVJpM/hOgOo
         Nyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PPKlM6ilF+RkuSDVJ6SNKmbFhrwgZfo86vIcplrjIGs=;
        b=OJJVqPq5QQPeYugIc+NkCjo2L2CDSt5C/ZCrOzz7R4rz6d8u3Y2VKcrHp+G7tooUew
         h6t/oPB25NjXTGdr56naQzWahh+fSTt9fNcbZnEswbe6lAXfS/dBGPljrMcEywggZ3zx
         L6Xwegj7ec2+iTpHVEXVKEg+SoaybuIM6d5abpiegZfzkv+6/7sSo5GNVDF0jzSQYdwb
         aEXpKdoMQpYzh4Wl2xPxECGZD81DBxFrffoy9lrkJW83QNnifDAEZEAPJcj9PyJuWU0t
         7E4VcH4xA9wvvBfThIY0G3dGT1gB2Bq1MmRl++FMBKi8+Qozi2SRK+aWZeLruZsdz/E3
         ggsg==
X-Gm-Message-State: APjAAAUR1/CjAwoiNVl2MK6GAqjNy2+WJVdeddNDFovu+PVxrWFZTcZ/
        aFlbIJFjFu7To5CsWZfHXQfFwuzfvSRKYQ==
X-Google-Smtp-Source: APXvYqzg+rh7oZ7zzM1JLsbmVj4kGhZTIydfF2Frr4Z+u70rc50kF54FhizKvCZun6T23AB/8YHSQg==
X-Received: by 2002:a7b:cb58:: with SMTP id v24mr3433234wmj.107.1556825954250;
        Thu, 02 May 2019 12:39:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s2sm176347wmc.7.2019.05.02.12.39.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 12:39:13 -0700 (PDT)
Message-ID: <5ccb4761.1c69fb81.4a5b1.123d@mx.google.com>
Date:   Thu, 02 May 2019 12:39:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.11-102-g17f93022a8c9
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 129 boots: 4 failed,
 121 passed with 3 offline, 1 untried/unknown (v5.0.11-102-g17f93022a8c9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 129 boots: 4 failed, 121 passed with 3 offline,=
 1 untried/unknown (v5.0.11-102-g17f93022a8c9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.11-102-g17f93022a8c9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.11-102-g17f93022a8c9/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.11-102-g17f93022a8c9
Git Commit: 17f93022a8c96d740be0f8dfc01e1ccaa70eea5f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.0.11)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab

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
