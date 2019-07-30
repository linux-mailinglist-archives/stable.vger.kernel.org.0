Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612E77AB75
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 16:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfG3OwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 10:52:18 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40249 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfG3OwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 10:52:18 -0400
Received: by mail-lf1-f66.google.com with SMTP id b17so44958096lff.7;
        Tue, 30 Jul 2019 07:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vLDKuH+/Y6R1wGAQGSCIi/9agKk/j9gR7pNqj2Ro2Ic=;
        b=iuQpUu6a8JnbGLjoBITZrEilnUrTWiH26PXOZvr0eJQhTGXYXPQKMEzNw2wB2Zdhwg
         O1s79fuH/+qKj9qM+F5N7WUORuY3bi2XPxK5gT8Guf2uZd9D6oyAtYDwhskz/FMsfn6o
         lKk6nD1IBmzrEbMo1z8fbSNSoKGZUfXjLfcnm5mKawQB8u+vap+bsQ1AUfdjGTiXN2ty
         tL6eFXIjDfZ571OcOPQwvXVAUX+46G+xpgSdufwNKOjBmDF3XP8A7mx0CfXSR6UXqbUn
         dguHNLtM+ir+qgid1b0WJ9SI3b8hxcX2P6U5NkAvYIDJKRzUwkVnKHJszs5C7d/SjcoV
         C0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vLDKuH+/Y6R1wGAQGSCIi/9agKk/j9gR7pNqj2Ro2Ic=;
        b=NGKkLnA3hd2NE4ghB6+4hIJSTtb9cJr6cmxiq2kByYTcHaMMPuXfTna4e9gbFu71KV
         0+2i8dk7lLBpKWbif4YO2GlQZDEHSmzC5x/AXN9o1R6D+DA3j16adeONyzHjihQl3Ate
         vXyUXu/Nk2VT/F9WV0kk5Rx1b3dOBo/b8mQOGnf+KkkfF754NYokhQsrG46G0FsFS6af
         5FxhCh10lwiGL7r59EDa4u/OfcxWvWN5XXVhr6S9EgvZzJJK9/2CWxKGXzYs4n+9AIsI
         VR4Z1TrlLrMbpzCfl8JMkC8D6kAsneqVk+f5H7jzUzH4WDAjJx0bIu48WODzUb193Bjt
         +YOQ==
X-Gm-Message-State: APjAAAURGDLiJx2rt9SaVWaZH/4vSPhunCbqFT8Yw94P4XM0Vxd03yba
        AK0mT27eiIhOokDDR+0ITTbx7mM9Yt3W/8VirXQQyg==
X-Google-Smtp-Source: APXvYqwtNV8PHczquSPB8e+BmF7PEr+3WvMBui8pMbhp0rAOkLkZq6TteMkvwzTbZj0eIDgOEAic/3pWWOYVMC6LbUU=
X-Received: by 2002:a19:c1cc:: with SMTP id r195mr53854149lff.95.1564498336043;
 Tue, 30 Jul 2019 07:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190215024830.GA26477@jordon-HP-15-Notebook-PC>
 <20190728180611.GA20589@mail-itl> <CAFqt6zaMDnpB-RuapQAyYAub1t7oSdHH_pTD=f5k-s327ZvqMA@mail.gmail.com>
 <CAFqt6zY+07JBxAVfMqb+X78mXwFOj2VBh0nbR2tGnQOP9RrNkQ@mail.gmail.com>
 <20190729133642.GQ1250@mail-itl> <CAFqt6zZN+6r6wYJY+f15JAjj8dY+o30w_+EWH9Vy2kUXCKSBog@mail.gmail.com>
 <bf02becc-9db0-bb78-8efc-9e25cc115237@oracle.com> <20190730142233.GR1250@mail-itl>
In-Reply-To: <20190730142233.GR1250@mail-itl>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Tue, 30 Jul 2019 20:22:02 +0530
Message-ID: <CAFqt6zZOymx8RH75F69exukLYcGd45xpUHkRHK8nYXpwF8co6g@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH v4 8/9] xen/gntdev.c: Convert to use vm_map_pages()
To:     =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 7:52 PM Marek Marczykowski-G=C3=B3recki
<marmarek@invisiblethingslab.com> wrote:
>
> On Tue, Jul 30, 2019 at 10:05:42AM -0400, Boris Ostrovsky wrote:
> > On 7/30/19 2:03 AM, Souptick Joarder wrote:
> > > On Mon, Jul 29, 2019 at 7:06 PM Marek Marczykowski-G=C3=B3recki
> > > <marmarek@invisiblethingslab.com> wrote:
> > >> On Mon, Jul 29, 2019 at 02:02:54PM +0530, Souptick Joarder wrote:
> > >>> On Mon, Jul 29, 2019 at 1:35 PM Souptick Joarder <jrdr.linux@gmail.=
com> wrote:
> > >>>> On Sun, Jul 28, 2019 at 11:36 PM Marek Marczykowski-G=C3=B3recki
> > >>>> <marmarek@invisiblethingslab.com> wrote:
> > >>>>> On Fri, Feb 15, 2019 at 08:18:31AM +0530, Souptick Joarder wrote:
> > >>>>>> Convert to use vm_map_pages() to map range of kernel
> > >>>>>> memory to user vma.
> > >>>>>>
> > >>>>>> map->count is passed to vm_map_pages() and internal API
> > >>>>>> verify map->count against count ( count =3D vma_pages(vma))
> > >>>>>> for page array boundary overrun condition.
> > >>>>> This commit breaks gntdev driver. If vma->vm_pgoff > 0, vm_map_pa=
ges
> > >>>>> will:
> > >>>>>  - use map->pages starting at vma->vm_pgoff instead of 0
> > >>>> The actual code ignores vma->vm_pgoff > 0 scenario and mapped
> > >>>> the entire map->pages[i]. Why the entire map->pages[i] needs to be=
 mapped
> > >>>> if vma->vm_pgoff > 0 (in original code) ?
> > >> vma->vm_pgoff is used as index passed to gntdev_find_map_index. It's
> > >> basically (ab)using this parameter for "which grant reference to map=
".
> > >>
> > >>>> are you referring to set vma->vm_pgoff =3D 0 irrespective of value=
 passed
> > >>>> from user space ? If yes, using vm_map_pages_zero() is an alternat=
e
> > >>>> option.
> > >> Yes, that should work.
> > > I prefer to use vm_map_pages_zero() to resolve both the issues. Alter=
natively
> > > the patch can be reverted as you suggested. Let me know you opinion a=
nd wait
> > > for feedback from others.
> > >
> > > Boris, would you like to give any feedback ?
> >
> > vm_map_pages_zero() looks good to me. Marek, does it work for you?
>
> Yes, replacing vm_map_pages() with vm_map_pages_zero() fixes the
> problem for me.

Marek, I can send a patch for the same if you are ok.
We need to cc stable as this changes are available in 5.2.4.

>
> --
> Best Regards,
> Marek Marczykowski-G=C3=B3recki
> Invisible Things Lab
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
