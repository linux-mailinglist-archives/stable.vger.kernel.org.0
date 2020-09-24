Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED3277C3F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 01:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgIXXPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 19:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgIXXPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 19:15:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADF4206FB;
        Thu, 24 Sep 2020 23:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600989334;
        bh=onLl9pdzKKBLLI1VQv11GZzYupiHqp+44ByFLPo9EFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v/WZEbgspZQD+vEGR1Eiq6u3Mu8yjt81spiwRRMfh9Rxi8eUiJGD/tg/toZ7vhYZJ
         uReq1H3U83QaM+lT7Uo2tsz7e4bXKI0OMtKCBlararfUq+hSc831rYNzlPFp6b+elV
         CSvHmAXFMr0dH/NTK2XVoMyQClOMofHRSXG/QfDI=
Date:   Thu, 24 Sep 2020 19:15:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org,
        Shamir Rabinovitch <shamir.rabinovitch@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH for 4.4, 4.9, 4.14] RDMA/ucma: ucma_context reference
 leak in error path
Message-ID: <20200924231533.GR2431@sasha-vm>
References: <20200924092449.367288-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200924092449.367288-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 06:24:49PM +0900, Nobuhiro Iwamatsu wrote:
>From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
>
>commit ef95a90ae6f4f21990e1f7ced6719784a409e811 upstream.
>
>Validating input parameters should be done before getting the cm_id
>otherwise it can leak a cm_id reference.
>
>Fixes: 6a21dfc0d0db ("RDMA/ucma: Limit possible option size")
>Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
>Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>[iwamatsu: Backported to 4.4, 4.9 and 4.14: adjust context]
>Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>

Queued up, thanks!

-- 
Thanks,
Sasha
