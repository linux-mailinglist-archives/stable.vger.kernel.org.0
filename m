Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF97461386D
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 14:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiJaNxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 09:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJaNxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 09:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED6D1054C;
        Mon, 31 Oct 2022 06:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A418161234;
        Mon, 31 Oct 2022 13:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5920C433C1;
        Mon, 31 Oct 2022 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667224385;
        bh=L+f9q+7arbkRsu3om4S7s3pvQcwEFSDo9OD2UXdL+YI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVm6mCIoQSKHGVK0lw6agZNIgY/5U+amyGkJ1TWE6u/kIcOIGCR3AY8qge4B84BYb
         OhZD4ExqRb3YKG3ocrcwIDZ+5ArzkBt6wWRtbphEg/ceaQ/pIW70lXCc8IDkB/WmjP
         RDN2FEsOwIE9O57xKg7v+nyUwZOpO46xUVKq/1B/Fs8xccwhp5I2Ot+Kgji5LcdVsa
         PggXqSl8fCMh/1++kF7nFrBLsfKnxyFKp7n8/wh0Y9kxXp/0RwZOZz4VcMnxv8H+b3
         X2fe855JdpR+QWL05TrteDAUfq66l7SnlHjm/Q2Iz7xjxdvMrPufg3+nfZwOQmOnFA
         ofAhsByK0yccA==
Date:   Mon, 31 Oct 2022 13:52:59 +0000
From:   Lee Jones <lee@kernel.org>
To:     cy_huang <u0084500@gmail.com>
Cc:     matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mfd: mt6360: add bound check in regmap read/write
 function
Message-ID: <Y1/TO+mOrwjj3D33@google.com>
References: <1664416817-31590-1-git-send-email-u0084500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1664416817-31590-1-git-send-email-u0084500@gmail.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Sep 2022, cy_huang wrote:

> From: ChiYuan Huang <cy_huang@richtek.com>
> 
> Fix the potential risk for null pointer if bank index is over the maximum.
> 
> Refer to the discussion list for the experiment result on mt6370.
> https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-840-g3.rt/
> If not to check the bound, there is the same issue on mt6360.
> 
> Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/write)
> Cc: stable@vger.kernel.org
> Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
> ---
> Since v2:
> - Assign i2c bank variable after bank index is already checked.
> 
> ---
>  drivers/mfd/mt6360-core.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
