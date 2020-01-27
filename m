Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD514A630
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 15:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgA0Odi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 09:33:38 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:21255 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727817AbgA0Odi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 09:33:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580135617; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=7+xkR3BHg9A0v14RQ5mF55Y04fzclGoR+oy704vl4Fc=;
 b=LDOSuqK4EiPo9x3GCa26paev9eaNUmWSWxobefwkjMgp9q2zizS440bkNKIm7kb+33bp4b1a
 fTJ6aq928eAdczu1NrUZ7XuCA6/ua6GkyzdAg4Y1mxUss00MRM8SJ9kj7L0Ml+KGIPkZVYgd
 man/42mZbKMOyb2aP7xvpVahNF0=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2ef4bc.7fb04834eea0-smtp-out-n02;
 Mon, 27 Jan 2020 14:33:32 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D78F4C433CB; Mon, 27 Jan 2020 14:33:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EBDCEC433CB;
        Mon, 27 Jan 2020 14:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EBDCEC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: fix unbalanced locking in
 mwifiex_process_country_ie()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200106224212.189763-1-briannorris@chromium.org>
References: <20200106224212.189763-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, huangwen <huangwenabc@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200127143332.D78F4C433CB@smtp.codeaurora.org>
Date:   Mon, 27 Jan 2020 14:33:32 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> We called rcu_read_lock(), so we need to call rcu_read_unlock() before
> we return.
> 
> Fixes: 3d94a4a8373b ("mwifiex: fix possible heap overflow in mwifiex_process_country_ie()")
> Cc: stable@vger.kernel.org
> Cc: huangwen <huangwenabc@gmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Patch applied to wireless-drivers.git, thanks.

65b1aae0d9d5 mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

-- 
https://patchwork.kernel.org/patch/11320227/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
