Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8C69D3CC
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjBTTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjBTTG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:06:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E8D21A13
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC943B80DC6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 19:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5902EC433A1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676919909;
        bh=PZ6tDPtwPjbEMYbKxM+KYSSu33m01JZndukjYPZajdw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sMePoKvC5jzkooQ+Sh6vmobmONrTT8878HiZOFfKtPk9npJnxeLVM4dNDD9/F+xmz
         5XV6siUbv8IIKAKETJjSjYkOt9rm+x7a6vvt0yv5M2npZeo/TNkLwXqwfviMzlZHbx
         WXyd9vrXgwhY/wMHWekjuSo0RhzEsCovojNqD0mLn9403fNmxG9Iw+wd7YDm3f2hT0
         zU+aYvsTLX3yqO3vxzfr1Nd0RWvj4zW52wnhtV/+sGAKV1KrezQFx4W299v75tUR4E
         dY4espsNs3fGosXRxGRsDSXG0MQjezUuc1AfUB0Am7+jjQMR0l7Z+jTAvkRNt70Td+
         qUoL+4xDTdLGA==
Received: by mail-ed1-f47.google.com with SMTP id h32so8614788eda.2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:05:09 -0800 (PST)
X-Gm-Message-State: AO0yUKWkFM8+5JtcbDV6gqnfRRy/M3DOF3kxw8a1Xq/tEbvJvAkupp0G
        ZNUTIc5BZ4wQWEcFz9Y7MjQiYDDNTjZQVmSOyw2+4A==
X-Google-Smtp-Source: AK7set8Whr51kX9RbFrqXcODsIse9VvV5gMLpZxWyxjeYOW0Khw2lItyJDGXteRctqMAzk4roJsWTMQzBrR9ETvT5hk=
X-Received: by 2002:a17:906:6d07:b0:8af:4963:fb08 with SMTP id
 m7-20020a1709066d0700b008af4963fb08mr5139809ejr.15.1676919907551; Mon, 20 Feb
 2023 11:05:07 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble> <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble> <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <20230220182717.uzrym2gtavlbjbxo@treble> <CACYkzJ5z3qLhkWqKLvP55HcjLACzAJbFjc4XjRzcft9ww40MaQ@mail.gmail.com>
 <20230220185957.yzjdnhcqpmkji2xs@treble>
In-Reply-To: <20230220185957.yzjdnhcqpmkji2xs@treble>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 11:04:56 -0800
X-Gmail-Original-Message-ID: <CACYkzJ6p0+bTjbAyv6PD+ZKyyfjM9NyvtuMB-vwNHkeWm72B7A@mail.gmail.com>
Message-ID: <CACYkzJ6p0+bTjbAyv6PD+ZKyyfjM9NyvtuMB-vwNHkeWm72B7A@mail.gmail.com>
Subject: Re: [PATCH] x86/bugs: Allow STIBP with IBRS
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:00 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Mon, Feb 20, 2023 at 10:33:56AM -0800, KP Singh wrote:
> >  static char *stibp_state(void)
> >  {
> > -       if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > +       if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))
> >                 return "";
> >
> >         switch (spectre_v2_user_stibp) {
> >
> > Also Josh, is it okay for us to have a discussion and have me write
> > the patch as a v2? Your current patch does not even credit me at all.
> > Seems a bit unfair, but I don't really care. I was going to rev up the
> > patch with your suggestions.
>
> Well, frankly the patch needed a complete rewrite.  The patch
> description was unclear about what the problem is and what's being

Josh, this is a complex issue, we are figuring it out together on the
list. It's complex, that's why folks got it wrong in the first place.
Calling the patch obtuse and unclear is unfair!

> fixed.  The code was obtuse and the comments didn't help.  I could tell
> by the other replies that I wasn't the only one confused.

The patch you sent is not clear either, it implicitly ties in STIBP
with eIBRS. There is no explanation anywhere that IBRS just means
KERNEL_IBRS.

>
> I can give you Reported-by, or did you have some other tag in mind?
>
> --
> Josh
