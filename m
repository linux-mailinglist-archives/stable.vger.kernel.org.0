Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD67196B98
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 09:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgC2HUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 03:20:55 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38018 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgC2HUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 03:20:55 -0400
Received: by mail-qk1-f196.google.com with SMTP id h14so15712181qke.5;
        Sun, 29 Mar 2020 00:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MBRt8+k2paszDjk+AWvvybbznwwY03OoRZexgAwjbK0=;
        b=egGUiNaemesGJM4SizgtC8pV1xeaw2lChfdN3Y6Ap+7kYnUO+3ogshbVDDs5jOWZAE
         HfWFUW9kQTFi/pycmC6A5s/iChoTAohnpyT1iQiaB3Gcr6ZxjCD1TziriSplir3ZGhdI
         ssBdo5TmtOTdiwSM8km5QKLuko/WJqPGrbBRmOAGvcbxQ8aAD3Hn7nZFoSq+ScISIoOC
         eszFVfXTezSaLHoKaQ41U5rVwsf17s/U7rKlndv8CzaZN/u+h9kcgSvExdz3U41/b9PB
         sceJZCMlBLzCG8kh0gxGCUl49QX7Ne/zOceNkhoPClyWXGqGutjPXRxwMAC6zc0Rp030
         jqcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MBRt8+k2paszDjk+AWvvybbznwwY03OoRZexgAwjbK0=;
        b=dxcfRQluOoOKMuS+AVuzGUOpLMx//moy3wZQaVztvRaCFOGhcIbeVcLXTShWwZ2P6f
         mxpLUDes0qZkONVOnDCjebLONZJLwJSi/MEZqaO7PrFP5SVcIdMyjuVxAMRb8tw7KwyO
         LiThARYKG5wUSDIZN4FhSEQcAXDIfcRkfy5IzKUxxVERoznUgxiS00bDHdAx1/i2n9nB
         QAjK3+VGk1izHNy/Bj39We9AXwtVYPfanru9aL+9v39CtVmuoNYYwsGSo2zg4uqiyjRi
         qFDvbRZsTpwQ4uA2zHsLXc87rKtV4LKAXYtr7eaNh64RlFKQpUfiWUXwVBEYxcmKd34F
         zQ2w==
X-Gm-Message-State: ANhLgQ09q96NckjgAgIvHVjcVNL2uJ1eGACXvwo/sRtb3T5e5/4nvu1J
        27p/vT+zyRyJh4KiIp6HroRsint5jeeLIBYvxio=
X-Google-Smtp-Source: ADFU+vsWKd46vZveHx9M2yXIoJCrlyRomGGVxfnkeiiNED12YbUeYIwfRcad6LGYY6pvVbHcPjOVn2a7A1TF1VLW0ro=
X-Received: by 2002:a37:4015:: with SMTP id n21mr6220237qka.76.1585466453876;
 Sun, 29 Mar 2020 00:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVqi1R0Cc4+wqwCr9-8HoTU+6cShzorD44YzDNyex+jv1dztA@mail.gmail.com>
 <20200328195932.GA96482@google.com>
In-Reply-To: <20200328195932.GA96482@google.com>
From:   Kelsey <skunberg.kelsey@gmail.com>
Date:   Sun, 29 Mar 2020 01:20:42 -0600
Message-ID: <CAFVqi1Td3kE0Gd6S43F5xs3br=UBd1ssZu-1xkoO+Z9EYRQR=w@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2] PCI: sysfs: Change bus_rescan
 and dev_rescan to rescan
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org,
        Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        rbilovol@cisco.com, stable <stable@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Bodong Wang <bodong@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 28, 2020 at 1:59 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Thu, Mar 26, 2020 at 12:29:11AM -0600, Kelsey wrote:
> > On Wed, Mar 25, 2020 at 4:10 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> > > Thanks for taking care of this!  Two questions:
> > >
> > > 1) You supplied permissions of 0220, but DEVICE_ATTR_WO()
> > > uses__ATTR_WO(), which uses 0200.  Shouldn't we keep 0200?
> > >
> >
> > Good catch. Before changing to DEVICE_ATTR_WO(), the permissions used
> > was (S_IWUSR | S_IWGRP), which would be 0220. This means the
> > permissions were mistakenly changed from 0220 to 0200 in the same
> > patch:
> >
> > commit 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
> >
> > To verify DEVICE_ATTR_WO() is using __ATTR_WO() can be seen in
> > /include/linux/device.h
> > To verify permissions for __ATTR_WO() is 0200 can be seen in
> > /inlcude/linux/sysfs.h
> >
> > These attributes had permissions 0220 when first being introduced and
> > before the above mentioned patch, so I'm on the side to believe that
> > 0220 should be used.
>
> I'm not sure it was a mistake that 4e2b79436e4f changed from 0220 to
> 200 or not.  I'd say __ATTR_WO (0200) is the "standard" one, and we
> should have a special reason to use 0220.

Sounds good. I didn't find any information or reason stating the
permissions needed to be 0220. So sounds like 0200 will be the winner.

Appreciate the help and you checking this over!

- Kelsey
