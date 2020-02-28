Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1DE173F31
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 19:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgB1SIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 13:08:21 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:57186 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725730AbgB1SIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 13:08:21 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 8F291837F24A;
        Fri, 28 Feb 2020 18:08:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:4385:5007:6119:7514:7576:7903:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13255:13311:13357:13439:13618:14181:14659:14721:21080:21451:21611:21627:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: lunch56_2b73572b6e63e
X-Filterd-Recvd-Size: 1764
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Fri, 28 Feb 2020 18:08:18 +0000 (UTC)
Message-ID: <a81f6072c8adfc5343fbc249f355c9ea5ced698e.camel@perches.com>
Subject: Re: [PATCH 4.14 111/237] tty: synclinkmp: Adjust indentation in
 several functions
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Fri, 28 Feb 2020 10:06:45 -0800
In-Reply-To: <20200228071239.GC2895159@kroah.com>
References: <20200227132255.285644406@linuxfoundation.org>
         <20200227132305.054909944@linuxfoundation.org>
         <11c17de7c525997ddddab995223828bdec8e8e93.camel@perches.com>
         <20200228071239.GC2895159@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-02-28 at 08:12 +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 27, 2020 at 07:55:49PM -0800, Joe Perches wrote:
> > On Thu, 2020-02-27 at 14:35 +0100, Greg Kroah-Hartman wrote:
> > > From: Nathan Chancellor <natechancellor@gmail.com>
> > 
> > I believe these sorts of whitespace only changes should
> > not be applied to a stable branch unless it's useful for
> > porting other actual defect fixes.
> 
> I want to get clang build warnings down to the same level that gcc build
> warnings are, so that they become useful in detecting new issues.  That
> is why I add these types of patches to the stable trees.

New issues should be found in the current kernel.
Backporting whitespace changes is value-free.


