Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263CC51E5A2
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382906AbiEGIpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 04:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346493AbiEGIpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 04:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14F0D3EF31
        for <stable@vger.kernel.org>; Sat,  7 May 2022 01:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651912906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pH/8q4WWU1F57uoZuiEXN9uHXlw/jrDUSuY49/KnKJw=;
        b=M5mNLNCuhruwJDnEp3rKN/ca69IJlmsWWJMEcot8/3vir0vmevHR3WpSkucCykpivUfUTe
        Sjs/Fei5Ab23uIy4E7dOrXgeV9+FWFYuwW1aQMYzfEDZTcGGaR+Z8Mm4WRYSopER3WQ9zT
        a1eHn51N+Tyi1oDTqQzdLOYvJTH8wsY=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-N3IM0C23NnOzquWD1mmy6Q-1; Sat, 07 May 2022 04:41:45 -0400
X-MC-Unique: N3IM0C23NnOzquWD1mmy6Q-1
Received: by mail-yb1-f200.google.com with SMTP id j11-20020a05690212cb00b006454988d225so8085505ybu.10
        for <stable@vger.kernel.org>; Sat, 07 May 2022 01:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pH/8q4WWU1F57uoZuiEXN9uHXlw/jrDUSuY49/KnKJw=;
        b=FElivkS03LbNzlS9re4iUbGvm3bpamtV1kLN+fUAWTtvQG/PKq7QTANeGAkSIz0kuD
         Ij8h+hMQktId+9WJ7xBorP5KjNvjWANzm45ZsnVyTD7NQXoWTqchdCWlJJaOtJcipIpr
         69oV+R1le0kBaLMeajiBOtSPQv/WvkyezK9xaEtwNXrTvGh2tyGY5RZ9RL9qlQLULUFG
         leyTGqLJ4EuaqpwmWIgGV8DjF/JPJ5hWXEggpYkAwct+WE2wOtjbyjchkcJdGdo2g2wH
         Yh+0HRUW/F59uSqImXgzu/fskJ9+s0fgiUAi2iD7/gARMvXHKI1z47rW0p+9YSL02wUG
         57/Q==
X-Gm-Message-State: AOAM532gAydu11GVldJeY2fKlpho9KISOVottZC0qqvwBRdU5WjC+MkK
        yatC69AhjZQqBjmHlVPkoIUyNBLxOYFYySB9LEhPY1uW9j57uJ5RXMNw4s2yYH3ZvaxztwgO8F5
        UwF/IAafFSObhCc7F0czttL9A+ZBK02iH
X-Received: by 2002:a25:d209:0:b0:648:370f:573c with SMTP id j9-20020a25d209000000b00648370f573cmr5570216ybg.255.1651912904429;
        Sat, 07 May 2022 01:41:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL8lHgmhm01MbdmhDDqtcHd5MtPPN2X8/3Y6Vo0COEyOTfbsiMCUsGQj/N/qrO0ZhjLJ/gcTEuPNxd2WmE35I=
X-Received: by 2002:a25:d209:0:b0:648:370f:573c with SMTP id
 j9-20020a25d209000000b00648370f573cmr5570202ybg.255.1651912904261; Sat, 07
 May 2022 01:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220503115010.1750296-1-omosnace@redhat.com> <YnFUH6nyVs8fBgED@x1>
In-Reply-To: <YnFUH6nyVs8fBgED@x1>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Sat, 7 May 2022 10:41:32 +0200
Message-ID: <CAFqZXNsQK-0knY-W4YojJEFapJyWZBsf9sE=L=0drXnb4SPQeA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qcom-rng - fix infinite loop on requests not
 multiple of WORD_SZ
To:     Brian Masney <bmasney@redhat.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 3, 2022 at 6:11 PM Brian Masney <bmasney@redhat.com> wrote:
> On Tue, May 03, 2022 at 01:50:10PM +0200, Ondrej Mosnacek wrote:
> > The commit referenced in the Fixes tag removed the 'break' from the else
> > branch in qcom_rng_read(), causing an infinite loop whenever 'max' is
> > not a multiple of WORD_SZ. This can be reproduced e.g. by running:
> >
> >     kcapi-rng -b 67 >/dev/null
> >
> > There are many ways to fix this without adding back the 'break', but
> > they all seem more awkward than simply adding it back, so do just that.
> >
> > Tested on a machine with Qualcomm Amberwing processor.
> >
> > Fixes: a680b1832ced ("crypto: qcom-rng - ensure buffer for generate is completely filled")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> Reviewed-by: Brian Masney <bmasney@redhat.com>
>
> We should add '# 5.17+' to the end of the stable line.

Is that really relied upon any more? AFAIK, the stable maintainer(s)
already compute the target versions from the Fixes: tag. And the
version based on the original commit would be inaccurate in many
cases, as the commit may have been already backported to earlier
streams and you need to patch those as well. Thus, I believe it's
better to leave out the version hint and force people to look up the
Fixes: commit instead, which is more reliable. Also if you grep the
latest mainline commits for 'Cc: stable@vger.kernel.org', you'll see
that most commits don't include the version hint any more.

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

