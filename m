Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE7A5999A8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 12:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346578AbiHSKTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348194AbiHSKTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:19:42 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A0EEF1E
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 03:19:40 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3375488624aso80434247b3.3
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ncKzxvUqfsU1JKurF4Cekb1acSp+SQ2D4v+f8v4mXnw=;
        b=oYvV3TCww8K210dIUWWz+SUj3/ghcXjjpOn2M8vJHbKcciCs7VP3w7toQEgXlnvpm7
         jGXfy4BW2Zadh5qi2CvGYBX7hnnD09I96Sd7jAhmxhDWZl5H8ev1TpUWiM7J9Ehj/PK5
         gKE0OOSnXK7Ec9qLov5xNrq1qxQ2UyGfiGtBuojrb1ONG/1tX/9rWBCbHSYg+djMK09m
         Y9YLoSlS8Fondw4KtpZuwJzaQ3/BkuJZ/vhzZoX6S1vlE7Qx/8ll1tVFuR0muvz5PQxl
         R1ACTjbXVl5yccLgRIaAk8ZHd5RTCR3FeqoVIlziQgegF2pA2O7RDYExRnAdQuYE7IA8
         ESgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ncKzxvUqfsU1JKurF4Cekb1acSp+SQ2D4v+f8v4mXnw=;
        b=C6XAjNgd/xVuZDUfKaQBYGBXRieG3Z0Axa6J/CWxlSLBdhC4YTzNM7xXThVbWGQgFP
         Jv/6lV5FmohfdPt68Py3TLRI8DXCuVa/AxjwG9sk6drP0mauVHrlGqrBdLjyIjaBe761
         v7OGP57IgTuB3sCEtP3ixhFPotvPDqrCYjodLrkGWsNOMTY7V3O6JjEr/41mUXDrD69P
         RzmkCHeGHRdXoIoP+Pj0o4Pi8zQR1kFk+F2M3AC9bBFhTcCfyVDU7qm/NbbZexrWwpb6
         CAOjfXPpdDOPe7c546qrUpKQJ8mYL+by+UxII5Mkr6kYc6146zdIJwawJa0xE3n5eTnI
         nf7g==
X-Gm-Message-State: ACgBeo2NYcQ9Os0V0RDTge/9ztRfEd1X3dtxFxmM1Nttx3vsVT6eT1eG
        tJ8C22eSvn+DRVEWxtgM2SdjUcYuQ7EkwmduPMul2L58iXvI4Q==
X-Google-Smtp-Source: AA6agR75oNSvkuYKyQCSHRzMAF6RVAOZ7yXsFNF4J8MXcNdGVlnGhidEBZyWvJX3bTamZOlij7nfww0kHNdT1gvwbG4=
X-Received: by 2002:a25:fe07:0:b0:691:d1f4:681f with SMTP id
 k7-20020a25fe07000000b00691d1f4681fmr7087092ybe.211.1660904379783; Fri, 19
 Aug 2022 03:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220819094952.2602066-1-jens.wiklander@linaro.org>
In-Reply-To: <20220819094952.2602066-1-jens.wiklander@linaro.org>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 19 Aug 2022 15:49:28 +0530
Message-ID: <CAFA6WYOaKmcdU8ZAOsno9N8znCeg3QTu=LhSwJf-5J2P9ud4Vw@mail.gmail.com>
Subject: Re: [PATCH v3] tee: add overflow check in register_shm_helper()
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Jerome Forissier <jerome.forissier@linaro.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

On Fri, 19 Aug 2022 at 15:20, Jens Wiklander <jens.wiklander@linaro.org> wrote:
>
> With special lengths supplied by user space, register_shm_helper() has
> an integer overflow when calculating the number of pages covered by a
> supplied user space memory region. This causes
> internal_get_user_pages_fast() a helper function of
> pin_user_pages_fast() to do a NULL pointer dereference.
>
> [   14.141620] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
> [   14.142556] Mem abort info:
> [   14.142829]   ESR = 0x0000000096000044
> [   14.143237]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   14.143742]   SET = 0, FnV = 0
> [   14.144052]   EA = 0, S1PTW = 0
> [   14.144348]   FSC = 0x04: level 0 translation fault
> [   14.144767] Data abort info:
> [   14.145053]   ISV = 0, ISS = 0x00000044
> [   14.145394]   CM = 0, WnR = 1
> [   14.145766] user pgtable: 4k pages, 48-bit VAs, pgdp=000000004278e000
> [   14.146279] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
> [   14.147435] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [   14.148026] Modules linked in:
> [   14.148595] CPU: 1 PID: 173 Comm: optee_example_a Not tainted 5.19.0 #11
> [   14.149204] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
> [   14.149832] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   14.150481] pc : internal_get_user_pages_fast+0x474/0xa80
> [   14.151640] lr : internal_get_user_pages_fast+0x404/0xa80
> [   14.152408] sp : ffff80000a88bb30
> [   14.152711] x29: ffff80000a88bb30 x28: 0000fffff836d000 x27: 0000fffff836e000
> [   14.153580] x26: fffffc0000000000 x25: fffffc0000f4a1c0 x24: ffff00000289fb70
> [   14.154634] x23: ffff000002702e08 x22: 0000000000040001 x21: ffff8000097eec60
> [   14.155378] x20: 0000000000f4a1c0 x19: 00e800007d287f43 x18: 0000000000000000
> [   14.156215] x17: 0000000000000000 x16: 0000000000000000 x15: 0000fffff836cfb0
> [   14.157068] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> [   14.157747] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> [   14.158576] x8 : ffff00000276ec80 x7 : 0000000000000000 x6 : 000000000000003f
> [   14.159243] x5 : 0000000000000000 x4 : ffff000041ec4eac x3 : ffff000002774cb8
> [   14.159977] x2 : 0000000000000004 x1 : 0000000000000010 x0 : 0000000000000000
> [   14.160883] Call trace:
> [   14.161166]  internal_get_user_pages_fast+0x474/0xa80
> [   14.161763]  pin_user_pages_fast+0x24/0x4c
> [   14.162227]  register_shm_helper+0x194/0x330
> [   14.162734]  tee_shm_register_user_buf+0x78/0x120
> [   14.163290]  tee_ioctl+0xd0/0x11a0
> [   14.163739]  __arm64_sys_ioctl+0xa8/0xec
> [   14.164227]  invoke_syscall+0x48/0x114
> [   14.164653]  el0_svc_common.constprop.0+0x44/0xec
> [   14.165130]  do_el0_svc+0x2c/0xc0
> [   14.165498]  el0_svc+0x2c/0x84
> [   14.165847]  el0t_64_sync_handler+0x1ac/0x1b0
> [   14.166258]  el0t_64_sync+0x18c/0x190
> [   14.166878] Code: 91002318 11000401 b900f7e1 f9403be1 (f820d839)
> [   14.167666] ---[ end trace 0000000000000000 ]---
>
> Fix this by adding an overflow check when calculating the end of the
> memory range. Also add an explicit call to access_ok() in
> tee_shm_register_user_buf() to catch an invalid user space address
> early.
>
> Fixes: 033ddf12bcf5 ("tee: add register user memory")
> Cc: stable@vger.kernel.org
> Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
> v2 -> v3:
> - Public review
> - Relies entirely on access_ok() for overflow checks as suggested

Linus has already applied this fix here [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=573ae4f13f630d6660008f1974c0a8a29c30e18a

> - Check against zero registersted pages is kept

Do you think this alone fixes any other scenario? If not then I would
suggest sending it as a regular improvement patch.

-Sumit

> - Replaced Suggested-by tag
>
> v1 -> v2:
> - Non-public review
> - Added access_ok() and overflow check with roundup()
>
>  drivers/tee/tee_shm.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> index f2b1bcefcadd..a88669d6ea68 100644
> --- a/drivers/tee/tee_shm.c
> +++ b/drivers/tee/tee_shm.c
> @@ -240,6 +240,14 @@ register_shm_helper(struct tee_context *ctx, unsigned long addr,
>         void *ret;
>         int rc;
>
> +       addr = untagged_addr(addr);
> +       start = rounddown(addr, PAGE_SIZE);
> +       num_pages = (roundup(addr + length, PAGE_SIZE) - start) / PAGE_SIZE;
> +
> +       /* Error out early if no pages are to be registered */
> +       if (!num_pages)
> +               return ERR_PTR(-EINVAL);
> +
>         if (!tee_device_get(teedev))
>                 return ERR_PTR(-EINVAL);
>
> @@ -261,11 +269,8 @@ register_shm_helper(struct tee_context *ctx, unsigned long addr,
>         shm->flags = flags;
>         shm->ctx = ctx;
>         shm->id = id;
> -       addr = untagged_addr(addr);
> -       start = rounddown(addr, PAGE_SIZE);
>         shm->offset = addr - start;
>         shm->size = length;
> -       num_pages = (roundup(addr + length, PAGE_SIZE) - start) / PAGE_SIZE;
>         shm->pages = kcalloc(num_pages, sizeof(*shm->pages), GFP_KERNEL);
>         if (!shm->pages) {
>                 ret = ERR_PTR(-ENOMEM);
> @@ -326,6 +331,9 @@ struct tee_shm *tee_shm_register_user_buf(struct tee_context *ctx,
>         void *ret;
>         int id;
>
> +       if (!access_ok((void __user *)addr, length))
> +               return ERR_PTR(-EFAULT);
> +
>         mutex_lock(&teedev->mutex);
>         id = idr_alloc(&teedev->idr, NULL, 1, 0, GFP_KERNEL);
>         mutex_unlock(&teedev->mutex);
> --
> 2.31.1
>
