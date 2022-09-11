Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1118E5B4D00
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 11:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiIKJbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 05:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIKJbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 05:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A793D25E99;
        Sun, 11 Sep 2022 02:31:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ED33B80AFD;
        Sun, 11 Sep 2022 09:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9DDC433C1;
        Sun, 11 Sep 2022 09:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662888676;
        bh=onrx/VfMWRlqA5VQAt3JkDr5rEpPhLtH56ehL+XsUmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=osLIxzE+0FD1Ft+iZT4rWvKoO3/F0gfUDsbzIPsgVR08sO9eqQE6JeSHcZBAhXxuv
         i26ZBqWOB5LcdikOEHB6dwlsBL1uLT568r6+4PXp29YkP78rJa7NjMQxeb+o4ZgW5b
         FRb1CdORknuycjgxtYYy7F0fb09dIcxTlaaBX98uRCdBlYx293qL4tlxRvsICH3SOS
         mvWe5nN9ZCnsHjAuVRepksGra7Fnb3G7V3oLgb0MXMpe9PAmuab7wAlikFXOzSkvPX
         sfotqljp2P3Hv8V+rfY3aJcq9fsBME1AMA4gmb+sqvYZCCy5Nvp4IxpmWsHELoGRLq
         zLlZBEUnfTq3Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oXJJD-0005c1-DD; Sun, 11 Sep 2022 11:31:23 +0200
Date:   Sun, 11 Sep 2022 11:31:23 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        srinivas.kandagatla@linaro.org, amahesh@qti.qualcomm.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 33/38] misc: fastrpc: increase maximum
 session count
Message-ID: <Yx2q6zgypevyXEto@hovoldconsulting.com>
References: <20220910211623.69825-1-sashal@kernel.org>
 <20220910211623.69825-33-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220910211623.69825-33-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 10, 2022 at 05:16:18PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit 689a2d9f9332a27b1379ef230396e944f949a72b ]
> 
> The SC8280XP platform uses 14 sessions for the compute DSP so increment
> the maximum session count.
> 
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220829080531.29681-4-johan+linaro@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

SC8280XP was not added until 6.0 so the stable tag was left out on
purpose (as usual).

Please drop.

> ---
>  drivers/misc/fastrpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
> index 93ebd174d8487..08032a207c1c0 100644
> --- a/drivers/misc/fastrpc.c
> +++ b/drivers/misc/fastrpc.c
> @@ -25,7 +25,7 @@
>  #define SDSP_DOMAIN_ID (2)
>  #define CDSP_DOMAIN_ID (3)
>  #define FASTRPC_DEV_MAX		4 /* adsp, mdsp, slpi, cdsp*/
> -#define FASTRPC_MAX_SESSIONS	13 /*12 compute, 1 cpz*/
> +#define FASTRPC_MAX_SESSIONS	14
>  #define FASTRPC_MAX_VMIDS	16
>  #define FASTRPC_ALIGN		128
>  #define FASTRPC_MAX_FDLIST	16

Johan
