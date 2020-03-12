Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDDE183180
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgCLNcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:32:03 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:40594 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727462AbgCLNcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:32:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584019919; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=hhYI/xqrH4iLJzSbbenfz+gy72pcGI+/7urHJfM7BQw=;
 b=WNyYj8voPpyQ90oWxJjpooqz8Rsw64njZiZWqiaRxtCdnZE+jIbJ4RRLoTrkICHYFEZCecpz
 q/aAvksC3o9l9tDZdGlwiinusaawsxVGTTDj9880VMLA68PD7NQrasqRQwp7NZ1WnI79mw2G
 42AZZ7tqdZF5ULQWNf5L2RDjvrw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6a39cf.7fee11a58d18-smtp-out-n01;
 Thu, 12 Mar 2020 13:31:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12782C44791; Thu, 12 Mar 2020 13:31:59 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDDD7C432C2;
        Thu, 12 Mar 2020 13:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CDDD7C432C2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Fix regression due to commit
 d1d1a96bdb44
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200219200041.22279-1-Larry.Finger@lwfinger.net>
References: <20200219200041.22279-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200312133159.12782C44791@smtp.codeaurora.org>
Date:   Thu, 12 Mar 2020 13:31:59 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> For some unexplained reason, commit d1d1a96bdb44 ("rtlwifi: rtl8188ee:
> Remove local configuration variable") broke at least one system. As
> the only net effect of the change was to remove 2 bytes from the start
> of struct phy_status_rpt, this patch adds 2 bytes of padding at the
> beginning of the struct.
> 
> Fixes: d1d1a96bdb44 ("rtlwifi: rtl8188ee: Remove local configuration variable")
> Cc: Stable <stable@vger.kernel.org>  # V5.4+
> Reported-by: Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
> Tested-by: Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

c80b18cbb04b rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44

-- 
https://patchwork.kernel.org/patch/11392353/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
