Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3870442876
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 16:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfFLOL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 10:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbfFLOL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 10:11:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DC7E3082E71;
        Wed, 12 Jun 2019 14:11:13 +0000 (UTC)
Received: from localhost (ovpn-12-46.pek2.redhat.com [10.72.12.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80FA45D9D5;
        Wed, 12 Jun 2019 14:11:12 +0000 (UTC)
Date:   Wed, 12 Jun 2019 22:11:10 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [v5] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190612141110.GQ26148@MiWiFi-R3L-srv>
References: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
 <20190612101519.GM26148@MiWiFi-R3L-srv>
 <CA+icZUV78MPyLRie4MWa0PZ-UObpG33gmZhFfHD1rFsTqV7vnw@mail.gmail.com>
 <20190612131922.GO26148@MiWiFi-R3L-srv>
 <20190612132306.GA28802@MiWiFi-R3L-srv>
 <CA+icZUVjj=9uj77aUwJsO9haRNWWGe4xKYdyJUOscT=Dq8Y-Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVjj=9uj77aUwJsO9haRNWWGe4xKYdyJUOscT=Dq8Y-Hw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 12 Jun 2019 14:11:26 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/12/19 at 03:41pm, Sedat Dilek wrote:
> On Wed, Jun 12, 2019 at 3:23 PM Baoquan He <bhe@redhat.com> wrote:

> I have seen that the Kconfig help text [0] says...
> 
>  See Documentation/x86/x86_64/5level-paging.txt for more
>  information.
> 
> That should be s/5level-paging.txt/5level-paging.rst.
> I can send a patch if you like.

Yeah, it should be updated.

> 
> Can you look at the text of [1] - are the informations up2date?


I saw below sentence need be updated too, it should be Documentation/x86/x86_64/mm.rst.

Virtual memory layout for 5-level paging is described in
Documentation/x86/x86_64/mm.txt

> 
> 
> 
> 
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/Kconfig#n1481
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/x86/x86_64/5level-paging.rst
> 
> > > >
> > > > - Sedat -
> > > >
> > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
> > > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/x86/x86_64/5level-paging.rst
