Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234D622D573
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGYGYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGYGYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 02:24:02 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1180AC0619D3;
        Fri, 24 Jul 2020 23:24:02 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l64so3945550qkb.8;
        Fri, 24 Jul 2020 23:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6PT1mu1xTpmCv3EUdlnK2nrXPxfD/ZZI+ZMUa6SpY7c=;
        b=HM6lMpcNeKtE34rmXzpQAmzezqwkAKQ/l0h6kvd46Vjn/sEjcGIk4/Dqo0OlZ+LBUt
         JhyLT/7h9qS55pXeeQgYxa0u+yIMEaGxVc0Ihk0TQYc2yulS1xnt82bAAGMOAcQlnyJj
         J9YOmrVMTb85KWEjTqiGuv1PQKjvjZjJ7a6hvcVTUjBHzXLm1sW10taPVDGdr7vipbS1
         7gehVB/7A4d2R+eWSLDQQ2OFkrvFonJpeDqt4S2NXcpia8IpjJFC4vfcxiyRFF05N4xo
         XUij1NbKmtbwJqX3usPLBfp1UXDfTOj3npJMrY6ab4IXRbphDu8xX1sjiIpBq1tk9Y3k
         DIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6PT1mu1xTpmCv3EUdlnK2nrXPxfD/ZZI+ZMUa6SpY7c=;
        b=RFaaB/uodianWysgOZi0bO5fYjYQDHL03lQ3wr2uI9Wo61k/M4yeQUtj76aIdKN7RP
         KhV58fJBdBZ93acPND041KQaKc52sB1vzfdn72bMJKbKvWO2RJM6Imlc1znBi79MPzy0
         UZMsMR3H8tthCScs3o/LoQa9Xxo3RQY9AclvRzGoJc5/Ii3JpBdMDur1BffIrOuD7XnY
         mc+Y6x7Dep4Hzlh6a/GW3TGhFr9lTlElPGYkomBxhrqzQHDCltpWXJFjTxUD4SDV9UDb
         ncdv/yyuXAMJq7+n3bXkPEoMC7tfyMlK77Pyy+LKUA13ByjT4ejjpaQ55kX284oNrfbM
         XmqA==
X-Gm-Message-State: AOAM532xnyrK7EZqT+SdWKDR+i+YHbh0MsB2yE6EmBITCmVqpuIqxCjU
        vjZrw5qNlHN3JsE685gOLi/43acQ
X-Google-Smtp-Source: ABdhPJy42lSy/HOSmiqdvGU0sSrUk/qGoSNOCn6Lw5AXf9bPesyWWI5woh6H1wl2GnjC6pjezvKNHg==
X-Received: by 2002:a05:620a:789:: with SMTP id 9mr4680773qka.199.1595658241112;
        Fri, 24 Jul 2020 23:24:01 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id q68sm9715438qke.123.2020.07.24.23.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 23:24:00 -0700 (PDT)
Date:   Fri, 24 Jul 2020 23:23:59 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix parameter type in function pointer
 prototype
Message-ID: <20200725062359.GA457524@ubuntu-n2-xlarge-x86>
References: <20200725060354.177009-1-natechancellor@gmail.com>
 <20200725061947.GA1051290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725061947.GA1051290@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 25, 2020 at 08:19:47AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 24, 2020 at 11:03:54PM -0700, Nathan Chancellor wrote:
> > When booting up on a Raspberry Pi 4 with Control Flow Integrity checking
> > enabled, the following warning/panic happens:
> > 
> > [    1.626435] CFI failure (target: dwc2_set_bcm_params+0x0/0x4):
> > [    1.632408] WARNING: CPU: 0 PID: 32 at kernel/cfi.c:30 __cfi_check_fail+0x54/0x5c
> > [    1.640021] Modules linked in:
> > [    1.643137] CPU: 0 PID: 32 Comm: kworker/0:1 Not tainted 5.8.0-rc6-next-20200724-00051-g89ba619726de #1
> > [    1.652693] Hardware name: Raspberry Pi 4 Model B Rev 1.2 (DT)
> > [    1.658637] Workqueue: events deferred_probe_work_func
> > [    1.663870] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
> > [    1.669542] pc : __cfi_check_fail+0x54/0x5c
> > [    1.673798] lr : __cfi_check_fail+0x54/0x5c
> > [    1.678050] sp : ffff8000102bbaa0
> > [    1.681419] x29: ffff8000102bbaa0 x28: ffffab09e21c7000
> > [    1.686829] x27: 0000000000000402 x26: ffff0000f6e7c228
> > [    1.692238] x25: 00000000fb7cdb0d x24: 0000000000000005
> > [    1.697647] x23: ffffab09e2515000 x22: ffffab09e069a000
> > [    1.703055] x21: 4c550309df1cf4c1 x20: ffffab09e2433c60
> > [    1.708462] x19: ffffab09e160dc50 x18: ffff0000f6e8cc78
> > [    1.713870] x17: 0000000000000041 x16: ffffab09e0bce6f8
> > [    1.719278] x15: ffffab09e1c819b7 x14: 0000000000000003
> > [    1.724686] x13: 00000000ffffefff x12: 0000000000000000
> > [    1.730094] x11: 0000000000000000 x10: 00000000ffffffff
> > [    1.735501] x9 : c932f7abfc4bc600 x8 : c932f7abfc4bc600
> > [    1.740910] x7 : 077207610770075f x6 : ffff0000f6c38f00
> > [    1.746317] x5 : 0000000000000000 x4 : 0000000000000000
> > [    1.751723] x3 : 0000000000000000 x2 : 0000000000000000
> > [    1.757129] x1 : ffff8000102bb7d8 x0 : 0000000000000032
> > [    1.762539] Call trace:
> > [    1.765030]  __cfi_check_fail+0x54/0x5c
> > [    1.768938]  __cfi_check+0x5fa6c/0x66afc
> > [    1.772932]  dwc2_init_params+0xd74/0xd78
> > [    1.777012]  dwc2_driver_probe+0x484/0x6ec
> > [    1.781180]  platform_drv_probe+0xb4/0x100
> > [    1.785350]  really_probe+0x228/0x63c
> > [    1.789076]  driver_probe_device+0x80/0xc0
> > [    1.793247]  __device_attach_driver+0x114/0x160
> > [    1.797857]  bus_for_each_drv+0xa8/0x128
> > [    1.801851]  __device_attach.llvm.14901095709067289134+0xc0/0x170
> > [    1.808050]  bus_probe_device+0x44/0x100
> > [    1.812044]  deferred_probe_work_func+0x78/0xb8
> > [    1.816656]  process_one_work+0x204/0x3c4
> > [    1.820736]  worker_thread+0x2f0/0x4c4
> > [    1.824552]  kthread+0x174/0x184
> > [    1.827837]  ret_from_fork+0x10/0x18
> > 
> > CFI validates that all indirect calls go to a function with the same
> > exact function pointer prototype. In this case, dwc2_set_bcm_params
> > is the target, which has a parameter of type 'struct dwc2_hsotg *',
> > but it is being implicitly cast to have a parameter of type 'void *'
> > because that is the set_params function pointer prototype. Make the
> > function pointer protoype match the definitions so that there is no
> > more violation.
> > 
> > Cc: stable@vger.kernel.org
> 
> Why does this matter for stable kernels, given that CFI is not in any
> kernel tree yet?
> 
> thanks,
> 
> greg k-h

It might not be available upstream but it is in all downstream Android
kernels. Furthermore, all of the previous CFI fixes I have done have
inevitably ended up in stable trees through AUTOSEL, I figured I would
save Sasha the hassle this time around. It does not personally matter to
me though, I am fine with stripping the tag since I do all of my
personal testing with mainline/next so if this is needed in stable
later due to an OEM or someone else tripping over it, it can just be
added then.

Let me know if you want me to resend it without that tag.

Cheers,
Nathan
