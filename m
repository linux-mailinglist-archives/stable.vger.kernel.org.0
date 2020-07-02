Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24B2119B0
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgGBBi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgGBBi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:38:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F8920781;
        Thu,  2 Jul 2020 01:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653906;
        bh=n7G0ZoHURaVvKPF/v5+VF5jUWoLBPpS7aaMeUI0BxxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ODSQGqWciKtxVmLPw1z3yEnnWnq9TTYPm32DqG5N75qs0ciVOGI2hZ1y776vbImln
         fsjbipDnZLiMV6RyYcRvkG5etAxCjXxpjD3nDQxnBrjWXVXhwDzGdiTaNf3PhAyvXo
         oiaRuAQ8g79/4FFhxsGBi/qNHqqfZsZixtNeHyHQ=
Date:   Wed, 1 Jul 2020 21:38:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.7.y 0/5] exfat stable patches for 5.7.y
Message-ID: <20200702013824.GH2687961@sasha-vm>
References: <CGME20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac@epcas1p3.samsung.com>
 <20200701232024.2083-1-namjae.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200701232024.2083-1-namjae.jeon@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Namjae,

On Thu, Jul 02, 2020 at 08:20:19AM +0900, Namjae Jeon wrote:
>Could you please push exfat stable patches into 5.7.y kernel tree ?

I've queued them up, however it would be much easier if for commits that
don't require any modification to allow backporting you would just
provide the commit ids in Linus's tree rather than the patches
themselves.

I do see that you had to modify this one:

>Sungjong Seo (1):
>  exfat: flush dirty metadata in fsync

In which case, a header in the commit message indicating the upstream
commit id would be appriciated. Something like this:

[ Upstream commit 5267456e953fd8c5abd8e278b1cc6a9f9027ac0a ]

Thank you!

-- 
Thanks,
Sasha
