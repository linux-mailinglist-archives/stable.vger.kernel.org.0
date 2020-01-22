Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A855145ACD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 18:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAVR0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 12:26:21 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:11800 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgAVR0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 12:26:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579713980; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=JT8t4mKOX65qBwKaBugFTnYrziFh/b4z7AwIEFhR5+o=;
 b=B8xhS/UyWSZJfzTikpmvN6JLFU7HoGdRas2ZxwkERz1KMAdyOCXN6ye/AtOWG8HEzwcDUvfu
 cOlXqQG5SwAywgCnLhBD6F5j1ZkaPM6qVAG7zI0+tZos4FLzJoq87DmlBZtQ21t1WHSjv2kK
 omnVlvos+YulMOIFOHhV0VHOEXo=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2885b2.7f52ca6ca1b8-smtp-out-n03;
 Wed, 22 Jan 2020 17:26:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 217F2C433A2; Wed, 22 Jan 2020 17:26:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C10CCC433CB;
        Wed, 22 Jan 2020 17:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C10CCC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC
 notif to Rx queues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191203080849.12013-1-emmanuel.grumbach@intel.com>
References: <20191203080849.12013-1-emmanuel.grumbach@intel.com>
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200122172609.217F2C433A2@smtp.codeaurora.org>
Date:   Wed, 22 Jan 2020 17:26:09 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Emmanuel Grumbach <emmanuel.grumbach@intel.com> wrote:

> The purpose of this was to keep all the queues updated with
> the Rx sequence numbers because unlikely yet possible
> situations where queues can't understand if a specific
> packet needs to be dropped or not.
> 
> Unfortunately, it was reported that this caused issues in
> our DMA engine. We don't fully understand how this is related,
> but this is being currently debugged. For now, just don't send
> this notification to the Rx queues. This de-facto reverts my
> commit 3c514bf831ac12356b695ff054bef641b9e99593:
> 
> iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
> 
> This issue was reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=204873
> https://bugzilla.kernel.org/show_bug.cgi?id=205001
> and others maybe.
> 
> Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
> CC: <stable@vger.kernel.org> # 5.3+
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Patch applied to wireless-drivers.git, thanks.

d829229e35f3 iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues

-- 
https://patchwork.kernel.org/patch/11270795/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
