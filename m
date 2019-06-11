Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FBB3CA2D
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 13:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389817AbfFKLjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 07:39:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:31374 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389464AbfFKLjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 07:39:46 -0400
X-UUID: c27faa6a4e3246578445f37629f642cb-20190611
X-UUID: c27faa6a4e3246578445f37629f642cb-20190611
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 18765715; Tue, 11 Jun 2019 19:39:34 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 11 Jun
 2019 19:39:32 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 11 Jun 2019 19:39:32 +0800
Message-ID: <1560253172.2479.12.camel@mtkswgap22>
Subject: Re: backport commit ("739f79fc9db1 mm: memcontrol: fix NULL pointer
 crash in test_clear_page_writeback()") to linux-4.9-stable
From:   Miles Chen <miles.chen@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        Vladimir Davydov <vdavydov@virtuozzo.com>,
        Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bradley Bolen <bradleybolen@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Jun 2019 19:39:32 +0800
In-Reply-To: <20190611111817.GA12260@kroah.com>
References: <1560243467.26425.8.camel@mtkswgap22>
         <20190611103407.GA3486@kroah.com> <20190611111817.GA12260@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-06-11 at 13:18 +0200, Greg KH wrote:
> On Tue, Jun 11, 2019 at 12:34:07PM +0200, Greg KH wrote:
> > On Tue, Jun 11, 2019 at 04:57:47PM +0800, Miles Chen wrote:
> > > Hi reviewers,
> > > 
> > > I suggest to backport commit "739f79fc9db1 mm: memcontrol: fix NULL
> > > pointer crash in test_clear_page_writeback()" to linux-4.9 stable tree.
> > > 
> > > This email reports a NULL pointer crash in test_clear_page_writeback()
> > > in android common kernel-4.9. There is a fix ("739f79fc9db1 mm:
> > > memcontrol: fix NULL pointer crash in test_clear_page_writeback()") in
> > > kernel-4.13.
> > > 
> > > 
> > > commit: 739f79fc9db1b38f96b5a5109b247a650fbebf6d
> > > subject: mm: memcontrol: fix NULL pointer crash in
> > > test_clear_page_writeback()
> > > kernel version to apply to: Linux-4.9
> > 
> > It does not apply cleanly to the 4.9.y tree, can you provide a working
> > backport of it that I can apply?

thanks for the fast reply:
Sorry I do not have a working backport now. 
I tried to find the correct patchset but failed.

> 
> Also be sure to cc: all of the people involved in that patch (the author
> and the cc and signed-off-by list) so they can weigh in if they do not
> feel that this patch should be backported to the older kernel.

Thanks for the remainder. 
Add all of the people involved in the patch to the cc list.

> 
> thanks,
> 
> greg k-h


