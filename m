Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A13867C4F3
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 08:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjAZHig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 02:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZHif (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 02:38:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1347065F1D
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 23:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21AF6173C
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 07:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0591FC433D2;
        Thu, 26 Jan 2023 07:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674718714;
        bh=h1uRdpSWZwWAYXYd7iQ3eVvFqrgRrVqKt8id9xyxMzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PmIT0hx4EL/9kFJtpQYVruDKKf3AniHc7ngey9cvL6LC8QncTghtiLpASDbNMba9P
         19NVgkglJUVXEEg6I8PeakiFAJFD4V+yvl2ZNzg486+ruVA/z1Gs4qwYcI1kPboZoU
         Kz6yeGm5eGC5KJsysDM8c+MwCCgwJLVk+WuBCjQIeKdlw5k7rfND6gOt33WqLJFpHA
         bRVH6pJPBfI074ppd/G5/ljMaf1x1so6ZHO8Oe47BMLoc3HEqmeIItkKAYSjmTwA90
         tVbWZTu0jo3MpfiwVwW1cvjeKXICU1ncXPvAXODVbQqbGicxMI6t+bpq9Ke7MOc9Wq
         TTg0T4NrVl42g==
Date:   Thu, 26 Jan 2023 15:38:27 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@denx.de>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx7d-smegw01: Fix USB host over-current
 polarity
Message-ID: <20230126073826.GW20713@T480>
References: <20230117112510.109123-1-festevam@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117112510.109123-1-festevam@denx.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 08:25:10AM -0300, Fabio Estevam wrote:
> Currently, when resetting the USB modem via AT commands, the modem is
> no longer re-connected.
> 
> This problem is caused by the incorrect description of the USB_OTG2_OC
> pad. It should have pull-up enabled, hysteresis enabled and the
> property 'over-current-active-low' should be passed.
> 
> With this change, the USB modem can be successfully re-connected
> after a reset.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9ac0ae97e349 ("ARM: dts: imx7d-smegw01: Add support for i.MX7D SMEGW01 board")
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Applied, thanks!
