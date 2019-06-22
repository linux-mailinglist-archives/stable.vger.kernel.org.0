Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3930E4F587
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 13:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFVLqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 07:46:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36700 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVLqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 07:46:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so7809747wrs.3
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 04:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M2+3peMHd80oMqJpmkqsGWd7B/SJo9zR4p62VKigndg=;
        b=2PKggV30DIEWA79XuOhVDfwBhBykP24ImCb9Qv2ZXdffEn4fe02bK5CLoqBxYGv7uL
         mKmNwJckeFc0u5OG4d1SZUodoV4xk0xiz+ADKb9TIbnjnalm38VfHt0hro5o4IsUCGCO
         hBIaFUsCe95ww/jN5P9Ki+hWeTyiNiWk7YU1+D5RhEmiDObYUuL8TDbUwgStOYxOYpnQ
         X+Spu47ZlClrUXglnNW0trYLxXyTiUY6S0Iqqqcz3pZnmI2aDHHPnnoPjirvqrcNDREP
         KBWoF9QbGUKJgdyK4meLT88ffEGu6548yv66sqQw4Uh6hme5rUfJgfYE22jeSGOV5ZfE
         EQ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M2+3peMHd80oMqJpmkqsGWd7B/SJo9zR4p62VKigndg=;
        b=uoGZEm8WTXU5e+5wB5roIMIm0ouYN2PHJGhokflqKIm6HT0iJtaPBkcojfu7Khbcr7
         9CYiOCiwL3P2BSscCgCh6+sD9x3FlXkiWGfwm3cFYWuAD0lI8gJeQInxYmx1jrH0yDB1
         MY9f1YXA1i0Umiu1CE4uJkR5Sj8f4GvIp0WaHBfe3ujikY+IGVllxA0nwpw8bXVYPhM0
         vtVOKEj49hnrNJwR5fjulmbLnlCZ+HsOZG38MdxfoB3yyVgv66lvtGFr966D7zqk5zMU
         sdwQvBtAbfrT2XlMxf5uFBOQn1C8ROdyzmH+HZvsdLcHJi5ZM4Twk3XNjMZOLJywVYAx
         +0UA==
X-Gm-Message-State: APjAAAVWYiWT9yKBWfhtejTGAk9fK8z8D55JsOPlYl7iuvY5SbA6OaiU
        aPQwSMpQPEIqbi8/yGkqJoFtf2rlfNmHzw==
X-Google-Smtp-Source: APXvYqw94SXf+cOJCIc0gSe6eFgtd59UdDv18M2/NhMtmHBRitUK0Vc+E84U4L0AZ2/+9ICPXa2HFA==
X-Received: by 2002:adf:fdc2:: with SMTP id i2mr51140373wrs.146.1561203977069;
        Sat, 22 Jun 2019 04:46:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l12sm10418477wrb.81.2019.06.22.04.46.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 04:46:16 -0700 (PDT)
Message-ID: <5d0e1508.1c69fb81.45641.9f3e@mx.google.com>
Date:   Sat, 22 Jun 2019 04:46:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.54
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 77 boots: 0 failed,
 76 passed with 1 untried/unknown (v4.19.54)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 77 boots: 0 failed, 76 passed with 1 untried/unkn=
own (v4.19.54)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.54/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.54/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.54
Git Commit: 63bbbcd8ed53c404649e0b4248c1e5d42c41ac97
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 17 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
