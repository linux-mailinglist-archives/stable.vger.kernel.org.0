Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884242903AF
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 13:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406696AbgJPLAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406692AbgJPLAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 07:00:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC74C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 04:00:22 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d6so1057547plo.13
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 04:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBlnGOyWJl5jqMghAxsBSmAf4foQJCCn7+HIncdnhB0=;
        b=h5b9LupQUgg8tB+cOtqi6/FbrS57XFIbBsKMPMEaXsT6VBPIaKUWsNPjONNTwWmyBV
         dIayyIIrYfzkFnntkWhq5brJmOmJ8a2IhD+FT0h2iMYD5NqalmCr9qYYaJl00hcyhpKW
         M+zawjl2bDIAU6+H1VqnLJxf/3qIs5rdq2kMOb8hQVJrO5yTPUbqsINfONkPFpHey7NW
         UL4UqlSvduFanCxu0ZWlRcolc1/O6xbhCRSE6jDihNvwA1s/dh4BDZNSCLsC13rUtCq7
         DsADxoUkiAEZ6GvFHJN6vSDQ6sa/PL4i0+ek5LevlYyvUnY5cwhrsX5HbgO8n5VKmtSh
         jvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBlnGOyWJl5jqMghAxsBSmAf4foQJCCn7+HIncdnhB0=;
        b=fF7Rgp0Pc2rT7R/31C4DTKy+M11n2LtSdBj0w9HJSJIHBAB6iYvC/N1LJSB24BFJMA
         KTb6L7yOOfBzPrnXQZx9NmAq4Y9FcRa42Ti4bXcwO8YDf3U7ZOD2SG2Zmdx7hG7HtSqY
         uD4GQZT4pavdif9gpD1CgA9mmRTx7/TdKcr2ThqQAn2Oj9PEingUA4/YkR+mD4IwVUf0
         zUuSu9OS43/oBpejNBv7KvqPotSbQTUttDWUlXzlk7E6svvpcL5sJaKOHbstIXZdcuK9
         y1grB/CDbuXc8567y54/ueogvPDrjajMhYSD9SkfmILL0OM00PhK6sHb8OmiFkfMMjP3
         ohoA==
X-Gm-Message-State: AOAM530MKwY35HGJAlKvKeBg/gMd2/i/lYNE4uPlmehM6EwSmrtsV9K6
        XZq184fK7fQhgZF7Gj3X8himdExSk+zuQVJpMg==
X-Google-Smtp-Source: ABdhPJxW1BZ7P/sHQe5T4Jjlcf6shGk/iv+SZyWQQq76ng8HqplmrDg8lPmUYHKGR1D28h3hnZb9JkEFTvvgf3zTbFA=
X-Received: by 2002:a17:902:b696:b029:d5:cb0b:976f with SMTP id
 c22-20020a170902b696b02900d5cb0b976fmr797604pls.26.1602846022441; Fri, 16 Oct
 2020 04:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <CALjTZvZ_hesn5D34o7+X-gffN-POPzk49-ExB_r-sCpupdTtmA@mail.gmail.com>
 <20201016095300.GA1769500@kroah.com>
In-Reply-To: <20201016095300.GA1769500@kroah.com>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Fri, 16 Oct 2020 12:00:11 +0100
Message-ID: <CALjTZvZvnSFTxXWB3COGOAC_0G9ZGhLxPVrbQc84Jh6QJ=bv1w@mail.gmail.com>
Subject: Re: Backport request: arm-8987-1-vdso-fix-incorrect-clock_gettime64.patch
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, jaedon.shin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

On Fri, 16 Oct 2020 at 10:52, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> But that's not what that commit says should happen, it says it fixes a
> commit that showed up in the 5.5 release.
>
> Is it incorrect?  Have you tested this on 5.4.y?

Well, this took quite a lot of digging, sorry for the delay (I'm
definitely not a timers/vDSO expert, I was just trying to understand
the reason for a strange Musl workaround [1]), but you're completely
right. Only 5.5+ is affected, since it was at that time the
clock_gettime64 entry point was introduced for ARM [2].
Sorry for the noise!

Thanks,
Rui

[1] https://git.musl-libc.org/cgit/musl/commit/?id=4486c579cbf0d989080705f515d08cb48636ba88
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm/vdso?id=74d06efb9c2f99b496eb118b1e941dc4c6404e93
