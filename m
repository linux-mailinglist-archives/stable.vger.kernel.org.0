Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D44206D9
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 14:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfEPMYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 08:24:41 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:34481 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfEPMYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 08:24:41 -0400
Received: by mail-wr1-f53.google.com with SMTP id f8so1769978wrt.1
        for <stable@vger.kernel.org>; Thu, 16 May 2019 05:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EmD7kQD5j3+UIXELWIJod5oV8YoNhDE3k8obdF9sHCc=;
        b=oWywDoXitbrQ3trAJy9OMzW+tbhhH+DNJDABSmRWGWJyNomXIwAJ+X8sfFPawzZ117
         kRJ1Xbj23uE4/HC+MbGyyU4VAwIXQPaFc6psr/KSyCm2GihapjqksY/8ofWFWGYWSZ5F
         WmbdWrCdj7Wtw6npRwjNDmTW1VDd7sdZmmCFCUBnJpiZvSlAwd4F5uMC3v/l2Ei78Uxl
         H5Hz3QHVDi8o0YLPAMrzPnw7GljMm2BY5FZAHjMq+/fkZDEbVEIunWp1Bv1W6DQNu+HG
         ew/D6QvY+4hpkW28gLSVYuigsWF0nUxifodBDTezBFacVQAUT66KzU8HmIXT8Dg7uTdr
         UYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EmD7kQD5j3+UIXELWIJod5oV8YoNhDE3k8obdF9sHCc=;
        b=sY2WTBvvyPx1nZXQM9TXTXnTjPfQB7c6avBVZvE2BhVh3VGAfFO7aUwVkgfYyFvAo5
         2xMSiGm3lbedGNEZ22ER/OZMwf7k4MsCfGBJ99iju5BIAKT8EHPPvKpxDDu24mdkBUdd
         nMftJaNvWK0G/jc7EpOrSOrp7yKFC+F0w5IhM/en80KXM5iRDxjlQQZWrjo3GN6DidL2
         dC0Cb84FfptqAYo+pgV9JGVTapxTmjD3hOjnt3F8ckJLzRyJ2nqFUYxBgICl+q6VSgN+
         7fn3PSEZ0vJ5GVh7tIezhESVq+d2gfcFH1zkI4FtH9heKvDrc5Rf1hHywCF5TL6gNZ/E
         U4mQ==
X-Gm-Message-State: APjAAAWUy5ejn64rXw/fQVnYZpr6iAbtsACijg9uZV5BzOyS9yNfQSW4
        izhpa/IfLJruB5Cyiszr38ytqTSGzSilhQ==
X-Google-Smtp-Source: APXvYqxdzbke2kVFmb/CFxT3FWwsQvYcqK8DOFHrWUU3zWgKvdsdWvNUHLQflq10XmKgHGC5Vs1Mug==
X-Received: by 2002:a5d:68c7:: with SMTP id p7mr7897495wrw.23.1558009479464;
        Thu, 16 May 2019 05:24:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a8sm6101494wmf.33.2019.05.16.05.24.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 05:24:38 -0700 (PDT)
Message-ID: <5cdd5686.1c69fb81.4e98b.3c41@mx.google.com>
Date:   Thu, 16 May 2019 05:24:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.140
Subject: stable/linux-3.18.y boot: 27 boots: 6 failed, 21 passed (v3.18.140)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-3.18.y boot: 27 boots: 6 failed, 21 passed (v3.18.140)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-3.=
18.y/kernel/v3.18.140/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-3.18.y/k=
ernel/v3.18.140/

Tree: stable
Branch: linux-3.18.y
Git Describe: v3.18.140
Git Commit: 6b1ae527b1fdee86e81da0cb26ced75731c6c0fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 9 unique boards, 5 SoC families, 7 builds out of 189

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 4 failed labs

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
