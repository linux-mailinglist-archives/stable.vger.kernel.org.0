Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F3D475920
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 13:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhLOMyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 07:54:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43968 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhLOMyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 07:54:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B03DEB817E2;
        Wed, 15 Dec 2021 12:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1CCC34605;
        Wed, 15 Dec 2021 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639572875;
        bh=sDAdKAEWoKymaU21bL9bOk0WN3gSE+kY6EqkVtUA720=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ShgL11Oa0oixb+6a4yve3OYKiVghK7lFd7Gz/4APwtylGpB7fFj6ByFlk4fe5z7Ac
         j0JB5fHBA9pQP7VewcqE1SvJ8fySidL5kgrLiDSbkubnxkzzRzaZYrQXYEDe1JFp+c
         x4h/VTEwMcPEG/oopKYDHN2uiFYGjtss4ow8KvAw=
Date:   Wed, 15 Dec 2021 13:54:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Carel Si <beibei.si@intel.com>, Jann Horn <jannh@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        kernel test robot <lkp@intel.com>, fengwei.yin@intel.com,
        stable <stable@vger.kernel.org>
Subject: Re: [LKP] Re: [fget] 054aa8d439: will-it-scale.per_thread_ops -5.7%
 regression
Message-ID: <Ybnlic4KUznysQvl@kroah.com>
References: <20211210053743.GA36420@xsang-OptiPlex-9020>
 <CAHk-=wgxd2DqzM3PAsFmzJDHFggxg7ODTQxfJoGCRDbjgMm8nA@mail.gmail.com>
 <CAG48ez1pnatAB095dnbrn9LbuQe4+ENwh-WEW36pM40ozhpruw@mail.gmail.com>
 <CAHk-=wg1uxUTmdEYgTcxWGQ-s6vb_V_Jux+Z+qwoAcVGkCTDYA@mail.gmail.com>
 <CAHk-=wh5iFv1MOx6r8zyGYkYGfgfxqcPSrUDwfuOCdis+VR+BQ@mail.gmail.com>
 <20211213083154.GA20853@linux.intel.com>
 <CAHk-=wjsTk2jym66RYkK9kuq8zOXTd2bWPiOq43-iCF6Qy-xQQ@mail.gmail.com>
 <CAHk-=whoMGTAAyah0jH+rHyAXCLnxAHu8KffrR8PrAXGhTxRdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whoMGTAAyah0jH+rHyAXCLnxAHu8KffrR8PrAXGhTxRdA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 11:44:31AM -0800, Linus Torvalds wrote:
> On Mon, Dec 13, 2021 at 10:37 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So I'll just apply the patch. Thanks for the report and the testing
> 
> Done, it's commit e386dfc56f83 ("fget: clarify and improve
> __fget_files() implementation") in my tree now.
> 
> I didn't mark it as "Fixes:" or for stable, because I can't imagine
> that it matters in real life.
> 
> But then it  struck me that Greg has mentioned that he ends up getting
> a lot of performance regression reports for people testing stable and
> they can be distracting.
> 
> So I'm adding a stable cc here just so people are aware of this as a
> "yeah, will-it-scale.poll2 performance regression has been reported,
> has a fix available if somebody cares".

Thanks, I'll keep an eye on this.

greg k-h
