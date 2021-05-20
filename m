Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170C338A358
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhETJvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:24 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54757 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbhETJtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 05:49:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621504079; h=Content-Type: MIME-Version: Message-ID: Date:
 Subject: Cc: To: From: Sender;
 bh=H49bGQOtTMgeuENHMnla+QC4zWMuF1l90hEt5XsQN8U=; b=xlMXzF+qdy9BioKscokx7W2dFYUFkT0mE5STqex+t65P3JLRhLAvsFYdfydEscZlLHxLYF6F
 rj/SiNsZhBUIasu15BFzu6D/hlF9IIIl/XVaOZVf9HMtEZrgAzXBXCicCppF7DxrdRG61r7N
 5ijCjfjWzbmQATv+u0aEX/pE5uk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60a6304fc4456bc0f1c49d88 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 20 May 2021 09:47:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF2B0C43146; Thu, 20 May 2021 09:47:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B86B1C43460;
        Thu, 20 May 2021 09:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B86B1C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: [regressions] ath11k: v5.12.3 mhi regression
Date:   Thu, 20 May 2021 12:47:53 +0300
Message-ID: <87v97dhh2u.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I got several reports that this mhi commit broke ath11k in v5.12.3:

commit 29b9829718c5e9bd68fc1c652f5e0ba9b9a64fed
Author: Bhaumik Bhatt <bbhatt@codeaurora.org>
Date:   Wed Feb 24 15:23:04 2021 -0800

    bus: mhi: core: Process execution environment changes serially
    
    [ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]

Here are the reports:

https://bugzilla.kernel.org/show_bug.cgi?id=213055

https://bugzilla.kernel.org/show_bug.cgi?id=212187

https://bugs.archlinux.org/task/70849?project=1&string=linux

Interestingly v5.13-rc1 seems to work fine, at least for me, though I
have not tested v5.12.3 myself. Can someone revert this commit in the
stable release so that people get their wifi working again, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
