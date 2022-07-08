Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA7156AF6E
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 02:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbiGHAZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 20:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiGHAZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 20:25:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA2D70E43;
        Thu,  7 Jul 2022 17:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D637CE2773;
        Fri,  8 Jul 2022 00:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60876C3411E;
        Fri,  8 Jul 2022 00:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657239929;
        bh=t8pNjd1lDTnbAj/JRWuEuOjDgFjSmhx1uzGGMa77Xsw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LZKiWaFWUQxCrwXrTL7P6W6GRUgIFF0nNvkDTobft3sQZ4xEY1BQxlVm5rypbSwHj
         hOMO8107Vk9WTzdnoVvW1yDANq0tQ23XMhyryK+KNIBqsaG5+vIXhC9d4dIeO8ujUY
         sV8863YX5jnjgaHC9pMZehnlr9+OU/RRSDuSU6Z0=
Date:   Thu, 7 Jul 2022 17:25:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     mm-commits@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Subject: Re: [merged mm-nonmm-stable]
 fs-sendfile-handles-o_nonblock-of-out_fd.patch removed from -mm tree
Message-Id: <20220707172528.4bbbdc25156447e3fc52e887@linux-foundation.org>
In-Reply-To: <CANaxB-zXrkhzXzSUjon+4Y63GPJZNvhHyc+CmN6meUvCxh8BEw@mail.gmail.com>
References: <20220513192342.7C8A0C34100@smtp.kernel.org>
        <CANaxB-zXrkhzXzSUjon+4Y63GPJZNvhHyc+CmN6meUvCxh8BEw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Jul 2022 16:13:09 -0700 Andrei Vagin <avagin@gmail.com> wrote:

> On Fri, May 13, 2022 at 12:23 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >
> > The quilt patch titled
> >      Subject: fs: sendfile handles O_NONBLOCK of out_fd
> > has been removed from the -mm tree.  Its filename was
> >      fs-sendfile-handles-o_nonblock-of-out_fd.patch
> >
> > This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Andrew, sorry for bothering you. I can't find this patch in mm-nonmm-stable
> and it has not been merged to the Linus' tree. Do I miss something?

Thanks, I'm not sure what happened there.  I'll restore it.
