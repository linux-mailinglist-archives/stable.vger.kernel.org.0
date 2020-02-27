Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F54172240
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 16:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgB0P2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 10:28:48 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:38965 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729174AbgB0P2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 10:28:48 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 10:28:47 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id BC2E8180C44AC
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 15:22:08 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id F3FBA181F9334;
        Thu, 27 Feb 2020 15:22:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6642:7576:7653:10004:10400:10848:11232:11658:11914:12043:12297:12438:12555:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21451:21611:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: coal17_868b39358c95e
X-Filterd-Recvd-Size: 1511
Received: from XPS-9350 (47-209-22-207.mmlkcmtc01.res.dyn.suddenlink.net [47.209.22.207])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Thu, 27 Feb 2020 15:22:04 +0000 (UTC)
Message-ID: <dd96f64a5fd44278e48a1f7ee9269c485278d183.camel@perches.com>
Subject: Re: [PATCH 5.5 133/150] scripts/get_maintainer.pl: deprioritize old
 Fixes: addresses
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Feb 2020 07:20:32 -0800
In-Reply-To: <20200227132252.076691216@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
         <20200227132252.076691216@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-27 at 14:37 +0100, Greg Kroah-Hartman wrote:
> From: Douglas Anderson <dianders@chromium.org>
> 
> commit 0ef82fcefb99300ede6f4d38a8100845b2dc8e30 upstream.

I think adding just about any checkpatch patch to stable a bit silly.
Including patches to checkpatch.


