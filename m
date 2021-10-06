Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86288424A1A
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 00:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhJFWt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 18:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhJFWtx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 18:49:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F8561037;
        Wed,  6 Oct 2021 22:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633560480;
        bh=F0iFmN8HMCbHfc8zV069WQt6cMrOBGXBX+/W4HxGhAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KfojF2JCjDs07Phmr7Pa4PEuk0jr5Emyh5qLgfr/T9ZbAJGmUkoSZVAYDQ3/pwMD5
         MWZR/5NWRDkQSWAtE7U4J7mxrq5RJDu0xntZQg/G1fYNdM30Yn1vK+oYOwmFkyFx+8
         JM/UigNtMfovTtQAQpuQaMuPLulUs4BEJ+UXdGShKrnMXeLcudpDUB/vkgwduwEiD6
         HpoLkH01FWr3wySv+1w85mbRaEYqUEGOnkNuzhTOTEcIj1OighaAqsM/P9y2P5SUa0
         uJib4+i9XTAJO/UFUAmE0fYOgUUtY4hc8RC3YZYNA8KZe3/gCWaiIwTeIWMIeZX/hV
         rJYw27H2zV0kA==
Date:   Wed, 6 Oct 2021 15:47:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ramji Jiyani <ramjiyani@google.com>
Cc:     arnd@arndb.de, viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@lst.de,
        kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] aio: Add support for the POLLFREE
Message-ID: <YV4nnko8rmWAWj2+@gmail.com>
References: <20211006224311.26662-1-ramjiyani@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006224311.26662-1-ramjiyani@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 10:43:11PM +0000, Ramji Jiyani wrote:
> Fixes: f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread exits.")
> Signed-off-by: Ramji Jiyani <ramjiyani@google.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Cc: stable@vger.kernel.org # 4.19+

The commit that this claims to be fixing is in linux-4.4.y, so either the fixes
tag is wrong or the Cc stable tag is wrong.  It's important to provide correct
information here for backporting purposes, so please do so.

- Eric
