Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E90175B6
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEHKMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 06:12:36 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:32981 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfEHKMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 06:12:36 -0400
Received: by mail-wr1-f53.google.com with SMTP id e11so13366767wrs.0
        for <stable@vger.kernel.org>; Wed, 08 May 2019 03:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5nlaOEENeyLKPXOV0hJMvD/izkwYL/Vzqu2kY4H1l7Y=;
        b=dCzrlaRbSDmvt7GcssymLtOioHVnr9wVtxdWx04Z38ZmnHnyCqZeB8uYcH31GSfAMk
         gMYRa6jTbmjJuaaIpWY8UAqfE6S7fKDEwvkxzp1nxXzhtbgqb8OauHBV8S0EYzxIIaZI
         cw6eTQT/EeS22kZ0G/5ueCWxEXtnyt9GxKJ+Zrv8axyr/+dhKVX+UZXjpPAq201EL1uf
         zBweHflc80cp+Ha4wsMvYh90Hmy9KpxpfJSNNsbR7etVQJ87lpdT7jTIjxhryBKDuHvr
         Mz4OVHmC6l3Qc+/ln9wQFRb7x4LEvYahAwWKm45/rj65S/EB4fo7DwCZT4iPZETjgR2U
         QSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5nlaOEENeyLKPXOV0hJMvD/izkwYL/Vzqu2kY4H1l7Y=;
        b=l7RUlqTEDPT4FyhTLHTUmJvQNRTY18TxkzA6AcCFpjoNMd16QANZhu8eR+RI1AQCmJ
         IOqmrCJjmKDkzVDX0K0/e6PZ2HUFj2C3tUfIBuuIOI2vHV1OyyI8wl0jwrlq4KFl30Gh
         hXz8AhdK6YrxdzK3WdCtW9JZqxay13+UhHdk7n9chJYhGpvnk9O5wiQZXE8Ez3MxocZE
         6inEmjwHgzf2lnm2LHx8o9OdnCRDPIthLfzKgNrl1OrLswoi2EsfMquLaRlwYQESZNdL
         xcdOTHmeR9lwbACisi/xrFqEr5uUya/YPTjpI4Y+o8U91PuYQoBOoKoOL1qnCurZUY9O
         2LCw==
X-Gm-Message-State: APjAAAX5XNPDlsuY5t3Vbd48SMG1Qr0OY7/dzPRyu8i5OXNX/LxAmczU
        SrZvZD6+aP4PS09W+DFQS7T2RbCnhETiIQ==
X-Google-Smtp-Source: APXvYqyZAcJAfW+1qaRtyMEvfzbkj8wARTCmF/0d8Nv4Gd8UVWYU/cieVPiaBw3u0FlrQUOx3uAEvg==
X-Received: by 2002:adf:fe49:: with SMTP id m9mr8110621wrs.73.1557310354398;
        Wed, 08 May 2019 03:12:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m8sm27905564wrg.18.2019.05.08.03.12.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 03:12:33 -0700 (PDT)
Message-ID: <5cd2ab91.1c69fb81.33a48.3906@mx.google.com>
Date:   Wed, 08 May 2019 03:12:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.14
Subject: stable/linux-5.0.y boot: 70 boots: 0 failed, 70 passed (v5.0.14)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 70 boots: 0 failed, 70 passed (v5.0.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.14/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.14/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.14
Git Commit: 274ede3e1a5fb3d0fd33acafb08993e95972c51f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 15 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
