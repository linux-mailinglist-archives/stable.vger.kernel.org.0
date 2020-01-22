Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855FE144AF1
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 05:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgAVEzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 23:55:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38008 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgAVEzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 23:55:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so5736022wmc.3
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 20:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fksy4y//5zzZ05RsWfsIoQHnm90FRLor2VjCSrvuIXo=;
        b=knmJMjApFFnVeAtV2IVlhDG4HJdpXQctcw3QmmpnzeCslTCKO1DXnXooZmfBdiX3Nn
         m95AlK93W4oFJ3oVvH2TJapkePQrC3eNk6SBXDIJzhZd7cm3k8XaFQ7SFrsIA7VDeIpV
         WW8WJYke8ZEx6KKSxtUCWBzOy5nj4vl4ZgF1s6hiEo0THiPUlw/J/fcvtx+0J5uoiQfj
         Csyoks8mh+dVw02uQpL3p02Oj8sE8duEEWDG2uzxo3qf+OQnCEbxAvk87srFz3aL3mFr
         d1jrgiVX6CAhHxImgxA7u0x9qqsnl5anl0O225WpXaIAi4bL5suDlEWka56ez1aBfEZH
         pYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fksy4y//5zzZ05RsWfsIoQHnm90FRLor2VjCSrvuIXo=;
        b=UYQSHChwYoyKPP16WaJfspcykLHBZO3JEEfYj8d8Lu9Xt1Wx7MGnV3BPrSMLMU3+jo
         b1ODA+aDH50PIPp45ZtPOL2JEHxUcyIEPultjvRPyWL8ySpZdLVGx9PCmDndIUcW+Shx
         NrArzSAxnWWZRWREl5cnGdtjfW0kSOoAw7fjWZJF5pmFpC5G98GKDXgWGjHNW/TfqCQM
         O0LAzkwig1IjaaTBsuikwnG1Uf7xV9jYtrwRHI5Fi9I9Zj5YuV6cITcwt6VVszCQu8ry
         LYuRaMuKt/1nJfwKQYmua0G5KKpKfiUVlcQmx7EKvaV+o32mFWFSN9VZW5IIRbj4WE3j
         cjVg==
X-Gm-Message-State: APjAAAWYmCuQjYLocchZGdepvh6zT60ISRNF3VZ691fjieK7Q/XLCznD
        ZNPK/32l0T8mql3Dk+L3bGOPCTTZaXF7Pw==
X-Google-Smtp-Source: APXvYqx1/Aq11OCEzz2HpvXGdKzcPfnts6Yty4o+8ruAd/NB3X6jTngEvtlEuxFl038fz2/HikkyEQ==
X-Received: by 2002:a1c:96c4:: with SMTP id y187mr746965wmd.112.1579668949210;
        Tue, 21 Jan 2020 20:55:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y7sm3243840wmd.1.2020.01.21.20.55.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 20:55:48 -0800 (PST)
Message-ID: <5e27d5d4.1c69fb81.fbf00.952d@mx.google.com>
Date:   Tue, 21 Jan 2020 20:55:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210-90-ge20d090cbbfe
Subject: stable-rc/linux-4.9.y boot: 53 boots: 2 failed,
 51 passed (v4.9.210-90-ge20d090cbbfe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 53 boots: 2 failed, 51 passed (v4.9.210-90-ge20=
d090cbbfe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210-90-ge20d090cbbfe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210-90-ge20d090cbbfe/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210-90-ge20d090cbbfe
Git Commit: e20d090cbbfefd4e4f49fbd3b5535ef965533294
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 28 unique boards, 13 SoC families, 10 builds out of 183

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v4.9.210)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            alpine-db: 1 failed lab

---
For more info write to <info@kernelci.org>
