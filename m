Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6101E302C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 22:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbgEZUnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 16:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389486AbgEZUnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 16:43:00 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162A0C061A0F
        for <stable@vger.kernel.org>; Tue, 26 May 2020 13:43:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id x20so25254714ejb.11
        for <stable@vger.kernel.org>; Tue, 26 May 2020 13:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z0+qB9PAs/0dIVTxt6TWQveY0BQoV0IqGxgJ1RJtPJ8=;
        b=Mmipay1v52TsRSAxngafTq/GIafI4i5MGesqoQtqIdctmq2XigRTUluiaR0xV89H8W
         yFzbwIKrBLUxF4eDbHG0as3sOfpOM83xGs601y887zEJjHAiHDF7VT6KQkB4JHQjB+na
         TnG/+HHbvltKPGgCYphiAK/76TjA7NPgX/90rpvU+U/H03TfX3bVQeczDzuRzvsb3Urj
         g9+bv6Z2MMCzThJPGN1avuSRTdBz98RNNdENoNfvHGiE7NT4k8XFpDXzQXR5lr0Aw2Cf
         OWr9AK5ECVGOcCcBmi9DJ1IEHOE9haHRMJQeACqeeazF80DGfUucWYS/YVdlDlpVhS6j
         aQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z0+qB9PAs/0dIVTxt6TWQveY0BQoV0IqGxgJ1RJtPJ8=;
        b=gVZ7n9YIEojrYZ+MTI7c52O1Fdq/Cy8c9zylJIndp2zbTEL/phOZioNrUERXSs+kQx
         Rlx/tXLLwlB69JAxHy94kOL4ps2mRht8ifcl+KoriLiQsHJIN/AUiZSMWA7208rmiXtG
         7y27MaVAI7AI1z9n0SLOxYlHPPqDy7evQBWgfg8XnGnEcAhcmWnmkpNxVrnnExPpCh9U
         gXeL2rb9sYmxUVIz5+WKVLA8Ns2m48QFaK4MqqV8s34FtWIgxdwF7OCEkuLB/j2Tv0gX
         SKXCNBw532vod7wUws5g1biku4v5S06VzMNij+N1uNb1l5vwzYICH8jjYskshLNEW1vp
         JfyA==
X-Gm-Message-State: AOAM5320GyXCzOJsT4DIOT/h+GJuTKNjzHuTLeyCZo0aQWMGeUVUivbl
        RZAJI4sOmfOT29Avv673IVm9a2lLpID78nFC5kfOLQ==
X-Google-Smtp-Source: ABdhPJyjICkIAYJoUWeh5IAj7h4qSUa1lPDgHsaGCVWa7SWsoVWAuaVyTS5T07gQoCLsNSWBDtrrXAQew17WRC/6Zf4=
X-Received: by 2002:a17:906:3597:: with SMTP id o23mr2695842ejb.174.1590525775277;
 Tue, 26 May 2020 13:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200522115800.GA1451824@kroah.com> <20200522120009.GA1456052@kroah.com>
In-Reply-To: <20200522120009.GA1456052@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 26 May 2020 13:42:44 -0700
Message-ID: <CAPcyv4jW9P2FP2p6OiLoN+e_wzZY9-c8C-mMMoDqohuTekF7WQ@mail.gmail.com>
Subject: Re: [5.4-stable PATCH 0/7] libnvdimm: Cross-arch compatible namespace alignment
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 5:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, May 22, 2020 at 01:58:00PM +0200, Greg KH wrote:
> > On Thu, May 21, 2020 at 04:37:43PM -0700, Dan Williams wrote:
> > > Hello stable team,
> > >
> > > These patches have been shipping in mainline since v5.7-rc1 with no
> > > reported issues. They address long standing problems in libnvdimm's
> > > handling of namespace provisioning relative to alignment constraints
> > > including crashes trying to even load the driver on some PowerPC
> > > configurations.
> > >
> > > I did fold one build fix [1] into "libnvdimm/region: Introduce an 'align'
> > > attribute" so as to not convey the bisection breakage to -stable.
> > >
> > > Please consider them for v5.4-stable. They do pass the latest
> > > version of the ndctl unit tests.
> >
> > What about 5.6.y?  Any user upgrading from 5.4-stable to 5.6-stable
> > would hit a regression, right?
> >
> > So can we get a series backported to 5.6.y as well?  I need that before
> > I can take this series.

Yes, should be the exact same set, but I will run the regression suite
to be sure.

> Also, I really don't see the "bug" that this is fixing here.  If this
> didn't work on PowerPC before, it can continue to just "not work" until
> 5.7, right?

There's a mix of "never worked" and "used to work" in this set. The
PowerPC case is indeed a "never worked", but I highlighted it as it
was the simplest to understand.

> What problems with 5.4.y and 5.6.y is this series fixing
> that used to work before?

The "used to work" bug fixed by this set is the fact that the kernel
used to force a 128MB (memory hotplug section size) alignment padding
on all persistent memory namespaces to enable DAX operation. The
support for sub-sections (2MB) dropped forced alignment padding, but
unfortunately introduced a regression for the case of trying to create
multiple unaligned namespaces. When that bug triggers namespace
creation for the region is disabled, iirc, previously that lockout
scenario was prevented.

Jeff, can you corroborate this?

I otherwise agree, if the above never worked then this can all wait
for v5.7 upgrades.
