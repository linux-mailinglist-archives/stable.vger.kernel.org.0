Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF8136EF8
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 15:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgAJOHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 09:07:38 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37781 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgAJOHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 09:07:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so1950743wru.4
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 06:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HS3Ajip1UVbHWRT+CDPoJdT+ibZqWnpAWn+Hfr3slaY=;
        b=mxasKHrIJC+Fyu5sFtG66XYrxzGkWKQeVFh2G0SsRIwZriH2JAFTu5CHc5hkXMVaRS
         Q+JmQofKyLl7ydL22GhKMmLr+pJEIgDZO1EUGdfhFscv8JdqIggf/2dgcvJSy4KI29Wp
         TeXOU3L+iRxnh2MUzTHFunU45MjC1uUdfKsZ2CbNLNrDoTvA0OqgyqmdbrmvfCTwzwZ7
         03ZaxgrsIE/tdJZUxMzFy62v7/8O5eDoewlLDhC7l/HCq36JJ0plmlBRlj/n7da68PBK
         nJ12bfcfyjaw4MYw02pui+Ve2pr2iF75K8MVxC3wA7rN5TeVquiVSatwfINFqj9J4kpC
         bs9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HS3Ajip1UVbHWRT+CDPoJdT+ibZqWnpAWn+Hfr3slaY=;
        b=lsbwqlofmK7XgYnqZUJYqUyST8TfJPRgppYwRIcqGic/ygIpBMlbirFJDARkmD7BPx
         qhmo6Azq5JbhSQCahg8AaAb8iPlc2T8isXGxVWBTBXP/76Bx9MW5Qng/85NGyUdLGZf/
         XlCHMVb9vj7kEA60Wex7s3z1h1tWRBCkVGbTj52gXTReFpstHV8s2LnWTUeOMlHjn9yL
         2gEQUcqGRknngLfgDxvClkd4hVyGG+pEzY6Or11yD8aBL+3jEXjbjEJyUMM9zGbP+uMH
         hergdA3U8LHfI5rkqkgn49gTLuMr5CtJQsJw+Ojhf0OORmmyY0At0I3jifJHEXDaow/t
         y6SA==
X-Gm-Message-State: APjAAAXjG9ha1TjNfgwxJ2muZRHELJuoNb0Xf9P2/IXl94SGD6qKeNP3
        ZOV3ZQgKpoyM/Tu+e7PzobyXS3x5TTpyuQ==
X-Google-Smtp-Source: APXvYqy8O4qG3dwKnW0EOcGjZFu3vuYEnPWF2y0GxTJuw2mDe7CRySGTzukt6ADDnBQ26plh6+ns6Q==
X-Received: by 2002:adf:dc86:: with SMTP id r6mr4032445wrj.68.1578665255982;
        Fri, 10 Jan 2020 06:07:35 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z123sm2474628wme.18.2020.01.10.06.07.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 06:07:35 -0800 (PST)
Message-ID: <5e188527.1c69fb81.d4805.b9ac@mx.google.com>
Date:   Fri, 10 Jan 2020 06:07:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.163-42-gd508caa26185
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 72 boots: 1 failed,
 67 passed with 4 untried/unknown (v4.14.163-42-gd508caa26185)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 72 boots: 1 failed, 67 passed with 4 untried/u=
nknown (v4.14.163-42-gd508caa26185)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.163-42-gd508caa26185/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.163-42-gd508caa26185/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.163-42-gd508caa26185
Git Commit: d508caa261851cf05cfa501df31cb52777942dd2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 15 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.14.163-40-g258da0180=
e68)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
