Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A60D57EFD7
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiGWOxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiGWOxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:53:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BB91F629
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 07:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1590560B88
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 14:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A1C341C0;
        Sat, 23 Jul 2022 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658588029;
        bh=ioN5k9Psk69uJ3GttcBGUyDl7Q5JsdIF9Xj0T2KPA+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYCA+x51/kqsQA92xHMuPmv/NvHrOPwTjCvrBirGl8fN3gQhq1swuxr1UfOLLm9za
         D1zGUZN87CjMYMtrmpB7DUz5vCDBwlTQXZjfyVo2UnOwC+o/zM5e6ezDaMKQOjWyTS
         b7v/OKjpapkRT/UvivQSFGfr4lIWYKI/kvAfTKQM=
Date:   Sat, 23 Jul 2022 16:53:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix vm kselftest build
Message-ID: <YtwLeqSHaFP7Fl8v@kroah.com>
References: <20220715231542.2169650-1-ovt@google.com>
 <YtJHOtDQ4swTmxjf@kroah.com>
 <CACGj0Ch1wQnVp0k4EBujncGXW8UGGyprFh2ESeRt_5m2OL4FZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGj0Ch1wQnVp0k4EBujncGXW8UGGyprFh2ESeRt_5m2OL4FZg@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 16, 2022 at 11:11:02AM -0700, Oleksandr Tymoshenko wrote:
> On Fri, Jul 15, 2022 at 10:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jul 15, 2022 at 11:15:40PM +0000, Oleksandr Tymoshenko wrote:
> > > This patchset reverts duplicates of two backported commits that created
> > > exact copies of functions added by the original backports.
> > >
> > > Oleksandr Tymoshenko (2):
> > >   Revert "selftest/vm: verify remap destination address in mremap_test"
> > >   Revert "selftest/vm: verify mmap addr in mremap_test"
> > >
> > >  tools/testing/selftests/vm/mremap_test.c | 53 ------------------------
> > >  1 file changed, 53 deletions(-)
> >
> > For what stable tree(s) are you wanting these to be applied to?
> 
> 5.15, only this branch is affected

thanks, now queued up.

greg k-h
