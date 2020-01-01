Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB3712E0F5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 00:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbgAAXEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 18:04:45 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38020 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgAAXEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 18:04:44 -0500
Received: by mail-wr1-f41.google.com with SMTP id y17so37803113wrh.5
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 15:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tUqCnSdF9Z2T9VA3iuHBG8knNI+kpFyEnUB/INHlnFc=;
        b=HHPlxXoOhn7dgns1kGPsI8lBsFcOn1aBL1ovJauYH8JBh9VhBnTkm8gxh5h1wlJJ9o
         Ub+YnD+fbFvfTtry8ntW3nPXybsFEAa5DOKPhsvOCyWj0L96LV6ij0mI0o57tjjxOPyP
         FxB1fq9o9tSXm+W9wURfxCAPzjXeGerPThMUgprBXXSP3oQZRbUZ+vqxxQH12LhwP3tM
         BcIQCtiIhCtuNaYo1sODYTedCjRlMMkaVGx0qJtP4FFm3fNfeCAwox9PDpmZnQwhsSQx
         fWiMXyrEfSP+ELN3dCnjzh5DABvqXkOgG6NyVLcXkjr5zu6TL6CXVwFAsP48iwCba6U/
         aV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tUqCnSdF9Z2T9VA3iuHBG8knNI+kpFyEnUB/INHlnFc=;
        b=rwvnlZNtRSMylW6tWwtk31u2bwraIw58r5Kp6NWi6Y180njP0gNFjRBMMXosLmt6YL
         2+KxcgM236A62db7AQ/Crr/AA4OACm6OSWWPYrIjlNhG0NHu648IIwcU9dLWIAFMVhIx
         3Pne2VbcUql9O8MBzgw+FyXBUGFSg/k0E8ySzOOSGRmMsNyTQfxL64YMdxoN2FET1mA0
         4baDekDGejXoTfEfCe9FdBxcQluY4HVf94Hd92DDRoBYtIlaO7oTjWiDvE8Z0LVf122w
         c3zMQUX+9tcH7dvIJIikgnlQS2xSQbyNLQ4vR/kQlR1SMM2w4vKzGq22I6A8VeF+YfVf
         UXBw==
X-Gm-Message-State: APjAAAX/3LmmXml918lzCxv6M2g4oZSg3sz8QW1bI3AHPliXOLEcP4Wt
        O8zcAucEUx8797hkeECEyq/L5864+BMHKg==
X-Google-Smtp-Source: APXvYqx0x+7ofl87Al1e7flrdJ2yz5haKeqF4CkhoJH7ZxOEHZcXpNyGMQfL1ej0G/QvVdDWnXx36A==
X-Received: by 2002:adf:fcc4:: with SMTP id f4mr79427756wrs.247.1577919883020;
        Wed, 01 Jan 2020 15:04:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t190sm6683435wmt.44.2020.01.01.15.04.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 15:04:42 -0800 (PST)
Message-ID: <5e0d258a.1c69fb81.f9e45.e6a6@mx.google.com>
Date:   Wed, 01 Jan 2020 15:04:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-136-g0202b52c9813
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 20 boots: 0 failed,
 20 passed (v4.4.207-136-g0202b52c9813)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 20 boots: 0 failed, 20 passed (v4.4.207-136-g02=
02b52c9813)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-136-g0202b52c9813/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-136-g0202b52c9813/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-136-g0202b52c9813
Git Commit: 0202b52c98134a16af6fee502cee3c2d80ce96d5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 15 unique boards, 5 SoC families, 7 builds out of 190

---
For more info write to <info@kernelci.org>
