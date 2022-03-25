Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3344E7CFA
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiCYTqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 15:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiCYTqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 15:46:42 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA1E27381A
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:28:11 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m3so14973725lfj.11
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c98skZ0BjUMamIjtZ5imiZLVO/gl8DuHYbRwakJRogU=;
        b=Suev8BbZiQARkSS4t03OA365leJb0pqRURfN9ENchEyRkWs2YFj9yYWgBOyB03AwTX
         YhQZoZ7id1LSxPtVADVUj2io0XoJ1lCVLAHAHk2KnNq1hnonb7XuA9aYxWYlTBAgFBqO
         RtHXpHxhqkzfBGrkr/vstccVIywh2CCLpuHps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c98skZ0BjUMamIjtZ5imiZLVO/gl8DuHYbRwakJRogU=;
        b=jjUVuMPP1Xv24T62mk1M4jVwSSfzwrTv6J0QRU6+EVpAI9aOgutDUk11LayPRTZHuH
         +wn2xXzV/q7gEhkSJbZnQObVIQIFbm+JQps5a1lhc8htQKMddtEVRYiZA+0h2EnWIfiZ
         ka0LGMcF4RHwPX6+L+05S0eYI3Kh0P30YvJWtAJVMLuM+Po0K65px82go4H45GxJT0y3
         ifT/VW+fuFyUV07AJES4C/e+BIbyTP8mChCjb1AvOfueIxBBlOx486gG2+ivUYvhIvoF
         JTdgFlcufYpPGSXzryYzs9v/jV3cUI9DdNFH9m5aeLzqDxtRHh8S47F2GnCKKPO/A1cS
         aKlw==
X-Gm-Message-State: AOAM530rTwsUG6GAZ0DTw8q+X6iIMUXggSkel5hakKD1v0iPashJw4Da
        2YTmNv5/nLHpfDgTJXTk6GSJ3azTqCRO7yblijY=
X-Google-Smtp-Source: ABdhPJyIKvJTUQVX0eLLD9ZBNGFn71+80DeeXuSt7lWY58zeEpwGtFi1eq0TA2rGurxYg9wlObSXvQ==
X-Received: by 2002:a05:6512:2291:b0:44a:78c5:35ad with SMTP id f17-20020a056512229100b0044a78c535admr2216566lfu.60.1648236484216;
        Fri, 25 Mar 2022 12:28:04 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id u11-20020a19600b000000b0044a37ab974fsm797367lfb.51.2022.03.25.12.28.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 12:28:01 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id w27so15014039lfa.5
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:28:00 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr9229114lfj.449.1648236479896; Fri, 25
 Mar 2022 12:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com> <12981608.uLZWGnKmhe@natalenko.name>
In-Reply-To: <12981608.uLZWGnKmhe@natalenko.name>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Mar 2022 12:27:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghZ3c4G2xjy3pR7txmdCnau21z_tidjfU2w0HO-90=sw@mail.gmail.com>
Message-ID: <CAHk-=wghZ3c4G2xjy3pR7txmdCnau21z_tidjfU2w0HO-90=sw@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 12:26 PM Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> On p=C3=A1tek 25. b=C5=99ezna 2022 19:30:21 CET Linus Torvalds wrote:
> > The reason the ath9k issue was found quickly
> > is very likely *NOT* because ath9k is the only thing affected. No,
> > it's because ath9k is relatively common.
>
> Indeed. But having a wife who complains about non-working Wi-Fi printer d=
efinitely helps in finding the issue too.

Well, maybe we should credit her in the eventual resolution (whatever
it ends up being).

Although probably not using that exact wording.

        Linus
