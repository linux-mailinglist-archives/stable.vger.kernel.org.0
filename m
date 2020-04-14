Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DB11A841D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391268AbgDNQEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391235AbgDNQEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 12:04:41 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE74E20775;
        Tue, 14 Apr 2020 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586880281;
        bh=epy82pHJIjz+R+sTHySiSOV9DXsESpBVEBTHm5bQ8zE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=uzB6xCQH55+x/gMA2gVncOQC2YIunQFxYsPibIC1gUjHTZfWFMeKqaejV7lSBvD9o
         cGYSUmxTw40RI/a1Uk5jzTbaPOdKFExmGLUSjp3Keu/NRdxpC6Vi/3UmFTSBtZxMM/
         wjoLGqZvZ8x1RgdLJQktmDytt8OVQXEk+L+jl0Y4=
Subject: Re: [PATCH AUTOSEL 5.5 04/66] Kernel selftests: tpm2: check for tpm
 support
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        shuah <shuah@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
 <20200303024615.8889-4-sashal@kernel.org>
From:   shuah <shuah@kernel.org>
Message-ID: <8954e808-6dd9-dd71-e2d7-7dc90c9d66b3@kernel.org>
Date:   Tue, 14 Apr 2020 10:04:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303024615.8889-4-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/20 7:45 PM, Sasha Levin wrote:
> From: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
> 
> [ Upstream commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc ]
> 
> tpm2 tests set fails if there is no /dev/tpm0 and /dev/tpmrm0
> supported. Check if these files exist before run and mark test as
> skipped in case of absence.
> 
> Signed-off-by: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/testing/selftests/tpm2/test_smoke.sh | 13 +++++++++++--
>   tools/testing/selftests/tpm2/test_space.sh |  9 ++++++++-
>   2 files changed, 19 insertions(+), 3 deletions(-)
> 

Let's drop this unless it already made it into stables.
Jarkko Sakkinen found regressions and send in a revert
for this patch.

thanks,
-- Shuah
