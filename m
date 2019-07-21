Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3516F36F
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfGUNiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:38:22 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40113 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfGUNiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 09:38:22 -0400
Received: by mail-wr1-f41.google.com with SMTP id r1so36653825wrl.7
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zmBoKeTsKpdRtwD54+kF5rOV+sKv3bWD2wknRywHDcg=;
        b=YmfdjXr8UekIKSHbTTvS0sL1s//DrpViXdAJ/X74qAg0Go0Qalq1nH/ltRl2yEIoef
         Qtpx3N02t+jDH/nDZ3McG3WbSrwUGug3JA9kNYLvkkhiY2Q+MWz/UgTGzc7PD0I8b5ow
         9hqXlwnZed5RAOoGPKkzBuIJ2XCHvXFHkbhGIkmQ2FgYg+GzVinQMQpW4g/khpyplssv
         ETdKX0ea9q4yM6VfYqRMVz8CBUIUNPEkNeCoThH32dDRKuvWWnI+J+zqwPXUG0f5blAs
         aS9B6vl6WhS+3yL8R6CFGmBRTP/VEcDp4TrojV6eBq1iybm8ZvQ4MJ6VO86JpS2+jFGe
         WxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zmBoKeTsKpdRtwD54+kF5rOV+sKv3bWD2wknRywHDcg=;
        b=K33NCq4MbwYRkdw8JOwoFrBwV3J8mo/5dJwt8efuLyIbdW8+KQPSib/k35WkGDXhhL
         jtwSrfiIKIsSnkhPgg7rtHIeVh08NrwzKgT4MaEiEAFGlWq8DZU/983c/rgYJq25D5Ei
         VkTMTtIG1E1QBEGAOUXsQXsr6r09gr2hVok5rg/Xkci7eJFK2BP2zL1BbF8lVYgPyFmH
         r+tcjXbmGMdipVGydYBmveEhIydRdGyhmTG9C3RiK+0YMjHO2no16gRCHdWPeO414Ucv
         1tan54GgADbwzfXG0l/ihMGuXcstn+i7aQwP0Rwv00zRsiXzUFuXokaTJqYUXEuFbnL5
         SMiA==
X-Gm-Message-State: APjAAAX+JG4G++ML8BSlqrSVb5+NaJfhFK3bx1vgqMUZ/qJ+dJ8XhnvU
        RG8oBtKtAG/egQIcdPY+did63WO/
X-Google-Smtp-Source: APXvYqwug+2eGhDtCjbNoqhE66PvvLDs44tklJlzUBS53gC+QWZMLaV3W/gNqQfZh4qXwtayn0VctA==
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr27883878wro.190.1563716300018;
        Sun, 21 Jul 2019 06:38:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b2sm47223948wrp.72.2019.07.21.06.38.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 06:38:19 -0700 (PDT)
Message-ID: <5d346acb.1c69fb81.589e1.a0f6@mx.google.com>
Date:   Sun, 21 Jul 2019 06:38:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.2
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 42 boots: 0 failed,
 41 passed with 1 untried/unknown (v5.2.2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 42 boots: 0 failed, 41 passed with 1 untried/unkno=
wn (v5.2.2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.2/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.2/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.2
Git Commit: e9b75c60f91a359cb0e1b2d0a9ed1c81485215e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 12 SoC families, 7 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          r8a7796-m3ulcb:
              lab-collabora: new failure (last pass: v5.2.1)

---
For more info write to <info@kernelci.org>
