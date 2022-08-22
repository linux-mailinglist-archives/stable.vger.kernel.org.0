Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB61C59BA4A
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiHVHcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiHVHb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:31:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949992A414
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 00:31:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ds12-20020a17090b08cc00b001fae6343d9fso5267429pjb.0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 00:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0rspbn1vY2SyrylNh1B0m2YaWH2VMshyvNj8B4VC3MU=;
        b=x5pBzTk3QjF4ylMXB2VuPjaRuq9Zxja44CxnkSalnf54sBxZ4kr2BrWvldXeqSninJ
         T+AScWRgdqFWsfhnC3HMwUk9tAr8dwq4P0ddFYJ7vjF8hbz3yCuJ+hGDMTG1pL4wY44d
         qBTvGOnTsbaOVmoONt9tTQMO7Crw0lVl6E4zLvywanyzquaTn7lRferlixtxEiLq0xfP
         H6Jy8vwPEtQpZhUbcbld2QuuUo+BB9o0UtLLEOqGuh2VGw6P2DR/hveke/e1bvYRL6ZT
         qYIwD0jIp4JsjSBlGpDBcRUzykshQNrwnmF8kAHFRRsIBprI5jbr3cZMmuaz2eAyFpMO
         px3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0rspbn1vY2SyrylNh1B0m2YaWH2VMshyvNj8B4VC3MU=;
        b=x/Dwqbghe9XUJb1aNZb2miINE07IbXM5ZxY3IGNHUHCd0hq23sqy5c0jEhug5SHfYp
         rbEWXsrhAfBwiU6WxD5G0JrdRxKCjoqJ4WaVqJn7CgxAji0DV0C1d70lNKWUfg5ymyIA
         1L8HXkI1+53nwtJMjvPu/p831HuVeipRd7MUXfkM59cj4XXVFfsxVvm3e2J+kJpeSpSE
         VYkX33uqIOCBG8apfJfJDBTFNX1LzLmdv7C6ZX32xxQLvcWWQfmrxFMrPsZwDyw+bexN
         b9R2tL+b19ZLwgRv9ZiGhKYToLrc6Qe23H15n2wFWR6hElzrdRQwYy6H+vrMIIBrVLGX
         F1pA==
X-Gm-Message-State: ACgBeo22nmHvRt6JHB7EiBW9JfKqwtNP894m9a7FWydlsEU8L4ZqMbVx
        liWsLBczVBxc17wHQ8c7ePuf6RnIYZKwgVLniy3wSg==
X-Google-Smtp-Source: AA6agR7Kl2lf1MWQwZ+nre5IPPms4/nKg97Ym/+VJ5f6jmz9p1KJ5D8HbacMiYjpK+cUE0WmViH4OfWabFsL6snlcJY=
X-Received: by 2002:a17:90a:304a:b0:1fa:d832:5aca with SMTP id
 q10-20020a17090a304a00b001fad8325acamr18804669pjl.16.1661153518102; Mon, 22
 Aug 2022 00:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <1661019430216134@kroah.com> <CAHk-=wiCbKaAhzhkSg1Y8DW-WZTkAdQJzXmRpnRBBC1stvKdkA@mail.gmail.com>
In-Reply-To: <CAHk-=wiCbKaAhzhkSg1Y8DW-WZTkAdQJzXmRpnRBBC1stvKdkA@mail.gmail.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 22 Aug 2022 09:31:47 +0200
Message-ID: <CAHUa44G=-LibdCHUKTXWuLkH7dSA5kdVOYMceXHXjVdgeMyGqg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tee: add overflow check in
 register_shm_helper()" failed to apply to 5.4-stable tree
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     gregkh@linuxfoundation.org, ch.anirban00727@gmail.com,
        debdeep.mukhopadhyay@gmail.com, jerome.forissier@linaro.org,
        neelam.nimish@gmail.com, stable@vger.kernel.org
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

On Sun, Aug 21, 2022 at 6:55 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Aug 21, 2022 at 12:00 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.4-stable tree.
>
> Yeah, there's some major re-org made by commit 53e16519c2ec ("tee:
> replace tee_shm_register()") and related in this area in v5.18.
>
> I think you need to just add that
>
>         if (!access_ok((void __user *)data.addr, data.length))
>                 return -EFAULT;
>
> to tee_ioctl_shm_register() just before the call to tee_shm_register().

That should work, but data.addr is a u64 so to avoid a warning like:
drivers/tee/tee_core.c:185:17: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
  185 |  if (!access_ok((void __user *)data.addr, data.length))

We should first cast it to an unsigned long or such first.

>
> It's where it checks "data.flags" too:
>
>         /* Currently no input flags are supported */
>         if (data.flags)
>                 return -EINVAL;
>
> so it lines up with that whole "check ioctl arguments in the memory
> block we just copied".
>
> But Jens should probably double-check that.

 I'll send a backported patch to take care of the warning I mentioned above.

Thanks,
Jens
