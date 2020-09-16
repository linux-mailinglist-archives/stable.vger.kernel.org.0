Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF226C896
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbgIPSxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 14:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgIPSHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 14:07:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4725FC004595
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 07:10:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i26so10517722ejb.12
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 07:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+S2CSyUrJOoSBKBPReWtWulZnnCfEKHUy+NnngyRef0=;
        b=dluw97T9kNaX3w4wxi7TgvZQVAz5KYKgo6ZXUd3RC+AdiNAUw5smK7MJsd9wsco4x0
         jBJ/ZnbEIoIQNGHmT7flOg6+78EP6vH9RDSWELcntd9a9EPWUMbNfqMuQLRfC/il9Vh/
         zNSNUpaQ74kW1dUXfkkuS9duSQXZYPxJ9OwDejpX+YSrP4vRN2nZ6XfHSqYlMgtNjpga
         TpZ4coX0MP+aR5+kPLY2mxqiTGGa+GqtwjEGzceCzCl6zly9hdhqJGOZDoxAnUPpMQWN
         B65Hjbn7qEMzSwOH6gA8OhzN835jVlgNbQygO1p2e7I3mSakhrJYP8lgZwLgPQb+opa3
         LZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+S2CSyUrJOoSBKBPReWtWulZnnCfEKHUy+NnngyRef0=;
        b=odxOy5lxtwyITwWJUfKfBCK5LtbdpbelSCEsXdtQ3nwFwKv7Mvq7LDs6q2zQrtyjDl
         o0Z3rTa2US3onlLWMxzFgSMwuEsfo0HD+ly2HGmbdX5iF7j1WqSQvxFSECu6Y2P19hp4
         D8qVBgOBggIKGv6eBVlsyo2paXuxd+/jUuDOYqs/GEW95VyMyk2qiFc0m6eRSDPyeLHl
         YKTo69fVirGmjnbJEbFMBACB1wtF8AGTBgC0mG7YieO/PASlfpkdVUYlfj22eVGKscNS
         GwkZGuuSxafhnlsfwf5lF73DqPs/7DitWC8xAYQGhkl+PNhGFeSJpw/u2RTK40VlCHlu
         SGlQ==
X-Gm-Message-State: AOAM533qf5/aWvniDJgiL230CSfz3IxwSjdEfH88WfwAfcd2FO6VBnSB
        00FDlZp/1OqlQTa45PFAIA1cwZyN04wBu6uit7NKNg==
X-Google-Smtp-Source: ABdhPJx2NzetNWtREp5DWWS4b530PRluwUjIRG1OMEZ86H/MG5LysfSoTioHzg3z9mZQBMl49b7e4Qhq5E9iVAG7qtw=
X-Received: by 2002:a17:906:d787:: with SMTP id pj7mr24536109ejb.340.1600265428812;
 Wed, 16 Sep 2020 07:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200916000948.N0vvr%akpm@linux-foundation.org> <20200916073345.GC18998@dhcp22.suse.cz>
In-Reply-To: <20200916073345.GC18998@dhcp22.suse.cz>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 16 Sep 2020 10:09:52 -0400
Message-ID: <CA+CK2bBSOQYbWjJZAHTFBwzcp4=h1X9Yd5rFj4hWxt97kzp8kw@mail.gmail.com>
Subject: Re: + mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch
 added to -mm tree
To:     Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Allen Pais <apais@microsoft.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vijay Balakrishna <vijayb@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 3:33 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 15-09-20 17:09:48, Andrew Morton wrote:
> > From: Vijay Balakrishna <vijayb@linux.microsoft.com>
> > Subject: mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged
> >
> > When memory is hotplug added or removed the min_free_kbytes must be
> > recalculated based on what is expected by khugepaged.  Currently after
> > hotplug, min_free_kbytes will be set to a lower default and higher default
> > set when THP enabled is lost.  This leaves the system with small
> > min_free_kbytes which isn't suitable for systems especially with network
> > intensive loads.  Typical failure symptoms include HW WATCHDOG reset, soft
> > lockup hang notices, NETDEVICE WATCHDOG timeouts, and OOM process kills.
> >
> > Link: https://lkml.kernel.org/r/1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com
> > Fixes: f000565adb77 ("thp: set recommended min free kbytes")
> > Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
> > Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> > Cc: Allen Pais <apais@microsoft.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> The patch has been explicitly nacked by Kirill IIRC.

Hi Michal,

You are correct it was NAK by Kirill because of this:
"NAK. It would override min_free_kbytes set by user."

I do not see a problem with that because during boot we are doing
exactly that: if the user sets unreasonably small min_free_kbytes we
overwrite it and print a message about it. Kirill could you please
comment on this?
IMO the hot-add behaviour must be exactly the same as during boot.

I am also not happy
> about it because the changelog doesn't really explain the problem and
> the follow up discussion didn't drill down to the underlying problem
> either.
>
> Maybe we want to make the min_free_kbytes udpate consistent with the
> boot but the current changelog is incomplete and this shouldn't have
> been added yet.
>

Yes, what Vijay should do is to remove all the irrelevant information
from the commit log, and only state the actual problem that he found
which is min_free_kbytes is not being updated during the memory
hotplug. I think the OOMs and timeouts should be covered in a
different discussion.

Thank you,
Pasha
