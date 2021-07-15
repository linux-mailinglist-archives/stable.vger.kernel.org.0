Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81A53CA57A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhGOSZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238268AbhGOSZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28095613CA;
        Thu, 15 Jul 2021 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626373330;
        bh=5wUFyx8ibPcFTxhFLfL1FGFltOrr8ZfBQjNHOv+jXfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l4G6XhCF2HkLVOSr8xnLXYDueGOuAGmm26TPFZ69U5PGQDMYJlmibzPZ6OfU6LXuJ
         n06SaHgyU4KGuiJm8aMOe04tUNU2BWmkKJLK2BbyTv+huVecxMk/jBeuatY/erpmXA
         0jgMLRHyJpIrdrEY5eifyloEGqlpIcbYSk2pT83Y=
Date:   Thu, 15 Jul 2021 11:22:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     Dmitriy Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: + kfence-skip-all-gfp_zonemask-allocations.patch added to -mm
 tree
Message-Id: <20210715112209.cf9dc6fdd27320f8d0eb5ac3@linux-foundation.org>
In-Reply-To: <CAG_fn=U1U2b4Q_rvT8MzkdaAW0cqWkEyjmeE2BiZE=vymEKe9w@mail.gmail.com>
References: <20210714224225.Gmo7sht2E%akpm@linux-foundation.org>
        <CAG_fn=U1U2b4Q_rvT8MzkdaAW0cqWkEyjmeE2BiZE=vymEKe9w@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 15:51:30 +0200 Alexander Potapenko <glider@google.com> wrote:

> On Thu, Jul 15, 2021 at 12:42 AM <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: kfence: skip all GFP_ZONEMASK allocations
> > has been added to the -mm tree.  Its filename is
> >      kfence-skip-all-gfp_zonemask-allocations.patch
> >
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch
> 
> Hi Andrew,
> 
> mmotm and mmots were last updated on 2021-06-25, did some automation break?

This happens after -rc1.  I'm in the process of going through all the
material which was sent along too late for 5.14.  And mainline & -next
tend to be a bit chaotic at this point, so it's a decent time to just
sit and wait for the dust to settle.  Hopefully I'll be able to push
something out later today.

