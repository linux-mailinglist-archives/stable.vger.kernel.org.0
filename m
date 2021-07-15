Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3474B3C9E95
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhGOM3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:29:51 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:51033 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237205AbhGOM3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:29:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UftPkJr_1626352015;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UftPkJr_1626352015)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 15 Jul 2021 20:26:56 +0800
Date:   Thu, 15 Jul 2021 20:26:54 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 5.4.y stable only] MIPS: fix "mipsel-linux-ld:
 decompress.c:undefined reference to `memmove'"
Message-ID: <YPApjvqvv1mhvgqt@B-P7TQMD6M-0146.local>
References: <YOglcE85xuwfD7It@kroah.com>
 <20210709132408.174206-1-hsiangkao@linux.alibaba.com>
 <YPATcUXGydBlQ+BK@kroah.com>
 <YPAaWOM1z75o21V1@B-P7TQMD6M-0146.local>
 <YPAdi8UOhyaw0eNT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YPAdi8UOhyaw0eNT@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 01:35:39PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Jul 15, 2021 at 07:22:00PM +0800, Gao Xiang wrote:
> > Hi Greg,
> > 
> > On Thu, Jul 15, 2021 at 12:52:33PM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Jul 09, 2021 at 09:24:08PM +0800, Gao Xiang wrote:
> > > > commit a510b616131f85215ba156ed67e5ed1c0701f80f upstream.
> > > 
> > > That is not what this commit id is :(
> > > 
> > > Please fix this up and be more careful.
> > 
> > That's the exact commit, the original upstream commit was named as
> > "MIPS: Add support for ZSTD-compressed kernels", which contains the
> > memmove() definition so the upstream / 5.10 LTS kernel is fine.
> > 
> > But for 5.4 LTS, we shouldn't backport the whole patch since only
> > memmove() part is needed in order to fix the build regression...
> 
> That was not obvious, and is confusing :(
> 
> Please just submit the fix and say _why_ this is not an upstream commit,
> do not attempt to emulate an upstream commit like your change did.

Ok, got it. I was confused how to handle such condition as well...
Let me resend it...

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
