Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA06CFD66
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfJHPQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:16:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44541 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJHPQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:16:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so19824530wrl.11
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BNCccIsRlGQHWDcGnWhF68if+yo25plx9u6ffEHA2Tk=;
        b=P4Av/7x7KKZtFme3U+thIN1kIJuNUhc4/00ZR56hSdsqKcYPq1biSovPAehUemCpRq
         1wnh/2rrE7KdGcA4sNT1Cox1IKEuwYIfkJfmIUSYkuEGxOYlN337kgsuPZpzdM9H+9xP
         rAWUELNDpMd7BN9vazybvWlABIGStUorWH6fyKKaUpY8ehD8fYdcflwmnyYsefTtgsYC
         r3zifh9IMnc1F+HLaJEOEpJB//ND3jiBg2qKE6roYi6Uj1pNv3EKaZafxH73YpQoQbu4
         +X9rJaXGENHAXyd1C4qaugoq7sj9mSnyPQ7wEBcrM7d0fvOsFvzK0jXBqoxrl7piP2/+
         +KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BNCccIsRlGQHWDcGnWhF68if+yo25plx9u6ffEHA2Tk=;
        b=dMaoY4HigEY2r5vg/KlFvG5pSNP5VycJd9Mw7f8dBDSt6uhDzvNkhXbbHSgE68QKlj
         xbP0wDEoJ2+rKt56VxehrUyLN7fb+XSMZSXYUEa0tLOgyWHbs40s4iXKeeXl9oVc9qHv
         0gaXfa8qYwFFlWSDUv7SpVM42zaJh/1BLu6YZN5YoDf77+KoB46jojeenYFh3noKLi2k
         ucDlsgEUX5CqgAt0aAR9L9bFKYItGtbPPpQ7eHJeIRojwZnmkTPeHO+48vc88ABKuleI
         UpnE6aIUP8gAS7qe6mPa6b8VSbgyxsvM3mXnCOndXJPdTXNtGWCnpgal0oWJBMDtbwBJ
         dXtg==
X-Gm-Message-State: APjAAAWTUgzRPzB8AIhn+i5fq747NtlphTqJzeWNNpQYYDOwTb5oLs8c
        4rIolRiZ41Oy2wwmmt1B+HGZLSjZr7GrQA==
X-Google-Smtp-Source: APXvYqxwKIxNkJ4CBU/lW+SspVIZ/87Bg0wlogsEL3DVVIK8q9X27eQB/lOqRfTksXgSIwC5TsMa/w==
X-Received: by 2002:adf:f081:: with SMTP id n1mr263640wro.273.1570547809025;
        Tue, 08 Oct 2019 08:16:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 94sm28398315wrk.92.2019.10.08.08.16.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:16:48 -0700 (PDT)
Message-ID: <5d9ca860.1c69fb81.af96f.34d4@mx.google.com>
Date:   Tue, 08 Oct 2019 08:16:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.20
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 69 boots: 0 failed, 69 passed (v5.2.20)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 69 boots: 0 failed, 69 passed (v5.2.20)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.20/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.20/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.20
Git Commit: 56fd0c9f54730c7049774c0aa2a73151b628b735
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 16 SoC families, 15 builds out of 209

---
For more info write to <info@kernelci.org>
