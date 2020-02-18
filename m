Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFD31622D4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgBRIym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:54:42 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:45279 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgBRIym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:54:42 -0500
Received: by mail-lf1-f54.google.com with SMTP id 203so13872036lfa.12
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 00:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XG/ToDNpjK7E8+3CGMxRl+g9s3/nMUlrXkuxpJ67stc=;
        b=c7sRKvLQ8+H4frQrJ1H8goYPxVlU2AddyNxLpIBIN/AqaMvzf4x6wmtCJANmwtDMEF
         7hNgxiz7QJOEHdbPyK8R79tWdL5zujKNA9+xcLswzikMaIbSejle8WOzaji5a8dMulDY
         YvdfCgafpkZjEoo0eRQq58dt3NKEOYCBBqhOypNgW2fegl41SFwtUWQNqf/+771fPIKC
         m7YPXZ55o8kRKs+VXdA8/FG/Y7WPxUu1t/tgzDqeX4b2thHL0S4NnSLdkmVUTudUTRsN
         svCjWi9i/ey3cLgtKs7vslFENfMsTmxmu3F7PpvuT1E1rkQt4RpOmqwiPF+duYUT5gOv
         WhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XG/ToDNpjK7E8+3CGMxRl+g9s3/nMUlrXkuxpJ67stc=;
        b=QRbcWfISUMRMRvKVNKVhkpwrwjkzrWq6mJ8G8kodxspMYNQbVM6IYsvHEl6rfJsdt5
         f0XWE+IsebnNup1VZKFBTHz1wzIwQjYTIc9Hztqizp5xFNweJCmJd7L8Kokx2CIb4Xjg
         8JlZlKptucYuitYj3QYOe5CmqWCYpaSPyrVftNe/CG85qmROVCgIrwXmL/JOYKT4X++M
         Cb+gBsI7vEK/oE6zXXQr8o82zV7ICdVNhQqOmkh75zlmJfUmeFCwE4BmXTvqOZQXOZjV
         gWSjwdkZ6RbNPEqfsdiPYfbtDWzk7otxqRFV6caz/sQCc5+zukm4BW/HuGs95ZjoIo/1
         e/pQ==
X-Gm-Message-State: APjAAAWLD+hK/m5cTTT2AdSWv+Y/UW8cXhBRD41A3y/fBEfHoRJO8kFZ
        dAxkGxKKAkdijaGB5di7XCZ0bMS/hRYs7FBJwhdd8w==
X-Google-Smtp-Source: APXvYqyCg/ZmVyNTESFogv89ipoB2XbTpF1LFPmdEqcmNwY2/no19dGcxt27cJaHQ5PEo6SoifP4ZcnehB2lQRVEYh0=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr9516197lfn.74.1582016079887;
 Tue, 18 Feb 2020 00:54:39 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Feb 2020 14:24:27 +0530
Message-ID: <CA+G9fYtmJkYdUG1wXgUHs3KoLdGQPYFcR8oTzFmDJ5oMXu5kaQ@mail.gmail.com>
Subject: stable-rc 5.5.5-rc1: [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, LTP List <ltp@lists.linux.it>,
        xuyiping@hisilicon.com, sam@ravnborg.org,
        dri-devel@lists.freedesktop.org, Al Viro <viro@zeniv.linux.org.uk>,
        noralf@tronnes.org, daniel@ffwll.ch,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The arm64 device running LTP hugetlb test suite caused test hang on
stable-rc 5.5.5-rc1 due to [drm:ade_irq_handler [kirin_drm]] *ERROR*
LDI underflow!.
Same problem noticed while running libhugetlbfs test suite.

Problematic patch not identified yet.

hugemmap05.c:223: INFO: original nr_hugepages is 0
hugemmap05.c:236: INFO: original nr_overcommit_hugepages is 0
hugemmap05.c:104: INFO: check /proc/meminfo before allocation.
hugemmap05.c:285: INFO: HugePages_Total is 192.
hugemmap05.c:285: INFO: HugePages_Free is 192.
hugemmap05.c:285: INFO: HugePages_Surp is 64.
hugemmap05.c:285: INFO: HugePages_[   51.411646] [drm:ade_irq_handler
[kirin_drm]] *ERROR* LDI underflow!
Rsvd is 192.
[   51.411735] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.419705] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.427680] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.434455] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.441179] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.447912] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.454639] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.461395] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.468175] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.475014] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.481868] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.488621] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.495367] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.502113] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.508845] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.515582] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.522316] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.529054] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.535836] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.542621] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.549399] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.556144] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.562897] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.569634] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.576378] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.583142] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.589889] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.596610] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
hugemmap05.c:260:[   51.603356] [drm:ade_irq_handler [kirin_drm]]
*ERROR* LDI underflow!
 INFO: First hex is 7070707
[   51.610101] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   51.621956] [drm:ade_ldi_set_mode [kirin_drm]] *ERROR* failed to
set pixel clk 0Hz (-22)
hugemmap05.c:139: INFO: check /proc/meminfo.
hugemmap05.c:285: INFO: HugePages_Total is 192.
hugemmap05.c:285: INFO: HugePages_Free is 0.
hugemmap05.c:285: INFO: HugePages_Surp is 64.
hugemmap05.c:285: INFO: HugePages_Rsvd is 0.
hugemmap05.c:163: PASS: hugepages overcommit test pass
hugemmap05.c:180: INFO: restore nr_hugepages to 0.
hugemmap05.c:189: INFO: restore nr_overcommit_hugepages to 0.
Summary:
passed   1
failed   0
skipped  0
warnings 0
tst_test.c:1217: INFO: Timeout per run is 0h 15m 00s
mem.c:817: INFO: set nr_hugepages to 255
[   54.139687] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   54.143384] [drm:ade_ldi_set_mode [kirin_drm]] *ERROR* failed to
set pixel clk 0Hz (-22)
[   54.278589] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   54.280642] [drm:ade_ldi_set_mode [kirin_drm]] *ERROR* failed to
set pixel clk 0Hz (-22)
hugemmap06.c:139: PASS: No regression found.
[   54.520165] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   54.522769] [drm:ade_ldi_set_mode [kirin_drm]] *ERROR* failed to
set pixel clk 0Hz (-22)
[   54.664774] [drm:ade_irq_handler [kirin_drm]] *ERROR* LDI underflow!
[   54.668013] [drm:ade_ldi_set_mode [kirin_drm]] *ERROR* failed to
set pixel clk 0Hz (-22)

<SYSTEM HANGS HERE>

Ref:
https://lkft.validation.linaro.org/scheduler/job/1227316#L4288

metadata:
  git branch: linux-5.5.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: 7d6c8f2632c92635fcef4175921a7742f23947e4
  git describe: v5.5.4-46-g7d6c8f2632c9
  make_kernelversion: 5.5.5-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-5.5/24/config
  build-location:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-5.5/24

-- 
Linaro LKFT
https://lkft.linaro.org
