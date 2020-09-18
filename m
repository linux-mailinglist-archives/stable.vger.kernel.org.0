Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6605626F28A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgIRC7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIRC7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:59:01 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4DAB2083B;
        Fri, 18 Sep 2020 02:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600397941;
        bh=UxyESt/K75+rUqzJRmabdg0mnMv1VHXCfyIK+f5CqpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uO19MVTx3NWJ9usXy2oKKEIPkmosZEXtgFGOe6IEnE3qkk4VXDca0g/Z9bOhX3W/9
         2VfiWBgEYVCbm9UsWLG0XDoHFFvdK4qPQtPCzp3/bbSfQHYaNmfbliTMlnA7lLUN07
         /P37UsqT9PPJF9YTBQT4K/8fX84LKNaKv2DigGmk=
Date:   Thu, 17 Sep 2020 19:58:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 059/206] ext4: make dioread_nolock the
 default
Message-ID: <20200918025859.GB3518637@gmail.com>
References: <20200918020802.2065198-1-sashal@kernel.org>
 <20200918020802.2065198-59-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918020802.2065198-59-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 10:05:35PM -0400, Sasha Levin wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> [ Upstream commit 244adf6426ee31a83f397b700d964cff12a247d3 ]
> 
> This fixes the direct I/O versus writeback race which can reveal stale
> data, and it improves the tail latency of commits on slow devices.
> 
> Link: https://lore.kernel.org/r/20200125022254.1101588-1-tytso@mit.edu
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Any particular reason to be backporting this?  I thought I saw some fixes for
dioread_nolock go by, after it was made the default.  Are you getting all of
those fixes too?

- Eric
