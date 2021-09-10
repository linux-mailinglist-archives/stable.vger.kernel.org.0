Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED97406C8A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhIJM4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:56:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231843AbhIJM4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 08:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631278536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+hqVVaMtmlu5vIIR42/tfkZcHE07Vsb/t2ZabEAuVn8=;
        b=Byv4GOEw5Dvjfv0ic1E575a3jckXwXRsMkHqPk6PwfMWqqBlSHqBb6A+TJv/Nqs2mc1/Ds
        kl3LejUJmkyh/SzahCQmHc1gItfituL52cvQVBKkudNPMEKyYGVIWFB+Yi9sUJrok2sRGx
        Uekq2jIUNOYTr3/bzh1hF3W7VdPDUsY=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-YLU4ztCEMX-IvZBkjbhv6Q-1; Fri, 10 Sep 2021 08:55:35 -0400
X-MC-Unique: YLU4ztCEMX-IvZBkjbhv6Q-1
Received: by mail-yb1-f197.google.com with SMTP id a62-20020a254d410000b0290592f360b0ccso2239010ybb.14
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 05:55:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+hqVVaMtmlu5vIIR42/tfkZcHE07Vsb/t2ZabEAuVn8=;
        b=g8rYfnqcNFXPUL57R4k3LcA5L4ll4138QBxp8Hp6dvV6oaA2FKjr5VGxTrPPSvFjqo
         Nh2gX5Wq2xR/xpvuOZ8tJjKVNszuOPEFh9puhBX270VKPXt4cGeIqsI1CsaDXSsDz7bg
         Bndeasmpw0M3CHosFRg0LhoQ0OaQgfTMU8mfRlDKPry0LIfRnWkz/x6Q9ZtJDE1xvGPa
         hPuS4hvXshkKWfRUp14Tc14BlVn9aHZ5PUGaRW458dhppQ2lztEgvbqmspRu7ylr8+JZ
         DYCkLQNC+1jy96GQndS61Xl+j7WfxFyL5yawDw7djvgyp2PO/Xdw7WnK7lY00egB5hXJ
         gifg==
X-Gm-Message-State: AOAM53139OhE1xWpbdjF7Ph3edPgAqchZM94H1cTsvS0vOseuPpKWbr0
        9q4bPZOyLieiqKXNbIZxEhUVhBtnMnr3ODQQ50bSRCWTUTo+rVk/DQvMYS7ZOwPGiX30n4qOU4y
        wP/FZ+K997oF7w6gVr66IJAeQubxvTGQa
X-Received: by 2002:a25:83:: with SMTP id 125mr2806861yba.467.1631278535031;
        Fri, 10 Sep 2021 05:55:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCqeqKoEN5LoT9Ez07Ke3w6l76GG7mOhpttL9gebeFK3ls7PtTmYrygK+0HgAjLEA/OhUktZ+UqwWqO3ZLu18=
X-Received: by 2002:a25:83:: with SMTP id 125mr2806831yba.467.1631278534790;
 Fri, 10 Sep 2021 05:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com>
 <CAPcyv4gR+WbYf-dT0niT23UY8jZZVBXMk4R-1_0exPcbHrs=0Q@mail.gmail.com> <CAHC9VhTo-eV4oUF-ia67X-KK-qyB=M0xDv-=p0-xA-4=0BJ6uA@mail.gmail.com>
In-Reply-To: <CAHC9VhTo-eV4oUF-ia67X-KK-qyB=M0xDv-=p0-xA-4=0BJ6uA@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 10 Sep 2021 14:55:21 +0200
Message-ID: <CAFqZXNvSu2-nL8YEfKhEdT9csm1=nxecoo31FF+jgwyCVdjPMw@mail.gmail.com>
Subject: Re: [PATCH 2/6] cxl/pci: Fix lockdown level
To:     Paul Moore <paul@paul-moore.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
        Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable <stable@vger.kernel.org>,
        "Schofield, Alison" <alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 7, 2021 at 9:47 PM Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Sep 7, 2021 at 1:39 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > On Fri, Sep 3, 2021 at 8:57 PM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > On Fri, Sep 3, 2021 at 10:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > >
> > > > A proposed rework of security_locked_down() users identified that the
> > > > cxl_pci driver was passing the wrong lockdown_reason. Update
> > > > cxl_mem_raw_command_allowed() to fail raw command access when raw pci
> > > > access is also disabled.
> > > >
> > > > Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
> > > > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > > > Cc: Paul Moore <paul@paul-moore.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  drivers/cxl/pci.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > Hi Dan,
> > >
> > > Thanks for fixing this up.  Would you mind if this was included in
> > > Ondrej's patchset, or would you prefer to merge it via another tree
> > > (e.g. cxl)?
> >
> > I was planning to merge this via the cxl tree for v5.15-rc1.
>
> Okay, thanks.

And I can see the patch is now in Linus' tree, so if Paul agrees I'll
rebase the patch on top of v5.15-rc1 once it's tagged and do one more
respin. There are a few other minor conflicts and one new
security_locked_down() call to cover, anyway.

Dan, is it okay if I preserve your Acked-by from the last version?
There will be no other change in the cxl area than rebasing on top of
this patch.

Thank you for taking care of the fix!

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

