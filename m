Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE5E57BA5
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 07:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfF0Fvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 01:51:50 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:43608 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0Fvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 01:51:49 -0400
Received: by mail-wr1-f54.google.com with SMTP id p13so940291wru.10
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 22:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/dNqjhYW8Ej45ZjeW7ihSdi/GQwTrFNO14vHkGBHiag=;
        b=Dy7+x8iuegJwkzGSjDCq6ZdIwZZDlmMD+Ca88IXmk0lVhxKgJM9NE2W8+MEEvSkmMq
         quk3kgzLEWlCJ1cf3egxonmlMefI03v+XwFk9D5bCx+9sPsOi8FDPe9l0sflpU6g2lfl
         4rUQT6/kxNT88yVLet1LaP0JJcqb4XPznUzd+hmcBbxWmR1glPL4Sc5VTogslkGRIKet
         wzP/qCtqEW8MBDa3rWUmxO/WXpt/RlrFq7wo5c40p9au0Ihss47+arJ/2+t6nHcQTMwA
         SQeNKnBq/OSV4qBKBenxddntQztakuJFAwlPWK2snomzIHiJnxsXxAKWPOwQcNOwGAFM
         vdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/dNqjhYW8Ej45ZjeW7ihSdi/GQwTrFNO14vHkGBHiag=;
        b=bKcnVZkcj0Iz48S7e23IHAf4a993IF8MOF6XyajoJYGtyHd0URAbfaiITuEJ7uat/p
         RHJniblnPZpDzmbnHGQh7ESrGdMIQN69UAucUVbv7B9lhKNg+sKHmnPmNOJBQZj0BRoc
         pu8ZMpUhAfAFcBeIqKW8lemrQEv7RB7If4oJU3dIKRsdBtTmxir8OYoLepL8oyOk/zrz
         ALWxO8aIsY7spRnNj5biG3pDm+/8R6UzWa+nwM310akjpSwbi/wrswfrJxHWHM5E4HyA
         4A1vRCrSegGomHoPTSlxxG33qoiK2tk5xbxdZt+sJ6dXgGKgTcPfz0jYn3MoNyC7s4ry
         K9PA==
X-Gm-Message-State: APjAAAXs1RHN3DfKJbxnyfJMZmeedN8N4S0EHBuT6j3I3OTbEBfLrqDN
        1dcgUQqPL+NrNmiZIHrvrVZyxf6eWkw5qg==
X-Google-Smtp-Source: APXvYqwu3GA8ZoKf2odjdL93Xug5soklKUJc03+JmY0WvfWUgkix3h8fYqbbMNH3cksa0KVO1o9c1g==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr1477737wrv.89.1561614707372;
        Wed, 26 Jun 2019 22:51:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 32sm1927564wra.35.2019.06.26.22.51.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 22:51:46 -0700 (PDT)
Message-ID: <5d145972.1c69fb81.fd76a.96d9@mx.google.com>
Date:   Wed, 26 Jun 2019 22:51:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 57 boots: 1 failed, 56 passed (v4.9.184)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 57 boots: 1 failed, 56 passed (v4.9.184)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.184/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.184/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.184
Git Commit: 09a70683607778bf96ef2db72e8c3b823339734f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 15 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.183)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
