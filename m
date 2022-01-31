Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099FA4A4916
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 15:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359642AbiAaONN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 09:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379366AbiAaOMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 09:12:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12FC061714;
        Mon, 31 Jan 2022 06:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A637612FC;
        Mon, 31 Jan 2022 14:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F5FC340EF;
        Mon, 31 Jan 2022 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643638364;
        bh=/rNZCo422qabjvqVbA6mwkE9wNT/fqYn/U96SvxR74Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NdcxMkFcQa/IKyrwXI4I0N6amJQpuOGOmr1oNcWcv6vNnVjZvgu6gLWTiyVtZ/mqD
         yO1ovnzUzhZ7rmGehpbB1In3j4+IFzbAeTXhgC02R722god+Hc6xgEL/7aYzQKpetv
         QIWsN/2w+ZPMOGImdX7xST+EosrJLndhhorghyUOQFWtzU2xnYFm7ll2b8ZeUkStYq
         H896wTpnqlUJZ1n9Hj5+s0eoGkaOEfcXwcU709f7qhebVQ3sIOp+nfvQUmu3DbLlVk
         7v9aOqmmQM/wNj0ur758fEIdUBo+Nzjw9jvlYfwn0UdJwlAzrEPAGtGtdpDgwtmZjh
         gjt2FTgkaphBA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Differentiate wcn3660 from wcn3620
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220125004046.4058284-1-bryan.odonoghue@linaro.org>
References: <20220125004046.4058284-1-bryan.odonoghue@linaro.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        loic.poulain@linaro.org, benl@squareup.com,
        bryan.odonoghue@linaro.org, stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164363836093.10147.10288761047520390315.kvalo@kernel.org>
Date:   Mon, 31 Jan 2022 14:12:42 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> wrote:

> The spread of capability between the three WiFi silicon parts wcn36xx
> supports is:
> 
> wcn3620 - 802.11 a/b/g
> wcn3660 - 802.11 a/b/g/n
> wcn3680 - 802.11 a/b/g/n/ac
> 
> We currently treat wcn3660 as wcn3620 thus limiting it to 2GHz channels.
> Fix this regression by ensuring we differentiate between all three parts.
> 
> Fixes: 8490987bdb9a ("wcn36xx: Hook and identify RF_IRIS_WCN3680")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

98d504a82cc7 wcn36xx: Differentiate wcn3660 from wcn3620

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220125004046.4058284-1-bryan.odonoghue@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

