Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C220B4D0593
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 18:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241862AbiCGRrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 12:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244593AbiCGRrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 12:47:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB48939C2;
        Mon,  7 Mar 2022 09:45:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F24761255;
        Mon,  7 Mar 2022 17:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D497FC340E9;
        Mon,  7 Mar 2022 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646675157;
        bh=/NpjGjQdtw/amOpaK8Pkr0lhwX9x2eGRbV9UUgrtViY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=uEt667SZIcUPXrrVnrBcmmVYlI2+N+4d3+OfPjtr2s3JRJMMMH9Qk+JCfeh1QGL1B
         YEUbRTMUfBwgaueMHTSaeLzI/TBvwgLWOb06/mVQgxdb30CKzYK5HZNPUoA4JwRLYD
         sVQ0NXjFM6qDxqVr5v56Ag1wm0CpppC2rGaG0cVggW52Ti6Y7Gdurt8HBseLYTi3L4
         WHa5qGhXxx+qSFRsleje+Kad2EMvgZ+4ThYNcmWlNnxNY27tOJFBrRcZNcmewu8gCs
         obWOY/TwAdUxvtpN15z/7CxEQqXl4EeypRcXLv1NT/knVdvGAQGUcIk9rFEsUYDfpk
         qCKZjkTlm5c2w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory
 domain"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20200527165718.129307-1-briannorris@chromium.org>
References: <20200527165718.129307-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164667515364.26528.7146769565845782335.kvalo@kernel.org>
Date:   Mon,  7 Mar 2022 17:45:55 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> This reverts commit 2dc016599cfa9672a147528ca26d70c3654a5423.
> 
> Users are reporting regressions in regulatory domain detection and
> channel availability.
> 
> The problem this was trying to resolve was fixed in firmware anyway:
> 
>     QCA6174 hw3.0: sdio-4.4.1: add firmware.bin_WLAN.RMH.4.4.1-00042
>     https://github.com/kvalo/ath10k-firmware/commit/4d382787f0efa77dba40394e0bc604f8eff82552
> 
> Link: https://bbs.archlinux.org/viewtopic.php?id=254535
> Link: http://lists.infradead.org/pipermail/ath10k/2020-April/014871.html
> Link: http://lists.infradead.org/pipermail/ath10k/2020-May/015152.html
> Link: https://lore.kernel.org/all/1c160dfb-6ccc-b4d6-76f6-4364e0adb6dd@reox.at/
> Fixes: 2dc016599cfa ("ath: add support for special 0x0 regulatory domain")
> Cc: <stable@vger.kernel.org>
> Cc: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

1ec7ed5163c7 Revert "ath: add support for special 0x0 regulatory domain"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20200527165718.129307-1-briannorris@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

