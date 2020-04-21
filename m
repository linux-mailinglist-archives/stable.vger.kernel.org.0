Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73461B317F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgDUUzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDUUzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 16:55:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBCD2072D;
        Tue, 21 Apr 2020 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587502536;
        bh=fe3Lr0ik/J5FdKeBR0zh7KONvEwq1B6pZH68csqDaA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XydnI0O+RiXf7q6XlhnhlXbyDARvIIoJhalXUSrQ8hkqGDJ6X558yC8Ury3M4p/vT
         zc/TNawF2/1q0qFe774nzsjbJsXg+E5ckxjP/BGPyvNyeC08zLV8h8f4vuB2FsAT/n
         fx/s1C4Aai4GmdJ+8crlM0/OY9BQBPiFh3IbgDMA=
Date:   Tue, 21 Apr 2020 16:55:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     Ilan Peer <ilan.peer@intel.com>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 v5.7 5/6] iwlwifi: mvm: Do not declare support for ACK
 Enabled Aggregation
Message-ID: <20200421205535.GL1809@sasha-vm>
References: <iwlwifi.20200417100405.53dbc3c6c36b.Idfe118546b92cc31548b2211472a5303c7de5909@changeid>
 <20200421195608.CB7EA2074B@mail.kernel.org>
 <c548cd4416cfe6f1e9c6824a60edf11de3ee6e43.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c548cd4416cfe6f1e9c6824a60edf11de3ee6e43.camel@coelho.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 11:13:40PM +0300, Luca Coelho wrote:
>On Tue, 2020-04-21 at 19:56 +0000, Sasha Levin wrote:
>> Hi
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: 4.19+
>>
>> The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116.
>>
>> v5.6.5: Build OK!
>> v5.5.18: Build OK!
>> v5.4.33: Build OK!
>> v4.19.116: Failed to apply! Possible dependencies:
>>     57a3a454f303 ("iwlwifi: split HE capabilities between AP and STA")
>>     80aaa9c16415 ("mac80211: Add he_capa debugfs entry")
>>     add7453ad62f ("wireless: align to draft 11ax D3.0")
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
>
>Same thing as with the other patches: We definitely don't want all
>these dependencies.  Some functions were moved around and that's what's
>causing the failures.  I'll rebase this patch for those kernels where
>it failed and submit separately.

No problem, this is more of a backport hint rather than us saying "we're
going to take all of this".

And thanks for the (future) backport :)

-- 
Thanks,
Sasha
