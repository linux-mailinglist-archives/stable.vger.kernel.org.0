Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD495F6AEA
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfKJSyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 13:54:38 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54075 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJSyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 13:54:38 -0500
Received: by mail-wm1-f48.google.com with SMTP id u18so3435525wmc.3
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 10:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5tiE0WwenKxoSfrX2lqs+m+4Jg7NsxbEL20AMoSCD20=;
        b=tEh6bxvuPtFve+ddFqQN86al9SL7N4XNl13eBFPckfxB9KEVVDIJzt/dNRnOOYCMUW
         dxEht+1pE7fyEDgAf2DEb1k2OVf1NYT6Gzwva0vubHex2G9rXXvkrCQMECr9Z0Oy4APQ
         aWhKSIyb7C/UKwSY15uLKW9BAblOojKboj0vsf9CWjdFiYzPzTUaVAwK3mu8XmIx7MxY
         3xa3eL8aQSyvHUz9Xoq8DB1LsHW1LBXylC7syQ2oInEl7ZH+4tKZ2Jl2w9t6sR1Dvku3
         YpnZ1EmgBMNZ+fOnjyq9qd0bfyo66q4J2B5T2r9PCd1X2C56VbGRb5P/jAEvPgv1H1Rb
         N15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5tiE0WwenKxoSfrX2lqs+m+4Jg7NsxbEL20AMoSCD20=;
        b=W62RncyNnJPccypBpahQL9AeptX4tC/pJlhNaHrOvtwghc5RvMA08uKzwX8SHuY5Qd
         jCu8t9DMzs0RygwBMlawKBkYHFYqFQIV0b1KBbL7MrGyESAmEF3rnZL/HqkWfZ/xn3Ns
         03NM53qu776orfJeYBPFBCF0jy7oFTPdp1Xtl5QCvgMvhNj40XjUiTGXbww6+DSmGqaY
         M3sZ1s3KTqPNJwuxLnMOmJ1rNevu5ZTofTnU4LhyyUiWQF1ibWnXPjViYa4ZQmU48c4N
         5L3tZBFQ42FhyDWh8pcUK2Xd4MqC1kQnFLegKvtx3puFEVYJrfr+LeVvEYllz08Pg2tK
         rxdg==
X-Gm-Message-State: APjAAAUoQrzZspJtwWaZGFgLpi5IIaJZuCWMls4ZCm76zDWEqy4h0FDl
        5LikiLq70qhARUNkbwXwfgeKrkVmqJw=
X-Google-Smtp-Source: APXvYqy91hiRBYI3vtl8h8279dvUD0ofzPdlnOqlWlLZSBMS4BF7NPap760PvKpSu9KtMwlRpGmPPw==
X-Received: by 2002:a1c:2155:: with SMTP id h82mr16613304wmh.94.1573412076349;
        Sun, 10 Nov 2019 10:54:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v128sm22409850wmb.14.2019.11.10.10.54.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 10:54:35 -0800 (PST)
Message-ID: <5dc85ceb.1c69fb81.7c870.77d7@mx.google.com>
Date:   Sun, 10 Nov 2019 10:54:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.200
Subject: stable-rc/linux-4.9.y boot: 46 boots: 0 failed, 46 passed (v4.9.200)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 46 boots: 0 failed, 46 passed (v4.9.200)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.200/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.200/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.200
Git Commit: 574a61d201df8f159162bf706de3645b62d75048
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
