Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D531B6C03
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 05:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgDXDio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 23:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgDXDin (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 23:38:43 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13DDC09B044
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 20:38:43 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id y6so3400234pjc.4
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 20:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r3ERBKCNVAmx6G9e83r5GkMyaJE+DV6A8u8GLQKvPrE=;
        b=gQ8u3/X3D+HvYVmFffgwMfewOjNQguoXbFFvCyK2LjElcpTToXRDdYWqQ8VFihR1LG
         Yd+3v7xLflBK1+wEIPV9CqY6FsqXthG6XgNC9NtzL+l6vFec63+znhh5jdOlGZIaPo+R
         pdks18goS48vN6Fd8CfgpNIsz+BSlauukdU/YeI/Mgh3S54WLVJ0OrBys5vntKMEy9dt
         y6bqFqhu5c8HgZy1fr9e+UeObQjerjodY+x9pdSau6xgABexQ4nbFZqrysUy0/EVq6oL
         ZJXtwAJSfkIwx3fGagfK9wdHOz4orDfAuomO21alO4/a3z2+fw4Od1Y0ymp2agi6pgjW
         x6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r3ERBKCNVAmx6G9e83r5GkMyaJE+DV6A8u8GLQKvPrE=;
        b=NdXBO0N5FKRqgACM5N+xkE7WYTBkwKNiGAmKml4rzT2OSIAw//7NzSL9d0vWn79TMp
         1hlg3kjP6dVUcydo+80FGa6OWBNSZJEWUOu3vsY7yad2A8aN0ZV5HpPGGY5jZS2dAZ0N
         DEdLiVkJibBqjWM22Nb4BUZEbKJ4iUk0oGOWon6Ae1fs4bXzVFon90MENWhWrll0UtGd
         oJa8phk/92BQpNUfaFlvmbTEhAKBWxf8O6qosL3xoZz+Y6O0wZSgi5w62j6P7Uma33bQ
         r69iJuWtKQvCOQp7i+FuiG7MM7deMywLtuekh/m9amWl2neJuaLyGP9+F/syLldy6Ep/
         eeJQ==
X-Gm-Message-State: AGi0PuYF1AW58XQ0NuJqZq4k/dgjLeVPUxu29G2WdCRTThsytXa3KlIE
        CM+bs+5Qk+vkOzPHdDcxZPamkiuMSZY=
X-Google-Smtp-Source: APiQypJSMjw8S2N+T8PDnl7Q+/JIIwqp08L1N15awedQRauGUE93P8TQdtT9IYPFMYHQa9Blep/1Aw==
X-Received: by 2002:a17:902:361:: with SMTP id 88mr2294910pld.279.1587699522820;
        Thu, 23 Apr 2020 20:38:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w66sm4138168pfw.50.2020.04.23.20.38.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 20:38:42 -0700 (PDT)
Message-ID: <5ea25f42.1c69fb81.83aca.fb19@mx.google.com>
Date:   Thu, 23 Apr 2020 20:38:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.35
Subject: stable/linux-5.4.y boot: 27 boots: 0 failed, 27 passed (v5.4.35)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 27 boots: 0 failed, 27 passed (v5.4.35)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.35/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.35/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.35
Git Commit: 0c418786cb3aa175823f0172d939679df9ab9a54
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 5 SoC families, 7 builds out of 200

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-h6-orangepi-3:
              lab-clabbe: new failure (last pass: v5.4.34)

---
For more info write to <info@kernelci.org>
