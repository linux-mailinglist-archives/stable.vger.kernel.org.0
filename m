Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DE82F93EF
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 17:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbhAQQSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 11:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbhAQQSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 11:18:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 562D0206FA;
        Sun, 17 Jan 2021 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610900289;
        bh=HWLfGg/zx+DD4bzEZzYQcpwCpiLlq6T25unpshVIU48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rrO6Gbmn0NYwcbrbLs6fNTYF/5ol158d5p9GSSUybo4GFLm/JPEzc+7dCydr/b9xp
         oZWR7L2SOzsObhTUeT6zkLlf3ZJOM/b0vtLIwVhlpST0J3t1ZOPd2KLOnENdZr8Lth
         phsKPgR5Fomk1MEZQdH0NEmr0p0WAYQduwodurf+HKsCrcEjbhrqTh153rNwNw6z3C
         ENVExnubYLHPuuJS/bMzfB8E3iM5kMGW2KG/KJXF5kSirJOG1bRxLxGwn4nLndNStD
         So9H6Hsd40yrETUUDJjNVs2MwjDlechEMKY6G7YFBTFtSCO13n2ORFmQr07dvJnYyS
         BNbYWlJZlJdNQ==
Date:   Sun, 17 Jan 2021 11:18:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 45/51] gcc-plugins: fix gcc 11 indigestion
 with plugins...
Message-ID: <20210117161808.GX4035784@sasha-vm>
References: <20210112125534.70280-1-sashal@kernel.org>
 <20210112125534.70280-45-sashal@kernel.org>
 <202101120931.61C1F0B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202101120931.61C1F0B@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 09:31:38AM -0800, Kees Cook wrote:
>This will need an additional fix, so please don't backport it yet.

I'll drop it for now, thanks.

-- 
Thanks,
Sasha
