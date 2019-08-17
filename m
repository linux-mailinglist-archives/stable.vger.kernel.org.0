Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42215911AF
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfHQPiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 11:38:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:40440 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbfHQPiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 11:38:25 -0400
X-UUID: 0b44566e4c1d43c087cf9ec284ddc2d8-20190817
X-UUID: 0b44566e4c1d43c087cf9ec284ddc2d8-20190817
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0707 with TLS)
        with ESMTP id 1425637024; Sat, 17 Aug 2019 23:38:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Sat, 17 Aug
 2019 23:38:20 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 17 Aug 2019 23:38:20 +0800
Message-ID: <1566056298.6541.2.camel@mtkswgap22>
Subject: Re: FAILED: patch "[PATCH] mm/memcontrol.c: fix use after free in
 mem_cgroup_iter()" failed to apply to 4.14-stable tree
From:   Miles Chen <miles.chen@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <akpm@linux-foundation.org>, <cai@lca.pw>, <hannes@cmpxchg.org>,
        <mhocko@suse.com>, <stable@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <vdavydov.dev@gmail.com>
Date:   Sat, 17 Aug 2019 23:38:18 +0800
In-Reply-To: <20190817152744.GA16493@kroah.com>
References: <156594986715496@kroah.com>  <1565953640.26404.4.camel@mtkswgap22>
 <20190816153702.GA9558@kroah.com>       <1566054818.26404.11.camel@mtkswgap22>
 <20190817152744.GA16493@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2019-08-17 at 17:27 +0200, Greg KH wrote:
> On Sat, Aug 17, 2019 at 11:13:38PM +0800, Miles Chen wrote:
> > On Fri, 2019-08-16 at 17:37 +0200, Greg KH wrote:
> > > On Fri, Aug 16, 2019 at 07:07:20PM +0800, Miles Chen wrote:
> > > > On Fri, 2019-08-16 at 12:04 +0200, gregkh@linuxfoundation.org wrote:
> > > > > The patch below does not apply to the 4.14-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > > 
> > > > Hi Greg,
> > > > 
> > > > Below this the backport for 4.14
> > > 
> > > This backport, and the other 2, are all line-wrapped and the patch is
> > > corrupted and can not be applied :(
> > 
> > Sorry for that.
> > > 
> > > Can you fix up and resend?  I can take an attachment if that is what is
> > > needed here.
> > 
> > No problem. The backport patches are attached in this email.
> 
> This didn't apply either.  So I tried doing it "by hand" and it looks
> like you are not making these against the latest 4.14.y release (and
> other releases.)  The difference is in a commit that showed up in
> 4.14.58, which was released July 2018.
> 
> I'll take these as I've already fixed them up, but in the future, please
> make them against the latest version of the stable trees, not the
> "original" release that happened many years ago.
> 

Sorry for that. I'll make the patches against the latest version of
stable tree next time.

thanks for you help.

cheers,
Miles

> thanks,
> 
> greg k-h


