Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABB89617F
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfHTNr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:47:58 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:56284 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730760AbfHTNr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:47:57 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 0C2DA1800F5A4;
        Tue, 20 Aug 2019 13:47:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:4321:5007:6117:6119:7514:7576:7901:7904:10004:10400:10848:11232:11658:11914:12043:12297:12438:12555:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30055:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: wind43_7f520299af340
X-Filterd-Recvd-Size: 1500
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue, 20 Aug 2019 13:47:54 +0000 (UTC)
Message-ID: <f155ad1a9490bd273fa9c31a9745e328b346920a.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 4.19 07/27] intel_th: Use the correct style for
 SPDX License Identifier
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue, 20 Aug 2019 06:47:53 -0700
In-Reply-To: <20190820134213.11279-7-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
         <20190820134213.11279-7-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-08-20 at 09:41 -0400, Sasha Levin wrote:
> From: Nishad Kamdar <nishadkamdar@gmail.com>
> 
> [ Upstream commit fac7b714c514fcc555541e1d6450c694b0a5f8d3 ]
> 
> This patch corrects the SPDX License Identifier style
> in header files related to Drivers for Intel(R) Trace Hub
> controller.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)

Is there a reason to backport license header changes?

I believe there is not.

