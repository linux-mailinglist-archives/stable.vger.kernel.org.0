Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA4166AEFA
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 01:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjAOAzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 19:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAOAzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 19:55:51 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB53A259
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 16:55:50 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id y7so3627872qtv.5
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 16:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8um7jzfdZofjaGhbaEiPIgthhZTY/B5b/SUEq3CZJf4=;
        b=HDJDHEipGxwIomQUQCLkGwGUP4yS8GLbVRqadszvgYX8dn4vzaYaznNeHG1irvUOos
         p8FmFA961/qlcIfcgaKyQ4LjRJvOB/xB6PEaGjYpFATE/A97b1Guyvlh892mjX195xzH
         A0z9sM4t4mh/+O6Xu1D8h4eTtjLEaIAoUYJlrndVAMZDzyaNkBxVTAxMs9yV1faX8DW3
         32+fXTtVDeyEpGvfLZmBchaNtcAQ8aXggFE31VXi6fVJ8eUN6gIOhEQhp6uV+6qwAr8a
         XE0F4lyhS61PbYG1Mzc3dRkw2o0vHH7HXckYpb4BsR+w1JzrduDyz9lf3zoqOqTnJ8Wz
         +TVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8um7jzfdZofjaGhbaEiPIgthhZTY/B5b/SUEq3CZJf4=;
        b=S6yk1KRghF8fVdY+S5WWpSR3LRfTxVe1xJOlk8ffe3v1im92vSpDfReGjYhuIe5lik
         A3g7Qc+nDcPzFflQtlP+3tI5pU3WQtBVyHJeJw6+2TPjHzr6lfXhr3aVror26rqjeNum
         6BYaXIZNWoVT3Gj27uRQqKB+Cruf3GSRVtYyqvIRO9xhhEed0zGLtc+icZlQUmBU8Ct0
         g/zuOGhlTjBM27nuIJzBR2AIQKGhxW6+H1KPTP/+Krvexa3K3/CwpMirNVdcmWKyyUNA
         ZfvumsyKORsHV9Xly2G2qOGgUN6NdsHG/jxGYNdOWIEJYRhGpdM8x7iqKZbhTJ80vv7g
         ZPYA==
X-Gm-Message-State: AFqh2kpxW2YT7At/tR1m2Me8K/zV2nAXBghikkDbyF8+XnGdXf9mURLV
        axK4C5aCgstvLG91fqQz7Dz8w/3nlg0FV8MOBQhckEke8VPbuw==
X-Google-Smtp-Source: AMrXdXsQGkUMZ8iBNXUVVEwGHKbvQdbC1HGvyKlUxXcx0TYs/3XfWyeGKRkis57wQFhk4N4H/Z0O7eRaYAfRd4B+KR8=
X-Received: by 2002:a05:622a:5d83:b0:3b6:2bb2:216c with SMTP id
 fu3-20020a05622a5d8300b003b62bb2216cmr54608qtb.616.1673744149172; Sat, 14 Jan
 2023 16:55:49 -0800 (PST)
MIME-Version: 1.0
References: <CADsncqR2mTUArTv2HhRnsfmQx5iNgUZo=JVgkUcZT7MtjxEoYw@mail.gmail.com>
 <Y8JSMlMgnggwOYl0@kroah.com> <Y8LByXvibutD79au@eldamar.lan>
In-Reply-To: <Y8LByXvibutD79au@eldamar.lan>
From:   Matthew Fahner <mdfahner@gmail.com>
Date:   Sat, 14 Jan 2023 19:55:38 -0500
Message-ID: <CADsncqRgM17CEnKpwORz0_1n62-QgH74HZRO2yx5awvB6ULiBw@mail.gmail.com>
Subject: Re: Second Monitor Issue on Kernel 6.1.5
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Salvatore,

Thanks, yes, that does appear to match my issue.

The Debian bug report seems to have identified as commit
4d07b0bc403403438d9cf88450506240c5faf92f

I'll keep an eye on those threads and test again once it's believed to
be updated.

-Matt

On Sat, 14 Jan 2023 at 09:52, Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> Hi,
>
> On Sat, Jan 14, 2023 at 07:56:50AM +0100, Greg KH wrote:
> > On Fri, Jan 13, 2023 at 11:58:47PM -0500, Matthew Fahner wrote:
> > > Hello,
> > >
> > > I'm running Ubuntu 20.10 and experienced a regression when trying
> > > kernel 6.1.5 that was not present in previous kernels such as 6.0.19
> > > or 6.0.9
> > >
> > > I have two monitors attached using DisplayPort MST (daisy chaining the
> > > displays).
> > >
> > > Normally, this works without issue and both monitors are detected and
> > > display properly.
> > >
> > > With kernel 6.1.5, the second monitor (the monitor that's not directly
> > > connected to the computer) was detected but would not display.  I
> > > didn't spend much time troubleshooting the issue and instead reverted
> > > to 6.0.19 where it again worked without issue.  The first monitor
> > > worked without issue.
> > >
> > > Let me know what steps I can take to help identify the root cause.
> >
> > Can you use 'git bisect' to track down the offending commit?
>
> Not the reporter, but I suspect this is
> https://gitlab.freedesktop.org/drm/amd/-/issues/2171 .
>
> Matthew can you verify this matches? There is as well context on this
> issue on this thread:
>
> https://lore.kernel.org/stable/8502e5d8-8444-e256-54f3-0c488b54686a@amd.com/
>
> FWIW, we had a similar bugreport downstream in Debian:
> https://bugs.debian.org/1028451
>
> Regards,
> Salvatore
