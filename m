Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B04820E508
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgF2Vbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbgF2SlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E1C23D20;
        Mon, 29 Jun 2020 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593440142;
        bh=ILQjlYAH/ccZmwRZd7e5A9LesmTYOlW7IzZBgk8SVbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R6mb0AWIZ3l55/ZJrv6RyX2eaHlcg5P6PREFPoq85FaasYKONtlROVAeg3ACVzErp
         LrR2FUHc2P0FJY6dXb3svkZb+bpQha1ol9Yy0pMATgSpX+Ke3YqjLU1nGgFzmzINk/
         N9VMASlE7a2jI7tKe0xvVlmr82UVHyHRR4U7LwGM=
Date:   Mon, 29 Jun 2020 10:15:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     yishache@amazon.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: Request for inclusion on linux-4.14.y and linux-5.4.y
Message-ID: <20200629141541.GQ1931@sasha-vm>
References: <20200625225935.16844-1-yishache@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200625225935.16844-1-yishache@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 10:59:34PM +0000, yishache@amazon.com wrote:
>Hello Greg,
>
>Can you please consider including the following patch in the stable linux-4.14.y and stable linux-5.4.y branch?
>
>This is to fix CVE-2020-12655
>
>d0c7feaf87678371c2c09b3709400be416b2dc62(xfs: add agf freeblocks verify in xfs_agf_verify)

I've queued it for 5.4-4.9, thanks!

-- 
Thanks,
Sasha
