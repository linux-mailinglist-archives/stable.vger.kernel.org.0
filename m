Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993854DAFB
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 22:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFTUMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 16:12:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56151 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfFTUMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 16:12:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so4251535wmj.5
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 13:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9lG71Dhyjku4z4VvoSwS9coG776ou/zKKIv4xAGJt7Y=;
        b=HXL2RzYlDXNsLFCmhsOfvDAsN6HJqZrxUXO7HQw75OUDj0sRpH6b245Le21a2ZnNXv
         l+w8GPprTSEZtEkkAZputTTjT28gta3Xc/f97J9u+2KnNVYFaG2SujV1mLZkx3c4mvnk
         gU0TQciiytvb2xyWWtTh16/uOpLD78Za1vazHF5yjJ/bN/0tsGZmJXtZ+Qvs9mVLa3Bg
         OQBgAppk859CFtE3WrVHAxqHXdOIBR1+x0Sgaad6Y9NlPExoch2TTttErjqNoDtZ0ns5
         iX5K//sKippOf5lGNDtjeMrXfRIFpxTPvHpyzZqf/xyxvChaX0dG3WicDb1K5/7EQuDq
         H+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9lG71Dhyjku4z4VvoSwS9coG776ou/zKKIv4xAGJt7Y=;
        b=pDIGlHkOZqxq/7NEqBPIyeLqVaJFKKpWJ/uA8kTSrzgXo5d0Pa2gfJ7329FqhjlVBK
         1mlIoTvYMy11C+/oQYENeTTS41Jx3PL1vhg+Y/56fxHSOJz3dLuUBtoCL44H2rNWJLo5
         zv9hIQ03d9MkEFYwIkP5t2ndoMalt3lbvhdoQ1EYPeV/87RhVfCnQlJ8WWJyCN3HP4K3
         a+By4QhdaeS2A3piRamYyxBQYyziTEkZKXAO8NQlCQ48t9jftPWn65oj/6eE/dViTlxP
         v2pMLI/U+pr5nGhAd55aQrRijO7ds49GgttXLH+n8xf0VfoBt3IpHat/IPyXktfJ7aVQ
         XyBg==
X-Gm-Message-State: APjAAAWnOdAvmUIDxyUEyQtlVanis97fLWenEkDLwwUFbQ1EpqIHevx2
        qRqpWKVQExDxrlM6Z6ONsDNGqmmWW8QR0w==
X-Google-Smtp-Source: APXvYqyPgwHwbNWms6mCTaou+xsf9GsLs19cEgmBYWD+qvcgPPrscYlvPhHAf/6dXv6288ulG3PG6w==
X-Received: by 2002:a1c:2e16:: with SMTP id u22mr819281wmu.80.1561061565135;
        Thu, 20 Jun 2019 13:12:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y24sm468727wmi.10.2019.06.20.13.12.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:12:44 -0700 (PDT)
Message-ID: <5d0be8bc.1c69fb81.3c465.2e1d@mx.google.com>
Date:   Thu, 20 Jun 2019 13:12:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.12-100-gdd3e04c2e4ca
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 67 boots: 1 failed,
 66 passed (v5.1.12-100-gdd3e04c2e4ca)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 67 boots: 1 failed, 66 passed (v5.1.12-100-gdd3=
e04c2e4ca)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.12-100-gdd3e04c2e4ca/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.12-100-gdd3e04c2e4ca/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.12-100-gdd3e04c2e4ca
Git Commit: dd3e04c2e4cac1308721f3ffc619b13a20391b26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 37 unique boards, 17 SoC families, 12 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.1.12)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

---
For more info write to <info@kernelci.org>
