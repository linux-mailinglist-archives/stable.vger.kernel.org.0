Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0115177A75
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgCCPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 10:30:57 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:45235 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728330AbgCCPa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 10:30:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583249456; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3BxebRKEMOAjMUrBvm+Lh7nAfMlbm486WARWBwD2ECo=;
 b=FfJK5yGDPJxpDaZEsiUBprcN4XxTMu7gkaD2NUXbvrQSiEeL77H0ftijRvaQA36rM5s0uqKy
 YtBeHiZZbpnsjWY6KjMrNrBIAeTY6gbVvFHpZTJQgs1sqxL4nk2zDHg0Dmz3O4XRSMxxqoPb
 8OUyB6fJGHRdWCTHlHOA7sickSw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e5e7828.7f4a201e8848-smtp-out-n01;
 Tue, 03 Mar 2020 15:30:48 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 15991C4479D; Tue,  3 Mar 2020 15:30:48 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8CEBC43383;
        Tue,  3 Mar 2020 15:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8CEBC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.6] mt76: fix array overflow on receiving too many
 fragments for a packet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200220114139.46508-1-nbd@nbd.name>
References: <20200220114139.46508-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200303153048.15991C4479D@smtp.codeaurora.org>
Date:   Tue,  3 Mar 2020 15:30:48 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> If the hardware receives an oversized packet with too many rx fragments,
> skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
> This becomes especially visible if it corrupts the freelist pointer of
> a slab page.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers.git, thanks.

b102f0c522cf mt76: fix array overflow on receiving too many fragments for a packet

-- 
https://patchwork.kernel.org/patch/11393869/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
