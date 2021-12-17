Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6378B478EF6
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 16:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhLQPEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 10:04:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47890 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbhLQPEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 10:04:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25186B828A8
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 15:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF8FC36AE7;
        Fri, 17 Dec 2021 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639753491;
        bh=1xFubDrH4Uoq80yTbPvEc3pwI1MnkJjvFmpHYW2Eiqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wLHTOtY+2Wv8Dm+mFKGzAy/AI4MsfcDBD3bqjvSUZmZu+LoWCaCtp/dXX21yG6vs8
         C3XXjahvmKS78zzaawWyLuildbUdZTHXuP6qlyUAplwjjdrLuJZ9S4C5+8Q5v0fs2M
         mIKHUI97X8hP2Hrl4dvGFG/JOmbMCSbwjdinvNN8=
Date:   Fri, 17 Dec 2021 16:04:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ceph: fix up non-directory creation in
 SGID directories" failed to apply to 5.10-stable tree
Message-ID: <YbynEbAeWpB5A2sj@kroah.com>
References: <163974910684103@kroah.com>
 <20211217142301.a5y45b54ut3ika4v@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217142301.a5y45b54ut3ika4v@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 03:23:01PM +0100, Christian Brauner wrote:
> On Fri, Dec 17, 2021 at 02:51:46PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Oh? I just applied the patch on top of:
> 
> commit 272aedd4a305 ("Linux 5.10.87")
> 
> without any issues. Not sure what failed for you.

It fails to build :(
