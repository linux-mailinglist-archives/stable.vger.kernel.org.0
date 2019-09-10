Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1ADAED14
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfIJOdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:33:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40262 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfIJOdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 10:33:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so20732856wru.7
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 07:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K4I7eixd+nRn2Lo7haCkkgQg1L3fqUjaRkr06Dymm1k=;
        b=mxOSZzC6Jthdd52DSmqKQfYIUIpAABV4h8EpGFr4vZjPS7Acasi6wKDcSPJ+6DwXY6
         mpPR+X2KtRF6qKLnJSsTgS1WQf4+k771cBAUj5dkdrlq6RF0iaQ2AW7s6dnKRddNIqHa
         zeiRGDnglyd+lRkMZ92swxBuCyjNjvaZaVKJCMnwKq8GLrI17dAAgKo1p/G+PPhgS74q
         dSRjFZSMQwf6aGm2moY2GzLJeb/7BR6IlSJa43W2bAxuja1NRi00OL97Qbkthz3zNjQu
         f+tvZCriGyjChVbH1CXFqqeY4s6dC7lmQAvPxtPxZ3v9E/pu/jlcUbCzKYX2psYzbWHr
         Q4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K4I7eixd+nRn2Lo7haCkkgQg1L3fqUjaRkr06Dymm1k=;
        b=isr7orS80ryY/mGP68AuWgkkjVS/b4iO7ZfukM1RCrn8u6+ZkJDkGAgXDjrOOwmyqZ
         x02RpToN2QzSCm04bylGofNlOY695/4AaBZxnrTQlGdZ8buHlHlevJkhQX9A9RPFVu3D
         z3wJKCCap4rDEGQXTe/rtKKn8H8GL/A8hb9fbtoiThvqmu11nqvnp4ua3m78VuL8Hic7
         vXQMLfEPb8/iMIi3cb1n5pKI+jiAaic9j6DZMaQq68oCkEfBwyZpjqNPLN1lT4h7v3zE
         iUFP5WI/e9HtVhM0mIEgzgdV5ttqyExEF5uTB3DrEnwFXWgCCH6u7Ik6NkmxV/AoBiZz
         ogsw==
X-Gm-Message-State: APjAAAWJ0F4XXrIRIxJD1shfzzAcDLdeWfVbTT+DzMIA2zMRpwBuU6hi
        leBQKxtT+taajJmUeImmPITu2pTQvkKj4Q==
X-Google-Smtp-Source: APXvYqyHe79LOc4fEo4shbmEKTWyYeMJ5CK5gLWfRuVuqifRVxrkNLvxOw2Ggfhow310WBsBDAuPtg==
X-Received: by 2002:a5d:448a:: with SMTP id j10mr25645883wrq.82.1568125980397;
        Tue, 10 Sep 2019 07:33:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 207sm4460525wme.17.2019.09.10.07.32.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:32:59 -0700 (PDT)
Message-ID: <5d77b41b.1c69fb81.c121f.6132@mx.google.com>
Date:   Tue, 10 Sep 2019 07:32:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 91 boots: 0 failed, 91 passed (v4.19.72)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 91 boots: 0 failed, 91 passed (v4.19.72)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.72/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.72/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.72
Git Commit: ee809c7e08956d737cb66454f5b6ca32cc0d9f26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
