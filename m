Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64B71691D
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfEGRZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:25:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39160 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGRZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:25:52 -0400
Received: by mail-io1-f66.google.com with SMTP id m7so12617391ioa.6;
        Tue, 07 May 2019 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WNM91LsYQ4Jk8pRE5BfQ7giBI1LrDmHfewasLQMdhYY=;
        b=UZLkwKDWZ/r8H5KY8fg/33/rzkBhC8rortcsHyxbj/uQouwgh3b3DDS9g6ykPyPpra
         aDFzXyc8EsTaiUrLSUywp2Yuj8/azQ3kmxsbvf9f9iz42l/apPGiv/stQXD171MNZbYn
         aRXTbtthM9+AmPyJkKyuAPS+nYUn2CxFBzMWFfHOlfh5rZShAl0z41ZRJvNYhzQ0JQ7E
         0PCQV+Un+PumHBZJ97r58/YpwZoXwUAMeMes+m0CWSTL0lPWYuLDXvxyxMScNSDkh9fh
         hr44kb4EK8811jwNm9b66Xz40Gv0a/IVVN4xSeKvHy7gCqQVZG9izL1k/slGn4/i7p4h
         frFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WNM91LsYQ4Jk8pRE5BfQ7giBI1LrDmHfewasLQMdhYY=;
        b=cc0pQUdbgUf0oPdcaPnzzScRoU65qVjz4TZ+Km+6VGOAe3qwmw6aY2sOuTcBl++BgI
         KehnLFNWWcixcOMuNbQ1nd4HMGIReUQpwPpapUvg5OENSetuTMY33+JoUTo8Kfz71NIq
         SJOBmGWFaoJ8ZAiP3KbGG5XXWO4iTVVOQgdZb4jD+eh4Ri+RXtdfAM5P37gHecKbrb4T
         nOQcLup7ZV3Y9/PJgWaLbNciPK3BBcNP9dtIJcr8z7OLeBmssTYmESM88SnuUlPcamg7
         WlbK+AJiVTwTVb7uZ4VaStw+lKG9m5RHCpeE9F4JunTYEg/iw/bxED/FccQ2mLQ2s+W6
         vLTA==
X-Gm-Message-State: APjAAAXUufpViBkfUHoVGymIj9pz7zLCMmAs1Xw0kw90Lqnjlf9UCd3g
        HONy0VwH+emevV3+xhZC2oC161z3ifCDrLrgSpk=
X-Google-Smtp-Source: APXvYqw+NPyrJL89GMAhzIt3t6zWXwhaYY9Oqkc/vWNxkqLzU5VEltblOOYuAi3nSrx7h8Vv8xifBDFUb2XsSSe0CzY=
X-Received: by 2002:a6b:6e0f:: with SMTP id d15mr794901ioh.116.1557249951555;
 Tue, 07 May 2019 10:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190507053826.31622-1-sashal@kernel.org> <20190507053826.31622-71-sashal@kernel.org>
In-Reply-To: <20190507053826.31622-71-sashal@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 7 May 2019 10:25:40 -0700
Message-ID: <CAKgT0Uf89zkZDU5d5GO-i4B4igASXWqUioWCpoTsY92V4gEWjg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 71/95] Revert "mm, memory_hotplug: initialize
 struct pages for the full memory section"
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>,
        Robert Shteynfeld <robert.shteynfeld@gmail.com>,
        stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 6, 2019 at 10:40 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Michal Hocko <mhocko@suse.com>
>
> [ Upstream commit 4aa9fc2a435abe95a1e8d7f8c7b3d6356514b37a ]
>
> This reverts commit 2830bf6f05fb3e05bc4743274b806c821807a684.
>
> The underlying assumption that one sparse section belongs into a single
> numa node doesn't hold really. Robert Shteynfeld has reported a boot
> failure. The boot log was not captured but his memory layout is as
> follows:
>
>   Early memory node ranges
>     node   1: [mem 0x0000000000001000-0x0000000000090fff]
>     node   1: [mem 0x0000000000100000-0x00000000dbdf8fff]
>     node   1: [mem 0x0000000100000000-0x0000001423ffffff]
>     node   0: [mem 0x0000001424000000-0x0000002023ffffff]
>
> This means that node0 starts in the middle of a memory section which is
> also in node1.  memmap_init_zone tries to initialize padding of a
> section even when it is outside of the given pfn range because there are
> code paths (e.g.  memory hotplug) which assume that the full worth of
> memory section is always initialized.
>
> In this particular case, though, such a range is already intialized and
> most likely already managed by the page allocator.  Scribbling over
> those pages corrupts the internal state and likely blows up when any of
> those pages gets used.
>
> Reported-by: Robert Shteynfeld <robert.shteynfeld@gmail.com>
> Fixes: 2830bf6f05fb ("mm, memory_hotplug: initialize struct pages for the full memory section")
> Cc: stable@kernel.org
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> ---
>  mm/page_alloc.c | 12 ------------
>  1 file changed, 12 deletions(-)

So it looks like you already had the revert of the earlier patch I
pointed out enqueued as well. So you can probably at a minimum just
drop this patch and the earlier patch that this reverts.

Thanks.

- Alex
