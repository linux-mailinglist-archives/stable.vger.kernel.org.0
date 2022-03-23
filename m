Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF44E5620
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 17:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbiCWQQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 12:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiCWQQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 12:16:12 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42955E760
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:14:42 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h7so3550791lfl.2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdNw3h0+GqlQUOcDQQoYbUH6YE+Z/MNxelfKkrFspss=;
        b=bYaF8wrP7y8uqChO284WXGKg9mgLkLJlSl0fDt/0ezF7jxEqA0gqwjdGveRqS2jEPs
         +3S/MnroCY5BpY9twrElUg554johu5+NqxO32QQ1nTuCPLJ0HrQlIkoBaSWJX23O5rwq
         PUxfzIDX5qElJ7qXBjuqeQ8NW7OJzHKZfllpNzUTjnL5IBMrnQSTWzyjAW/clf6+8CYr
         np0GqcJTpRvapsBgU7afPkmLntkPDh+yTQohKEbX/8FXOKb0tQZDbFU+JNL+ohZHOM6W
         hid8jhDXeLz5bDh5AZpiU8mBbthFuSScsP+MzJDoBYntINgtZyT5WAiWMJ3W4CpTjCpp
         7SFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdNw3h0+GqlQUOcDQQoYbUH6YE+Z/MNxelfKkrFspss=;
        b=lpAMnlo/FmS9yRS7HlsNJuEE6YGbGmXZ6mL31GQjH2HuUa2BgObLUOG9veOZK4ho6F
         W5f1e7GEx5vAj28/D+1sTAj9b7HktY5so0lJ0mv6j62n8qcwGBgPtXvZ7JmtZopv+2c6
         7wtzMuGeSrBXPBfPNd+TppcXLnwF7YdHKlsY9EyvhCm/yFl04DZ3X22J+gF93I5kqa/r
         Hotcui3hTVTRSDLFNYq07ym4y5bxKeqhW4/oAJVHJwrKPNEiZzZq8gTPdOTJxNoJmGPo
         ry03FpXwm9w0w9J0EJolkqmACjbdw+HqWjLh/Ug65C0PcEASCwFL+zlpqO7dH1boYcxx
         12Dg==
X-Gm-Message-State: AOAM531c1p8SenT2g1fR6amqniRvuJ/b/Y9EJwP4h13w3tUdJmyiCUbf
        xtfi57lyAvBQZP7tsdTCaZA0KzsJZ0k85UtMDdaDxc47Mj4=
X-Google-Smtp-Source: ABdhPJzmLhIaRu5FMRz4UF7A6nIwyFhsWC7QMLY9gzDLFyqXEvNkvX+GbRKMdDj+uUP1O40klIeTe1lXvk4EAjsAzjQ=
X-Received: by 2002:a05:6512:1114:b0:448:388c:b79f with SMTP id
 l20-20020a056512111400b00448388cb79fmr473580lfg.250.1648052080118; Wed, 23
 Mar 2022 09:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
 <YjmCh1SPUOJjM7Rf@kroah.com> <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
 <YjrF1nMHPzAuL2qq@kroah.com>
In-Reply-To: <YjrF1nMHPzAuL2qq@kroah.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Wed, 23 Mar 2022 09:14:28 -0700
Message-ID: <CAMVonLj28yC=8W5MH0_0oMnBwjQxzEjEDfnO3ze2Wu68zyQLGA@mail.gmail.com>
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

On Wed, Mar 23, 2022 at 12:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 22, 2022 at 09:53:09AM -0700, Vaibhav Rustagi wrote:
> > On Tue, Mar 22, 2022 at 2:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Mar 21, 2022 at 06:49:02PM -0700, Vaibhav Rustagi wrote:
> > > > Hi Greg,
> > > >
> > > > To fix CVE-2022-0886 in v5.10 and v5.4, we need to cherry-pick the
> > > > commit "esp: Fix possible buffer overflow in ESP transformation"
> > > > (ebe48d368e97d007bfeb76fcb065d6cfc4c96645). The commit didn't apply
> > > > cleanly in v5.10 and v5.4 and therefore, patches for both the kernel
> > > > versions are attached.
> > > >
> > > > In order to backport the original commit, following changes are done:
> > > >
> > > >  - v5.10:
> > > >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > > > "net/core/sock.c" to "include/net/sock.c"
> > >
> > > Did you see that this is already in the 5.10 queue and out for review
> > > right now?  Can you verify that the backport there matches yours?
> > >
> >
> > I was not aware that I could check that. Thanks for the hint.
> >
> > The change is not exactly identical. In addition to the change
> > mentioned in https://www.spinics.net/lists/stable/msg542796.html, I
> > have also removed following from "net/core/sock.c":
>
> Please use lore.kernel.org for mailing list links.
>
> >
> > -#define SKB_FRAG_PAGE_ORDER get_order(32768)
> >
> > This is done because "net/core/sock.c" includes "include/net/sock.h"
> > which defined the MACRO.
>
> So is the backport correct?  Or just different?
>
Backport in the mailing list is correct. I have tried that as well for
build and I didn't find any warning.

> thanks,
>
> greg k-h
