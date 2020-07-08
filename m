Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE154218CCE
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 18:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgGHQUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 12:19:59 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DB8C061A0B
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 09:19:59 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 18so37315756otv.6
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 09:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FJA6Tf/ZkA2qBsAQURQEr7OtLGJgkosoHiAd0rU57rU=;
        b=GcS/YTrlW7rW3p/tfxKkemxJet/Y+kqfmvHB/VCwMqGyzxEhzq4Tq4lEmW0FeduhJP
         4nfG/YbMB2Wvvyg7UwFedMXvGvTLyc1Mv0oa+Es4KI2qH0gjBdz0tFdYXi/sq4TugCSR
         EKTBcjK3ovo2lfsswRRkE8BDL0Io/1m5Jngrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FJA6Tf/ZkA2qBsAQURQEr7OtLGJgkosoHiAd0rU57rU=;
        b=UnieQsbGazF4/4tUSSCe/SbcRz1Ggw9fHqlRXlkDyJ3OtTme5kEU009TLLWPE39ZAG
         ICFALlxop4tOAKVzBUyHtkyshqexi0Ad15svugNLR3mopDSFHZ8BZ+A4E1Mc8WGXa2sR
         QiHLG3p74+hvZFall53mgRd/xQO+qrSzMK0dc4mxG/jVB/9m9TSJa6bhkmBjgWq/UsXU
         CcKGJf8ALDgXALeRJeZdwly/fEZW05s7UyAj7BdPFfziNfwxjQFQtSwYkDf8i33iaeyG
         mfXnHr9b0pJ8btr7zpj2aztIGXFSe9Z79Xmg2HRsT7EHSj82C7MMorha0odrcdLAUrYX
         qwYg==
X-Gm-Message-State: AOAM53275vR8HjMKIT7lz41xJyY3Ms9uamvvPUvyEiA4U3MorROZZK4Z
        3GR7/ySXS9OmimuRONaa7OvQT64S6/r0i7MzjUr7fg==
X-Google-Smtp-Source: ABdhPJz6XBgfS5O+ywxcMKn0jeedW3JYARx+axeNEoamvFy2DcMjBtbQGRqe+uLGvxak8ff5CCoR79aZlepJrmvnzf0=
X-Received: by 2002:a05:6830:1613:: with SMTP id g19mr36972763otr.303.1594225198852;
 Wed, 08 Jul 2020 09:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
 <b8e6d844-f096-8efc-1252-ef430069d080@amd.com> <20200708095405.GJ3278063@phenom.ffwll.local>
 <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com> <CAKMK7uF1nXT-q-rJK0s2yUQa8h8qJmzO=p-ouzvXVQ5HgkE9Qg@mail.gmail.com>
 <ea2ba563-11ba-efc3-44db-ae83920225d6@amd.com> <CAKMK7uEA65DT=7Qxku5Mvdcm6ii9qnyeR03Es+E-oCsxXkJBmA@mail.gmail.com>
In-Reply-To: <CAKMK7uEA65DT=7Qxku5Mvdcm6ii9qnyeR03Es+E-oCsxXkJBmA@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 8 Jul 2020 18:19:47 +0200
Message-ID: <CAKMK7uHe_dZvdfEx7Sd73QRNFPpDoTGVo-=BcU8cRwFhUVRtHA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Steven Price <Steven.Price@arm.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        lepton <ytht.net@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 8, 2020 at 6:11 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Wed, Jul 8, 2020 at 5:05 PM Christian K=C3=B6nig <christian.koenig@amd=
.com> wrote:
> >
> > Am 08.07.20 um 17:01 schrieb Daniel Vetter:
> > > On Wed, Jul 8, 2020 at 4:37 PM Christian K=C3=B6nig <christian.koenig=
@amd.com> wrote:
> > >> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
> > >>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian K=C3=B6nig wrot=
e:
> > >>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
> > >>>>> Quoting lepton (2020-07-07 19:17:51)
> > >>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson=
.co.uk> wrote:
> > >>>>>>> Quoting lepton (2020-07-07 18:05:21)
> > >>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilso=
n.co.uk> wrote:
> > >>>>>>>>> If we assign obj->filp, we believe that the create vgem bo is=
 native and
> > >>>>>>>>> allow direct operations like mmap() assuming it behaves as ba=
cked by a
> > >>>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages ar=
e
> > >>>>>>>>> not always meaningful and the shmemfs backing store misleadin=
g.
> > >>>>>>>>>
> > >>>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb b=
uffer API,
> > >>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
> > >>>>>>>> What do you mean by "regular mmap access" here?  It looks like=
 vgem is
> > >>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it d=
oesn't call
> > >>>>>>>> drm_gem_dumb_map_offset
> > >>>>>>> As I too found out, and so had to correct my story telling.
> > >>>>>>>
> > >>>>>>> By regular mmap() access I mean mmap on the vgem bo [via the du=
mb buffer
> > >>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to =
look at
> > >>>>>>> igt to see how it was being used.
> > >>>>>> Now it seems your fix is to disable "regular mmap" on imported d=
ma buf
> > >>>>>> for vgem. I am not really a graphic guy, but then the api looks =
like:
> > >>>>>> for a gem handle, user space has to guess to find out the way to=
 mmap
> > >>>>>> it. If user space guess wrong, then it will fail to mmap. Is thi=
s the
> > >>>>>> expected way
> > >>>>>> for people to handle gpu buffer?
> > >>>>> You either have a dumb buffer handle, or a dma-buf fd. If you hav=
e the
> > >>>>> handle, you have to use the dumb buffer API, there's no other way=
 to
> > >>>>> mmap it. If you have the dma-buf fd, you should mmap it directly.=
 Those
> > >>>>> two are clear.
> > >>>>>
> > >>>>> It's when you import the dma-buf into vgem and create a handle ou=
t of
> > >>>>> it, that's when the handle is no longer first class and certain u=
API
> > >>>>> [the dumb buffer API in particular] fail.
> > >>>>>
> > >>>>> It's not brilliant, as you say, it requires the user to remember =
the
> > >>>>> difference between the handles, but at the same time it does prev=
ent
> > >>>>> them falling into coherency traps by forcing them to use the righ=
t
> > >>>>> driver to handle the object, and have to consider the additional =
ioctls
> > >>>>> that go along with that access.
> > >>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an=
 importer
> > >>>> is illegal.
> > >>>>
> > >>>> What we could maybe try to do is to redirect this mmap() API call =
on the
> > >>>> importer to the exporter, but I'm pretty sure that the fs layer wo=
uldn't
> > >>>> like that without changes.
> > >>> We already do that, there's a full helper-ified path from I think s=
hmem
> > >>> helpers through prime helpers to forward this all. Including handli=
ng
> > >>> buffer offsets and all the other lolz back&forth.
> > >> Oh, that most likely won't work correctly with unpinned DMA-bufs and
> > >> needs to be avoided.
> > >>
> > >> Each file descriptor is associated with an struct address_space. And
> > >> when you mmap() through the importer by redirecting the system call =
to
> > >> the exporter you end up with the wrong struct address_space in your =
VMA.
> > >>
> > >> That in turn can go up easily in flames when the exporter tries to
> > >> invalidate the CPU mappings for its DMA-buf while moving it.
> > >>
> > >> Where are we doing this? My last status was that this is forbidden.
> > > Hm I thought we're doing all that already, but looking at the code
> > > again we're only doing this when opening a new drm fd or dma-buf fd.
> > > So the right file->f_mapping is always set at file creation time.
> > >
> > > And we indeed don't frob this more when going another indirection ...
> > > Maybe we screwed up something somewhere :-/
> > >
> > > Also I thought the mapping is only taken after the vma is instatiated=
,
> > > otherwise the tricks we're playing with dma-buf already wouldn't work=
:
> > > dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap ha=
s
> > > it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
> > > whether we could adjust vm_file too. Or is that the thing that's
> > > forbidden?
> >
> > Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.
> >
> > But changing vma->vm_file, that's something I haven't seen before and
> > most likely could blow up badly.
>
> Ok, I read the shmem helpers again, I think those are the only ones
> which do the importer mmap -> dma_buf_mmap() forwarding, and hence
> break stuff all around here.
>
> They also remove the vma->vm_pgoff offset, which means
> unmap_mapping_range wont work anyway. I guess for drivers which use
> shmem helpers the hard assumption is that a) can't use p2p dma and b)
> pin everything into system memory.
>
> So not a problem. But something to keep in mind. I'll try to do a
> kerneldoc patch to note this somewhere. btw on that, did the
> timeline/syncobj documentation patch land by now? Just trying to make
> sure that doesn't get lost for another few months or so :-/

Ok, so maybe it is a problem. Because there is a drm_gem_shmem_purge()
which uses unmap_mapping_range underneath, and that's used by
panfrost. And panfrost also uses the mmap helper. Kinda wondering
whether we broke some stuff here, or whether the reverse map is
installed before we touch vma->vm_pgoff.

panfrost folks, does panfrost purged buffer handling of mmap still
work correctly? Do you have some kind of igt or similar for this?

Cheers, Daniel

>
> Cheers, Daniel
>
> >
> > Christian.
> >
> > > -Daniel
> > >
> > >> Christian.
> > >>
> > >>> Of course there's still the problem that many drivers don't forward=
 the
> > >>> cache coherency calls for begin/end cpu access, so in a bunch of ca=
ses
> > >>> you'll cache cacheline dirt soup. But that's kinda standard procedu=
re for
> > >>> dma-buf :-P
> > >>>
> > >>> But yeah trying to handle the mmap as an importer, bypassing the ex=
port:
> > >>> nope. The one exception is if you have some kind of fancy gart with
> > >>> cpu-visible pci bar (like at least integrated intel gpus have). But=
 in
> > >>> that case the mmap very much looks&acts like device access in every=
 way.
> > >>>
> > >>> Cheers, Daniel
> > >>>
> > >>>> Regards,
> > >>>> Christian.
> > >>>>
> > >>>>
> > >>>>> -Chris
> > >
> >
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
