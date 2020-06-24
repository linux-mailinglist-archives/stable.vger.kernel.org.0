Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86600206925
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 02:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbgFXAwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 20:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgFXAwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 20:52:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B06520C09;
        Wed, 24 Jun 2020 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592959935;
        bh=ogjjBsUrJhb2g1rz/AnDN1LIVnOYAnu6R0WaGEDpnvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPfPRQQDfatn8tIkNBrgsu7VhGF7wVUMPWGsgqDsarQkwehbw2U+l9vGUMX3fjWTY
         vhe09kigcjeCya597Nx0T+dczP60k1jjTq/60m74Xlalo3ArbrPIYEnCC7tcTq23Dx
         UK50vCv+CoRZN0QWpEByE0tUoK3Uzd9sSUVdiabU=
Date:   Tue, 23 Jun 2020 20:52:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aiman Najjar <aiman.najjar@hurranet.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 4.19 049/206] staging: rtl8712: fix multiline derefernce
 warnings
Message-ID: <20200624005214.GC1931@sasha-vm>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195319.392375544@linuxfoundation.org>
 <b3c1299c40cfb76ef46d4967763afed2f7ad2d3d.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b3c1299c40cfb76ef46d4967763afed2f7ad2d3d.camel@perches.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 03:09:10PM -0700, Joe Perches wrote:
>On Tue, 2020-06-23 at 21:56 +0200, Greg Kroah-Hartman wrote:
>> From: Aiman Najjar <aiman.najjar@hurranet.com>
>>
>> [ Upstream commit 269da10b1477c31c660288633c8d613e421b131f ]
>>
>> This patch fixes remaining checkpatch warnings
>> in rtl871x_xmit.c:
>
>IMO: unless necessary for another patch, these types
>of whitespace or renaming only conversions patches
>should not be applied to stable.

I've dropped it, thanks!

-- 
Thanks,
Sasha
