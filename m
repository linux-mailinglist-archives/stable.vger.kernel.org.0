Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1544725015C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgHXPnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgHXPh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 11:37:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C59920866;
        Mon, 24 Aug 2020 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598283475;
        bh=/FLQGPNihRgUzCMuWceWJqcQ7JwsYoFqRHQ31NibAt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSE6t9BzN9VILdf0Ss+Hl8LkVU/0+tKXQNpTYe3NLtuonDEZa0rRNiPYyj3HYRRm5
         kwNn63LW3PyvW+kdizD3KZu28C308WNzSyKOaMU4hRwPlhccAluBgOMiC2jz1PX2I1
         TdeObO90uUKh4MYdNWcYtm6WuMucVxIsHF01+E/0=
Date:   Mon, 24 Aug 2020 17:38:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ritesh Harjani <riteshh@linux.ibm.com>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4.9 15/39] jbd2: add the missing unlock_buffer() in the
 error path of jbd2_write_superblock()
Message-ID: <20200824153811.GC435319@kroah.com>
References: <20200824082348.445866152@linuxfoundation.org>
 <20200824082349.270439673@linuxfoundation.org>
 <72009693-6c2a-df4f-f93a-31b5924e7790@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72009693-6c2a-df4f-f93a-31b5924e7790@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 07:15:25PM +0800, zhangyi (F) wrote:
> Hi，Greg
> 
> The problem this patch want to fix only exists on the kernel both
> 538bcaa6261b and 742b06b5628f these two upstream patches were merged,
> but 538bcaa6261b was not merged to 4.9, so we don't need this patch
> for 4.9.

Ok, thanks, but that wasn't obvious at all :)

I'll go drop this from 4.9.y now...

greg k-h
