Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16093491A6
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhCYMMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhCYMMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C8AF619F3;
        Thu, 25 Mar 2021 12:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674326;
        bh=o6VejeF+tGS3d0ADVI0Qgn3eR8ej4UZ1y1yoQx65B2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=knCT2shG+32O0nJcRgevphGonuGbKK1EHeLJ58GV/AXOM8IIhXDRVliMvjSm1WIAW
         Bhy4uyaPOgJj39Qh7yPhaF8yRN+d1GwAB6Ecx56p/meQFFKlgGQB37S48lxrn8fSwY
         IWGWYhUUWgHM8/uA1DyopGy/5ewTWqepdUWyD96Y=
Date:   Thu, 25 Mar 2021 13:12:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     zhouguanghui1@huawei.com, akpm@linux-foundation.org,
        chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ziy@nvidia.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm/memcg: rename
 mem_cgroup_split_huge_fixup to" failed to apply to 5.10-stable tree
Message-ID: <YFx+FPkRkhocBnus@kroah.com>
References: <1615798405152241@kroah.com>
 <alpine.LSU.2.11.2103241424450.8948@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2103241424450.8948@eggly.anvils>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 02:37:59PM -0700, Hugh Dickins wrote:
> On Mon, 15 Mar 2021, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Fixed-up version below: this should be the first of the two patches (if
> the other goes first, as happened for 5.11, I believe its build breaks).

Both patches now queued up, thanks!

greg k-h
