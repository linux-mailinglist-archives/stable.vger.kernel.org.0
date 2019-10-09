Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66B6D0521
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 03:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfJIBRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 21:17:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57222 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIBRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 21:17:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5D8A060AA8; Wed,  9 Oct 2019 01:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570583842;
        bh=XVsNK4IrJQqEtygFw4GniV7xzf57ICAUT9ZaI0ARlGg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oiw1UQs+13t72DOqHm+xVhKHd7YlYy+qbHCjGbze04GI921sf7Pcc3om49Fj+ppCx
         E5tUEkiGtNgvJ+6vkJ6/Itb9NH42n19dvdLIx3RqmxyY0wenhI0cmXKistLHqF+joV
         GTMRmIesVf4259RLdz7Jbd5QOxOk9jmMh6U7tuCI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from [192.168.142.6] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: clew@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC10660709;
        Wed,  9 Oct 2019 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570583842;
        bh=XVsNK4IrJQqEtygFw4GniV7xzf57ICAUT9ZaI0ARlGg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oiw1UQs+13t72DOqHm+xVhKHd7YlYy+qbHCjGbze04GI921sf7Pcc3om49Fj+ppCx
         E5tUEkiGtNgvJ+6vkJ6/Itb9NH42n19dvdLIx3RqmxyY0wenhI0cmXKistLHqF+joV
         GTMRmIesVf4259RLdz7Jbd5QOxOk9jmMh6U7tuCI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC10660709
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v2 6/6] rpmsg: glink: Free pending deferred work on remove
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191004222702.8632-1-bjorn.andersson@linaro.org>
 <20191004222702.8632-7-bjorn.andersson@linaro.org>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <e50eabc6-c8d3-f47f-dab8-91e85ad38fb8@codeaurora.org>
Date:   Tue, 8 Oct 2019 18:17:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004222702.8632-7-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/4/2019 3:27 PM, Bjorn Andersson wrote:
> By just cancelling the deferred rx worker during GLINK instance teardown
> any pending deferred commands are leaked, so free them.
> 
> Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
> Cc: stable@vger.kernel.org
> Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
Acked-By: Chris Lew <clew@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
