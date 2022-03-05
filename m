Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7B4CE69A
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 20:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiCETqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 14:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiCETqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 14:46:06 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F58559A
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:45:15 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id o6so15248649ljp.3
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 11:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LPoOJ4AaVNL3oCNAAPlELZgxMH2Mdvtu3dbXK4LFzGs=;
        b=VP5ml3rhFccJpQT10F3e7U/zoXUd4YieWbaCb33Zddq/fZ5PPyqKrvHehNKXJqspFK
         t0tbIAsfMCXqBZGAxQ7y5zWU067Uum1XlNQ1M5GMkpzR6hRmOjp5TBpqLxpXZ+9kLLXT
         asBh+rJ5Sj8uEdX26hAQGU9heQsqmTwvFUnvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LPoOJ4AaVNL3oCNAAPlELZgxMH2Mdvtu3dbXK4LFzGs=;
        b=bjOC26HVauMJT9gZTsBW1Hqt8OnC/Q6wQwVuOW4MKS+oD1q+/qREd243d9sgXhImD0
         rO7oB7d4fs1dvdXOSTBMtB7FyCK7/d/9fizfqkFhdWYRceBngVtjFS+BOduZymaolFtS
         Uxyf66ya7zKij/l0MqWsLPerhtSoRwiXr3o7HBQ2gPR6LQ9GolTf08lLGvxnl+5iLPlj
         jAdAgjOwUf6wscn9tvkaVLqvNSV6V24VSEgDEExuH1+FnZHwYe9WYTq2m+7g90AMw/VM
         mceIbVsTNUO+9HrfT5LQxuKBHgBdnz+zCxt/1xMsftTUeUE+sp4PLH/kO5Lufa8IvsGs
         3ysg==
X-Gm-Message-State: AOAM532mSEv123IUXzxO4hMsenHXNRMHcakNKNN/wVgxz/43X3+KD/RU
        o8x8Bgwf1T5qxltkOborFs1B468taNXMqgUHU3c=
X-Google-Smtp-Source: ABdhPJwmxMzDhJqFV9nryqkFHx9/5eUo/iSFsj0kO0JWn/NrkXBvnJz5Fd+xypXl0J7HQjJCnMqhOw==
X-Received: by 2002:a2e:9d89:0:b0:244:1ed:1960 with SMTP id c9-20020a2e9d89000000b0024401ed1960mr2876431ljj.413.1646509510930;
        Sat, 05 Mar 2022 11:45:10 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id k8-20020a2eb748000000b00244badbe7c9sm1853386ljo.60.2022.03.05.11.45.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 11:45:08 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id bu29so19877113lfb.0
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 11:45:08 -0800 (PST)
X-Received: by 2002:ac2:41cf:0:b0:448:1eaa:296c with SMTP id
 d15-20020ac241cf000000b004481eaa296cmr3118225lfi.52.1646509508091; Sat, 05
 Mar 2022 11:45:08 -0800 (PST)
MIME-Version: 1.0
References: <20220305170714.2043896-1-pasic@linux.ibm.com>
In-Reply-To: <20220305170714.2043896-1-pasic@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Mar 2022 11:44:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgZ6fNG03pd2pAVw9RtymwPDyHNvTLHr2Q3LX3S0Y1k5Q@mail.gmail.com>
Message-ID: <CAHk-=wgZ6fNG03pd2pAVw9RtymwPDyHNvTLHr2Q3LX3S0Y1k5Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        stable <stable@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        iommu <iommu@lists.linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
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

On Sat, Mar 5, 2022 at 9:07 AM Halil Pasic <pasic@linux.ibm.com> wrote:
>
> Unfortunately, we ended up merging an old version of the patch "fix info
> leak with DMA_FROM_DEVICE" instead of merging the latest one. Christoph
> (the swiotlb maintainer), he asked me to create an incremental fix
> (after I have pointed this out the mix up, and asked him for guidance).
> So here we go.
 [...]

Christoph, I am assuming I'll get this from you, but if you have
nothing else pending, just holler and I can take it directly.

That said, it seems sad to bounce the buffer just in case the device
doesn't do what we expect it to do. Wouldn't it be better to just
clear the buffer instead of copying the old data into it?

Also, possibly stupid question - when is swiotlb used in practice
these days? What are the performance implications of this? Will this
mean completely unnecessary copies for all normal IO that will be
overwritten by the DMA? Can't we limit it to just SG_IO (or is it
already for some reason)?

                  Linus
