Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9104022BCA2
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 05:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgGXD5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 23:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726493AbgGXD5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 23:57:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3CCE20714;
        Fri, 24 Jul 2020 03:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595563045;
        bh=4FLV/a4QYhyym5l/KjNdzr8hXeKZmZZXWkFnAmPBB3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEUnBq+mT77FfROSxISzkLJ5wIZX6vTYjGpQBihSw87QlHZNJKFMioAGJ2NsWr6UX
         2gsLK468jPDJUWRHYyd71+pmlrRSSE4C4W0cO1+Tls9ck+WGVjIna00OmL5KtHJHGs
         Bxlvl60gFnLNrElW3EPIJewHQde2ZyDPQSGWUTLY=
Date:   Thu, 23 Jul 2020 23:57:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7.y 0/4] exfat stable patches for 5.7.y
Message-ID: <20200724035723.GF406581@sasha-vm>
References: <CGME20200724002112epcas1p24c54808617a5baddef4e4a2f49722866@epcas1p2.samsung.com>
 <20200724001544.30862-1-namjae.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200724001544.30862-1-namjae.jeon@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 24, 2020 at 09:15:40AM +0900, Namjae Jeon wrote:
>Hi,
>
>Could you please pick up exfat stable patches ?

I see that the upstream commits already have stable tags and don't need
modifications for backporting, so there is no need to explicitly send
them here - they will be picked up automatically.

-- 
Thanks,
Sasha
