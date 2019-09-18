Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB12B6219
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 13:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbfIRLKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 07:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbfIRLKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 07:10:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4378920644;
        Wed, 18 Sep 2019 11:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568805039;
        bh=rPqceDwqfp7kCokNreSth0gVwsFRJq6QSPVbFP1Ds+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rj61/XI4CEaBb30YbJCZ224KbQr0NeBRoSqXnHF8oU4Mvu8H8RIMpdGQz1N1K17s2
         g3KKOYDelNwChDHwTpUKQ98Mc7Y7LSRzvQzCCyGXYkAsuDGKvjYYMfZAB6I960xcn5
         15xPZJn+MAsOMrnB+//K3rkVAQeIJd39Q3AeDSV0=
Date:   Wed, 18 Sep 2019 13:10:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: Stable branches missing ed7a01fd3fd7
Message-ID: <20190918111037.GE1894362@kroah.com>
References: <880A1006-BF84-4691-8EE1-8E6D111BF09F@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <880A1006-BF84-4691-8EE1-8E6D111BF09F@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 11:17:59AM +0200, Håkon Bugge wrote:
> Hi Greg,
> 
> 
> Commit 00313983cda6 ("RDMA/nldev: provide detailed CM_ID information") is in the following stable releases:
> 
>   stable/linux-4.17.y
>   stable/linux-4.18.y
>   stable/linux-4.19.y
>   stable/linux-4.20.y
>   stable/linux-5.0.y
>   stable/linux-5.1.y
>   stable/linux-5.2.y
>   stable/linux-5.3.y
>   stable/master

It was part of the 4.17 release, so yes, of course it is in all later
releases.

> It has a potential for a big leak of task_struct's, and if the case is hit, the number of task_struct entries in /proc/slabinfo increases rapidly.
> 
> The fix, ed7a01fd3fd7 ("RDMA/restrack: Release task struct which was hold by CM_ID object"), is in the following stable releases:
> 
>   stable/linux-4.20.y
>   stable/linux-5.0.y
>   stable/linux-5.1.y
>   stable/linux-5.2.y
>   stable/linux-5.3.y
>   stable/master

It was part of the 4.20 release, so yes, it will be in all releases
newer than that.

> Hence, this commit needs to be included in 4-17..4.19.

Given there is only one "active" kernel branch you are looking at here,
that means it should only go into 4.19.y, right?

thanks,

greg k-h
