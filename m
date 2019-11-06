Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0229FF2162
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 23:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732639AbfKFWGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 17:06:08 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37038 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732615AbfKFWGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 17:06:07 -0500
Received: by mail-wm1-f47.google.com with SMTP id q130so5509940wme.2
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 14:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EwqUl+P4xArqC6UIvdpfk4tYPCytfOL9kEcmuCuTFvI=;
        b=euz8Cag5jLrUOBtwgS4Dwu0EP9Ox2RtpZyPuNSDLPyszZUVaSJNIxhHdK6kdRxjoow
         7j+ncA8s3YXBYeaznmiYZg3eRGFh8NpAE6dqmYzvQTUzH5Wofb0Xp06/sgUq8yhZ/LZI
         +KKIylLEFHLqplqskm4fJzgAClY0Z2fiQTKWLTJv/wOhu1cafoGaATSbXNepTOOUBr4S
         N5g2ez6DI4gyxg8qS7mgrxdYNccPaT6+elxSx5tkVNPmFOb7g5E6V/1ryoKQt9X0tPy5
         XRqx+H3JcnTJUTn3w49D2XXkfPsBP+mMOsWd187D0tlNHxT4kM+mAOdT5K5BY611iC1c
         paDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EwqUl+P4xArqC6UIvdpfk4tYPCytfOL9kEcmuCuTFvI=;
        b=kcxSqvQjVboCuPo+nr8zwaGJAqOAqEUc1b2Au7f2tZ0TQpLofPu0rzlSoy6HvEa5QI
         sVEgrZMrU06mZlZbVpg8zfNgi/HUsUSpo8/iZMGubhTzxwos3qHnNHKlS/5YItDuRCmi
         EaQnevXpex+/ZcJh++lXrno7xGQQUt20SlQnnDwZnBhBLumiVH3HV+S0xfUu8iPQ2p2E
         cJasZlqUD/tRLcZnYMJs3ZH2sE9pKnsoWU/R3HsxQ0PezT5g3aU8T2otyvn8OxAz9BtJ
         3MQAtU532u56cuadhJHW0HOvmthzdVOrfqQPCDFgmGgRGpnCzH1eX5lHOyYbhvedxld6
         Tu6w==
X-Gm-Message-State: APjAAAUg2bqV8BD+pokzFD8KtlZjY3/B5b6zXULU90Q4OVoYBWfl4wNL
        k+kl4vzbvqLpynXRKq7697bq+HNkTb4=
X-Google-Smtp-Source: APXvYqww6CqMv9mIvAmMkAVRIbo8g8/1QnG4lXYKLwmBkE7trFU0+OMMxXYU1Oq6zq+3S5AqUmj3Yg==
X-Received: by 2002:a1c:cc16:: with SMTP id h22mr4901433wmb.51.1573077965605;
        Wed, 06 Nov 2019 14:06:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t12sm19010wrx.93.2019.11.06.14.06.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 14:06:04 -0800 (PST)
Message-ID: <5dc343cc.1c69fb81.7fde.01c0@mx.google.com>
Date:   Wed, 06 Nov 2019 14:06:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.9
Subject: stable/linux-5.3.y boot: 43 boots: 0 failed, 43 passed (v5.3.9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 43 boots: 0 failed, 43 passed (v5.3.9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.9/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.9/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.9
Git Commit: fd272dcd73353e737928d50497ec113fa1d347f2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 12 SoC families, 8 builds out of 208

---
For more info write to <info@kernelci.org>
