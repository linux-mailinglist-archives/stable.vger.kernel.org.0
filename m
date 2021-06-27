Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A2E3B5415
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 17:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhF0PoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 11:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhF0PoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 11:44:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CBB3619B0;
        Sun, 27 Jun 2021 15:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624808507;
        bh=5SGoU+y+k8H7CqfP3kH0aewu9xDaBsnAwkcxzwGpK00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QnxcY1UJo2HksSVv0n/9lVrr6iWV9kGkFrHoVq4UkDrqXWWKmZv5E44BgTEbH95jV
         CkAf3mXeuDUA+UE9GWrCIIbWGq1M7V/bQmHorPx6Wih8Lbnbh/fv6MSdnFCwUwJLHM
         pH1PBssDlAk2Cfd9fktFOX61PLSfQS7+l3VzSaCyp52t8+Q39ceDv/X753j6dkDpjy
         CQJSdG3QrViJq/Rfv2fpbmNv+wwDLLUKmyNBZvsCA4xSNxABDdoTxajY7/ZrbU7mSj
         sBRq09XnCXeq+bxUBYGck1MbTlAchKvwEtAcXPWITO5nShCgRAMe/cxxYfLE4ZjgRJ
         Yqpar9TF7AQCA==
Message-ID: <460106c8619ce7575f84f6fb387453b31204185d.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix test for whether we can skip read when
 writing beyond EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, dhowells@redhat.com,
        Matthew Wilcox <willy@infradead.org>,
        Andrew W Elble <aweits@rit.edu>
Date:   Sun, 27 Jun 2021 11:41:45 -0400
In-Reply-To: <YNiJsmqZRDlFdnIa@kroah.com>
References: <20210625175951.90347-1-jlayton@kernel.org>
         <YNiJsmqZRDlFdnIa@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-06-27 at 16:22 +0200, Greg KH wrote:
> On Fri, Jun 25, 2021 at 01:59:51PM -0400, Jeff Layton wrote:
> > commit 827a746f405d upstream.
> 
> No it is not :(
> 
> Please fix this up and resend it with the correct git id.
> 
> thanks,
> 

Are you sure?

    $ git log --oneline origin/master -- fs/netfs
    827a746f405d (tag: netfs-fixes-20210621, dhowells/afs-fixes) netfs: fix test for whether we can skip read when writing beyond EOF

"origin" is Linus' tree. I'm not sure what I'm doing wrong otherwise.
-- 
Jeff Layton <jlayton@kernel.org>

