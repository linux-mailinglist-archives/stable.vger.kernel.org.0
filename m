Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9732D4E8F13
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbiC1HhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238832AbiC1HhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:37:17 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF152E08;
        Mon, 28 Mar 2022 00:35:36 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 996C322205;
        Mon, 28 Mar 2022 09:35:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648452932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KxoefHxHBWO4b2r56J13guP4925DtgDpQm/mM3H3NHE=;
        b=tuCU6rLPvYS4HLC6WvfjKQhqUDH665lXMWAlcV1ZvVcUAxENEnflPFcNuuyc8aht4cF0vD
        529FsUN8ktrT/KN6OUFARNq6IWFO3IOSOrMfmo/KVQdtdMYJgCPuDK23RHAPYVTLxUtwJA
        nX3RJqpEHGTwMkah0v+hJrkIuvorQTU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Mar 2022 09:35:30 +0200
From:   Michael Walle <michael@walle.cc>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
In-Reply-To: <20220303161724.3324948-1-michael@walle.cc>
References: <20220303161724.3324948-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <5673a4be5ac51d19529366c48afceb8c@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Am 2022-03-03 17:17, schrieb Michael Walle:
> The supplied buffer might be on the stack and we get the following 
> error
> message:
> [    3.312058] at91_i2c e0070600.i2c: rejecting DMA map of vmalloc 
> memory
> 
> Use i2c_{get,put}_dma_safe_msg_buf() to get a DMA-able memory region if
> necessary.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>

Any news here?

> ---
> 
> I'm not sure if or which Fixes: tag I should add to this patch. The 
> issue
> seems to be since a very long time, but nobody seem to have triggered 
> it.
> FWIW, I'm using the sff,sfp driver, which triggers this.

-michael
