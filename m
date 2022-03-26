Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1774E8493
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 23:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiCZWnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 18:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiCZWnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 18:43:40 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71082F3B4
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 15:42:03 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a30so7142009ljq.13
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 15:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lSLy1cPxoDC//3e7623ZX4es74MP3w4cCLgF29j5fUU=;
        b=HTqOpqutn/t7/GJQrakk/gAhabnVwnukxwMtMja/1SljWHCaJh+ZhMav3V4OqLq1/m
         JldSGIs54yIcMbIeQmTLdzLUuMQeARuWCJqZUzEEphC4IEXZ9NChSkH88YY0FSWwPQJu
         U24K7ZOq8FQZ2yFFgeY8MWj+ZVkdrqhAUb3Tw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lSLy1cPxoDC//3e7623ZX4es74MP3w4cCLgF29j5fUU=;
        b=d/cNVQU37c10B/QUW6B5AptCBPypqMpW64g4ujY2EOP4j2hdlFA4xMmP7sFcrv2z99
         CLs/MbhlSJRruvsa6vxUnm58IXucaSR5nq7Jjz71fuseg2gZ3fIjwIuSRkUX1KQkHUb7
         TpPz0nmmtxMn0vIinIpLwVF0o0EC4qXdIolW2xBmD8eb3Bj0EIvlOAmB36BG/YJYWuek
         cuVMd8mxNFmKq0mA2h59+Mx1pQkGJuhxDiFcyJHPWfwHNRwG+KXSgxayN4xRKMyHJ26e
         dEEEGghUajCA5EmH20PtqhCwSDHZLf2bvxqKr466k7pnufghqO4DTtGgI2+JGk8xU/dK
         sVLw==
X-Gm-Message-State: AOAM531V22TT44i4DNE0Nlft8XYQtVWJ5G+Fig6EMBBlLXWwyepEuBSx
        qQWxqjA3Geb6tCkQd57tB+GoyghxXGUSaF0vbII=
X-Google-Smtp-Source: ABdhPJz4V+ddpTwNxhWNtTRr/5B6dslV/YXa1AVnsQLeXbA7IcGWC2vYjU9r/GZhKX5l0w7L/2/Z7g==
X-Received: by 2002:a2e:bc19:0:b0:249:b29c:7f5e with SMTP id b25-20020a2ebc19000000b00249b29c7f5emr10709945ljf.312.1648334521771;
        Sat, 26 Mar 2022 15:42:01 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id q21-20020a194315000000b0044a1e36fda4sm1190366lfa.25.2022.03.26.15.41.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 15:41:59 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id bq24so3056401lfb.5
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 15:41:57 -0700 (PDT)
X-Received: by 2002:a05:6512:b13:b0:448:90c6:dc49 with SMTP id
 w19-20020a0565120b1300b0044890c6dc49mr13805287lfu.542.1648334517200; Sat, 26
 Mar 2022 15:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <cce202fb-5185-aa3e-9e9b-11626192cb49@arm.com> <20220326003853.44c3285c.pasic@linux.ibm.com>
 <8735j47l7y.fsf@toke.dk> <CAHk-=wjorwZTQuQB8QBgNpdBZNz7uyprgaTT+1Q6_1FaT3sAmQ@mail.gmail.com>
 <d9fbd3ab9b514b0d8121d4d7d21662a6@AcuMS.aculab.com>
In-Reply-To: <d9fbd3ab9b514b0d8121d4d7d21662a6@AcuMS.aculab.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Mar 2022 15:41:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgqHqb_yaNUGwMfLJJw28VvauSB6sSMCi3Bu7Q0-N0GEQ@mail.gmail.com>
Message-ID: <CAHk-=wgqHqb_yaNUGwMfLJJw28VvauSB6sSMCi3Bu7Q0-N0GEQ@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     David Laight <David.Laight@aculab.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxime Bizon <mbizon@freebox.fr>,
        Netdev <netdev@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        iommu <iommu@lists.linux-foundation.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 3:38 PM David Laight <David.Laight@aculab.com> wrote:
>
> Is the idea of 'buffer ownership' even a good one?

I do think it might be best to not think in those terms, but literally
just in data movement terms.

Because the "buffer ownership" mental model is clearly confused, when
data transfer might be ongoing, but the CPU might need to just look at
"what's going on right now" without actually taking any ownership of
the buffer.

                Linus
