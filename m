Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8FC1C06FC
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgD3Tvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 15:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgD3Tvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 15:51:50 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6875AC035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 12:51:50 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t12so5558467edw.3
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D+FwAVJSyrEXzkxSrmCS02v7oMdKUwO+F0o4wshx4Ek=;
        b=vVUQtbBBW2Z6/5fnVMc/CHaP+nmdWUZ9QxTg9U+zXdocuJvECmz2ZYNIGKPPz6wnQ8
         Y/blY8yPzeccGFk3m1sEppcnDb2DSh0FgHkCsa362EpoiStkcCEFl/jvgV3GTQCJGqIR
         1F5ZNP+5RAyCH89lA/zS+VK58cK0uw0HhqVN63Enq4YTlK6yQyXV4DIfnL10P+OqgGw/
         HCg5266Eh5MmmWWOvAC6lE6/rve3bHhcEcgVc+Td4DD9a+Td1zEyKuOO0czcYWrzhCcT
         tvoeMJf89WE0O/M4IxIXqvfJwcRgTiFBEmYdGzxdktpJKukTKOFi25Kns4jm5Sm2dyAU
         yc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D+FwAVJSyrEXzkxSrmCS02v7oMdKUwO+F0o4wshx4Ek=;
        b=KM+mhF5BdI8uViMnKCRAlPofyqEoYubUtidvpAHUPXFa1KdEBaby1UgOYv3Zj7qMya
         XZnxiaSVYO6TQU06U0rWS8+zXbilIsaqaTPX9GHoihrKczkxR0OL4ijeMejl+vorpQlj
         gIG0D2pr5Qj/wrtyGwOdB4fwPYhYRC/4WKyZuMTt1ZDCl1FH9ls1RM2IR6OJr7SRj2De
         Pv5xGUDrYfoC2HL5TO+xP3CjXQcDxFw9bnDjN4ssUG0gpFVUjsZKwGPAMm9hni/G92ag
         g5YJdebExovcs2F+on5TMSOm6q/HAZht5N5Pse549H2fltjhqX1hp2I5nH63Idm1IfL/
         WY2A==
X-Gm-Message-State: AGi0PuYbxZd/P8BRCeDBvX7A4jC6rb+Aiud5LKfhk0PvR4iO19c/Qi6F
        /9V4VuWBKAQcA39PWaGcTd6UkeKK8yFgy/+nGrs3cQ==
X-Google-Smtp-Source: APiQypKSjYZOD7xk1KJYIgeWWnr+Sy7zH5f3yAinfHlnQz1vSgERtk1La4XpoWwZWcsoyFjvzfAAP5KPRwAA/g7JUtg=
X-Received: by 2002:aa7:c643:: with SMTP id z3mr620607edr.154.1588276309142;
 Thu, 30 Apr 2020 12:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com> <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com>
In-Reply-To: <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 30 Apr 2020 12:51:38 -0700
Message-ID: <CAPcyv4g8rA2TRvoFHqEjs5Xn74gdZx8uF0PXFYCjTcx56yA=Jw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 12:23 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> On Thu, Apr 30, 2020 at 11:42:20AM -0700, Andy Lutomirski wrote:
> > I suppose there could be a consistent naming like this:
> >
> > copy_from_user()
> > copy_to_user()
> >
> > copy_from_unchecked_kernel_address() [what probe_kernel_read() is]
> > copy_to_unchecked_kernel_address() [what probe_kernel_write() is]
> >
> > copy_from_fallible() [from a kernel address that can fail to a kernel
> > address that can't fail]
> > copy_to_fallible() [the opposite, but hopefully identical to memcpy() on x86]
> >
> > copy_from_fallible_to_user()
> > copy_from_user_to_fallible()
> >
> > These names are fairly verbose and could probably be improved.
>
> How about
>
>         try_copy_catch(void *dst, void *src, size_t count, int *fault)
>
> returns number of bytes not-copied (like copy_to_user etc).
>
> if return is not zero, "fault" tells you what type of fault
> cause the early stop (#PF, #MC).

I do like try_copy_catch() for the case when neither of the buffers
are __user (like in the pmem driver) and _copy_to_iter_fallible()
(plus all the helpers it implies) for the other cases.

copy_to_user_fallible
copy_fallible_to_page
copy_pipe_to_iter_fallible

...because the mmu-fault handling is an aspect of "_user" and fallible
implies other source fault reasons. It does leave a gap if an
architecture has a concept of a fallible write, but that seems like
something that will be handled asynchronously and not subject to this
interface.
