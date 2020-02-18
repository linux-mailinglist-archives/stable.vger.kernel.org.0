Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCCA162A70
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgBRQ1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:27:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgBRQ1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 11:27:54 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06CA122B48;
        Tue, 18 Feb 2020 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582043274;
        bh=mNJcY1SbcjkvSzHthVNhrlPKPPGc3shV2dfOwIBOXqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y5NEd63TAWgr7RSZDyAnzcKgtM01NaEjhgU85vmxUBRQh8d3tNIYSualjD0b1pDNx
         y6Om7pEpWqLuDkjbrG638U0kiQ62KFJlLpwNUtaTOWpPyvn3PKyPcBgBM432EaBZ7R
         /obcjjXe7Sz9huOMpcOQr5Bm71krOp8vFqbcGoEU=
Date:   Tue, 18 Feb 2020 11:27:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org, jack@suse.cz,
        tytso@mit.edu
Subject: Re: [PATCH 5.4 1/2] jbd2: move the clearing of b_modified flag to
 the journal_unmap_buffer()
Message-ID: <20200218162752.GN1734@sasha-vm>
References: <20200218105953.10684-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200218105953.10684-1-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 06:59:52PM +0800, zhangyi (F) wrote:
>[ Upstream commit 6a66a7ded12baa6ebbb2e3e82f8cb91382814839 ]
>
>There is no need to delay the clearing of b_modified flag to the
>transaction committing time when unmapping the journalled buffer, so
>just move it to the journal_unmap_buffer().
>
>Link: https://lore.kernel.org/r/20200213063821.30455-2-yi.zhang@huawei.com
>Reviewed-by: Jan Kara <jack@suse.cz>
>Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>Cc: stable@kernel.org

I've queued all backports to their respective branches, thank you!

-- 
Thanks,
Sasha
