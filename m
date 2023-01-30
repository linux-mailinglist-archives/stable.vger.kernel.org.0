Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61A6805F7
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 07:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbjA3Ges (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 01:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjA3Ger (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 01:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC3726868
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 22:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675060439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GeA8p7IElQZmWDuS7ETU1wAXtU+jk4NtO9TFABoYpQo=;
        b=EB2ZedMJKuXVGWf5vAVNDoUHkWil1GN7rmw1PTWnnI7feTd6tEa82iHIQXpYAuurBRgjJq
        5vPjnv+I9cIuiulpyVIkbS1zXneDq3fEBzVKkH22EwjmMX1dzeRJmH/nuxu1a0wq1dqSm/
        GGyL/HZOQut6NnUZg+dgRI28QjwCI2s=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-125-NIT2AwgrMoCh-IMN_TEh7Q-1; Mon, 30 Jan 2023 01:33:55 -0500
X-MC-Unique: NIT2AwgrMoCh-IMN_TEh7Q-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-4b34cf67fb6so121727337b3.6
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 22:33:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GeA8p7IElQZmWDuS7ETU1wAXtU+jk4NtO9TFABoYpQo=;
        b=GYcQ4GE+NBa8NxzPr91+GksQMyR9zUwPCcBcGJdtPNCObfyDFEm+t4jJU4/d1ZZJ3d
         CpH7gBPM//JvfxSMMzs1Lgb7ZhWUEu3qV65ve1SzHcH43MC0cP4nFY0HceESoXI/wojN
         i27f23zY6jOxS9gfPaAX3bTUm2Dw+AuwTuNhaNUF7Tbm+5YKVUXvzQxFx5Ox+C4TU2IT
         aAfadYL02sxzMPGdr4IZ3M+w/DA4oju49P80wMhmtxZOCtoMjXHJdkI7dikDLTlsen0s
         fWCMulyZXpUjB5IX184PUrBQnWzT8YYQSTTVLciu96nlkUhveX252qinyPRbUwTXyc+/
         AoMA==
X-Gm-Message-State: AO0yUKX6REulnfFHDuxA6Z0FuD90U2GbMvYtqMW0LyldT0kShOjcrJ9T
        rjo+Km0L6158hhdoj/RWS26fgZSNApE7dHh159iIB1zjWPglLGIwlU8r3BJti2H4wOT8I/9aiiP
        XbACKwItDlYYMKx7TvCcypQcPWo4dHS3G
X-Received: by 2002:a0d:eb82:0:b0:507:4ba0:f1bc with SMTP id u124-20020a0deb82000000b005074ba0f1bcmr2518436ywe.293.1675060434680;
        Sun, 29 Jan 2023 22:33:54 -0800 (PST)
X-Google-Smtp-Source: AK7set9UpeZ9osWXs+yNLWMCxE6HsbfBShnUYYIAZH3CjZZ3A9MgSScBcIPRH1lp9Xgk6BmkOvRcGwOgiixAGdhbeGM=
X-Received: by 2002:a0d:eb82:0:b0:507:4ba0:f1bc with SMTP id
 u124-20020a0deb82000000b005074ba0f1bcmr2518433ywe.293.1675060434485; Sun, 29
 Jan 2023 22:33:54 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com> <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
In-Reply-To: <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
From:   Jason Montleon <jmontleo@redhat.com>
Date:   Mon, 30 Jan 2023 01:33:43 -0500
Message-ID: <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     casaxa@gmail.com, cezary.rojewski@intel.com, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I ran a bisect back further while patching in
f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338.

When doing this, 3fd63658caed9494cca1d4789a66d3d2def2a0ab appears to
be the commit in 6.1+ that it's interacting badly with. I couldn't
revert this cleanly without reverting a handful of other commits, but
doing so also results in working audio with 6.1.8 while leaving in
f2bd1c5ae2cb.
(e9441675edc1, 1cda83e42bf6, 37882100cd06, 0e213813df02, fb5987844808
were the others removed)

Hopefully that helps narrow it down for someone more familiar,
otherwise I'll keep digging.


On Sat, Jan 28, 2023 at 7:23 PM Jason Montleon <jmontleo@redhat.com> wrote:
>
> I have confirmed 6.2-rc5 is also broken and removing the same commit
> causes it to work again.
>
> Thank you,
> Jason Montleon
>
> On Sat, Jan 28, 2023 at 12:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Jan 28, 2023 at 12:09:54PM -0500, Jason Montleon wrote:
> > > I did a bisect which implicated
> > > f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 as the first bad commit.
> > >
> > > Reverting this commit on 6.1.8 gives me working sound again.
> > >
> > > I'm not clear why this is breaking 6.1.x since it appears to be in
> > > 6.0.18 (7494e2e6c55e), which was the last working package in Fedora
> > > for the 6.0 line. Maybe something else didn't make it into 6.1?
> > >
> > >
> >
> > So this is also broken in Linus's tree (6.2-rc5?)
> >
> > thanks,
> >
> > greg k-h
> >
>
>
> --
> Jason Montleon        | email: jmontleo@redhat.com
> Red Hat, Inc.         | gpg key: 0x069E3022
> Cell: 508-496-0663    | irc: jmontleo / jmontleon



--
Jason Montleon        | email: jmontleo@redhat.com
Red Hat, Inc.         | gpg key: 0x069E3022
Cell: 508-496-0663    | irc: jmontleo / jmontleon

