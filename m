Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E43CBC61
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhGPTZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 15:25:42 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:35904 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhGPTZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 15:25:41 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d84 with ME
        id VvNj2500921Fzsu03vNjpQ; Fri, 16 Jul 2021 21:22:44 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 16 Jul 2021 21:22:44 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH AUTOSEL 4.9 17/18] scsi: be2iscsi: Fix some missing space
 in some messages
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
 <20210714194806.55962-17-sashal@kernel.org>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <615a1135-bbb0-0384-8499-716f26fba08a@wanadoo.fr>
Date:   Fri, 16 Jul 2021 21:22:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714194806.55962-17-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 14/07/2021 à 21:48, Sasha Levin a écrit :
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> [ Upstream commit c7fa2c855e892721bafafdf6393342c000e0ef77 ]
>
> Fix a few style issues reported by checkpatch.pl:
>
>   - Avoid duplicated word in comment.
>
>   - Add missing space in messages.
>
>   - Unneeded continuation line character.
>
>   - Unneeded extra spaces.
>
>   - Unneeded log message after memory allocation failure.
>
> Link: https://lore.kernel.org/r/8cb62f0eb96ec7ce7a73fe97cb4490dd5121ecff.1623482155.git.christophe.jaillet@wanadoo.fr
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi,

I always appreciate to have some patches backported, but in this 
particular case, I wonder what is the rational to backport up to 4.9 
some checkpatch warning about log message?

Keeping code aligned to ease other future backport?

I thought that the rule for backport was that it needed to fix a real 
issue (and sometimes a real 'potential' issue)

CJ


