Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0BC170CE9
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 01:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgB0ADD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 19:03:03 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36182 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgB0ADC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 19:03:02 -0500
Received: by mail-io1-f65.google.com with SMTP id d15so1206739iog.3;
        Wed, 26 Feb 2020 16:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tZtnM0e+xr4AH9861svl/LlAtVjcSg0W4wskznM5ZKY=;
        b=C4wxSclBqOr2LuIMMwxD7oLZMwwjbp4vTUF3ZiBhz/VGtOdBYagVxf6pObpH9POUo+
         m9ci0oJvKahUD2zyeWp3IAIxTbFjQVVcZx/n8jU28HdofOZvk9KMGrHvBMt3p+IgFb8g
         bj35iSwW6vw6J43AhaGoR0aU6MEDc7I2lbQ6A3Qm4jf4W+ZNeWmnGUgxPRp7bHlpNsQx
         ombBRcrwfqlXWMwnY26xViHnqggxOEAnHlyjACJtW1+TSAnvTAmNA51IGzRc3VYslq0C
         NzNrdK2FGKqfrVRJMVt0lGSVy4UK+M2L5RuGU3jHRTg4uuI/4kUYmLAAXDVE8dwpL5T9
         YY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tZtnM0e+xr4AH9861svl/LlAtVjcSg0W4wskznM5ZKY=;
        b=RoWJjvRBV6TB4q1fDwsJqZ1ruq4O2hNd93PfG6lGxnCdxmVmIqZ/kdt/EdEkPDOMl/
         /pDrIHk6EynqRk2aGReijYMQplRj1RhJ0v5tJWYhPXYzKfVdZqB7T4Mdy81CJyfiqsLZ
         e6scZq0ozte3b0OT6g15hSEf1Vvef5lqPkgtWta7UpoPleduc9Rea626/X3xo5C3rS51
         LeIxU4kVE3DkaJiu1EMhZn+onWzhJxcLNoPj8BsZe6fEDMJlvhTH5Go1sUsH3hx91AaC
         33OLvCf9XUwupaUrOyewe8IwSUENaMfhr+ScVdxk95uzP69rCIg6rh7Pq4a3EKzqr6rG
         pJtw==
X-Gm-Message-State: APjAAAWpMIxsEYKBcvFOd7ZOBa/c0su/V7SQne8Hg9m6fHsDOAEWzc5Q
        f0HE+R8HA7u2g+oW7WC/w5JSzNZD2LShAlVE3ck=
X-Google-Smtp-Source: APXvYqxIn6NGD5ZRlTLPjMi1xq0GHuB1mJN4ffE/xw86VQ9rk0Y9Jvv0lkfcwSmGVSmMhb01pzQedOOsmhGlIxm0Cis=
X-Received: by 2002:a02:c815:: with SMTP id p21mr65171jao.20.1582761781497;
 Wed, 26 Feb 2020 16:03:01 -0800 (PST)
MIME-Version: 1.0
References: <20200226154752.24328-1-kraxel@redhat.com> <20200226154752.24328-2-kraxel@redhat.com>
 <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
In-Reply-To: <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Wed, 26 Feb 2020 16:02:50 -0800
Message-ID: <CAPaKu7R4VFYnk9UdpguZnkWeKk2ELVnoQ60=i72RN2GkME1ukw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] drm/shmem: add support for per object caching flags.
To:     =?UTF-8?Q?Thomas_Hellstr=C3=B6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Guillaume Gardet <Guillaume.Gardet@arm.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        tzimmermann@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 10:25 AM Thomas Hellstr=C3=B6m (VMware)
<thomas_os@shipmail.org> wrote:
>
> Hi, Gerd,
>
> While looking at this patchset I came across some stuff that seems
> strange but that was merged in a previous patchset.
>
> (please refer to
> https://lists.freedesktop.org/archives/dri-devel/2018-September/190001.ht=
ml.
> Forgive me if I've missed any discussion leading up to this).
>
>
> On 2/26/20 4:47 PM, Gerd Hoffmann wrote:
> > Add map_cached bool to drm_gem_shmem_object, to request cached mappings
> > on a per-object base.  Check the flag before adding writecombine to
> > pgprot bits.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > ---
> >   include/drm/drm_gem_shmem_helper.h     |  5 +++++
> >   drivers/gpu/drm/drm_gem_shmem_helper.c | 15 +++++++++++----
> >   2 files changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_s=
hmem_helper.h
> > index e34a7b7f848a..294b2931c4cc 100644
> > --- a/include/drm/drm_gem_shmem_helper.h
> > +++ b/include/drm/drm_gem_shmem_helper.h
> > @@ -96,6 +96,11 @@ struct drm_gem_shmem_object {
> >        * The address are un-mapped when the count reaches zero.
> >        */
> >       unsigned int vmap_use_count;
> > +
> > +     /**
> > +      * @map_cached: map object cached (instead of using writecombine)=
.
> > +      */
> > +     bool map_cached;
> >   };
> >
> >   #define to_drm_gem_shmem_obj(obj) \
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/d=
rm_gem_shmem_helper.c
> > index a421a2eed48a..aad9324dcf4f 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -254,11 +254,16 @@ static void *drm_gem_shmem_vmap_locked(struct drm=
_gem_shmem_object *shmem)
> >       if (ret)
> >               goto err_zero_use;
> >
> > -     if (obj->import_attach)
> > +     if (obj->import_attach) {
> >               shmem->vaddr =3D dma_buf_vmap(obj->import_attach->dmabuf)=
;
> > -     else
> > +     } else {
> > +             pgprot_t prot =3D PAGE_KERNEL;
> > +
> > +             if (!shmem->map_cached)
> > +                     prot =3D pgprot_writecombine(prot);
> >               shmem->vaddr =3D vmap(shmem->pages, obj->size >> PAGE_SHI=
FT,
> > -                                 VM_MAP, pgprot_writecombine(PAGE_KERN=
EL));
> > +                                 VM_MAP, prot)
>
>
> Wouldn't a vmap with pgprot_writecombine() create conflicting mappings
> with the linear kernel map which is not write-combined? Or do you change
> the linear kernel map of the shmem pages somewhere? vmap bypassess at
> least the x86 PAT core mapping consistency check and this could
> potentially cause spuriously overwritten memory.

Yeah, I think this creates a conflicting alias.  It seems a call to
set_pages_array_wc here or changes elsewhere is needed..

But this is a pre-existing issue in the shmem helper.  There is also
no universal fix (e.g., set_pages_array_wc is x86 only)?  I would hope
this series can be merged sooner to fix the regression first.

>
>
> > +     }
> >
> >       if (!shmem->vaddr) {
> >               DRM_DEBUG_KMS("Failed to vmap pages\n");
> > @@ -540,7 +545,9 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, =
struct vm_area_struct *vma)
> >       }
> >
> >       vma->vm_flags |=3D VM_MIXEDMAP | VM_DONTEXPAND;
> > -     vma->vm_page_prot =3D pgprot_writecombine(vm_get_page_prot(vma->v=
m_flags));
> > +     vma->vm_page_prot =3D vm_get_page_prot(vma->vm_flags);
> > +     if (!shmem->map_cached)
> > +             vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_pr=
ot);
>
> Same thing here. Note that vmf_insert_page() which is used by the fault
> handler also bypasses the x86 PAT  consistency check, whereas
> vmf_insert_mixed() doesn't.
>
> >       vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
>
> At least with SME or SEV encryption, where shmem memory has its kernel
> map set to encrypted, creating conflicting mappings is explicitly
> disallowed.
> BTW, why is mmap mapping decrypted while vmap isn't?
>
> >       vma->vm_ops =3D &drm_gem_shmem_vm_ops;
> >
>
> Thanks,
> Thomas
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
