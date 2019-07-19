Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3346EA17
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 19:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfGSR2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 13:28:19 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40151 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbfGSR2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 13:28:19 -0400
Received: by mail-wm1-f44.google.com with SMTP id v19so29747352wmj.5
        for <stable@vger.kernel.org>; Fri, 19 Jul 2019 10:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mVBTb5ed5i4hxI9IbdabcjtnsL3MzPy17CG3EGaB8Uo=;
        b=IK8zn1UGLu3n8HGlvLOi/ywwDAzfDqfxS0cGkQ9PKJD/02ACHNLEeMGIVj5V+IjKiU
         0k31jhKeYJCvh+h3Ua/X1M977RMTLswWA9Hb8Bhd2+HXpHGLo+wcYFtZ+oNg76gvfrcg
         ENkHkAd8wXpvvHuJGtALFcuclSGZrGE9ies+qWf79wKRxGydbW6i03r6tzTMSqeaHzAW
         sAPjB0CK7RgblhkixD6WpS9ocJc1kONQ380G3TeD1Q7bC4QRSxL4uVUtVhF9repjvblP
         cxY/Ghv0cWu48RpEFxihtO14/Q0BDEZ61CDRmYDTFMrQiV+b04kU/Ye0uH/zmEbbbjNt
         3uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mVBTb5ed5i4hxI9IbdabcjtnsL3MzPy17CG3EGaB8Uo=;
        b=DBWwIAW/sM0787xJduyZZDcGO6F26J8xalFDmTl84TjyVoTcf7eI1SmDSokEAsLUEM
         Sf53906dhL5xt/jZ3vyOLyaHXQOsArT+wPFrtObh27v2pxkmqyRI5qW+z41rpV8wU+J6
         ctSN0J4eiVJeJdH0zGio4OuPLwrDIYr9tgfc8NgCKBeEBm0VfmVuVvlOpd2h7OMHx1KC
         nu3oaVaP/We0LaA6jYngG8bBt9Dtp/WLIB6dl1TwdC5VIS39GBCbfanFSMXIuyNP2zrx
         s9mCcOdM2zgYyUPVZTQoJIOtn+3XUdH8UxhW3jQ2jWXwukxCK+pCNRnUUhsyYMQdv7VM
         ANgA==
X-Gm-Message-State: APjAAAVhIMvcp2CIBy/yCKm+W7M0pkhH+aCnmAhZn3w4QZsDdXvcxD9q
        FQa+4Ybu54n4r2xWpIDQQw0HQG0FV0w=
X-Google-Smtp-Source: APXvYqyd7P6lVoUKNAtmKvoGTPia9shuw429Z2VbsMVHxizTtikniXbaZdhYZOw/caQEHghwifRloA==
X-Received: by 2002:a05:600c:20c3:: with SMTP id y3mr50626315wmm.3.1563557296744;
        Fri, 19 Jul 2019 10:28:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v5sm34067449wre.50.2019.07.19.10.28.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:28:16 -0700 (PDT)
Message-ID: <5d31fdb0.1c69fb81.5beb3.f131@mx.google.com>
Date:   Fri, 19 Jul 2019 10:28:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 70 boots: 0 failed, 70 passed (v5.2.1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 70 boots: 0 failed, 70 passed (v5.2.1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.1/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.1/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.1
Git Commit: 527a3db363a3bd7e6ae0a77da809e01847a9931c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 17 SoC families, 10 builds out of 209

---
For more info write to <info@kernelci.org>
