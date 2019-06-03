Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2633176
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 15:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfFCNtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 09:49:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43222 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfFCNtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 09:49:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so3149115wrm.10
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 06:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31LGO/XpJnNd7BOFC3vpl0tiPR/B5JKzdu4q8pp5R+o=;
        b=I37uukdP95KP/dX8A8EfFLn8t67FE4iqbO9t4hV+4EfpUJTdbvQmviClTOCCdjvdRf
         h50vUWll6QcD2VmSRj+2jjweKNDG+nkuwhwt7Qs/LF4/hjCNSJeidPMLt39keXUzB4Ix
         4HNn5nZWrEJmuqJGILMZP4e55B2SyjvtFDBR9OUd5OUAvPg9VZaaSsdf4aZqt6VZ6JlK
         X6b7PcJ0+GYKRPp8uKLhZ8QZBdGJELTea9YXNJNjGSkA6WX2guXKSmeiHL7PGqOfKr19
         QRF9ajri2L5lWiuMu+ipeokG7/vPaqpUlGLP24JneklVseDXidGWTeOIkWlnFjnLV9f1
         vSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31LGO/XpJnNd7BOFC3vpl0tiPR/B5JKzdu4q8pp5R+o=;
        b=bGfLfzQ0PzwRyApjZqPZjgeuxhXuu72F3/lmNLCXluSsxZxcNbP67XfOhVniZ2OtcT
         D9awJQFpEMYo/vdL7qc0sXuxOQfLuAWcuxd7zagDHXM6rQ/k/3YYwhx0Ob3Hdpm1aSCJ
         Q/yCEGZ2isl5pcWIU8xR3Zfl+84P3YOmmTETXhhVy6XQBTBNJ7RUQcwxeJ8J7KtskSsO
         WgAPDso6CISH0WoQ48W+/ZziHwGHgdW6rESP2cruU+7tPDYcXL/MN5RwvzHO3A9HZBqg
         Rnh+YEFJqHwPFz1d2T3d94fCVsJ7Sdso8dhiR7RGm0zVlqd/V6M+2wS6WN0munE3nzXZ
         qRJg==
X-Gm-Message-State: APjAAAUDwAdixMT82n9qBAOnX/hbhA28+LrgDflTyS3W5auWCoU5bCtj
        z0ROsYna27sLS6nAaZ/n5/n9kYO1054=
X-Google-Smtp-Source: APXvYqyaoPqtB+UME9CkmXdxbC4wVRkeBQZUHuDL8/HaDGuDah2JzdE0SLM3zSpfyr4jGP14WVdGLA==
X-Received: by 2002:adf:eeca:: with SMTP id a10mr17385624wrp.266.1559569747210;
        Mon, 03 Jun 2019 06:49:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y17sm34388714wrg.18.2019.06.03.06.49.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 06:49:06 -0700 (PDT)
Message-ID: <5cf52552.1c69fb81.32aa8.6f83@mx.google.com>
Date:   Mon, 03 Jun 2019 06:49:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.6-39-g3e168883c324
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 65 boots: 1 failed,
 63 passed with 1 untried/unknown (v5.1.6-39-g3e168883c324)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 65 boots: 1 failed, 63 passed with 1 untried/un=
known (v5.1.6-39-g3e168883c324)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.6-39-g3e168883c324/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.6-39-g3e168883c324/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.6-39-g3e168883c324
Git Commit: 3e168883c324547c4965b50d9651b7ce8ecd4f16
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 16 SoC families, 11 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v5.1.6-38-g5a6f1b561052)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            meson8b-odroidc1: 1 failed lab

---
For more info write to <info@kernelci.org>
