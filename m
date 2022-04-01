Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7BA4EEC9C
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 13:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbiDALyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345645AbiDALyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 07:54:02 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA8D270874;
        Fri,  1 Apr 2022 04:52:13 -0700 (PDT)
Received: from [10.172.67.16] (1.general.hwang4.us.vpn [10.172.67.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7F5203F73A;
        Fri,  1 Apr 2022 11:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648813926;
        bh=EKknFNDPYnENQWgURsiV6MplF6BX+lU9qY7AxtYIw54=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=GKakZYUZYKvNzK2kxNDUB8cSchLqeFIvtvgN9EDmgpvnSuJ+TwMCFzJ8eNwezCaiy
         LYp0XNrywWVDMrnwX2CEYsgX3A6TYiOscpwtAQc/IZ6l9W4cU3XFgNxQg+/+qoOSNt
         ZTd9A/GF9szkMRXUeHt72z4YzVYJcZp2UOQk/JMwQQPO5Npo7CpW0zVEG4pGFab60J
         eXLhofqKnSxApYO4TkpjMMaiB0YvRvrpABNVAl+d6IapjvNfWCIW29IlS48r9UVyEo
         qabt3sq7+uc8ciW/sxCclAjCClZLPA5WxXuQXN9FDwFQA95ECocG4rooisJlFPsiJy
         U4FF6FRIo5oLA==
Message-ID: <5d0c62ac-0c43-c8d9-4812-d4ddbfb5b225@canonical.com>
Date:   Fri, 1 Apr 2022 19:51:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Patch "serial: sc16is7xx: Clear RS485 bits in the shutdown" has
 been added to the 4.9-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable-commits@vger.kernel.org, Stable <stable@vger.kernel.org>
References: <1648809520213199@kroah.com>
From:   Hui Wang <hui.wang@canonical.com>
In-Reply-To: <1648809520213199@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Sorry, please don't apply the patch to stable kernels. I tried to add 
"linux,rs485-enabled-at-boot-time" support for this driver yesterday and 
found this patch is not correct, I will send a patch to revert this 
patch from the mainline kernel.

Thanks,

Hui.

On 4/1/22 18:38, gregkh@linuxfoundation.org wrote:
> This is a note to let you know that I've just added the patch titled
>
>      serial: sc16is7xx: Clear RS485 bits in the shutdown
>
> to the 4.9-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>       serial-sc16is7xx-clear-rs485-bits-in-the-shutdown.patch
> and it can be found in the queue-4.9 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
> >From 927728a34f11b5a27f4610bdb7068317d6fdc72a Mon Sep 17 00:00:00 2001
> From: Hui Wang <hui.wang@canonical.com>
> Date: Tue, 8 Mar 2022 19:00:42 +0800
> Subject: serial: sc16is7xx: Clear RS485 bits in the shutdown
>
> From: Hui Wang <hui.wang@canonical.com>
>
> commit 927728a34f11b5a27f4610bdb7068317d6fdc72a upstream.
>
> We tested RS485 function on an EVB which has SC16IS752, after
> finishing the test, we started the RS232 function test, but found the
> RTS is still working in the RS485 mode.
>
> That is because both startup and shutdown call port_update() to set
> the EFCR_REG, this will not clear the RS485 bits once the bits are set
> in the reconf_rs485(). To fix it, clear the RS485 bits in shutdown.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> Link: https://lore.kernel.org/r/20220308110042.108451-1-hui.wang@canonical.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/tty/serial/sc16is7xx.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> --- a/drivers/tty/serial/sc16is7xx.c
> +++ b/drivers/tty/serial/sc16is7xx.c
> @@ -1055,10 +1055,12 @@ static void sc16is7xx_shutdown(struct ua
>   
>   	/* Disable all interrupts */
>   	sc16is7xx_port_write(port, SC16IS7XX_IER_REG, 0);
> -	/* Disable TX/RX */
> +	/* Disable TX/RX, clear auto RS485 and RTS invert */
>   	sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
>   			      SC16IS7XX_EFCR_RXDISABLE_BIT |
> -			      SC16IS7XX_EFCR_TXDISABLE_BIT,
> +			      SC16IS7XX_EFCR_TXDISABLE_BIT |
> +			      SC16IS7XX_EFCR_AUTO_RS485_BIT |
> +			      SC16IS7XX_EFCR_RTS_INVERT_BIT,
>   			      SC16IS7XX_EFCR_RXDISABLE_BIT |
>   			      SC16IS7XX_EFCR_TXDISABLE_BIT);
>   
>
>
> Patches currently in stable-queue which might be from hui.wang@canonical.com are
>
> queue-4.9/serial-sc16is7xx-clear-rs485-bits-in-the-shutdown.patch
