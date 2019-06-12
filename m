Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39F142217
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 12:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFLKPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 06:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfFLKPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 06:15:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A48811549;
        Wed, 12 Jun 2019 10:15:24 +0000 (UTC)
Received: from localhost (ovpn-12-46.pek2.redhat.com [10.72.12.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D64017C21;
        Wed, 12 Jun 2019 10:15:22 +0000 (UTC)
Date:   Wed, 12 Jun 2019 18:15:19 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [v5] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190612101519.GM26148@MiWiFi-R3L-srv>
References: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 12 Jun 2019 10:15:25 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/19 at 01:46pm, Sedat Dilek wrote:
> [ CC me I am not subscribed to linux-stable ML ]
> [ CC Greg and Sasha ]
> 
> Hi Baoquan,
> 
> that should be s/Fiexes/Fixes for the "Fixes tag".
> 
> OLD: Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
> for CONFIG_X86_5LEVEL=y")
> NEW: Fixes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
> for CONFIG_X86_5LEVEL=y")
> 
> Also, you can add...
> 
> Cc: stable@vger.kernel.org # v4.19+
> 
> ...to catch the below.
> 
> [ QUOTE ]
> You can see that it was added in kernel 4.17-rc1, as above. Can we just
> apply this patch to stable trees after 4.17?

Oops, I just noticed this mail today, sorry.

Boris has picked it into tip/x86/urgent. It should be in linus's tree
very soon. Appreciate your help anyway.

Thanks
Baoquan

> 
> >
> > v5.1.4: Build OK!
> > v5.0.18: Build OK!
> > v4.19.45: Build OK!
> [ /QUOTE ]
> 
> I had an early patchset of you tested (which included this one IIRC),
> so feel free to add my...
> 
>    Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> 
> Hope this lands in tip or linux-stable Git.
> 
> Thanks.
> 
> Regards,
> - Sedat -
> 
> [1] https://lore.kernel.org/patchwork/patch/1077557/
