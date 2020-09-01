Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B3F258CCE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 12:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIAKak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 06:30:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbgIAKaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 06:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598956234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7xp2NgyNQRcqEmc4bjcRafZrnamtozJTDGfd/4vpEMs=;
        b=Dbei0obFThJStEbRrupRvrG0iSXQ2jtd+jvrfKampJVC9hPXAVBa4UZOdPqlmlqIF16f8l
        Akn/3XX+q51Cz1HqSVvm2EiSZULi4yEW9winsv7dHq8dJ4SUvF8lsSh8WM9LInQldru2UW
        onHbaHW2Otw90cfkwAelqItiqjS+rJo=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-n9W0t_1KM2qUNnWP0D-A9Q-1; Tue, 01 Sep 2020 06:30:32 -0400
X-MC-Unique: n9W0t_1KM2qUNnWP0D-A9Q-1
Received: by mail-pg1-f197.google.com with SMTP id z4so481269pgv.13
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 03:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xp2NgyNQRcqEmc4bjcRafZrnamtozJTDGfd/4vpEMs=;
        b=MB+EvHS/wPqJbCdlsZbJnnd3nD5UVVk9nYgQedNwTPvT8O8eJ3CRXQJD9/7l5n/VXS
         qV/8N68b6M4CvuGWozbF8rgiiHNu4qWLUEdPS85gmBwSAz7QDdxgZN44VFFcVqlMVwW8
         ieBbGiBpu08reOo+UwuUcwvPcgNLtaen+El3Dnk3W2e7mzsjhCP0NSPzMt1q2uF57CNF
         gVVMcyW9CEBYmGW0mZdUvAcNoWMCFi/ZCyVHsgouw4SNlUaPj0dJ+HkDllKSRhe64xqL
         u8bg+Xf0NRRR7g+NMeuXu5PPLZLR5BWeVg91vXyyPxrKCEgA1y6G3Zp1kMJd0Qdq8tvG
         hlZw==
X-Gm-Message-State: AOAM5335ybfiZdSZhcWUBwrJnCfD34Lwc9lfdI9imIpsTmujPcs+PPhI
        S/TNkbEyMjB6ATYFYBcDJ4qaM1zHUk0oMVVfjiybp5jThUOvef3IR3h6HN0SiCMxSH+1enAQhRU
        L69n65ZdNspxThKcsdD67AthNVAgBL1OW
X-Received: by 2002:a17:90a:17cb:: with SMTP id q69mr925070pja.56.1598956231700;
        Tue, 01 Sep 2020 03:30:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztegbyjmEoed7odzziHs1Pf33M/uulBUGEeSZWeyMhPsGb0MYk/NwzotrRqoye5+bB6v4yoAlXvoViSIAm25E=
X-Received: by 2002:a17:90a:17cb:: with SMTP id q69mr925057pja.56.1598956231473;
 Tue, 01 Sep 2020 03:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200826134658.1046338-1-maz@kernel.org> <nycvar.YFH.7.76.2008271132050.27422@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.2008271132050.27422@cbobk.fhfr.pm>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 1 Sep 2020 12:30:20 +0200
Message-ID: <CAO-hwJLUk0eO0GC2WQf=iimTOL4JWak96t1z0Zskfv-G_+MGNA@mail.gmail.com>
Subject: Re: [PATCH v2] HID: core: Sanitize event code and type when mapping input
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 11:33 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> On Wed, 26 Aug 2020, Marc Zyngier wrote:
>
> > When calling into hid_map_usage(), the passed event code is
> > blindly stored as is, even if it doesn't fit in the associated bitmap.
> >
> > This event code can come from a variety of sources, including devices
> > masquerading as input devices, only a bit more "programmable".
> >
> > Instead of taking the event code at face value, check that it actually
> > fits the corresponding bitmap, and if it doesn't:
> > - spit out a warning so that we know which device is acting up
> > - NULLify the bitmap pointer so that we catch unexpected uses
> >
> > Code paths that can make use of untrusted inputs can now check
> > that the mapping was indeed correct and bail out if not.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> > * From v1:
> >   - Dropped the input.c changes, and turned hid_map_usage() into
> >     the validation primitive.
> >   - Handle mapping failures in hidinput_configure_usage() and
> >     mt_touch_input_mapping() (on top of hid_map_usage_clear() which
> >     was already handled)
>
> Benjamin, could you please run this through your regression testing
> machinery?
>
> It's a non-trivial core change, at the same time I'd like not to postpone
> it for 5.10 due to its nature.

OK, just passed the v4 to the testsuite, and this seems good. It won't
break touchscreens nor keyboards/mice that needed to be added in the
past.

So this is a go for me.

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>

