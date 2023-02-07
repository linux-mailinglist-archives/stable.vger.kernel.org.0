Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD2368D06F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 08:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBGHSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 02:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjBGHSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 02:18:11 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A761E9CF
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 23:18:10 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id o13so14092968pjg.2
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 23:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rymv0Qunjk0crbjvnwOGkGZRPnKg3lNe+kv8MV7OE6c=;
        b=ZAAMLg+Qkw3wAKPxdiAaLnX/gRbYPF2PMZS4CeM1r7bJqU9s/aOKonoCYFwFpLrQt+
         HT6EtWBNFmbgMA31SaTBlgbaEs2Gy/sYqcUeSjuvN+ZAr0Oe9EvnGC/9/m5e7DgkGWm+
         obrHI0mthgLXYWDhIkXW5fbnYr/S2jyV0dDgOPpcDKp8md5Cby6iZgEXBuNbCeJDr3eA
         zLSUWJulLanaef7PtZop6Dm3VA/T5HU3jhyFfal/4v4xqyWfOMGmxUQOunQF0Gg9y76N
         3vnl5Vmha8PaqCZPDD1CcZYlUWnMmh7WuvbZd4dxREGWxIsO9vt+HW8PNOganx/Io9vJ
         ZvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rymv0Qunjk0crbjvnwOGkGZRPnKg3lNe+kv8MV7OE6c=;
        b=VlvL9/MMI0T6NxatGGh1gNxZMg2QbX4yfCj1OJ6lwhBkjvqbSuhen84xedqTXrGgky
         XqOR6l3HNmA2QqzoUvM4Y053uJaccFxvKkrV4WwRa+kYl3k+xtw5NuWa7B8y5rYsYEOc
         loNKDYTQt3IGkqysc9hufPuJm2yavKMsHJk2rWmK20x+VIDBary2UpsRr9g5RFFh8IgA
         UKFDTQozwX5/I/Xk8YXqd3U2ejTxos5p3WTLmeFPDT0fVEUdVjrGtX1cC+xJMjzWwPdU
         9fn0wsYOkAwbogc5EOrZzkfqSs0biSa8gRZ6zw9lMDyNcxze5k9SPR7CMgVA4uqvIWcT
         jmJQ==
X-Gm-Message-State: AO0yUKWnBDgxDPD9Ko5o9Bs9ABxyzyFXoa71ABCF/YS/uJz50aXeg8NI
        N15K4coB9cJ7uJJsB9U1o8W4Smea33vuajS+8HY=
X-Google-Smtp-Source: AK7set/CQHwh9LR3bT2s8CBRhxY1PMpmlOG4k35+EfDb/kfKlwqbF4YwCmoTA9X8BLqy1ZUHguBBkaGPv6SLlI4Wrgk=
X-Received: by 2002:a17:90a:e08:b0:22b:fca9:4749 with SMTP id
 v8-20020a17090a0e0800b0022bfca94749mr618427pje.0.1675754290171; Mon, 06 Feb
 2023 23:18:10 -0800 (PST)
MIME-Version: 1.0
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com> <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
 <Y+DK4fP/u7iYi7Kt@kroah.com> <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
 <Y+H1HRqfnULl/B9f@kroah.com>
In-Reply-To: <Y+H1HRqfnULl/B9f@kroah.com>
From:   Xinghui Li <korantwork@gmail.com>
Date:   Tue, 7 Feb 2023 15:19:06 +0800
Message-ID: <CAEm4hYXnX=E55CQ9Ts5E1Z7pBLRnH91fckMvVO-xmnaT0++JFA@mail.gmail.com>
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=887=E6=
=97=A5=E5=91=A8=E4=BA=8C 14:52=E5=86=99=E9=81=93=EF=BC=9A
> I do not understand the actual runtime error, sorry.  Stack traces don't
> matter at runtime, do they?
>
Sorry for the inaccurate description~ I mean it might not just a
compiling warning.
> > > That is very odd, why is it hard to update to a new kernel?  What
Some features we developed based on v5.4's API. Update the kernel
verison could cause the KABI issue.
> > > happens if 5.4 stops being maintained tomorrow, what are your plans t=
o
We will align with the LTS's lifecycle on our product
lifecycle(actually shorter).
If v5.4 do stop being maintained(I know it is not real), It looks like
we can only maintain it all by ourselves :-(.
> > > move to a more modern kernel?  Being stuck with an old kernel version
> > > with no plans to move does not seem like a wise business decision:(
> > >
> > The product base on v5.4 is the LTS version just like the
> > stable-kernel in the upstream community.
>
> That was not the question I asked :(
>
Will the above reply answer your question?
Besides, we do base the new kernel to develop the new version product
such as v5.18 and 6.x.

Thanks~
