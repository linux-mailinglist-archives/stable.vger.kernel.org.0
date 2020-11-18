Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D79A2B762B
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 07:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgKRGMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 01:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKRGMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 01:12:02 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1859FC0613D4
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 22:12:01 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w13so1039069eju.13
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 22:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJ6Vhuy+iXRZiJNmZErzY7JnP8xPIvyRkVGtF53N6s8=;
        b=lf3bo8vJQQkAXT4raPezDGDIQLQWVRKOHAv0Di1iRBl5nAmkC9YOboQY+PTlB8J7wT
         TKBu74Xez0J03TDxUXi3Fthn0S10A+/j9ibTzO68k3IXIBTTGgW2u7mzhL4/pcGUG3uJ
         sdAAZpl5hxFhKxzf1HqPAwT5kGHJ0mv3nS7STDlw92u+qlRqlaTpLfWipaDUpNewEKpE
         3Xpq1i4C1z64OjlGVq62nxpiGV4NS4UpL9KuIh8s3PY7PT1eb5Yaz4yuWCOKqLaaYNPz
         w5/WLaDyWRj7WvrUEjPIiYf2UHrxPcUB052pi6Ap+tSLWPEvZpjKYfOLYZxh7OuXczvx
         1IqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJ6Vhuy+iXRZiJNmZErzY7JnP8xPIvyRkVGtF53N6s8=;
        b=G/ipvLxV0TNd3tDSE4d/T+h7yQO+PFGJyP/9Zhg1IRbOxbNKAz1IOn5dlzkr5Nv00n
         Jjt6jraURYohIwBK4RpBSznRzxjwH2PR8yDPs+cTd7NYcFGO9cSB0uvmf6diABeU0vh/
         uFIiwkonjHJD3III4pcDhXARp48CU/Ir8WGrmQ9H7iX6/sZKQvsbnu28rxIPtBRtf22q
         JvpZmECp2skFI3bTyK63p+d7N9hOaT3OwZZf3akIaSweMda4SZ5PuFdejO4e54x5cooB
         2yjVwrRdcmqVOcjnUr02b2ratEMvzb4KxdZaTsYhDFyF6h7jyUuJHQ99MB99aBvJd2Zu
         2xSw==
X-Gm-Message-State: AOAM532orQej2Ks2l6cUlRfA+eilU/MXZ0UMi7lHZKL7ty99srIZ/0h5
        1HohdHRcMTv+6O6OMPkMJX/KtbZn1PSI8sPh4hxpjN4sv0qTBquT
X-Google-Smtp-Source: ABdhPJzxPS3/BmwqqokOzxQFyGx/yp9qLjwisVYjO1DPNIAXMOkMER7XlYY/gbH3NVKWvYAmpOx1m93rJFhdL3DuMeg=
X-Received: by 2002:a17:906:6987:: with SMTP id i7mr24210882ejr.18.1605679919620;
 Tue, 17 Nov 2020 22:11:59 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtwycbC+Hf9aP5Br8wq7cKWVqjhcGusn2DbJaNauGC3Og@mail.gmail.com>
In-Reply-To: <CA+G9fYtwycbC+Hf9aP5Br8wq7cKWVqjhcGusn2DbJaNauGC3Og@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 11:41:48 +0530
Message-ID: <CA+G9fYsfEVK86ask=fL=M5juerbz+BwbFGcAZ_UxWrPHXYpA1Q@mail.gmail.com>
Subject: Re: WARNING: kernel/irq/chip.c:242 __irq_startup+0xa8/0xb0
To:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Oct 2020 at 11:09, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On stable rc  5.8.15 the following kernel warning was noticed once
> while boot and this is hard to reproduce.

This is now reproduciable on arm64 NXP ls2088 device

[   19.980839] ------------[ cut here ]------------
[   19.985468] WARNING: CPU: 1 PID: 441 at kernel/irq/chip.c:242
__irq_startup+0x9c/0xa8
[   19.985472] Modules linked in: rfkill lm90 ina2xx crct10dif_ce
qoriq_thermal fuse
[   20.000773] CPU: 1 PID: 441 Comm: (agetty) Not tainted 5.4.78-rc1 #2
[   20.000775] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[   20.000779] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   20.018253] pc : __irq_startup+0x9c/0xa8
[   20.018256] lr : irq_startup+0x64/0x130
[   20.018259] sp : ffff80001122f8e0
[   20.029303] x29: ffff80001122f8e0 x28: ffff0082c242d400
[   20.029306] x27: ffffdd0f47234768 x26: 0000000000020902
[   20.029309] x25: ffffdd0f461a6f10 x24: ffffdd0f461a6bc8
[   20.029311] x23: 0000000000000000 x22: 0000000000000001
[   20.029314] x21: 0000000000000001 x20: ffff0082c22f8780
[   20.029316] x19: ffff0082c1060800 x18: 0000000000000001
[   20.029318] x17: 0000000000000000 x16: ffff8000114a0000
[   20.029321] x15: 0000000000000000 x14: ffff0082c0e92f90
[   20.071738] x13: ffff0082c0e93080 x12: ffff800011460000
[   20.071741] x11: dead000000000100 x10: 0000000000000040
[   20.071743] x9 : ffffdd0f47093ba8 x8 : ffffdd0f47093ba0
[   20.087653] x7 : ffff0082a00002b0 x6 : ffffdd0f47074958
[   20.087655] x5 : ffffdd0f47074000 x4 : ffff800011230000
[   20.087657] x3 : 0000000000000504 x2 : 0000000000000001
[   20.103567] x1 : 0000000003032004 x0 : ffff0082c1060858
[   20.103570] Call trace:
[   20.103573]  __irq_startup+0x9c/0xa8
[   20.103577]  irq_startup+0x64/0x130
[   20.118359]  __enable_irq+0x7c/0x88
[   20.118362]  enable_irq+0x54/0xa8
[   20.118367]  serial8250_do_startup+0x658/0x718
[   20.118371]  serial8250_startup+0x38/0x48
[   20.133589]  uart_startup.part.0+0x12c/0x2b8
[   20.133592]  uart_port_activate+0x64/0x98
[   20.133595]  tty_port_open+0x94/0x200
[   20.133599]  uart_open+0x2c/0x40
[   20.148730]  tty_open+0x108/0x438
[   20.148734]  chrdev_open+0xa8/0x1a0
[   20.148737]  do_dentry_open+0x118/0x3b8
[   20.159348]  vfs_open+0x38/0x48
[   20.159350]  path_openat+0x4c8/0x1290
[   20.159353]  do_filp_open+0x84/0x108
[   20.159357]  do_sys_open+0x180/0x228
[   20.173271]  __arm64_sys_openat+0x2c/0x38
[   20.173274]  el0_svc_handler+0x88/0x1c8
[   20.173278]  el0_svc+0x8/0x1bc
[   20.184148] ---[ end trace 736144791ac25035 ]---



ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.77-152-ga3746663c347/testrun/3452654/suite/linux-log-parser/test/check-kernel-warning-139363/log
