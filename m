Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BB5EBA00
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 23:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfJaWxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 18:53:35 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:43479 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbfJaWxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 18:53:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id F01BB837F24D;
        Thu, 31 Oct 2019 22:53:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:3874:4321:4425:5007:6119:6120:7901:7903:10004:10400:10848:11232:11473:11658:11914:12048:12296:12297:12555:12740:12760:12895:13069:13160:13229:13255:13311:13357:13439:14096:14097:14180:14659:14721:21080:21212:21451:21627:30054:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: pipe73_3c057c4d0b128
X-Filterd-Recvd-Size: 2331
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu, 31 Oct 2019 22:53:32 +0000 (UTC)
Message-ID: <3078d0a186cca2dfae741908ffff41f1bdb30eae.camel@perches.com>
Subject: Re: [PATCH 3.16 47/47] KVM: x86/vPMU: refine kvm_pmu err msg when
 event creation failed
From:   Joe Perches <joe@perches.com>
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Oct 2019 15:53:23 -0700
In-Reply-To: <05be6a70382f1990a2ba6aba9ac75dac0c55f7fb.camel@decadent.org.uk>
References: <lsq.1572026582.631294584@decadent.org.uk>
         <220d8f2c1b299d2e71fdcf50b98286aae5b0c6f2.camel@perches.com>
         <05be6a70382f1990a2ba6aba9ac75dac0c55f7fb.camel@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-10-31 at 22:14 +0000, Ben Hutchings wrote:
> On Fri, 2019-10-25 at 12:05 -0700, Joe Perches wrote:
> > On Fri, 2019-10-25 at 19:03 +0100, Ben Hutchings wrote:
> > > 3.16.76-rc1 review patch.  If anyone has any objections, please let me know.
> > 
> > This seems more like an enhancement than a bug fix.
> > 
> > Is this really the type of patch that is appropriate
> > for stable?
> 
> Apparently so:
> 
> v4.14.135: eba797dbf352 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
> v4.19.61: ba27a25df6df KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
> v4.4.187: 505c011f9f53 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
> v4.9.187: 3984eae04473 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
> v5.1.20: edadec197fbf KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
> v5.2.3: 9f062aef7356 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

I think not, but hey, maybe you and Greg do.

Porting enhancements, even trivial ones, imo is
not a great thing for stable branches.

My perspective is that only bug fixes should be
applied to stable branches.

cheers, Joe

