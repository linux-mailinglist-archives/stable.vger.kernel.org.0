Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4093A3329A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfFCOse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:48:34 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45241 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbfFCOse (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:48:34 -0400
Received: by mail-wr1-f52.google.com with SMTP id b18so12357710wrq.12
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 07:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dTxrOsxUCXsXFGn572IgwOw5+RP5dDurYTRimMn6u1g=;
        b=uRtDSAb8eCcm3P1ma2ae3WTDQggzf/4+xfIDWMn38vayk3e11RkEdFXSmy6/YT9lXB
         ZncIm5E9Lbs8u79AqobiZ4SFXaU8T+c3iWERlnyueF7E28JMXyVGNMyiDN77v2Fz2wdn
         fJ/bLqLxN2DsWVRFHtGe77kN0iaq5LEqZsnzrKR/Hw5C2nx2GkWxh3gYCU8qUPEyyFdT
         9vHiTAdinvsUeM2TQqH0BUHmsHdkqQQ4n76LtE1W7wppz9MfLoWBHbE/YaRMYzYI3YSt
         cxYLoq/DNm3AHqGkKOlkk5wkLYkZTIJ6vJumEnBJjB0fAjN5dCSBkr2+XbeWINU1PeY3
         5qRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dTxrOsxUCXsXFGn572IgwOw5+RP5dDurYTRimMn6u1g=;
        b=bteCasZaTmYOC6AmlQXWCNB1peIhcz2X0gA+8wdI/dN6vlYmTQA+U47VezgOnEpocu
         f1Y4M8/BSHL2oizNfoF6miyakAA3SEeW7/YwxCO/PfNWVXHtpcuVnpUb5p4oB0KH+Ckd
         bmtr1GmwTmO2UErT0XK+oaBTsQHNCpQZot+L/vLDDz3sMTi4Dry0I9XmY8UFEyFeqJ2C
         CRiF3jOw2itIvgmUcsvrLPtNBtb+vp4cKMUKZ4GavSfOTFQ4TJVlGqBp4GzODuNszhRm
         yeHt41KeSF9Vle7YrsGbnJYkrBpnarQ/YypOPFfl/lxA84hCc6OIUPqJYKMRUUza1XrS
         dNUg==
X-Gm-Message-State: APjAAAWxIhnzKZEbrJJ4bTgVhUy41w0rbAMMTuRxEhVicGWymWjko8hM
        sDsP1jv2l1/AYbOraG8bTV9uj3lz426ayw==
X-Google-Smtp-Source: APXvYqyUsoQXhZi+ofHvUg4jHvjlrgKwVNWn5CSzUNS+sR/t5BMxZS6+/JlkwmUghayNTuL5MVe32w==
X-Received: by 2002:adf:8028:: with SMTP id 37mr16579495wrk.106.1559573313035;
        Mon, 03 Jun 2019 07:48:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s63sm6299957wme.17.2019.06.03.07.48.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 07:48:32 -0700 (PDT)
Message-ID: <5cf53340.1c69fb81.47692.3715@mx.google.com>
Date:   Mon, 03 Jun 2019 07:48:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.6-41-ge674455b9242
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 132 boots: 1 failed,
 131 passed (v5.1.6-41-ge674455b9242)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 132 boots: 1 failed, 131 passed (v5.1.6-41-ge67=
4455b9242)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.6-41-ge674455b9242/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.6-41-ge674455b9242/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.6-41-ge674455b9242
Git Commit: e674455b924207b06e6527d961a4b617cf13e7a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 23 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
