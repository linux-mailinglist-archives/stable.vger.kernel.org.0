Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18A3CBBA4
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGPSIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:08:54 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47559 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229462AbhGPSIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 14:08:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6C8E5320031A;
        Fri, 16 Jul 2021 14:05:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 16 Jul 2021 14:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=SvSMWqYYIP8SYmpHJbRdFdWBV7H
        Cjw0xvvARb8cUKJ4=; b=IHc825qaigR1lrmJAeSRN4y8FCg7imbcsiotXFiSzyh
        WYyahJM2DAY+X1XSrrVdPksmF4X58bmexA4n6uKi4xeR0IC5qHg16aWuP4uuDHoq
        a/GyQbRdb8ogv7WaI0BCrbTVoXWrsCLtMHT/giqLdmRG1yuT6LhwzhGJFK9GX6sf
        YFHY/Six7Toq82ngT9Ol2V6f8CH/yhknRFGEBvGIJYRPgn1awAjcKNjZ5sP32za7
        f9BC6DwlNtlNpuoO6Og1sNfto+YdodNpv2dT3rReC/1xKX/oTwaY+Pd3Jomwkaj3
        zebKJ4TiAGUSyy3LMhnPQmEfwWlyhXEOREe10qfNuyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SvSMWq
        YYIP8SYmpHJbRdFdWBV7HCjw0xvvARb8cUKJ4=; b=hoGxa4d1qZWD06P06d016Y
        jdFTJQmYlTM359PVI1vDoQ2tLUgTEl6iNwlMPwhh3PZ2FjTu9qDysK84n9EC9XwA
        xQVhBZBpDcIK2QI9Lma4B4qTGhpR0ZTpb9lmW6pJ7/KjI6QgAoP5Uf7/p2O8eBk9
        Exhurk3jcUqJafzhwBwR+lboOaaH339PjkpKpMa6yxarnnWjoBXjgus5+ObMv0ke
        6/kvUTFsi3bXI4R6EuNFzl3YqzrnhpKPc0caPp8NJq+lq1Wyjn6ZsbSkErTOe2o3
        +8vucdPb6iSaDTWhZEG5tMcUKT2NGodb76P+slp/1vR8QZ59YS3vm3SOQMoi33Cg
        ==
X-ME-Sender: <xms:hMrxYJE8fzR-h_fFE14dDX5Sp1DMpjgACMM-GiVpbe_HgsR6K73UAw>
    <xme:hMrxYOUrOYZDrY6v77MOI0bVvyAkXYe4oMRVe_hnMb1qe63vCInWttlZDFQRH0qIC
    Z3fyyVYhM5drg>
X-ME-Received: <xmr:hMrxYLLGQ4iRhd2ARO1bLZy3XcB9eFZuI4qlep6Ap03iKiiW9e-BdLurFg3IN6j7dnZnXRalYcG3-7GIoY__kN--6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehtdeihf
    fhheefgefghfegheevhfelleejueehheeuheehueeuhfdugfehleetveenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgpdgrmhgriihonhgrfihsrdgtohhmnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:hMrxYPHxWrZHfYPkPn3VxxtK8Obe7D7-6pOLvu7N0VMwtjw7TdMjlg>
    <xmx:hMrxYPVNh55h3IBCpW7J0BtW6rz-gHmkuWwP1JC0gKou0d72pB4RZQ>
    <xmx:hMrxYKPraOTdGVWVU_7GtNYhrJwlzGR1ZohEcIAWNGHOB3ralwA5xw>
    <xmx:hcrxYBLo6M8x4H2amBrNxAVkXt5MAiYytuKzsAs_u83suziQ5ssUOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jul 2021 14:05:56 -0400 (EDT)
Date:   Fri, 16 Jul 2021 20:05:54 +0200
From:   Greg KH <greg@kroah.com>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.13.2 (stable-queue, ee00910f)
Message-ID: <YPHKgryHsCuxSNxz@kroah.com>
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com>
 <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
 <YPBw8SQ/oQQXfguv@kroah.com>
 <CA+tGwnk3N6mGY+0HqKuhtraCx9Dyj9DU89dOt1tKNZ_Rg0jgeg@mail.gmail.com>
 <CAFxkdArW4BUhip_6xbwBNorEcCHOBx+GNd7i6PaV-sToZr1iWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdArW4BUhip_6xbwBNorEcCHOBx+GNd7i6PaV-sToZr1iWg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 02:54:33PM -0500, Justin Forbes wrote:
> On Thu, Jul 15, 2021 at 2:38 PM Veronika Kabatova <vkabatov@redhat.com> wrote:
> >
> > On Thu, Jul 15, 2021 at 7:32 PM Greg KH <greg@kroah.com> wrote:
> > >
> > > On Thu, Jul 15, 2021 at 02:51:15PM +0200, Veronika Kabatova wrote:
> > > > On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> wrote:
> > > > >
> > > > >
> > > > > Hello,
> > > > >
> > > > > We ran automated tests on a recent commit from this kernel tree:
> > > > >
> > > > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > >             Commit: ee00910f75ff - powerpc/powernv/vas: Release reference to tgid during window close
> > > > >
> > > > > The results of these automated tests are provided below.
> > > > >
> > > > >     Overall result: FAILED (see details below)
> > > > >              Merge: OK
> > > > >            Compile: FAILED
> > > > >
> > > > > All kernel binaries, config files, and logs are available for download here:
> > > > >
> > > > >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/15/337656806
> > > > >
> > > > > We attempted to compile the kernel for multiple architectures, but the compile
> > > > > failed on one or more architectures:
> > > > >
> > > > >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> > > > >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> > > > >
> > > >
> > > > Hi, looks to be introduced by
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.13&id=07d407cc1259634b3334dd47519ecd64e6818617
> > >
> > > Are you sure?  I fixed a different build bug in that area a few hours
> > > ago, if you rebuild the tree it should be resolved.
> > >
> >
> > Yes. All runs of the queue hit the problem, including the latest
> > b438694730fd. I also ran a test of the second latest completed
> > run with a patch revert and the issue disappeared.
> >
> > That said, the c139bde0fdca rebase (second latest) introduced
> > an s390x compilation problem that did not happen before. It
> > is also visible with the latest head. I don't know what commit
> > introduced it yet as the run barely finished:
> >
> 
> I hit this same failure building in koji.  All of the s390 patches are
> related, and appear to be an incomplete set:
> 
> 
> s390-signal-switch-to-using-vdso-for-sigreturn-and-syscall-restart.patch
> s390-vdso64-add-sigreturn-rt_sigreturn-and-restart_syscall.patch
> s390-vdso-add-minimal-compat-vdso.patch
> s390-vdso-always-enable-vdso.patch
> s390-vdso-rename-vdso64_lbase-to-vdso_lbase.patch

I'm going to drop all of these, they do not seem to work and will wait
for a series from the developers to get it right.

thanks,

greg k-h
