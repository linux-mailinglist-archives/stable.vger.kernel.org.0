Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017EC514519
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 11:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbiD2JKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 05:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356274AbiD2JKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 05:10:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D971EBAB84
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 02:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9998BB83393
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DE6C385A7;
        Fri, 29 Apr 2022 09:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651223234;
        bh=ErLJ+Htob2f1e5HmtrxY92HYHneSGjw/SHp3ovuCEOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NUs/HtC45nC3COLklsOIC9Q8dP++8oBQ48W/XMGJXfwkKs1+kttPIBY8Y/FWHymIj
         yn3J29PTe2LiRyuiuyfc8q61M02u8dmeE78UGaNlJ2RiDr5gyof489h2Q7q8WzIZYw
         thCcCKF+s/txUhmSJYflCP42qumwHiTZfTubv6Cg=
Date:   Fri, 29 Apr 2022 11:07:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Xiongchun duan <duanxiongchun@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] mm: kfence: fix objcgs vector allocation"
 failed to apply to 5.15-stable tree
Message-ID: <Ymuqv5O17fN8/nQE@kroah.com>
References: <165116018052255@kroah.com>
 <CAMZfGtXuQr77H2juiJTK5ZhP6tHFj4fNLDFZ82VBOfknnoa3pg@mail.gmail.com>
 <YmuPZQLKLfV3X6cW@elver.google.com>
 <CAMZfGtVOyUW0x1Hp689tV=Sr2O=H=jWRFpyJyRxVi5mHb=x8xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtVOyUW0x1Hp689tV=Sr2O=H=jWRFpyJyRxVi5mHb=x8xA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29, 2022 at 04:06:59PM +0800, Muchun Song wrote:
> On Fri, Apr 29, 2022 at 3:10 PM Marco Elver <elver@google.com> wrote:
> >
> > On Fri, Apr 29, 2022 at 12:15PM +0800, Muchun Song wrote:
> > > On Thu, Apr 28, 2022 at 11:36 PM <gregkh@linuxfoundation.org> wrote:
> > > >
> > > >
> > > > The patch below does not apply to the 5.15-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > >
> > >
> > > I have fixed all conflicts and the attachment is the new patch for 5.15.
> > >
> > > Thanks.
> >
> > I wanted to test, but unfortunately this doesn't apply to 5.15.36.
> 
> My bad. I was based on v5.15.33. I have made a new version
> for v5.15.36 (see attachment) and tested it.
> 
> Thanks.



Now queued up, thanks.

greg k-h
