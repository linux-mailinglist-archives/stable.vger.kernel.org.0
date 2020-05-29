Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8840A1E8475
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 19:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgE2ROS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 13:14:18 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:64486 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgE2ROR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 13:14:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590772457; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=g4wJ9oUXyWx7XokYJ4lsEr2jPRySwhpJ6Xg4tL0l7lU=;
 b=nHPvEd7hDm7JMEIVDIZM9IShwNZWGzHXqgU/do05uQkB203TMOgxv3cJ3UDxPEHc41ywKwnm
 q782cNcnyXUGXZasIOzrSQy1eLKA3Bd7yZ77yEC4hwYq+yREvw6DMCm34s3lsgrqHCMC4mK1
 uLYahj7fhmityGPNrElfWDk1BiU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5ed142dfcb045869339a39d9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:14:07
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E3C93C43391; Fri, 29 May 2020 17:14:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1C307C433C6;
        Fri, 29 May 2020 17:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1C307C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] b43: Fix connection problem with WPA3
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200526155909.5807-2-Larry.Finger@lwfinger.net>
References: <20200526155909.5807-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Stable <stable@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529171406.E3C93C43391@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:14:06 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Since the driver was first introduced into the kernel, it has only
> handled the ciphers associated with WEP, WPA, and WPA2. It fails with
> WPA3 even though mac80211 can handle those additional ciphers in software,
> b43 did not report that it could handle them. By setting MFP_CAPABLE using
> ieee80211_set_hw(), the problem is fixed.
> 
> With this change, b43 will handle the ciphers it knows in hardware,
> and let mac80211 handle the others in software. It is not necessary to
> use the module parameter NOHWCRYPT to turn hardware encryption off.
> Although this change essentially eliminates that module parameter,
> I am choosing to keep it for cases where the hardware is broken,
> and software encryption is required for all ciphers.
> 
> Reported-and-tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

2 patches applied to wireless-drivers-next.git, thanks.

75d057bda1fb b43: Fix connection problem with WPA3
6a29d134c04a b43_legacy: Fix connection problem with WPA3

-- 
https://patchwork.kernel.org/patch/11570765/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

