Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63D567F088
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 22:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjA0VkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 16:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjA0VkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 16:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF791C5AB;
        Fri, 27 Jan 2023 13:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8BB661DBB;
        Fri, 27 Jan 2023 21:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4182BC433A4;
        Fri, 27 Jan 2023 21:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674855616;
        bh=b9uDjU7LT+I/mG+9iGB49kgfPiodbLBnJTjLq2lnm9w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N3qRZC8vEwy5COnn34s8YMMpSApDx6S6U9Hg+fU42RD4JGew2wmhznAk/VjOdZkam
         9NBxaiAj5+cadTfif/p7cWIYOhLXXMaTIZQZRTu+uFhVLbAznHoNYkWkAciTgCFyZy
         sqTYII8kp4HDvDDv7k+qe13bqVo0GfIrSbgrj6UDmN71bNqkeecGbTz4v+rpKo68ql
         aNrcFQ0S5pc6cX35LcQ+p1568wjF4D1lMAIg5dTaQQMtlP4frLcUM30CFpHN5JNotn
         r/g30uCOFwFNRO6AWkfRTY/pJyl/4oOI78VkaMnSXEeV0ddnmKqSSVhUw/7tZ0oVY7
         FBp+cCG3Ml9Qw==
Received: by mail-vk1-f171.google.com with SMTP id t190so3055594vkb.13;
        Fri, 27 Jan 2023 13:40:16 -0800 (PST)
X-Gm-Message-State: AFqh2ko3Y+TjUyjEYJZCiKiE+WcQBAfcnV0shUoLbr8fC9MyaNKMvjeI
        Lqh3+0sLLeRYNk9FvADX5CXBfnrQ9Oa2jzmhYA==
X-Google-Smtp-Source: AMrXdXulnAkMWnXjcpXL/m412Iyt/Rx5osfcz9TGvRj6nAOp0u1AZt82H8i3SoeHOSB0ncQUU08SxYlZ7jc24m80yTs=
X-Received: by 2002:a1f:ad56:0:b0:3bc:8497:27fd with SMTP id
 w83-20020a1fad56000000b003bc849727fdmr5298244vke.15.1674855615161; Fri, 27
 Jan 2023 13:40:15 -0800 (PST)
MIME-Version: 1.0
References: <20230124230254.295589-1-isaacmanjarres@google.com> <167485548359.726924.14589412750691974893.robh@kernel.org>
In-Reply-To: <167485548359.726924.14589412750691974893.robh@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 27 Jan 2023 15:40:03 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKdHiZ0q8TkfjW6SUYg-_p4PxcGfA6SV0Q3Dif_dSY75Q@mail.gmail.com>
Message-ID: <CAL_JsqKdHiZ0q8TkfjW6SUYg-_p4PxcGfA6SV0Q3Dif_dSY75Q@mail.gmail.com>
Subject: Re: [PATCH v1] Revert "mm: kmemleak: alloc gray object for reserved
 region with direct map"
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Frank Rowand <frowand.list@gmail.com>, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org,
        Calvin Zhang <calvinzhang.cool@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 27, 2023 at 3:38 PM Rob Herring <robh@kernel.org> wrote:
>
>
> On Tue, 24 Jan 2023 15:02:54 -0800, Isaac J. Manjarres wrote:
> > This reverts commit 972fa3a7c17c9d60212e32ecc0205dc585b1e769.
> >
> > Kmemleak operates by periodically scanning memory regions for pointers
> > to allocated memory blocks to determine if they are leaked or not.
> > However, reserved memory regions can be used for DMA transactions
> > between a device and a CPU, and thus, wouldn't contain pointers to
> > allocated memory blocks, making them inappropriate for kmemleak to
> > scan. Thus, revert this commit.
> >
> > Cc: stable@vger.kernel.org # 5.17+
> > Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
> > Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> > ---
> >  drivers/of/fdt.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
>
> Applied, thanks!

Or not. Andrew already applied it.

Rob
