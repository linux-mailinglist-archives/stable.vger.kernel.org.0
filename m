Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222FB3ADE5F
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhFTM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 08:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhFTM6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Jun 2021 08:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1FA6113E;
        Sun, 20 Jun 2021 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624193761;
        bh=0t7IQUFh6zHqUD9R7xjQdwBzx24Trn04VAEJ9D2FgCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ABKD39gMt1bu7i0WfY5HIdwtGKaqm+avcDu9vo9R8ikoOcnR8fXLtZ/gi5WyzHA/A
         jJEUEA4GxumhSLLnUOPuZpq90OIoD1qrq/+BB0XdgjSCaEOL0Kg4TTyod/NaHr3vNi
         ISQngEjvjqjmmIvgJpbiqZ1W9ngB0Otv9kIgE+/jNnzZpDTcO7AJTbUPZTY7w0PAOZ
         yZGhsPDED87xEiIsYCKNj3T2hEgqk671uuQAv/n0p4rIC2hElXWPZy/fTCJ/iivfHq
         fHbAB04ZYmd3nEQAOSOsmHEv0tF2/jD1RpasXTdqpCGg2cualEplyvSA7FXbyYYN1Q
         Uf9BfWmBGgEeg==
Date:   Sun, 20 Jun 2021 08:55:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 02/33] regulator: max77620: Silence deferred
 probe error
Message-ID: <YM8633R356GXEwoR@sashalap>
References: <20210615154824.62044-1-sashal@kernel.org>
 <20210615154824.62044-2-sashal@kernel.org>
 <20210615155436.GM5149@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210615155436.GM5149@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 04:54:36PM +0100, Mark Brown wrote:
>On Tue, Jun 15, 2021 at 11:47:53AM -0400, Sasha Levin wrote:
>> From: Dmitry Osipenko <digetx@gmail.com>
>>
>> [ Upstream commit 62499a94ce5b9a41047dbadaad885347b1176079 ]
>>
>> One of previous changes to regulator core causes PMIC regulators to
>> re-probe until supply regulator is registered. Silence noisy error
>> message about the deferred probe.
>
>This really doesn't look like stable material...

Not strictly, but we usually take fixes to issues that can confuse users
or spam logs.

-- 
Thanks,
Sasha
