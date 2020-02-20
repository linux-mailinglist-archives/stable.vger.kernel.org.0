Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C2316574B
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 07:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgBTGIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 01:08:14 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53686 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgBTGIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 01:08:14 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so414746pjc.3
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 22:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4zKzg20LXxGqvxm8sOZd/00DzGzP+6WwxTqN7K4NA5E=;
        b=thFUbrnE70r7p3d+ghNNKE5jyBb0GyMYVtqO9EhsxD5wkn2cBY3mt4CARX6gyjvZT+
         03uWnanySBagdWLKPALjvQ2YDZD94EyFUMxe6MB5D5KAB1cs1pBaALPCXeyZbd5u0z0O
         /nu7s5R7Vd5G5958TuqCgZ3zcUR+Oxpbwg6hRY8DIZto9w3iRwded8vjp8rprrU02gGI
         Kw6aBmxvQMBhI+diPtfF1m2U9NY3BpvoY6jqIrDgIHv+TR1AvLKyoIeB+0QzMznpJiTO
         ZdnEN7TPQDbV1hGcYpMltmEGWx+Wi4Wz7r/pu7384+92+lHDPO+Rrk8VHk9h7dP/Shxp
         Pm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4zKzg20LXxGqvxm8sOZd/00DzGzP+6WwxTqN7K4NA5E=;
        b=GAjWSeBRNQjbbQP5yEDaYJSXn2+Gtf+XQzI1gRhywMyIH/Vi0yzZH9t5nRhhVwBVjx
         8a0YUqMjJ/Bfnxyka5gLMer5m0S5hELBxvEa/K4C1qvNJMw10cvcYcTtIlmGWxeeU0De
         yKO3wZqipGXENYSNS9bEo8c1kyhqxJ+gWNYCEv5e9yXuyxLonDGnZvzAXyfUuhwQDjQ+
         KM2VMlYu52/B8sTCvudaADddXEN+XqIpVnGb+T64+hsADctTPtyq6I/kdbt5U5A3Qtyw
         GZh3qU93qaOTgt8XMMNb7lfeqouIuiHrUWLuobWC60rR7OO/CCIfj9LNuTilD+kYvbAC
         Asbg==
X-Gm-Message-State: APjAAAUu1Ddt/oTTenhURtsOL5Tqip4GuAHTCeLz/twBSp130gMvDRTv
        dsRk9Zq4RR8YnIIwLhT6FXngQ5lE5bY=
X-Google-Smtp-Source: APXvYqy5adjsqi6BTyD798faugSd1wnfJ45D72PsG0qz/Ke3r5gCc9SX49CJkixu+VKZi5eF8iu8vQ==
X-Received: by 2002:a17:902:8604:: with SMTP id f4mr30518702plo.278.1582178892167;
        Wed, 19 Feb 2020 22:08:12 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fz21sm1592485pjb.15.2020.02.19.22.08.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 22:08:10 -0800 (PST)
Message-ID: <5e4e224a.1c69fb81.f81b7.573d@mx.google.com>
Date:   Wed, 19 Feb 2020 22:08:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.214-12-gcdfcbd60833e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 3 boots: 1 failed,
 2 passed (v4.4.214-12-gcdfcbd60833e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 3 boots: 1 failed, 2 passed (v4.4.214-12-gcdfcb=
d60833e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.214-12-gcdfcbd60833e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.214-12-gcdfcbd60833e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.214-12-gcdfcbd60833e
Git Commit: cdfcbd60833ead34457b09b11989d9ec77e928c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 3 unique boards, 2 SoC families, 2 builds out of 57

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
