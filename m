Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9BC1C74CC
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgEFPZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 11:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729965AbgEFPZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 11:25:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A066C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 08:25:10 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so1031832pjb.5
        for <stable@vger.kernel.org>; Wed, 06 May 2020 08:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tqOaOqcgJ5B7q7yxOLmkCyA2cbSH3uXXvo8YvOrS2IE=;
        b=n07tyaYvUhv1aZWLupY/OBST5kMpD6LF0N8aAI8jURl9LL+eNKxoNQu76+RsBFJZvW
         XWEihBjHiBuYYQQBR3h4jn7LmwWZr8oNrDtqgBSoCsvxPd51EruPeAYkmFLuO7SAZi1K
         xz+/Ynkt/emFOFBI3DjXggdZn+SugmuIlwYc/29xpV6UtDs9/RQktSKSbJ0GtVs7PxFO
         /YpkLOgZTR/jZu0CLTta49Y1w+Yw/oFRmvlGgS5tOfn74yaLcaNf8Eh/nKvAO1hTzn9x
         mhUijLJ5JC2CigJGxHRSo7en+AvZpmCDXdWAVERAa1ob9zLj4ei1J4kb+dfOQ4Zz0p6V
         0XHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tqOaOqcgJ5B7q7yxOLmkCyA2cbSH3uXXvo8YvOrS2IE=;
        b=A7ae+y4EjWYeasLbB3BdXu1pyQa5k88KUy8jPbJNOVDD9lWxWPfrCZg/5m6a3ze9/r
         j0IaQgJEuUveF7n1zo51NnuJaik8+U/t+VRTnWdFETLDmoE+pqFukIVWzrB6N4+glAR8
         04ouXMzNswd9W9ITtIOFyhLE/df/fE3DXZkV/iEiTGIA+kHXBaUa81oYyGfiaSM+uDjK
         YlOhYVYWNYZ7EOUogtNzZ7HI2kZ67SfiqMSp8RnmmIIu6dts3eYulQrjB+ZIy4u5ZlKT
         ScpKJQRduOBZeQU75hMH/mwswXTWzL/S+avYpemmebbK1yc8COOYJAlajWbgiPmVXX7d
         OaUQ==
X-Gm-Message-State: AGi0PuYOxRed6YsyeYH/pCeG/hY42ImHDReEP3xUfC+tkDZkqoo8/u3c
        90ubIWFDJ1pOvNXnS+MlaluyLKEM9TiePg==
X-Google-Smtp-Source: APiQypJjjjEqV2WR/FFWTjksDJFeSDFcVjeA2vSweCntk39hj6q0dDKolhmVYOUGm7Tzttw0CffmBw==
X-Received: by 2002:a17:90a:8c9:: with SMTP id 9mr10253636pjn.183.1588778709356;
        Wed, 06 May 2020 08:25:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3sm2105445pfq.110.2020.05.06.08.25.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:25:08 -0700 (PDT)
Message-ID: <5eb2d6d4.1c69fb81.89a40.683a@mx.google.com>
Date:   Wed, 06 May 2020 08:25:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.39
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 99 boots: 1 failed,
 96 passed with 2 untried/unknown (v5.4.39)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 99 boots: 1 failed, 96 passed with 2 untried/unkno=
wn (v5.4.39)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.39/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.39/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.39
Git Commit: 592465e6a54ba8104969f3b73b58df262c5be5f5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 71 unique boards, 18 SoC families, 17 builds out of 200

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
