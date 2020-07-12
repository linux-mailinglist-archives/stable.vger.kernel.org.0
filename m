Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E52221CB9F
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 23:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgGLVtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 17:49:47 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:48406 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729249AbgGLVtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 17:49:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 4EAD8182CED28;
        Sun, 12 Jul 2020 21:49:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6691:7576:7903:8603:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21433:21627:30054:30056:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: silk82_3d001b926ee3
X-Filterd-Recvd-Size: 1701
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun, 12 Jul 2020 21:49:45 +0000 (UTC)
Message-ID: <27660a3e38af43c9e741a4dfcdec50757c32f409.camel@perches.com>
Subject: Re: [PATCH] decompress_bunzip2: fix sizeof type in start_bunzip
From:   Joe Perches <joe@perches.com>
To:     Tom Rix <trix@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        alain@knaff.lu
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Sun, 12 Jul 2020 14:49:44 -0700
In-Reply-To: <9af191c2-0f2c-7637-433a-b557a07590ca@redhat.com>
References: <20200712125952.8809-1-trix@redhat.com>
         <639c8ef5-2755-7172-fbb8-ce45c8637feb@zytor.com>
         <9af191c2-0f2c-7637-433a-b557a07590ca@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-07-12 at 08:12 -0700, Tom Rix wrote:
> On 7/12/20 6:09 AM, H. Peter Anvin wrote:
> > On 2020-07-12 05:59, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
[]
> > > So change the type in sizeof to 'unsigned int'
> > You must be kidding.
> > 
> > If you want to change it, change it to sizeof(bd->dbuf) instead, but this flag
> > is at least in my opinion a total joke. For sizeof(int) != sizeof(unsigned
> > int) is beyond bizarre, no matter how stupid the platform.
> 
> Using the actual type is more correct that using a type of the same size.

Sure.

But this hardly matters as this same type conversion
from signed to unsigned or the other way round is
_everywhere_ in the kernel.

And especially the cc of stable is unnecessary.


