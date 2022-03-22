Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3424E4492
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 17:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiCVQyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 12:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbiCVQyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 12:54:53 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89B33EF3B
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 09:53:24 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id e16so16624694lfc.13
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 09:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jswCCmpyPJecTEttQI5HeBV1w2U4FYXHfnYSBXrk6r8=;
        b=cel3ahSbCQFFHZa5/a5n3X5hrK3WgthiBN21b0glQATecD9D+u2s0/Jy/c19i/XVJZ
         xLLv1+SoeHj1AkIc7vgVU7vyCWy59ZLKpYHL/4nL1HahCiA34P5Bz69bYmIhmM7FNn7O
         iPfDaoAjD05q+p/vi9+r/fpvLT/ehlG4HztBHBNRB9P8WjmOOtxw/rQZuNVZXNSxCBps
         RR7dqxiqzR4u0B+j9+wO0FS1g6fGMmj2ZzsCfVZeLdlc6B1P07xDcegH0Rpv/AY9t2Pq
         zh2FaLHISKarnv57s6LYkUo7UzZgJ5Ge8unqJKng4qUJWThGfc/VXcLC9f3FEk5wQWSj
         /YmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jswCCmpyPJecTEttQI5HeBV1w2U4FYXHfnYSBXrk6r8=;
        b=QH43bNZXG87YClDWgITt4qgEUe0ORL87VWOXBHcUT2QWrtbI0WWInwtLqO7eqGzhU7
         zBhPnRP/d4z+GGaU1mX8CEsgWLLaAXXkmudVLyafmsRSnE8ffJIXlYLviR2Le5KLFZXX
         qs4ZILUJHM39fbP7PWaV1xbcV8vNBYSsGPs8sam0413EQl6c7IcNOBL1jghhzE5COZDe
         Laq6VLnnrAr0GM1F7sh+X6X/xYdPq0fUeOiMq2PKisRwCU5Ah/se9c0wKKiGvbEc1rAf
         1h50OrOUxkazsGuRrHpg5iO+1x2Q678v29HIC0Ta3QykLZ1mjaph1xCo/vookHIAa1QF
         mcOg==
X-Gm-Message-State: AOAM5335j72A6DzeMUT1gZbjKiggsTKIoZ99ik2EVfqm84V0Te/42nFQ
        SeY5YNIPtAkjGktqvYwFYbxLup4yrWuocFR1VLWrDF3uLahsSQ==
X-Google-Smtp-Source: ABdhPJxwBDURHGCou9O0D98jAViTZc/JiN0MvrhjeoYvIj4pSAlAo9Ts9j/sKZywBkTJ8/z7DxNwaeouy3TnKIfwwAk=
X-Received: by 2002:a05:6512:3b0a:b0:44a:2e21:ef25 with SMTP id
 f10-20020a0565123b0a00b0044a2e21ef25mr6705879lfv.333.1647968000701; Tue, 22
 Mar 2022 09:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
 <YjmCh1SPUOJjM7Rf@kroah.com>
In-Reply-To: <YjmCh1SPUOJjM7Rf@kroah.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Tue, 22 Mar 2022 09:53:09 -0700
Message-ID: <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
Subject: Re: Cherry-pick request to fix CVE-2022-0886 in v5.10 and v5.4
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, steffen.klassert@secunet.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 2:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 21, 2022 at 06:49:02PM -0700, Vaibhav Rustagi wrote:
> > Hi Greg,
> >
> > To fix CVE-2022-0886 in v5.10 and v5.4, we need to cherry-pick the
> > commit "esp: Fix possible buffer overflow in ESP transformation"
> > (ebe48d368e97d007bfeb76fcb065d6cfc4c96645). The commit didn't apply
> > cleanly in v5.10 and v5.4 and therefore, patches for both the kernel
> > versions are attached.
> >
> > In order to backport the original commit, following changes are done:
> >
> >  - v5.10:
> >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > "net/core/sock.c" to "include/net/sock.c"
>
> Did you see that this is already in the 5.10 queue and out for review
> right now?  Can you verify that the backport there matches yours?
>

I was not aware that I could check that. Thanks for the hint.

The change is not exactly identical. In addition to the change
mentioned in https://www.spinics.net/lists/stable/msg542796.html, I
have also removed following from "net/core/sock.c":

-#define SKB_FRAG_PAGE_ORDER get_order(32768)

This is done because "net/core/sock.c" includes "include/net/sock.h"
which defined the MACRO.

> >  - v5.4:
> >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > "net/core/sock.c" to "include/net/sock.c"
> >     - Ignore changes introduced due to `xfrm: add support for UDPv6
> > encapsulation of ESP` in esp6_output_head()
>
> Thanks for this one, I'll queue it up after this next round of releases.
> What about 4.14 and 4.19?  Will this backport work there?  If not, can
> you provide a working one?
>

I haven't tested the change in v4.14 and v4.19. I will check out those
trees and check whether the current patch will work or not.

> thanks,
>
> greg k-h

Regards,
Vaibhav
