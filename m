Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A7247FCAF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhL0Mid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:38:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38018 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbhL0Mid (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:38:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6BE560FFE
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0172CC36AEA;
        Mon, 27 Dec 2021 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640608712;
        bh=hBAFBrI9NghNerhh+HT3k3RahVvoTE7lotKtEz2TLcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xSThXDUxPzN94XQd8euwL5vz3nA4v5d99tY5Kxvh+RxmMGDgpHzWQ2nUVulqUZE5y
         vsqgd4qkMlgnfpdtveEHh2U3CJHb789VrAunybANMZxlwUyxHEIarztWYTJkziw5IH
         3kUjb3Hzl2iBYEyuID1ZDl0CI+QSr0jXPMq50bJM=
Date:   Mon, 27 Dec 2021 13:38:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     stable@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH for 5.15.y stable] netfs: fix parameter of cleanup()
Message-ID: <YcmzxZUUFGCJX1aW@kroah.com>
References: <163913443334205@kroah.com>
 <20211224035243.56554-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224035243.56554-1-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 24, 2021 at 11:52:43AM +0800, Jeffle Xu wrote:
> commit 3cfef1b612e15a0c2f5b1c9d3f3f31ad72d56fcd upstream.
> 
> The order of these two parameters is just reversed. gcc didn't warn on
> that, probably because 'void *' can be converted from or to other
> pointer types without warning.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3d3c95046742 ("netfs: Provide readahead and readpage netfs helpers")
> Fixes: e1b1240c1ff5 ("netfs: Add write_begin helper")
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>
> Link: https://lore.kernel.org/r/20211207031449.100510-1-jefflexu@linux.alibaba.com/ # v1
> ---
>  fs/netfs/read_helper.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Now queued up, thanks,

greg k-h
