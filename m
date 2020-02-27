Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8295172AF9
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 23:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgB0WSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 17:18:15 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35506 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgB0WSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 17:18:15 -0500
Received: by mail-oi1-f193.google.com with SMTP id b18so913547oie.2
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 14:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0euUTmCAQFszhsvqHevYkjxbqAEm0wSut9S5to8A90=;
        b=KFVtxBRsgRmTAIFzjwv/bwVzn4nV0zvbz0Mnz2rNbRQ5CuLCqwmHfFg0ADCXePeFLw
         EqG+UGkgL4EcMkrNKxeZvtqDFLXZkn2e0Hlm63B7Q1oI3Z2cOjslchMC/VyYLTuIYBok
         6QgKIFir0TwVM3h8lmOCGwMP52Pr0PlAACVikOtmNI46VvcmmFoxQNrY20paD7qnml+Y
         kXOE1OjSfzazvobPwnvF0kWr0ggKE0uStSlhoMMZBUdE/+J7xASRNFzjSc1qm1Q6A1Qp
         arDZMja986Tq2DRq8fNtbGt3qFc3NcE5lQVbluIMMFsDkrOsUDzKIYnHxg/JRtV8GQcN
         pxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0euUTmCAQFszhsvqHevYkjxbqAEm0wSut9S5to8A90=;
        b=gz3q4FzFMPz0J0clccIbBzHay0AD2h2d2ZHzjTi2dRjVKzwKEkS40NTwDw6M/Hzerz
         ev8PB/gyfcXb5rWfI9Lv4Juthgwd9BuEn3kURH98HgAicv/YSl9kzrt1gMgYrk5+bqoh
         B7Mdy6p6cipqmjgx60hqm2hsR3CLgEcwPDbVdv+XRhxmTAJ4+fg4p1/IWgfd/8iKU3E8
         A72tzXpofP4zYnZCfCCmRA4AP8bASr6e7XWrmEd6W/NoNgVFdKs+NXf4F+9ZfpAE2cqM
         whFW5PU3ATZMMEXszeMY9Ha0jycrFM/NjTYlFPBca0j3lig56SxcjzbZjN9QoA0JNhy+
         AUNA==
X-Gm-Message-State: APjAAAVm25wlpK9IV/e97vjUan8I53ZqX2gwLCCesgE4bKMD4mPeoGbb
        HAIkM6ikBli5dHilFgY5g0z/wWX/7FQP50mCh68M592oDUc=
X-Google-Smtp-Source: APXvYqy5JED6V+vdCWHxMIdfVpZP3a6/wtGC4U3ubBssd/4e5r0PhJiZKJHaiApwFYnRQEn+284emGt6jGjVDuFh91Q=
X-Received: by 2002:aca:ea43:: with SMTP id i64mr994463oih.30.1582841894370;
 Thu, 27 Feb 2020 14:18:14 -0800 (PST)
MIME-Version: 1.0
References: <CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com>
 <20200227095107.GB579982@kroah.com> <CAGETcx-RCS84nWAU7BPZSaXei5VCV1X+S48eYoSjYhgmjaFq0A@mail.gmail.com>
In-Reply-To: <CAGETcx-RCS84nWAU7BPZSaXei5VCV1X+S48eYoSjYhgmjaFq0A@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 27 Feb 2020 14:17:38 -0800
Message-ID: <CAGETcx8kFOHMmCd3gopUmQgFp+DfC45gVqVkNbb4TwWmvZOJkA@mail.gmail.com>
Subject: Re: device link patches on 4.19.99 breaks functionality
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 1:26 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Thu, Feb 27, 2020 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 21, 2020 at 01:21:00AM -0800, Saravana Kannan wrote:
> > > 4.19.99 seems to have picked up quite a few device link patches.
> > > However, one of them [1] broke the ability to add stateful and
> > > stateless links between the same two devices. Looks like the breakage
> > > was fixed in the mainline kernel in subsequent commits [2] and [3].
> > >
> > > Can we pull [2] and [3] into 4.19 please? And any other intermediate
> > > device link patches up to [3].
> > >
> > > [1] - 6fdc440366f1a99f344b629ac92f350aefd77911
> > > [2] - 515db266a9da
> > > [3] - fb583c8eeeb1 (this fixed a bug in [2])
> >
> > "up to"?
> >
> > 515db266a9da does not apply to 4.19, so should I just drop [1] instead?
> >
> > Or, can you provided a backported set of patches so I know exactly what
> > to apply?
>
> Let me take a stab at backporting [2] and [3] or whatever else might
> be necessary. What git repo/branch did you want me to try that on?

I'm assuming this one:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y

-Saravana
