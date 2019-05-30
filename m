Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273032F5B0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfE3Et0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:49:26 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40201 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbfE3EtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 00:49:25 -0400
Received: by mail-wr1-f41.google.com with SMTP id t4so3186301wrx.7
        for <stable@vger.kernel.org>; Wed, 29 May 2019 21:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7ATiqfs0E+uHvtpM0bDkj4XevelQaC929D1TK4nFwiY=;
        b=EOE6LyjdrP97plMVzOHltUWkamM50dOG1DaKm8JlLq6D2czNLyyHjTV+7AMEMtseag
         A1harORo5rpyc9j6Xb2eYbf5likb8savJlJ0LcXMYDnkpRT5+q80euEfjET+c5hsoV8M
         3oLd/18rQVT1X4Upe4r16FlLT3X+rY/4gungORrNxUrZwROssqfqRn7VQAXVOJJ3Ho/G
         lQRL9JgemHBqe4m5N0fY4uP+QInC8RLhv5H/FqKwM1HK/nnMrsQSAaOtw+TJheZz+zTb
         r9BeBNV4Z8TjNNHatGcoHcPZ4iHjJkPH+ZTJZG6uEQ8JCgkDrIgVa5WoD9pF+PFJ9FJ+
         /Vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7ATiqfs0E+uHvtpM0bDkj4XevelQaC929D1TK4nFwiY=;
        b=J7W70U+p2zSRidk3QA75Mk3cterDN8d2vfFkEEctt38YGMNEtr+eIEQV37hib5SbR8
         rBI33l1qBFQxbWZVhB+k+Rxli4ePMj4a7xCrrsFZavTc/pEQypV705Q1Et8b3/u7nP1u
         QxT2C7pRIMn0r8fLaUG06SvEAjoeRVGDqXM9A/gjkVQ7XeKgYw+qexLjTxXRCO2Wwwg7
         3XD6Rfnp1vwSDEwZBbhSm+kL2RHkdyCE5b3rVSrlmXWCWyz2hJgzFyT/gw7uccfWFBwi
         WaOPa9L1DMCEd43e1vBSAW+PDg0F23wNRz7zjvXSQngUn6wxatwDAAFdEisvxRmlPpB8
         DzLQ==
X-Gm-Message-State: APjAAAXAd1s0Ldsf0cE9aaWNCBcTSd8qGPu9C0Dyy1zon+S9VW3DGT37
        AaqdZ5yFhc+mfTDwH1Yqpq3yCWbrLuHcwA==
X-Google-Smtp-Source: APXvYqwBWDmx5Fel2WbLCW2LI51IIhYKbTnnqpxDTy2L/GZxrddJY7dSC8SIk5ROOYkasn0j8cQWig==
X-Received: by 2002:adf:90c3:: with SMTP id i61mr961449wri.48.1559191764087;
        Wed, 29 May 2019 21:49:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k125sm3153459wmb.34.2019.05.29.21.49.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 21:49:23 -0700 (PDT)
Message-ID: <5cef60d3.1c69fb81.6dd14.f870@mx.google.com>
Date:   Wed, 29 May 2019 21:49:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46-44-gf17349f88f3a
Subject: stable-rc/linux-4.19.y boot: 116 boots: 0 failed,
 116 passed (v4.19.46-44-gf17349f88f3a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 116 boots: 0 failed, 116 passed (v4.19.46-44-g=
f17349f88f3a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46-44-gf17349f88f3a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46-44-gf17349f88f3a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46-44-gf17349f88f3a
Git Commit: f17349f88f3ad2f62c66596b86e4ea5bf5b1c195
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 22 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
