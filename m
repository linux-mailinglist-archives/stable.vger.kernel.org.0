Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE0E4E892A
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 20:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiC0SEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 14:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiC0SEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 14:04:14 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E71B344F4
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 11:02:35 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s25so16421926lji.5
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 11:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQOFDrIFh2bz70XHqIr89KbFLDHUuV5VP66dlTu2bGw=;
        b=UaVNLwcZnvNLhG+fejMyq3YjMXYSMxy5CO44s6uUwA0vwEwVOizoIns9xkanN7LLp0
         W1vSRjwHVhQ+ttok6Z7J+uole/YvctKvrH6MJNpHghzdUIo/cKLR1r4McGrH4Vruxf7W
         HID+h3OJaj/oQ34G67d/vgqL0v6Fwqnq6rLSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQOFDrIFh2bz70XHqIr89KbFLDHUuV5VP66dlTu2bGw=;
        b=ZTa0NdH3hJXAPlUU+RsXf5eJM5F3g+1+WvoR+6BA0RGB7nma0aEQWdDdxb8jMlMreT
         lU6iNGLoYkhcXP7a5sbI3a57FuJN/dgasAVIeE+9vBHGs4R/REoAa+ECqpsA5glTLWpx
         oCTdqTxux98bmlkRLw/TxKUac1xy7WxcRS7UKNww+jbC8JUb8zZDx06ZFfc3VeuPrEHg
         Ux3rybOmmPC/P5ZNtLwGSTqR7XSkm1vAPviPmXjI4e8Oe4ogVjbMEqyDYbRetT628Lt5
         N4cf0uttp0pd7wKxg7iqkaVxpTbYjuWTuJJO+qgZrhU+5la39yghrydKRIfaHpbpufhx
         RRrA==
X-Gm-Message-State: AOAM531TgRBgFxRBeSqYJd2tnBBtFcIpaiKAZwlqzUL3CuQbz+Ri610i
        +7N0OCNTY0HvRGU7nC460vyxlytSN53Yy8QAAdQ=
X-Google-Smtp-Source: ABdhPJxszGr8Hg3Fw/4ogeTiZKgP1pqN9+l+zs04OXlz/RaNNl4S/ovRY5ir6WfkL6MfMludD3hSeQ==
X-Received: by 2002:a2e:6e0d:0:b0:247:fc9c:284e with SMTP id j13-20020a2e6e0d000000b00247fc9c284emr17181746ljc.251.1648404152650;
        Sun, 27 Mar 2022 11:02:32 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id d16-20020a2eb050000000b002461d8f365bsm1478402ljl.38.2022.03.27.11.02.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Mar 2022 11:02:30 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id bt26so21194570lfb.3
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 11:02:29 -0700 (PDT)
X-Received: by 2002:a05:6512:3d8f:b0:44a:2c65:8323 with SMTP id
 k15-20020a0565123d8f00b0044a2c658323mr16370626lfv.52.1648404149184; Sun, 27
 Mar 2022 11:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150419.757836392@linuxfoundation.org> <20220325150420.085364078@linuxfoundation.org>
 <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
 <Yj7oXgoCdhWAwFQt@kroah.com> <CAHk-=wgeOrhN_Gznm80==STG1pEbqLMCaZZoeQzZu=NN9GOTgw@mail.gmail.com>
 <YkAuqiHAEaDLHDAO@kroah.com>
In-Reply-To: <YkAuqiHAEaDLHDAO@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 27 Mar 2022 11:02:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzSHQqz33i0DfmFyEG43eeyDkkUO=a3jY0eH2h_1AwgA@mail.gmail.com>
Message-ID: <CAHk-=wgzSHQqz33i0DfmFyEG43eeyDkkUO=a3jY0eH2h_1AwgA@mail.gmail.com>
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
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

On Sun, Mar 27, 2022 at 2:30 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> But why did you just revert that commit, and not the previous one (i.e.
> the one that this one "fixes")?  Shouldn't ddbd89deb7d3 ("swiotlb: fix
> info leak with DMA_FROM_DEVICE") also be dropped?

The previous one wasn't obviously broken, and while it's a bit ugly,
it doesn't have the fundamental issues that the "fix" commit had.

And it does fix the whole "bounce buffer contents are undefined, and
can get copied back later" at the bounce buffer allocation (well,
"mapping") stage.

Which could cause wasted CPU cycles and isn't great, but should fix
the stale content thing for at least the common "map DMA, do DMA,
unmap" situation.

What commit aa6f8dcbab47 tried to fix was the "do multiple DMA
sequences using one single mapping" case, but that's also what then
broke ath9k because it really does want to do exactly that, but it
very much needs to do it using the same buffer with no "let's reset
it".

So I think you're fine to drop ddbd89deb7d3 too, but that commit
doesn't seem *wrong* per se.

I do think we need some model for "clear the bounce buffer of stale
data", and I do think that commit ddbd89deb7d3 probably isn't the
final word, but we don't actually _have_ the final word on this all,
so stable dropping it all is sane.

But as mentioned, commit ddbd89deb7d3 can actually fix some cases.

In particular, I do think it fixes the SG_IO data leak case that
triggered the whole issue. It was just then the "let's expand on this
fix" that was a disaster.

                  Linus
