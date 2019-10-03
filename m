Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D620CA0E8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJCPJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:09:59 -0400
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:56052 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbfJCPJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 11:09:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 6981318225E03;
        Thu,  3 Oct 2019 15:09:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:4425:5007:7903:7974:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13255:13311:13357:13439:14096:14097:14659:14777:21080:21325:21433:21611:21627:21819:21939:30022:30054:30083:30091,0,RBL:47.151.152.152:@perches.com:.lbl8.mailshell.net-62.14.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: move54_39a3222fc933b
X-Filterd-Recvd-Size: 1870
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Thu,  3 Oct 2019 15:09:55 +0000 (UTC)
Message-ID: <de5e7cd39ce661f8441fb4f5bdf21ee37ada1366.camel@perches.com>
Subject: Re: [PATCH 3.16 29/87] staging: iio: cdc: Don't put an else right
 after a return
From:   Joe Perches <joe@perches.com>
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <3fe1cd65a7860464d3780b57c734d12880df4b92.camel@decadent.org.uk>
References: <lsq.1570043211.136218297@decadent.org.uk>
         <6436567dd141e5528a5363dd3aaad21815a1c111.camel@perches.com>
         <3fe1cd65a7860464d3780b57c734d12880df4b92.camel@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Thu, 03 Oct 2019 08:09:05 -0700
User-Agent: Evolution 3.32.1-2 
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-10-03 at 15:47 +0100, Ben Hutchings wrote:
> On Wed, 2019-10-02 at 14:36 -0700, Joe Perches wrote:
> > On Wed, 2019-10-02 at 20:06 +0100, Ben Hutchings wrote:
> > > 3.16.75-rc1 review patch.  If anyone has any objections, please let me know.
> > 
> > This doesn't look necessary.
> 
> It allows the next patch to apply cleanly.

Perhaps when you pick patches that are unnecessary
for any other reason but to allow easier picking of
actual fixes, the nominal unnecessary patches could
be marked as necessary for follow-on patches.

Also, when you send these patch series, please use
an email delay of at least 1 second between each
entry in the series as the threading is otherwise
poor in various email clients when sorting by time.


