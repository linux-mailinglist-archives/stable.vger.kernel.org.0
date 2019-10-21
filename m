Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2486ADEE6B
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 15:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfJUNxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 09:53:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfJUNxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 09:53:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D8DE96076A; Mon, 21 Oct 2019 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571666024;
        bh=kHPCqSDycA6KEAoUomcYWPc5e+ajK/BLVgtYOFqyX/U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=agAZZCc0thnjJLrM4UWbDytEAm6inBPfud7Bj+Kr6Pe//dsnGfwh0GpTQlSJcnlop
         k1LJTV+I4k2kvg7QoRQalaUaxYQSqT19rAn2mrOJwEFru6VV9QvnyK0vYGzRB2+c8s
         j6y4qjvtz64/wx0RbSkRRYG4kRqH06Qn1MH8M1BA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2796060112;
        Mon, 21 Oct 2019 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571666024;
        bh=kHPCqSDycA6KEAoUomcYWPc5e+ajK/BLVgtYOFqyX/U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=agAZZCc0thnjJLrM4UWbDytEAm6inBPfud7Bj+Kr6Pe//dsnGfwh0GpTQlSJcnlop
         k1LJTV+I4k2kvg7QoRQalaUaxYQSqT19rAn2mrOJwEFru6VV9QvnyK0vYGzRB2+c8s
         j6y4qjvtz64/wx0RbSkRRYG4kRqH06Qn1MH8M1BA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2796060112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH V3] rtlwifi: rtl_pci: Fix problem of too small skb->len
References: <20191021005658.31391-1-Larry.Finger@lwfinger.net>
Date:   Mon, 21 Oct 2019 16:53:40 +0300
In-Reply-To: <20191021005658.31391-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 20 Oct 2019 19:56:58 -0500")
Message-ID: <87zhhuurvf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
> only"), buffers whose length is too short cause a WARN_ON(1) to be
> executed. This change exposed a fault in rtlwifi drivers, which is fixed
> by regarding packets with skb->len <= FCS_LEN as though they are in error
> and dropping them. The test is now annotated as likely.
>
> Cc: Stable <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> V2 - content dropped
> V3 - changed fix to drop packet rather than arbitrarily increasing the length.

Much better, thanks.

> Material for 5.4.

Ok, I'll queue it for v5.4.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
