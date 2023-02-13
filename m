Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E27A6945A8
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 13:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjBMMTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 07:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBMMTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 07:19:09 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6A6901D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:19:08 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id u75so7959533pgc.10
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfwBZdkqOIQp9zvA0NqNsfTT8/17bRtke/KzsbVK1Us=;
        b=N5KY3S4KoUo3MlL1lYbfoUcj243h4Zy75wbePKpIMZ/bmwZNrqsB58igYbAcmd3d+T
         +EfkpB/USoRxlLmFUWeitfg9QwzgO3JBoxOYrYi50uzch2xXwvwnDi39wC+2tpmtzZnr
         Imj7Fzq1FxYS851GUUsf82T+JphWXrAxNBXk9gZZf4bXJIQNcGuWWQr/1p4h6imd992W
         7QY6uX98yXIXgPobOhE7V0E2hnJ6Qt/qCv5mbXRrHaPM1nMAugV5F2p4SgPLeg0ZEKIW
         KBPU45ryMv5RTbgDU2XyKXgALQB9eAQZkBR6hBI+mONPtYfjl+xxbbm+NPSBNvtLDEOS
         4+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfwBZdkqOIQp9zvA0NqNsfTT8/17bRtke/KzsbVK1Us=;
        b=nJ//Okla0KqIGGny/qQJdFiWGshls30pDAjQfP4ReaWSqxoZurUeO34xddwn23b9de
         ElcTmtJIWbnRG++Wdy2ikHAiw23Hxc6wAdcza3LQuBw3Rnt79zCjWlZU3Qx5J03H7Kp+
         tCmlyaPvsMDLm33v7sj7jU4vGGSUh+/bi2tzolB6sYIOrZtraczEWg53B1VnjfcWzrab
         RWWb1cHIMO12A1lXNrrZXqxdGe63dD9g7xwGb9i1vwgnSYp3rJsae20PnApQtW9m+REi
         aCMqS67/WW0//9P4jhzsYqBcFDTXd6Rac9QG992CvnH4O+f2hpWLhdYzyYRVg02i30u2
         Shzg==
X-Gm-Message-State: AO0yUKUuwszyKttxbX8jYbr7Eqaofy1OsGeIMBpKptM0m1VuA2tH9rLa
        7oMJ6AkPbBQrJ4G/GJGIVRi+9ImSJmitCulryhc=
X-Google-Smtp-Source: AK7set9jr+rgtIgFxyWi5JMlGAtSc111O+nTg+K61QewVjPrwcs0yrlBeUApSynp0Ojzo7edsuSgaDkzyavRiOxFwq0=
X-Received: by 2002:a62:55c5:0:b0:58d:b5d2:fce1 with SMTP id
 j188-20020a6255c5000000b0058db5d2fce1mr4753271pfb.21.1676290747825; Mon, 13
 Feb 2023 04:19:07 -0800 (PST)
MIME-Version: 1.0
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com> <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
 <Y+DK4fP/u7iYi7Kt@kroah.com> <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
 <Y+H1HRqfnULl/B9f@kroah.com> <CAEm4hYXnX=E55CQ9Ts5E1Z7pBLRnH91fckMvVO-xmnaT0++JFA@mail.gmail.com>
 <Y+H+LDbPoN2JDE2X@kroah.com>
In-Reply-To: <Y+H+LDbPoN2JDE2X@kroah.com>
From:   Xinghui Li <korantwork@gmail.com>
Date:   Mon, 13 Feb 2023 20:20:03 +0800
Message-ID: <CAEm4hYX3q=zRFYO68UXYmtnA-ZcVXX_rsnka-eR0--wYdNgHzw@mail.gmail.com>
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
=97=A5=E5=91=A8=E4=BA=8C 15:30=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Feb 07, 2023 at 03:19:06PM +0800, Xinghui Li wrote:
> > Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=887=
=E6=97=A5=E5=91=A8=E4=BA=8C 14:52=E5=86=99=E9=81=93=EF=BC=9A
> > > I do not understand the actual runtime error, sorry.  Stack traces do=
n't
> > > matter at runtime, do they?
> > >
> > Sorry for the inaccurate description~ I mean it might not just a
> > compiling warning.
> > > > > That is very odd, why is it hard to update to a new kernel?  What
> > Some features we developed based on v5.4's API. Update the kernel
> > verison could cause the KABI issue.
>
> What abi issue are you referring to?  The user/kernel api?  Or
> out-of-tree-code that is in your kernel tree?
>
> If out-of-tree stuff, just forward port it, like you are going to have
> to do anyway.  You have to always have a plan to move forward, otherwise
> you are guaranteed to have an insecure kernel someday.
>
> Moving to a new kernel version should always be planned, and possible.
> If not, something is very wrong with your management process :(
>
> > > > > happens if 5.4 stops being maintained tomorrow, what are your pla=
ns to
> > We will align with the LTS's lifecycle on our product
> > lifecycle(actually shorter).
> > If v5.4 do stop being maintained(I know it is not real), It looks like
> > we can only maintain it all by ourselves :-(.
>
> Again, why?  What is so magical about this release?
>
> thanks,
>
> greg k-h

Hi Greg, first of all, I have to say I totally agree with your opinion
about keeping updating the product's kernel.
But maybe because I'm not a native English speaker, it seems I didn't
convey my meaning clearly or didn't get you well.

We do have plans to update the kernel of the product and we keep doing that=
.

However, for conservative reasons, parts of our customers are opposed
to making significant upgrades to the products.
Meanwhile, for commercial purposes, we are committed to maintaining
the products we sell over a period of time.
For the above reasons, we also maintain older versions of the product,
so we will fix/report the issues in older kernels just like this time.

As for your question about why we chose v5.4, most likely because it
was the latest LTS release at the time.

Thanks~
