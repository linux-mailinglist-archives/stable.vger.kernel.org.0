Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA8149604
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 01:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfFQXjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 19:39:15 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:45361 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfFQXjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 19:39:14 -0400
Received: by mail-wr1-f42.google.com with SMTP id f9so11797219wre.12
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 16:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XpVeh+sz8l0MglOFihLIUBQe1u4nS2JU8kbEBnBdz+E=;
        b=TaoS56k//nc3/yNGzEwhGdUrXIHkMRRIwP4Xt/7OoGz0EWUO/KrVbu2PIhz0NCD+pD
         uG5YrRwAbZQ8vgeSJ59J0BwFX2bBk3Fhu2eBAPvPZI38eXnwygAr7hnadNcx08ReHkzm
         uy1Fc0GzJW2AtJFkHWdMXZDwhPNtyL8Bvd6GxfRaNDHWsiUOQyfv4hO6hzHBjfc46H+W
         +gF1TDQcjmhNVxupWVYul9RJvnoa6brO2GXts5vmrRoEbbILj9k4RIzvSKpg3OIq18Dn
         LRU25eSCDZOKqQ6v4gQha999siRtLeMWg9GPFWiHTX76umhbfYMX8wpq/y/TTQydDpnx
         m3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XpVeh+sz8l0MglOFihLIUBQe1u4nS2JU8kbEBnBdz+E=;
        b=hkgJ25e/Da41uVrwZtldkbkr1cmXk/7Kz/N+YjDPZbcvsMuDTMA5mfnBZg8royTGTC
         /7k4HOtdpfvSNuatFg6o/TVixaFEs+WUPKSoGIWcFl+MBrXhtIPIqOsOmK/QD8Er4Bx7
         IE5vIuog8VXDf0juJ7DRDsplv6mi6971ANHUEpOFnJc87EsKRz1TXBDM3BoBhiP8Ku+e
         d4hOa+OtlXcGiyWyXAttxrCfTVuTUoI4JN+uUT/UsZaFBhQrA4wGQQKHcnTasj9cR3wv
         +YhMgrlVA+71T2tpq7fKDSLUy4FRQnJOnLCHHtRI3wPazHVuCqRK9lqu4+Lulv4LRDci
         l6JQ==
X-Gm-Message-State: APjAAAXK335clxb5aiC1bbMvHsEtyPFuXd5I4+GlrArxbsEn1xDS7PmW
        WfjmxfXTnpfBszvQ16K7iHNeqS2K6hJ7rg==
X-Google-Smtp-Source: APXvYqwHURNmExp8YFy9ie1V6ItaWaA6XqI9VcP4JCv5CZXSEtZFLCmj3Yh8E6VfxZ70Aouh8IySCQ==
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr34596632wrs.2.1560814752323;
        Mon, 17 Jun 2019 16:39:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x17sm15095113wrq.64.2019.06.17.16.39.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 16:39:11 -0700 (PDT)
Message-ID: <5d08249f.1c69fb81.70311.1723@mx.google.com>
Date:   Mon, 17 Jun 2019 16:39:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.127-54-g1ed3ad23f285
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 105 boots: 0 failed,
 105 passed (v4.14.127-54-g1ed3ad23f285)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 105 boots: 0 failed, 105 passed (v4.14.127-54-=
g1ed3ad23f285)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.127-54-g1ed3ad23f285/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.127-54-g1ed3ad23f285/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.127-54-g1ed3ad23f285
Git Commit: 1ed3ad23f2853e59a94e55528b42112d3e00c842
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 24 SoC families, 15 builds out of 201

---
For more info write to <info@kernelci.org>
