Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47034CCC8C
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 22:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfJEUAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 16:00:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33659 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbfJEUAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 16:00:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so10884419wrs.0
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 13:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hYQPHSc4E5cYty45dBNYitYj6/Oe1U8xcvKMqPLCwsg=;
        b=gg+V39JyMwQcjYKk6m/ZfKC/ri3tNRnEKVKITSlDEW4HOjPvcIOf6gPYCh9QBTHFca
         F1tmM33YKmqwCxZifaZZ4vhTiM4EJS7ytbBlWEQuyNuAXSEF3tuo+rKn2QyoJ/n10cgT
         vCc+zVbMTI4JkBj91VIQTxfNnsKZB+rg7yBh3fQMOdjMeQTazFgYkuk5yyxEEe8RJnNP
         9tM91/miUinM2BCH8LvxoyoJp+MbxpD5FiWPgCaR84vbomiyGoXa+/P4ll4prwvN8DTh
         0i+avZQ0vkNM0YWYVzZunZtUKhd2Ry8Pni0/ZMX2RV6FlUOhLkiIE3S3y9QoECbvO1PK
         QKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hYQPHSc4E5cYty45dBNYitYj6/Oe1U8xcvKMqPLCwsg=;
        b=VPxjNjlFZg88D3veEcs+vYsKhl73Th1IhwRRqXcQmpDk1RfRltOR7ecVRG0KMnCxQg
         xiPVEFDFdcf5KbAaukPvUj0NOjC+fFK+l15ZgkCZHqqu5wVwaEfVGVZqPX5bCIaoqTuq
         XatjcZpqyBtT61LiXS1G3XwXWNZT9J73BpW67/Td9PpNdrpkE5EwqSVT2puW/R75ttVu
         CBACBg322VEupa2c9kevZ8jQyDMdaTN0JF9Nxq/Qpj73kmo6ocA7PmVWc+B8flLxUegQ
         TEv6G81it7YesMplK/6HZf9jV2jG4ssFHbnt1rFIRWrAfX+KT0KXFcugO3L0IZ+jPqNp
         nEwg==
X-Gm-Message-State: APjAAAVsF3XETQsLsNrDXwuK/qst3rbK2eAYw+CuHNUPWX5X/IdDZm7V
        gNiBDDdsGqO5wHhaa1qzHgWM40QCRmU=
X-Google-Smtp-Source: APXvYqy7zAh0NkMZwbavss7SVtnpQg27vPV9x5WRbwOx/tQ6FR8OhNMbQmrOS2YPT2SArAg4rCDRVA==
X-Received: by 2002:adf:ec09:: with SMTP id x9mr17288335wrn.308.1570305605834;
        Sat, 05 Oct 2019 13:00:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm22159465wme.3.2019.10.05.13.00.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 13:00:04 -0700 (PDT)
Message-ID: <5d98f644.1c69fb81.1b61a.97fb@mx.google.com>
Date:   Sat, 05 Oct 2019 13:00:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 64 boots: 1 failed, 63 passed (v5.3.4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 64 boots: 1 failed, 63 passed (v5.3.4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.4/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.4
Git Commit: ed56826f177921da1cc66a927de22ca1666eb78c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 12 builds out of 208

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: failing since 1 day (last pass: v5.3.2-346-gc9a=
dc631ac5f - first fail: v5.3.3)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
