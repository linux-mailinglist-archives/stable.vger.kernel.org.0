Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDC1123FEA
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 08:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbfLRHAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 02:00:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40426 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfLRHAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 02:00:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so1002878wrn.7
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 23:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aExLEXnvgpj4ehEiLn3RGFCgI5DEilo1b6QWNMergy0=;
        b=x/DQdWAegFUcbHFY6UiQQzenrpq9dM0T3FIx4vBtphe/VZiLHRQcUVa2lAd53Om8Ob
         WoMrgnMStLo8JkoS8L4r1FEH7EbmVmJ1foDpEWBq9S6W4IxEVVTitfqI6YI9gv1GteXP
         dyX1Ny2dZuBqYrHBhAoRODZQj6FC60N/ZvHM6rfEK6tA7qpZGgRVcXGSvkmwyQwd+uux
         LxQtLUKAKkcVBXTv6+SgUrqcORJiuY55cXpN9h0EfuxgrFZ6/KrEtElIYhgl1pEak+I4
         8NpEiq3iUCQJN9Yg1TAjnVE/YaUmUfAF2luL5LzDj66uHNKeiqBMDmAxobQftjpixNyp
         JYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aExLEXnvgpj4ehEiLn3RGFCgI5DEilo1b6QWNMergy0=;
        b=YFRIQw/2FqMFQd0LD43KSxjP0UDHKw2cnlyrCwVq44lms4TRx6JuQSQy72VultVwTA
         V25WXKNbghZ42ZxLcD5mQpVYd9EoxUSMhL6MD8NRuGhjexGFBgFrFEZQ0n+AxOPMztqx
         hSmguc0JjK6+lTDgqEGC216J5cpWiX2SJsDRVQVtvehQj+YzE7ehseCM69+F/5I4m6yn
         uFSI4ABHf8Q5Qs9CcQJIfHj/P4H//m/uzs7tbsV16zhq4h6wlveFXa9C1qCagIvONCc0
         cIWqT7VA5DptjOQq+O9yJkJRxK05VMVl57K0lvAqJuQlm6ERIVDvyBr9UBnZPL2O1Mzn
         Fg7A==
X-Gm-Message-State: APjAAAVJE1vo//NEz3C8lJKKp9wVJkkos/5YcsCO6nRv6BUAW4kaJgKz
        VoPTODSCLuViMtYdfv+MzK8KFWVbvXKgEg==
X-Google-Smtp-Source: APXvYqzCY3sdBj0D/Taz+Qg7+KTWaueN2W2JqWOmJlPPShSR/ixZDLFUIp23L/Wco+lrLT/9RYH/vw==
X-Received: by 2002:adf:ee92:: with SMTP id b18mr857825wro.281.1576652430728;
        Tue, 17 Dec 2019 23:00:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w8sm1460869wmm.0.2019.12.17.23.00.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 23:00:30 -0800 (PST)
Message-ID: <5df9ce8e.1c69fb81.7c476.62e1@mx.google.com>
Date:   Tue, 17 Dec 2019 23:00:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.159
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 52 boots: 1 failed,
 50 passed with 1 untried/unknown (v4.14.159)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 52 boots: 1 failed, 50 passed with 1 untried/unkn=
own (v4.14.159)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.159/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.159/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.159
Git Commit: bfb9e5c03076a446b1f4f6a523ddc8d723c907a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 14 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.158)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
