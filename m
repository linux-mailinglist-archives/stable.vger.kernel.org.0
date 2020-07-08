Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF6218CA2
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgGHQL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 12:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 12:11:57 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B23C061A0B
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 09:11:57 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id c4so5397652oou.6
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 09:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YN71cATLDI30LRa2mroKtRtPhlu/+jUrZdtC56DgGlc=;
        b=QWY0UZX/3Gh6wEm7Xc920GbpeNk0DMAhW5YzQyoVKlLFLUISjBYwCAjH2WSswb/0qQ
         P9zLU08WE4n0gLo5MeUL6wB84hdZZU5LFhPTlWrBR9g7GwIlUWI1Sa1ZVMRoS2TFpOr/
         2onEh469wPJ0tigjO1WK5T8Z5Ebqsgcd7jrk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YN71cATLDI30LRa2mroKtRtPhlu/+jUrZdtC56DgGlc=;
        b=k9btO/Eik0GDRRCJhsl8bEY126IOJPyFnBKdvrJCWaol46ijRnpRkyy6il7ds4ff3w
         wreUnhMgEQzc42Zg+MEnaBfMi7oTIvGm8FtftgOBRD6JVs2UZ3h6995idLlKY1LuIHo2
         su9QvwQDqPbYr9OLv0Q2wIVJlFh5tqQTnOZC84K7F9hU0TMiB6U65sq1UVSQWOJb3jJz
         HHgPq5vNWwXxQIo3wY5bV6unLzNu/aqhpHfvzHmPXR5/yK5Lr5uBeuGdC01JevWi66o7
         61Lh6629VPnwiMYLtLdj7zdJUUx7mR/+YW9VFhFg6k2ao+PM5AeQRCFwSagtVzyVha2K
         aT7Q==
X-Gm-Message-State: AOAM530a4hK1dbg/O6m+kKBNsq7k3oJY94+5SU4blmotL5BGmqgfs+uE
        NiCPu1fHh1cIbEzIrFgivIllVOc1RSzAfMuHMGzK0asS
X-Google-Smtp-Source: ABdhPJwkYWjR2bcHPyfqayBgmEUcWiCqkeALZ1He5Pn3cKp5uUK4uOxIlt63eWq3QtuRGCoL2PidJCm3W7KjISQyszg=
X-Received: by 2002:a4a:9653:: with SMTP id r19mr28869286ooi.85.1594224717078;
 Wed, 08 Jul 2020 09:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
 <b8e6d844-f096-8efc-1252-ef430069d080@amd.com> <20200708095405.GJ3278063@phenom.ffwll.local>
 <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com> <CAKMK7uF1nXT-q-rJK0s2yUQa8h8qJmzO=p-ouzvXVQ5HgkE9Qg@mail.gmail.com>
 <ea2ba563-11ba-efc3-44db-ae83920225d6@amd.com>
In-Reply-To: <ea2ba563-11ba-efc3-44db-ae83920225d6@amd.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 8 Jul 2020 18:11:45 +0200
Message-ID: <CAKMK7uEA65DT=7Qxku5Mvdcm6ii9qnyeR03Es+E-oCsxXkJBmA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
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

On Wed, Jul 8, 2020 at 5:05 PM Christian K=C3=B6nig <christian.koenig@amd.c=
om> wrote:
>
> Am 08.07.20 um 17:01 schrieb Daniel Vetter:
> > On Wed, Jul 8, 2020 at 4:37 PM Christian K=C3=B6nig <christian.koenig@a=
md.com> wrote:
> >> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
> >>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian K=C3=B6nig wrote:
> >>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
> >>>>> Quoting lepton (2020-07-07 19:17:51)
> >>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.c=
o.uk> wrote:
> >>>>>>> Quoting lepton (2020-07-07 18:05:21)
> >>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.=
co.uk> wrote:
> >>>>>>>>> If we assign obj->filp, we believe that the create vgem bo is n=
ative and
> >>>>>>>>> allow direct operations like mmap() assuming it behaves as back=
ed by a
> >>>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
> >>>>>>>>> not always meaningful and the shmemfs backing store misleading.
> >>>>>>>>>
> >>>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb buf=
fer API,
> >>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
> >>>>>>>> What do you mean by "regular mmap access" here?  It looks like v=
gem is
> >>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doe=
sn't call
> >>>>>>>> drm_gem_dumb_map_offset
> >>>>>>> As I too found out, and so had to correct my story telling.
> >>>>>>>
> >>>>>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb=
 buffer
> >>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to lo=
ok at
> >>>>>>> igt to see how it was being used.
> >>>>>> Now it seems your fix is to disable "regular mmap" on imported dma=
 buf
> >>>>>> for vgem. I am not really a graphic guy, but then the api looks li=
ke:
> >>>>>> for a gem handle, user space has to guess to find out the way to m=
map
> >>>>>> it. If user space guess wrong, then it will fail to mmap. Is this =
the
> >>>>>> expected way
> >>>>>> for people to handle gpu buffer?
> >>>>> You either have a dumb buffer handle, or a dma-buf fd. If you have =
the
> >>>>> handle, you have to use the dumb buffer API, there's no other way t=
o
> >>>>> mmap it. If you have the dma-buf fd, you should mmap it directly. T=
hose
> >>>>> two are clear.
> >>>>>
> >>>>> It's when you import the dma-buf into vgem and create a handle out =
of
> >>>>> it, that's when the handle is no longer first class and certain uAP=
I
> >>>>> [the dumb buffer API in particular] fail.
> >>>>>
> >>>>> It's not brilliant, as you say, it requires the user to remember th=
e
> >>>>> difference between the handles, but at the same time it does preven=
t
> >>>>> them falling into coherency traps by forcing them to use the right
> >>>>> driver to handle the object, and have to consider the additional io=
ctls
> >>>>> that go along with that access.
> >>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an i=
mporter
> >>>> is illegal.
> >>>>
> >>>> What we could maybe try to do is to redirect this mmap() API call on=
 the
> >>>> importer to the exporter, but I'm pretty sure that the fs layer woul=
dn't
> >>>> like that without changes.
> >>> We already do that, there's a full helper-ified path from I think shm=
em
> >>> helpers through prime helpers to forward this all. Including handling
> >>> buffer offsets and all the other lolz back&forth.
> >> Oh, that most likely won't work correctly with unpinned DMA-bufs and
> >> needs to be avoided.
> >>
> >> Each file descriptor is associated with an struct address_space. And
> >> when you mmap() through the importer by redirecting the system call to
> >> the exporter you end up with the wrong struct address_space in your VM=
A.
> >>
> >> That in turn can go up easily in flames when the exporter tries to
> >> invalidate the CPU mappings for its DMA-buf while moving it.
> >>
> >> Where are we doing this? My last status was that this is forbidden.
> > Hm I thought we're doing all that already, but looking at the code
> > again we're only doing this when opening a new drm fd or dma-buf fd.
> > So the right file->f_mapping is always set at file creation time.
> >
> > And we indeed don't frob this more when going another indirection ...
> > Maybe we screwed up something somewhere :-/
> >
> > Also I thought the mapping is only taken after the vma is instatiated,
> > otherwise the tricks we're playing with dma-buf already wouldn't work:
> > dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap has
> > it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
> > whether we could adjust vm_file too. Or is that the thing that's
> > forbidden?
>
> Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.
>
> But changing vma->vm_file, that's something I haven't seen before and
> most likely could blow up badly.

Ok, I read the shmem helpers again, I think those are the only ones
which do the importer mmap -> dma_buf_mmap() forwarding, and hence
break stuff all around here.

They also remove the vma->vm_pgoff offset, which means
unmap_mapping_range wont work anyway. I guess for drivers which use
shmem helpers the hard assumption is that a) can't use p2p dma and b)
pin everything into system memory.

So not a problem. But something to keep in mind. I'll try to do a
kerneldoc patch to note this somewhere. btw on that, did the
timeline/syncobj documentation patch land by now? Just trying to make
sure that doesn't get lost for another few months or so :-/

Cheers, Daniel

>
> Christian.
>
> > -Daniel
> >
> >> Christian.
> >>
> >>> Of course there's still the problem that many drivers don't forward t=
he
> >>> cache coherency calls for begin/end cpu access, so in a bunch of case=
s
> >>> you'll cache cacheline dirt soup. But that's kinda standard procedure=
 for
> >>> dma-buf :-P
> >>>
> >>> But yeah trying to handle the mmap as an importer, bypassing the expo=
rt:
> >>> nope. The one exception is if you have some kind of fancy gart with
> >>> cpu-visible pci bar (like at least integrated intel gpus have). But i=
n
> >>> that case the mmap very much looks&acts like device access in every w=
ay.
> >>>
> >>> Cheers, Daniel
> >>>
> >>>> Regards,
> >>>> Christian.
> >>>>
> >>>>
> >>>>> -Chris
> >
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
