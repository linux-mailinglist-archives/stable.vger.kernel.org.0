Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE6544BFB
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 14:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiFIM2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 08:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiFIM2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 08:28:53 -0400
Received: from sonata.ens-lyon.org (domu-toccata.ens-lyon.fr [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5093F13F32;
        Thu,  9 Jun 2022 05:28:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id 61E4B2015C;
        Thu,  9 Jun 2022 14:28:45 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K-HSDGkridoK; Thu,  9 Jun 2022 14:28:45 +0200 (CEST)
Received: from begin (ip-185-104-137-33.ptr.icomera.net [185.104.137.33])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 948A620157;
        Thu,  9 Jun 2022 14:28:44 +0200 (CEST)
Received: from samy by begin with local (Exim 4.95)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1nzHHD-00DgPa-Cr;
        Thu, 09 Jun 2022 14:28:39 +0200
Date:   Thu, 9 Jun 2022 14:28:39 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        trix@redhat.com, salah.triki@gmail.com, speakup@linux-speakup.org
Subject: Re: [PATCH AUTOSEL 5.18 31/68] accessiblity: speakup: Add missing
 misc_deregister in softsynth_probe
Message-ID: <20220609122839.35vn5vtukmuuxch3@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        trix@redhat.com, salah.triki@gmail.com, speakup@linux-speakup.org
References: <20220607174846.477972-1-sashal@kernel.org>
 <20220607174846.477972-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220607174846.477972-31-sashal@kernel.org>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin, le mar. 07 juin 2022 13:47:57 -0400, a ecrit:
> From: Zheng Bin <zhengbin13@huawei.com>
> 
> [ Upstream commit 106101303eda8f93c65158e5d72b2cc6088ed034 ]
> 
> softsynth_probe misses a call misc_deregister() in an error path, this
> patch fixes that.
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> Link: https://lore.kernel.org/r/20220511032937.2736738-1-zhengbin13@huawei.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/accessibility/speakup/speakup_soft.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/accessibility/speakup/speakup_soft.c b/drivers/accessibility/speakup/speakup_soft.c
> index 19824e7006fe..786dc5d080f3 100644
> --- a/drivers/accessibility/speakup/speakup_soft.c
> +++ b/drivers/accessibility/speakup/speakup_soft.c
> @@ -397,6 +397,7 @@ static int softsynth_probe(struct spk_synth *synth)
>  	synthu_device.name = "softsynthu";
>  	synthu_device.fops = &softsynthu_fops;
>  	if (misc_register(&synthu_device)) {
> +		misc_deregister(&synth_device);
>  		pr_warn("Couldn't initialize miscdevice /dev/softsynthu.\n");
>  		return -ENODEV;
>  	}
> -- 
> 2.35.1
> 

-- 
Samuel
---
Pour une évaluation indépendante, transparente et rigoureuse !
Je soutiens la Commission d'Évaluation de l'Inria.
