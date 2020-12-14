Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA572D95BF
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 11:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392056AbgLNKDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 05:03:36 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:46539 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406294AbgLNKC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 05:02:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607940149; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=yGhYtL6foUyLuEeIMQV5SXrQIq8elvpV73k2G+sb9vs=; b=on/Vi9NJCJGOJ4WywRFj47cqSLT0thophOoen8LEZCtCE1yralYwZkNAuO3U8sQxJZ06ewai
 l8JN0XlavT0AYulLW6N48Cbxg+18y8RSFFZcz8n8vJnH39GL7rYivWNUYrsUzKT+OIpL1b6d
 KQnZJF0ZKDfa+ldM9EspQfkAwwA=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fd7383553d7c5ba60a10d51 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Dec 2020 10:02:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 160A8C43463; Mon, 14 Dec 2020 10:02:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6097C433C6;
        Mon, 14 Dec 2020 10:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6097C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     David Hildenbrand <david@redhat.com>, arm-soc <arm@kernel.org>,
        SoC Team <soc@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Pavel Procopiuc <pavel.procopiuc@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>, wi nk <wink@technolu.st>
Subject: Re: [PATCH] ARM: dts: ux500: Reserve memory carveouts
References: <20201213225517.3838501-1-linus.walleij@linaro.org>
        <cc06e06b-ff24-68a2-f5f3-c8533118a34d@redhat.com>
        <CACRpkdZp+gnJAo02OJkiN_KUX3bOPc2vzQGWHLZF2hQHvuQQkw@mail.gmail.com>
Date:   Mon, 14 Dec 2020 12:02:23 +0200
In-Reply-To: <CACRpkdZp+gnJAo02OJkiN_KUX3bOPc2vzQGWHLZF2hQHvuQQkw@mail.gmail.com>
        (Linus Walleij's message of "Mon, 14 Dec 2020 10:27:28 +0100")
Message-ID: <877dpk3du8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Mon, Dec 14, 2020 at 10:21 AM David Hildenbrand <david@redhat.com> wrote:
>
>> > ARM SoC folks: please apply this directly for fixes.
>>
>> Can we come up with a Fixes: tag or has this been broken forever?
>> (assuming modern boot loaders)
>
> It's been broken forever :/
>
>> > David: just FYI if you run into more of these type of
>> > regressions. Actually the patch is unintentionally good
>> > at smoking out other bugs :D
>>
>> Thanks for CCing - I'm adding some people that ran into similar issues,
>> but not sure if the other bugreports are related (or have similar root
>> causes).
>
> Yeah we first were convinced there was something wrong with
> the patch you made but I read it over and over again and there
> is nothing wrong with it at all. It just alters the behaviour pattern of
> memory management in some apparently drastic ways.
>
> After a lot of silent crashes I finally got an external abort with
> a reasonable backtrace showing the PTE pointing to this
> modem memory and then we figured it out.

We had similar experiences with ath11k (Wi-Fi 6) and QCA6390 firmware.
So indeed commit 7fef431be9c9 ("mm/page_alloc: place pages to tail in
__free_pages_core()") is a great way to catch odd firmware or hardware
problems, which most likely would have gone unnoticed otherwise and
users would have end up experiencing random crashes.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
