Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0079E11AFF
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBONv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 10:13:51 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:36121 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfEBONv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 10:13:51 -0400
Received: by mail-wm1-f48.google.com with SMTP id p16so2851641wma.1
        for <stable@vger.kernel.org>; Thu, 02 May 2019 07:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X5ngUGVGuROL+wRlgml9yHvLlUYWbOWLF1K29rtzwp4=;
        b=EhiuiAE8+0Am6ThSvLYwwlYFNWkzbYFMlRshybN6Xlor/UcHL/sqtkS0t4V8eYdtU/
         r8IRmpreLwqv1mhXW/Mqhw7IZSU5HRjQWXiqKaAF4zgFuuWUW1p5Mq3MIHQwKYywUzHR
         qspupR6F/aJ+lwNu/A3vev4T/POOtMZs6qMJ3gFXVhGuvKobHyRYZgisH4dzYWLnEDjS
         gHVOOhlTTr4VgpLggFMUDSC+HgyBwV3X1LV+YvJ6cixk14VJcGRkjoYFk/240E8h4McD
         +PP8W7GsAKrRgmri9GdBHQLmJOVL/TRrl5yosr95iBn6qxVTbshGlihtmckYJkV5UW/J
         LDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X5ngUGVGuROL+wRlgml9yHvLlUYWbOWLF1K29rtzwp4=;
        b=f6F0MazWDh7EN4mX+KRH3cf+8/k2GED9W8mZTc52nJXCUgf8/S/JDEGyVw4aJh0X9c
         zEc3ap8OyL/eVsMPYHShtzdQen+Pi4BcbJ1HdDCauy+Osxob+yMlyBamFJm6b0YBHLBI
         5Y/Un19oXgtV888xReBXJRKKf/kjRpVC47HdNBFACyW+pWWZKXX+ctXQY2Q9tc4jN1d7
         9c/cK7jTNTuUwQtP/e6JgXYtDudF8yav7ktXJdggimRPAgbWKURwtPQLAd6kJRYVJYVN
         vMfz3zSHqrIsr4CaBj8g4jR6ZRrN9U+slFb8FFz1unvTXxREeJtmIvCsstAvW7Ovscw1
         2psQ==
X-Gm-Message-State: APjAAAVINrmnc7a05BkqQq2g2tSXeVCQao65wYckV7mlJtqiudDFCYhX
        BX42j2iy/puWZk6y18NBOW6bRw/fexJTHg==
X-Google-Smtp-Source: APXvYqyXGEghBG78FfPbTq9OqT9Vpz8dQFJUZHsr8RlS9Ix6YhugxJJK64J6WiV2svf7plljypW+Jg==
X-Received: by 2002:a1c:9cd1:: with SMTP id f200mr2451531wme.91.1556806428446;
        Thu, 02 May 2019 07:13:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u11sm1906541wmu.15.2019.05.02.07.13.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 07:13:47 -0700 (PDT)
Message-ID: <5ccafb1b.1c69fb81.19ffd.bad6@mx.google.com>
Date:   Thu, 02 May 2019 07:13:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.11
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.0.y boot: 60 boots: 0 failed,
 58 passed with 2 untried/unknown (v5.0.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 60 boots: 0 failed, 58 passed with 2 untried/unkno=
wn (v5.0.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.11/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.11/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.11
Git Commit: d5a2675b207d3b3629edb3e1588ccc4f8dfb5040
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
