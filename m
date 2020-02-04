Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19040151395
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 01:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgBDAGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 19:06:23 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:54251 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgBDAGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 19:06:23 -0500
Received: by mail-wm1-f45.google.com with SMTP id s10so1281351wmh.3
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 16:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pz9pum+uRPXon9tpDMfNgwXvvE8qAwUMOu6hp6/R33A=;
        b=xWAqSspcTqfCrDlo5SpENOwX/96SSS1g78trICfmea92A95JpL5qFfWeWpb/BujBIf
         PUznc86Zq2Ld9Bp7Y6OabHaQCXIhoD0b2m9hpthTlfXQxYvtaLYVV/mKiBaDerQNaT9q
         9N14xO6kefYFb7XL0yFl06Pof1gKf4X6r14jSE+oPCIhHgIGqqWg7KGLWOAg1XzfNyN8
         tUeIuQqBhbPcPD3WzGMxYU8IQyzUodlTJyKnOKWC+U1LSKZE9Oi8zXkOI7gHGXxLOZ51
         7W1q8TJ9BXKQ6cvK5BR9rYSso4K1WGFQM1cpWBxnbRrL6My0JiSzVh9Uwzkg1kw0eTcm
         MBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pz9pum+uRPXon9tpDMfNgwXvvE8qAwUMOu6hp6/R33A=;
        b=Vkt9ZnHqiFWEQSuRm6JKDI45bVlmAGU1+gCuLzd8xw2orT5IZuN6TpUed8C9A48LUK
         gpsEgUQFMjau2b+BsNKZXbhx3JvI9wA1r1jk3i7r2xEPYTnyA1bzDKR+40Doh6RtU32j
         lJmL67BRjyHVLCT6krzNg0VUBhpqzBg7utMh7MCdOX/sQI80W7xUUrj2lh0z2R4dkfnv
         jmjz0uySCrWDc1s0Z8ALVPax3Lp8NRBF1bP/K+MkUxLSooC+qd34BqCfLdbS7m3naIwa
         tcOo759IHHlLGMmGaO7kwXw/gBXhuEKA4IYBHSHzFp+QAM6wpSFoAHFhGBDB8i8CDfDV
         ds6Q==
X-Gm-Message-State: APjAAAVyW3zbYDUNQwO5Swtm2/Kt4JmknVHZJddTf1XzHCXUmJtK4v/B
        c8YXNQFF1f7CzbbcKmYcfvfTfKYZKRNGyA==
X-Google-Smtp-Source: APXvYqzO8e6xiz8Ptf6N4ARBRocMi6akALMTyq3xPfeL2bTOeoA4xYZKFOjDRsfH1BnwLHVaOf2dzg==
X-Received: by 2002:a7b:c1d0:: with SMTP id a16mr1510603wmj.175.1580774780945;
        Mon, 03 Feb 2020 16:06:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s22sm1294429wmh.4.2020.02.03.16.06.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 16:06:20 -0800 (PST)
Message-ID: <5e38b57c.1c69fb81.c8faf.68ae@mx.google.com>
Date:   Mon, 03 Feb 2020 16:06:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.212-54-gb514f5a16f0b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 19 boots: 1 failed,
 17 passed with 1 offline (v4.4.212-54-gb514f5a16f0b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 19 boots: 1 failed, 17 passed with 1 offline (v=
4.4.212-54-gb514f5a16f0b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.212-54-gb514f5a16f0b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.212-54-gb514f5a16f0b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.212-54-gb514f5a16f0b
Git Commit: b514f5a16f0bced88bb83b1bf71831af257ccb59
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 18 unique boards, 8 SoC families, 9 builds out of 144

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.212)

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
