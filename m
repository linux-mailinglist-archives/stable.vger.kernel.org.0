Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8461B1E304E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 22:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403963AbgEZUwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 16:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404010AbgEZUwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 16:52:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC5BC061A0F
        for <stable@vger.kernel.org>; Tue, 26 May 2020 13:52:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x20so25284104ejb.11
        for <stable@vger.kernel.org>; Tue, 26 May 2020 13:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZL3ilne+GNMSewS9YNjjKuWKAhBcjlAa2MA8SA2wuzA=;
        b=r2z4N6y94qMDZmbC/5g8ZBnNI9jDMJ43mzIkUt4bZ7LmsB6zn5gkm7oPk75lZyCEtZ
         WjWwJXrH21yDNsQaRIfBLv83UxxAikddjQnOGHLgDlVQulNNWFzouNZndtKZjQKNS8Ot
         FgzwXg3SERr6wpTeOEynVkKst8khQJF3sPMQ25pJg0fVNjGxBOtnI/q6eEbjBFfHTZ4u
         c8OqeLgS05yVuUwUACTZXIzRAcp5wT65wNtQ6txdqdttRE59cQToUbGT0mqoEsTUvJ0t
         knaW1ecZpjF1p/s6HHOIyJx/lNj3usTQn6Q1WPAWGztLrAjKhJiv6JraLIoM+CaJXAbk
         ZhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZL3ilne+GNMSewS9YNjjKuWKAhBcjlAa2MA8SA2wuzA=;
        b=ONSpNqkTRnb1NyEVyUkBpxAK2pzkqQDHDpp6/2zvoeALpvjaio0sXzrIL5rXlTekpW
         aX7YSoXmcm+sgjQeg2R4YnYtNumD7yHX2yAhcO7xnpMIE/dfoPWPN4awp+PlV8rGmLv0
         dO+rCAtiuRAP+fDehKkbmxN22krFWfxkln6PP/zxfOMbJpwA2ue3343pHj6dVqlAFDv2
         jlQIH5HRWbIfSuT11608LH4sEzJLE5aeWBrHSRXDz0DhwocFtCEE2w3Hi8IFxRmaoXls
         I+sdHODW3C8Z+4o3L/B1nVuYCKBIpzedVPaNGgMiSt/wADICGCBs8XX8gOW+LpXDMc/A
         6nMA==
X-Gm-Message-State: AOAM530ztD6KurRYgrJy/nZZgjuZs8LuK9nV2P+JDBKhCoO7m7i6LJT9
        5qvThUaTMvhCO8xpCFrCwY/uG/Hqqdhy2FO4FzIdHMKh
X-Google-Smtp-Source: ABdhPJwj5jKLXuQ67bNjPxeM/yLM9fMTV9PfxjjNpwwOPDOS4fyMuJll+S41uNZuvGe7j3DAA6kwNJejL2G57xt2xpk=
X-Received: by 2002:a17:906:3597:: with SMTP id o23mr2722884ejb.174.1590526352787;
 Tue, 26 May 2020 13:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200522115800.GA1451824@kroah.com> <20200522120009.GA1456052@kroah.com>
 <CAPcyv4jW9P2FP2p6OiLoN+e_wzZY9-c8C-mMMoDqohuTekF7WQ@mail.gmail.com> <x491rn6a0bp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x491rn6a0bp.fsf@segfault.boston.devel.redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 26 May 2020 13:52:21 -0700
Message-ID: <CAPcyv4idRgByUTdb=6coYV=kkhqfLTzO1c+LZc7VQXus-BHh6Q@mail.gmail.com>
Subject: Re: [5.4-stable PATCH 0/7] libnvdimm: Cross-arch compatible namespace alignment
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 1:49 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> >> What problems with 5.4.y and 5.6.y is this series fixing
> >> that used to work before?
> >
> > The "used to work" bug fixed by this set is the fact that the kernel
> > used to force a 128MB (memory hotplug section size) alignment padding
> > on all persistent memory namespaces to enable DAX operation. The
> > support for sub-sections (2MB) dropped forced alignment padding, but
> > unfortunately introduced a regression for the case of trying to create
> > multiple unaligned namespaces. When that bug triggers namespace
> > creation for the region is disabled, iirc, previously that lockout
> > scenario was prevented.
> >
> > Jeff, can you corroborate this?
>
> So, I don't pretend to remember the exact state of brokenness for each
> iteration.  :)  As far as I can recall, though, the issue you describe
> with a misaligned namespace preventing further namespace creation was
> present in all kernels up until it was finally fixed.

Well, if it was always there, then there is nothing to fix, and I
misremembered that we went backwards.

> > I otherwise agree, if the above never worked then this can all wait
> > for v5.7 upgrades.
>
> I can test specific kernel versions if that would help out.

Thanks for that offer, but outside of a clear regression I don't think
this meets -stable criteria.
