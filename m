Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81403D4893
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 18:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGXPnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 11:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGXPnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Jul 2021 11:43:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EAFC061575;
        Sat, 24 Jul 2021 09:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UdKbYcMBZylcrRBVcQRb8LlJpC27Qlfh0Nw1vs/Gwg0=; b=cqmb2WZM0kG49hKRcejfxgDd1m
        gg5Tf9URvWsomrRWIClBSDVXqzWwIov6bg2Z2xToDG3TJUHNBeILYodDfGmy3/e64idGeRewF+ZM+
        7qTBZC+VDNVnS4sBZzoRihTgCI/+dRXLPuu9EXiBsqW/QbqiNYAuAaxkV/y+15uqKXd/iCsf98UMl
        CFIAakZnIlDNhtq6h+8k7j3O+I3SYBmcY4Eq0BBaHITLyrUrRGYKTqdDClwM8EHqnAIrSPbMiNtZF
        d00myIoTQfoscRiS1SHwtPgJ32OtQbckZJuSVKCuqW0JQkRQ2MURm5RIoiNPEudbzrWO4NdcVKm3D
        u9IIUX9w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7KR8-00CO3a-5N; Sat, 24 Jul 2021 16:23:40 +0000
Date:   Sat, 24 Jul 2021 17:23:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        chaitanya.kulkarni@wdc.com, ira.weiny@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 06/15] mm: call flush_dcache_page() in memcpy_to_page()
 and memzero_page()
Message-ID: <YPw+im91HBhFK6fd@casper.infradead.org>
References: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
 <20210723225017.xFO0jZesP%akpm@linux-foundation.org>
 <20210724065954.GA2505@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210724065954.GA2505@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 24, 2021 at 08:59:54AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 23, 2021 at 03:50:17PM -0700, Andrew Morton wrote:
> > one used the PC floppy dr\u0456ver, the aha1542 driver for an ISA SCSI
> 
> Looks like I produced some messed up utf8 chars again - the above garbage
> should read "driver" of course.

I went back and looked it up, and you did indeed manage to type:

U+0456 CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I character (&#x0456;)

It's on the list:
http://www.unicode.org/Public/security/revision-05/confusables.txt

Maybe someone could do something with that file to prevent the
confusables from slipping in when unwanted?
