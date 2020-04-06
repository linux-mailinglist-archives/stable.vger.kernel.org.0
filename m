Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3ED19F17C
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 10:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgDFIXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 04:23:23 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36274 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgDFIXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 04:23:23 -0400
Received: by mail-lf1-f68.google.com with SMTP id w145so11054478lff.3
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 01:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1c07BEC07UZVPJHnU0F7x86Le0JR3iWdmr6B9bHz+yQ=;
        b=a7tYuu3Tabrb7D/49u9jm9lL6eXqgnC87ZMNcPFC7Nhjk8WnjExZ5NeAav2TmLOtTW
         HVNKnRwOQthkpWpKCu2IqTs9B9uLUy+qD+ZXrkoZOQa4SdgWML5ql6jNVz6rjlMO86EM
         vko/niF41g++EhmL5P89Gaw9j9naop8nVPhfPvv8MtqRlJWkb00n0vhf1E8dnZUcusZm
         W0XWYQ8/D5jON++s/0YlrLFub6gpZD2KF1qEuyJMLJsVONTssqP7rGo/2tnCoRIGTPsr
         GLui6R61RHcd9Xb2J+Wnm2rOU8Yv+FJkmZScKBanNWvbolq/1/jbnRCD7nqBKn52Ovdp
         WDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1c07BEC07UZVPJHnU0F7x86Le0JR3iWdmr6B9bHz+yQ=;
        b=Cx7pJeMB/wLZqqr7/kXecQRw8LmGqBKp2SCFCd79wUx/FG1gBWRHgJUTRC72cd9qYc
         +d48TCXOd8WQhNQL8pwLksgLur7xHarQMgBNUkwc9nZYF4hsXhN088V25+GwIp5H1Jbz
         udPT8QfedLpwcUJ6Tc1x/+WfGZw36LDdvpyYCRuZOThTKQApimdcItJiQcyEo2aSu355
         ZE8ln/UpeClNVCTyI0Qv0UB3aUua6nTx2wtvM/8DTVp9Wlky+4+MeRnyDGw48fk16R+t
         iGU4eIF3ENBR/A6LQ5tkbNxruFZ7T4arkDMcZKX5urba1LC8fBqAttRKt2UagdvsQ6yt
         jziA==
X-Gm-Message-State: AGi0PubEG3/YUcIDq0h/Nf60NI6ENMbjXe5lb58PCBIuJhEDx2qEYmeV
        3MbLNrQsK2Nmt7M3evYVNz70lcouKKtd9kHYD6yCXw==
X-Google-Smtp-Source: APiQypJnyOYlwjP10HGdWQRrOOqzpBCTzDkFCOrs1js1rgvxGv5ZQLRUnz8Sei/ZMVu9arbIsNBG6fLhNsXR4+STv6U=
X-Received: by 2002:a19:5e46:: with SMTP id z6mr11789742lfi.74.1586161400666;
 Mon, 06 Apr 2020 01:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs1xStrrsvGbW7bc4h1a0Kjfz0_zn4c7LL7-bGZb0GH6g@mail.gmail.com>
 <20200402133849.mmkvekzx37kw4nsj@box> <CA+G9fYv0xNtnD=eBmxVqYqEoYTbMk6mdn04WmgSUasDw2L7uFg@mail.gmail.com>
 <20200403133252.ivdqoppxhc6w5b47@box> <CA+G9fYsnD0vkCpSH98Lpsi6nxXBS+JYbSPhTnNE16CrQ4s4QhQ@mail.gmail.com>
 <20200404160631.7eny3swsqn665m2p@box>
In-Reply-To: <20200404160631.7eny3swsqn665m2p@box>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 6 Apr 2020 13:53:09 +0530
Message-ID: <CA+G9fYtmSMLaqmt-OEovQxXseGqiq_HUDyq_dZZ1kSbsuNQo=Q@mail.gmail.com>
Subject: Re: mm/mremap.c : WARNING: at mm/mremap.c:211 move_page_tables+0x5b0/0x5d0
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Michal Hocko <mhocko@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 4 Apr 2020 at 21:36, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Sat, Apr 04, 2020 at 08:10:42PM +0530, Naresh Kamboju wrote:
> > On Fri, 3 Apr 2020 at 19:02, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > >
> > > On Fri, Apr 03, 2020 at 12:56:57AM +0530, Naresh Kamboju wrote:
> > > > [  734.876355] old_addr: 0xbfe00000, new_addr: 0xbfc00000, old_end: 0xc0000000
> > >
> > > The ranges are overlapping. We don't expect it. mremap(2) never does this.
> > >
> > > shift_arg_pages() only moves range downwards. It should be safe.
> > >
> > > Could you try this:
> >
> > Applied the patch and tested and still getting kernel warning.
> > CONFIG_HIGHMEM64G=y is still enabled.
> >
> > [  790.041040] ------------[ cut here ]------------
> > [  790.045664] WARNING: CPU: 3 PID: 3195 at mm/mremap.c:212
> > move_page_tables+0x7a7/0x840
>
> Are you sure the patch is applied? The line number in the warning supposed
> to change.

Yes. The patch was applied and tested.
The reason for line number change is due to linux/mmdebug.h included
because an earlier patch "dump_vma(vma);" needed this.

diff --git a/mm/mremap.c b/mm/mremap.c
index af363063ea23..cf02d4244e83 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -24,6 +24,7 @@
 #include <linux/uaccess.h>
 #include <linux/mm-arch-hooks.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/mmdebug.h>

 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -208,7 +209,7 @@ static bool move_normal_pmd(struct vm_area_struct
*vma, unsigned long old_addr,
         * The destination pmd shouldn't be established, free_pgtables()
         * should have release it.
         */
-       if (WARN_ON(!pmd_none(*new_pmd)))
+       if (WARN_ON(!pmd_none(*new_pmd) && old_addr > new_addr))
                return false;

        /*



- Naresh
