Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4002AA635
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgKGP1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgKGP1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 10:27:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58656206DB;
        Sat,  7 Nov 2020 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604762829;
        bh=6Bq8EHuIomKuRGgfa0yZE8F54A0Q+B1436WODP+gmb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=urUtYz0IGkZqgUO+3r5uOHIKcM57dW0mvpqAqtrRUrqpVt6gsuNKz6O2QFQ4iBTsb
         Pfuuoj+h5iBPXvNKEVkPziuwsZ09Y9hY1zbBu3OMtSg8LanY6zYCjZN5Bvjc4/npy5
         u3e3zoeIrxMqC4yuOPoqGrQpcWj2eIaBfs11mgFk=
Date:   Sat, 7 Nov 2020 16:27:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org
Subject: Re: [4.19] Security fixes (blktrace, btrfs)
Message-ID: <20201107152714.GA71608@kroah.com>
References: <9b242dcfb11f8d2106c4f8efe72b982d70b351c3.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b242dcfb11f8d2106c4f8efe72b982d70b351c3.camel@codethink.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 12:13:24AM +0000, Ben Hutchings wrote:
> Here are backports of some fixes to the 4.19 stable branch.
> 
> I tested the blktrace fix with the script referenced in the commit
> message.
> 
> I tested the btrfs changes with the reproducers for CVE-2019-19039,
> CVE-2019-19377, and CVE-2019-19816, and checked for regressions with
> xfstests.

Thanks so much for these, all now queued up.

greg k-h
