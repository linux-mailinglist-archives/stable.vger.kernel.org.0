Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6ADCFC0C
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 16:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfJHOMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 10:12:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36448 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfJHOMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 10:12:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so3317024wmc.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ul9fke1vg9lhoJev5zL6NOvQo2Fsnwtum5Y2fozXp3M=;
        b=SgtwCsFDFaHC8S76Vy87Vk24TwSBCxLpi+PYVAT+ISKrKIKaRe4+hleGcI8PzEjklQ
         yZNtbZ+xO04hpK6gowrHnSGQMqL2kRzcHu9bR52Ovu43TCY2YRsKMzuGrYGcVE6ANF1i
         9eAUTCk1jmvWTs1qWxRUHHqZAVxZnc+/C/StHijxghKeFaWtUpD9bMknrtK5kwVZ+Uj6
         6R7cIFUVRnGsQJrlhY+zmoIFWcT0CCXzna+AQcpcSWD93BHm/fIcjZCl61rT0N0kFM9T
         r/CGqlL+I/wtCWusSyorHVYGrZoHrb8qSgaqrvWKYShjRjeTi2p00Nj9uXuExXhLCwi5
         KwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ul9fke1vg9lhoJev5zL6NOvQo2Fsnwtum5Y2fozXp3M=;
        b=hosgKOepk1WFhTMSAOR+E2f3xlhr2+moRstxP2t/gFBLGuQFSAFUP02bVnYnjTQA/Y
         N5KpCkxBIj+qwquFDhXlixhFNO6ToLlyBeV795EkJ3fUGKhoryEO9WiMflYsPiyrIkpU
         G0uQHSxRKmk4QhNiAm2Y2EyBirky27rTdQnF5asWEc0U9XmGgWQnvAbwhQg3OiyMysk5
         ER2SCD+R+itFfRv+ZbJ0+w6MljpQuKv+FTM3FZLGhQpCtxukFGZM2gWc7IEh+aLvGHtY
         PWgQBbo4RSSnepluyMx4BqVF8aMcovflD4TuGVEtVFXDJohHBtriwAgvd1LfBXeOY9ej
         JX5w==
X-Gm-Message-State: APjAAAX/eAQpLoISRo0cPYftGUKuF37VJFMmrCWHXw2CCbBQsMtOEBzF
        UkfrQZF1WcIfDmvgbR0vbqn4CIU54knRiw==
X-Google-Smtp-Source: APXvYqx+lQ9B6ZWH7dsp7E27etpIN48cxCG/KhUTRMqoGSq3cOwrFLACvk+eVx3eshu76uMMu5pc9A==
X-Received: by 2002:a1c:1a4c:: with SMTP id a73mr3944111wma.124.1570543933467;
        Tue, 08 Oct 2019 07:12:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm32897974wrg.67.2019.10.08.07.12.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 07:12:12 -0700 (PDT)
Message-ID: <5d9c993c.1c69fb81.ecd34.76c1@mx.google.com>
Date:   Tue, 08 Oct 2019 07:12:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 46 boots: 0 failed, 46 passed (v4.9.196)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 46 boots: 0 failed, 46 passed (v4.9.196)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.196/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.196/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.196
Git Commit: 140fcbee3e9de3d649c5cb313c4919bd07f0017f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
