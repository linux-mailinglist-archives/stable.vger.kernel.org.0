Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F5141266
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 21:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgAQUnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 15:43:55 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36785 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgAQUnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 15:43:55 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so22375091iln.3
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 12:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Bedva7uR9RCxWnglqLnOetZ7iPOlTbuJ7vu8I/S3FI=;
        b=B0d5YRbWLVMYdXdrXgUgamVBrvj9IQb0JlhV/eIhDfFAddKa/n1TwR1/ASeYIROtCb
         NtdDLnJmWH4BP8iQ+2tW8qMvjOhYcsNWzqPHrigsBUrpEfjXA6ATv/OKtr6yR0xb9ifF
         3tXAllbEjk5sTldU6B+Km/1pQi5s2qKa0NmZ4mra7ieRwTwp+2olTluhQ2N6ULRztoUv
         GkXVxWc60OTSECDFjQ7d6PE6aXYoa8Y5/0d2EVsR8OUg/FDqzf8jieCRwcPLr/IIFtrz
         Q0FmleFHlai1mx8uIdRHZ24/Il5cslf6kD+YxzfcwY+7GVkcmrg4cEibsIo6z4lgAQRM
         U51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Bedva7uR9RCxWnglqLnOetZ7iPOlTbuJ7vu8I/S3FI=;
        b=LNIBMWZA0K16w36U9FiIwllelhiTjJoglih4Hc2bLFM/4XhHC+yiTKJFl7hfOr60cU
         9cOvaidH7eFdnsWC6SkU4HappAX8rFoCJm2MmTZDzSCs1UWHQD+9cfujcWZbQ3DFKfBM
         +u/VywBcXP4tPeq/LTJlLh6DLHl6ZGEYxg4g43gSm/W8u71xbdi/xMOiVKmRAp736RvL
         6tw0ASvcAkvfr818WtgebUjyVSd48DT8b954ImzxxOdmZPsMTYgu0zuEt5DV3LDy67Yf
         TAPsmjXr+a+23O0u3PsRMszOnm2LyNz6URVk6hUMiRxVjFl0w6IrgzBJCydb6ZPODI/M
         w9lw==
X-Gm-Message-State: APjAAAXHZlQCmAfCvBXGwkjAbuG28XpavswWdcHZ6RAhuVpiiyEsJ05G
        2/QWxjTpdIt5RNcAWLkIZEY1PR/mufn1J0+FWoa5sw==
X-Google-Smtp-Source: APXvYqzvNMYw6bQh4ZpYpE3e0JCVyRjqeCJDQOiElcrPWk6yW5BITe9gYwxXa8hsS7KDL/Jw3vVatm7410trYoNTVUg=
X-Received: by 2002:a05:6e02:102c:: with SMTP id o12mr319100ilj.165.1579293834244;
 Fri, 17 Jan 2020 12:43:54 -0800 (PST)
MIME-Version: 1.0
References: <20191205090043.7580-1-Wayne.Lin@amd.com> <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
 <ec3e020798d99ce638c05b0f3eb00ebf53c3bd7c.camel@redhat.com>
 <DM6PR12MB41371AC4B0EC24E84AB0C84DFC580@DM6PR12MB4137.namprd12.prod.outlook.com>
 <CAMavQK+pS40SQibFuirjLAmjmy8NbOcXWvNsFP8PanS6dEcXWw@mail.gmail.com> <31d9eabe57a25ff8f4df22e645494d57715cdc0b.camel@redhat.com>
In-Reply-To: <31d9eabe57a25ff8f4df22e645494d57715cdc0b.camel@redhat.com>
From:   Sean Paul <sean@poorly.run>
Date:   Fri, 17 Jan 2020 15:43:17 -0500
Message-ID: <CAMavQK+pOtQ62mp4DSRDW7nHDz4doW3LA5AV1NML-wFa3s3cQA@mail.gmail.com>
Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
To:     Lyude Paul <lyude@redhat.com>
Cc:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 3:27 PM Lyude Paul <lyude@redhat.com> wrote:
>
> On Fri, 2020-01-17 at 11:19 -0500, Sean Paul wrote:
> > On Mon, Dec 9, 2019 at 12:56 AM Lin, Wayne <Wayne.Lin@amd.com> wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Lyude Paul <lyude@redhat.com>
> > > > Sent: Saturday, December 7, 2019 3:57 AM
> > > > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org;
> > > > amd-gfx@lists.freedesktop.org
> > > > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland, Harry
> > > > <Harry.Wentland@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>;
> > > > stable@vger.kernel.org
> > > > Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology
> > > > mgr
> > > >
> > > > On Fri, 2019-12-06 at 14:24 -0500, Lyude Paul wrote:
> > > > > Reviewed-by: Lyude Paul <lyude@redhat.com>
> > > > >
> > > > > I'll go ahead and push this to drm-misc-next-fixes right now, thanks!
> > > >
> > > > Whoops-meant to say drm-misc-next here, anyway, pushed!
> > > Thanks for your time!
> > >
> >
> > I'm getting the following warning on unplug with this patch:
> >

\snip

>
> I think I've got a better fix for this that should avoid that problem, I'll
> write up a patch and send it out in a bit

Thanks Lyude! Should we revert this patch for the time being?

> >
> --
> Cheers,
>         Lyude Paul
>
