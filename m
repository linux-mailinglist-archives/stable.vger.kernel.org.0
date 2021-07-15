Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326AD3C9D4B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhGOKzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232055AbhGOKzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 06:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDEF76120A;
        Thu, 15 Jul 2021 10:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626346359;
        bh=11ld29xAx7JtXcxWIBlUIkNU9VAZzciasgbP8B4vqMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hZmQL1iM4aeIxzSRA1jCMJwqn8IS77rj/SWwPHxn9M1IsBztluZBkXVZ548Gl2cdA
         IvLb3CCwyWKdCp2iUF/aQX571mjUQMztzm7V+zwkQwNyXtDx/9ZXRngxyVJj//bKW5
         6a5bk/cxNmJhtOlmZLO4KZVpFCQ5rnbfc0pSaB/c=
Date:   Thu, 15 Jul 2021 12:52:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     stable <stable@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 5.4.y stable only] MIPS: fix "mipsel-linux-ld:
 decompress.c:undefined reference to `memmove'"
Message-ID: <YPATcUXGydBlQ+BK@kroah.com>
References: <YOglcE85xuwfD7It@kroah.com>
 <20210709132408.174206-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709132408.174206-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 09:24:08PM +0800, Gao Xiang wrote:
> commit a510b616131f85215ba156ed67e5ed1c0701f80f upstream.

That is not what this commit id is :(

Please fix this up and be more careful.

thanks,

greg k-h
