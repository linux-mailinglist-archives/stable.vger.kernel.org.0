Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012765B18EC
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIHJkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiIHJkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:40:39 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99433A4065;
        Thu,  8 Sep 2022 02:40:38 -0700 (PDT)
Received: from [192.168.169.80] (unknown [182.2.70.215])
        by gnuweeb.org (Postfix) with ESMTPSA id 7BFA07E257;
        Thu,  8 Sep 2022 09:40:35 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662630038;
        bh=9GtF7/yEBkr3DszkBXwjMPoNQDrMpR247woZPWbmsww=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=LyfdZKPLqAilUE8+7Lb8ALBPWP0h2R5x6S0KM7XTE+4UnWPLNbzpyVHjwOrRSIoPu
         7yMLfGRc2qw7EX7LJyNPN7IdPoWRpz4MnIhx1mHJmXh2BQFQvCfF1fU2JL82M7UaFz
         VBkjSfJYjyeDliIjBtH+/wzTl9HL0rMmZYnLmUa0+GAi9iuK2v5M4gL4BNqa54iFrg
         VzVK2J/0F/OFXOe19Rh2TXVgnGQMQZXmzqZXDCC1qUjDu9RIC8GXYi1BnLI3Yq4/Tk
         HtC3kMEkktQ4fWrUbrTg9dKqJmV5ncsIG+O46PlG3joVmvS6enFAuSXOjENDTI+AMV
         +OlfmxwomwQdw==
Message-ID: <c0c393cf-8f1a-b86e-db55-e493509dafd7@gnuweeb.org>
Date:   Thu, 8 Sep 2022 16:40:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20220906132829.417117002@linuxfoundation.org>
 <20220906132833.059733416@linuxfoundation.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH 5.19 086/155] drm/i915/reg: Fix spelling mistake
 "Unsupport" -> "Unsupported"
In-Reply-To: <20220906132833.059733416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/22 8:30 PM, Greg Kroah-Hartman wrote:
> From: Colin Ian King <colin.i.king@gmail.com>
> 
> [ Upstream commit 233f56745be446b289edac2ba8184c09365c005e ]
> 
> There is a spelling mistake in a gvt_vgpu_err error message. Fix it.
> 
> Fixes: 695fbc08d80f ("drm/i915/gvt: replace the gvt_err with gvt_vgpu_err")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Signed-off-by: Zhi Wang <zhi.a.wang@intel.com>
> Link: http://patchwork.freedesktop.org/patch/msgid/20220315202449.2952845-1-colin.i.king@gmail.com
> Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/i915/gvt/handlers.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
> index beea5895e4992..73e74a6a76037 100644
> --- a/drivers/gpu/drm/i915/gvt/handlers.c
> +++ b/drivers/gpu/drm/i915/gvt/handlers.c
> @@ -905,7 +905,7 @@ static int update_fdi_rx_iir_status(struct intel_vgpu *vgpu,
>   	else if (FDI_RX_IMR_TO_PIPE(offset) != INVALID_INDEX)
>   		index = FDI_RX_IMR_TO_PIPE(offset);
>   	else {
> -		gvt_vgpu_err("Unsupport registers %x\n", offset);
> +		gvt_vgpu_err("Unsupported registers %x\n", offset);
>   		return -EINVAL;
>   	}

I don't think this one is a stable material. How did this get picked up?

-- 
Ammar Faizi
