Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462C41D1C7D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 19:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389843AbgEMRmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732694AbgEMRmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 13:42:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F370C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 10:42:18 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e6so11299833pjt.4
        for <stable@vger.kernel.org>; Wed, 13 May 2020 10:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vf4eST6LeGYFH51qQlUzoNV4qpUnxkh4NykhtusN2vA=;
        b=juVM8yRJK3/oX9bQ33o0bsLk03Y4+JwQnJfPrVDGllBn6QDZ37rMrBt03Z/uxvyeOI
         5aKzKz7EW+vxhyXjXBnuIz5bKjzPwyGaBufhkPTkWOJosLx5R04sadFJ21mWnpsi7djb
         QSbfJKfIi/IbpdeF3PvRRPa8zzh9k4VN1nM5kNhDvsn0FFujWsHr7kZHiCh/BVTlrb4n
         Uuqrdb94/SrCWxVF5Pxa2UPChovPKx6KKO2PSqnMKiFpqL4HpIW5d1b7Wua/dSVpbzqa
         s2urvtR5YkCg0MjeELQXh/hWsu07GHaYaCIWMA4jmqFHreILNpmEXjPGA2MVe1qi8b5O
         hQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vf4eST6LeGYFH51qQlUzoNV4qpUnxkh4NykhtusN2vA=;
        b=e6pJQZD2laK+rI/U9UlqsTEfXOtOo2cQZwww138WfqSzunz7WmALlOSj+e0Y+j2/zu
         7ZBWMJjTaILJiJV6AJ8fMp4VHVXWl5h2uQS0S/4Z7jNKVTB3dVweJG4fAnHmMUxPCViJ
         HfVQpNZZFYqdNWIzQVtV0XaSSbPFJKOYe48ZdeehT/+OY8rK8OtIAhuZpnokWKRZ7B0x
         WYy1CCNw1ti0Bphgk57ysZekDBstN7he2Wup+CThRW0XkcLcqPxpZ1oyX2tMOI9M0i+k
         j0EWXRy2iCYFzjBpUFY037/+J7zz6y4COrzQMT+zIfCchJvDk90ycnB+EcdykYYAv/b3
         02jg==
X-Gm-Message-State: AOAM533Nwm9MY1+spJ6pXSUyJx/gFkPwUwiWSBnCYtCzZuhzfidLJMh7
        3XZV84sRtdI8GddIRO+0+55M1bmGIDI=
X-Google-Smtp-Source: ABdhPJxYZhNt0jR2K9+OH0IAEVDeEmRwSJ1Z5qimgv4alDIvV3Li3ApVkmaGxpexRayF2GLo/YPGvg==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr9524362pjc.230.1589391737873;
        Wed, 13 May 2020 10:42:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm171277pff.9.2020.05.13.10.42.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 10:42:17 -0700 (PDT)
Message-ID: <5ebc3179.1c69fb81.8496c.0935@mx.google.com>
Date:   Wed, 13 May 2020 10:42:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.122-49-g6d5c161fb73d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 126 boots: 0 failed,
 118 passed with 2 offline, 6 untried/unknown (v4.19.122-49-g6d5c161fb73d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 118 passed with 2 offline=
, 6 untried/unknown (v4.19.122-49-g6d5c161fb73d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.122-49-g6d5c161fb73d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.122-49-g6d5c161fb73d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.122-49-g6d5c161fb73d
Git Commit: 6d5c161fb73d8e3d1a5a0efcf2d089b939a1e165
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 19 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.1=
22 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.19.122-48-g92ba0b6b3=
3ad)
          sun8i-r40-bananapi-m2-ultra:
              lab-clabbe: failing since 1 day (last pass: v4.19.108-87-g624=
c124960e8 - first fail: v4.19.122-48-g92ba0b6b33ad)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
