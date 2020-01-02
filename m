Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280C912ECEA
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgABWXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:23:16 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39470 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbgABWXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 17:23:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so40739235wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 14:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c9ZbD+8JbfneqRyteMAdsnK/8qoYSrJRtttLqwB1UfY=;
        b=1+k8A2xyDHObG4W7eiFaoMOt1Zo/BD+qf6HhX3mWmdOwziLSW4bMppXoAW+/PbUcnW
         zLZyd93qsSdjAziuBHcCJgtjitlTVGSQeKYH2zIqGiQvMBYVev+Z7uf+ruNd7V1lenn1
         qABrDn6FVxy3+jjZ4F5QSYvqOphT8sY2yvUwe1GGBqD0kSCHd+SC08a2wunQPny7WLn+
         E2ddFCnAFoXoR+YhKT1lJLku94JFAzQhozcNilFDXWoZmx08w/b1q+Amf5DeMD8/oQNm
         vRzn4KMo56hYciX3YCql63Qfx7/b9kXs6MISJg7oPoQHgH8vttV5Kxb2GGfDfZvC+rhH
         /Ebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c9ZbD+8JbfneqRyteMAdsnK/8qoYSrJRtttLqwB1UfY=;
        b=IB5mxNXDp0T/kUOqpQRFCp2G1mrTEoVicv9oGgb65fNTVoblkTPAICTBXBf39UnYsQ
         QF5bM4YSET7lZabjz076cH467K6bNmUTM47zoDEIxT29ECWWLlYjWTD9wO2xp9M7rGFe
         vpUHnl7Pc1TxJHGIMtboBHw/aWnJHHgOgrVewMIgRtp2TU1W5WXnh3bOkIfHAO07BHsg
         yZIn4ERRvf/sV8X34a4/OzDK5Io8DU5FtSAYLao/+MoOscTiwd/puNE1r2lTLAmy+zzl
         8WCbteA0DM4CrgZ6Gc4YhWZELOofi4AmfAUHW++TEPnXGMab9AP/FqGPSdRt5kEJiGsJ
         eSUg==
X-Gm-Message-State: APjAAAVO2ng0BwJ7mIKo0PSP9EODUoT5XXxiXIdBuep+5p337s14F7F6
        NR13+g4OQDNOjf2Ks9BL3CmurH1IrIQIiQ==
X-Google-Smtp-Source: APXvYqykiIGfqJW744zoNv3xtAA75JfAUEE8A7w1InFOHn5e5uD9Q/hUKkBSX0ToLimDAIVnwDGfjg==
X-Received: by 2002:adf:df03:: with SMTP id y3mr90774075wrl.260.1578003791837;
        Thu, 02 Jan 2020 14:23:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s128sm9993045wme.39.2020.01.02.14.23.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 14:23:11 -0800 (PST)
Message-ID: <5e0e6d4f.1c69fb81.8748c.e3a3@mx.google.com>
Date:   Thu, 02 Jan 2020 14:23:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-92-g10c651e610f7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 52 boots: 1 failed,
 50 passed with 1 untried/unknown (v4.14.161-92-g10c651e610f7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 1 failed, 50 passed with 1 untried/u=
nknown (v4.14.161-92-g10c651e610f7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-92-g10c651e610f7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-92-g10c651e610f7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-92-g10c651e610f7
Git Commit: 10c651e610f7d6e560ba67a77cc51d560bb1a188
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 13 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
