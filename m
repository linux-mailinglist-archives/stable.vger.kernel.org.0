Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBC7447B83
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbhKHIF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 03:05:56 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33073 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhKHIF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 03:05:56 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C67515C00F5;
        Mon,  8 Nov 2021 03:03:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Nov 2021 03:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=6onizj35llXqjVpM6j57otHXMeO
        F0HU8T031ZzfdTDY=; b=p1SiTNhrjwQHIlLFRrAghwR170Uv0ApZOV+uU+pdurL
        ENoPRUZRGxQTxLXXvT9ToXaV1EzooOFeTFXsLT+SkJnd2pomKCp6UJrCvj+lH8nQ
        pptNTR6xR+4bT7ac3/pvXRwTUvKP5q7CsbFIYZ8wuDftjCtVwI1SKY0a+KmHe/o2
        aYUN606+xSTqPQj/6xMK3yM2cjdFaBNG+AQ3CfqaiPTzYM239BkQjCpz6RaJRb6U
        gP2DFN4vaUz4Mg4F0aaH+wDn9Lj4ev8RC1dl9nkEenMD8cMsrfqGTMeTRHAzaHnL
        X/dGksg3Ot0I6zvIxiZ4wg8nHuZSyNH4bXVCYBamUgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6onizj
        35llXqjVpM6j57otHXMeOF0HU8T031ZzfdTDY=; b=gnpLzv89DhgLVmT3SIxD3P
        0kH18QjgsIlwxL7KsxW3vynr+/4KiOURfNTB/Yyt7MmUpSDfl9gK+7LQFI56L9mi
        sQHXHzhJi+3cXMKBeiRBhCewkG+aLXvu0deAL+acIF018EpYMn/qmemwu7/i9sev
        Yzw2+AqqJ7/0G+EtniuggwbCzV02BO8cimIP1PYXjVdx3Z9yfpgSZHqu3i5lbcOL
        MpCL6Kik9zYVpGvXi7HEEVHev7PK+EyHlftH5rj3Y1hVEGaM1CIJY+OkslrTCNvv
        r8wWCbLMT/pa48+JxtLZYXXrQI1pPZ9k4PjzWV2YpNSNZxUCwkfi/ruEirO/S6tg
        ==
X-ME-Sender: <xms:v9mIYbVI6rX4db5KJi8VNQmK0vbwnGZuBibaNmdE5qVe8330Gii_Jg>
    <xme:v9mIYTmv5TYdV1Y6_jzPJiBS_KfOnlX5ivUELYBzanQ_sOwQ8xVRCa9uLobZsvSjb
    uFT8x2Y3v9ZRA>
X-ME-Received: <xmr:v9mIYXYpJamQc8y1RrRXpoi0pi-SERovPL63dG1SDvN4Eg2RFUBPqXAhRD8Rgp6FKtQWM9NCDi3RGdz6-5oFJbIpHDiIK_WG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddugddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:v9mIYWUXvjlk5zQUHRxROE9rBVAobLiF4kfV58wPT9WjmhlClBmR5g>
    <xmx:v9mIYVl4VMLvjLAtt3gvp67M-FcLJW2eoluHfY8ZnhN_K-SIQnmMTA>
    <xmx:v9mIYTfQCUOZ7lDnMGJwVFxbcQszdus9_N3PsoafwsOToOThmNFoPQ>
    <xmx:v9mIYeA-n0sxF7TzM07xFtcSN_DnlDYxWH6SavFYOSDRzR1J_3lNHg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Nov 2021 03:03:10 -0500 (EST)
Date:   Mon, 8 Nov 2021 09:03:09 +0100
From:   Greg KH <greg@kroah.com>
To:     mike.marciniszyn@cornelisnetworks.com
Cc:     stable@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 4.9-stable v2 0/2] Port upstream patch v2 to 4.9.x
Message-ID: <YYjZve1RZIIFPfFW@kroah.com>
References: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 11:23:34AM -0400, mike.marciniszyn@cornelisnetworks.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> This series ports upstream commit:
> 
> d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")
> 
> Gustavo A. R. Silva (1):
>   IB/qib: Use struct_size() helper
> 
> Mike Marciniszyn (1):
>   IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt
>     fields
> 
>  drivers/infiniband/hw/qib/qib_user_sdma.c | 35 ++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> -- 
> Changes from v1:
> Correct signed off for Mike Marciniszyn

All now applied, thanks.

greg k-h
