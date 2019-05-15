Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082AD1E6BF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 03:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfEOBsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 21:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfEOBsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 21:48:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B58EDC057E65;
        Wed, 15 May 2019 01:48:04 +0000 (UTC)
Received: from localhost (ovpn-116-111.sin2.redhat.com [10.67.116.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1894D5D6A6;
        Wed, 15 May 2019 01:48:03 +0000 (UTC)
Date:   Wed, 15 May 2019 09:48:01 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@kernel.org, hpa@zytor.com, kirill.shutemov@linux.intel.com,
        keescook@chromium.org
Subject: Re: [PATCH v4] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190515014801.GE16774@MiWiFi-R3L-srv>
References: <20190508080417.15074-1-bhe@redhat.com>
 <20190508082418.GC24922@MiWiFi-R3L-srv>
 <20190508090424.GA19015@zn.tnic>
 <20190508093520.GD24922@MiWiFi-R3L-srv>
 <20190508144739.we4owbvjmjisium5@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144739.we4owbvjmjisium5@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 15 May 2019 01:48:04 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/08/19 at 05:47pm, Kirill A. Shutemov wrote:
> On Wed, May 08, 2019 at 05:35:20PM +0800, Baoquan He wrote:
> > On 05/08/19 at 11:04am, Borislav Petkov wrote:
> > > On Wed, May 08, 2019 at 04:24:18PM +0800, Baoquan He wrote:
> > > > I think this's worth noticing stable tree:
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > 
> > > Fixes: ?
> > 
> > Not sure which commit validated 5-level.
> > 
> > Hi Kirill,
> > 
> > Is this commit OK?
> > 
> > Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic for CONFIG_X86_5LEVEL=y")
> 
> Yep.

Thanks for confirming, will use it to update patch.
