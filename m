Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23134656300
	for <lists+stable@lfdr.de>; Mon, 26 Dec 2022 15:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiLZOHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Dec 2022 09:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiLZOHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Dec 2022 09:07:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B47410A
        for <stable@vger.kernel.org>; Mon, 26 Dec 2022 06:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E83B80BE7
        for <stable@vger.kernel.org>; Mon, 26 Dec 2022 14:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35433C433EF;
        Mon, 26 Dec 2022 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672063616;
        bh=Vp1Gxgy8aLvVN6RcBm+WX5OTFGMNl28teaDAmCl1qbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tn6D7Pm8bTOWSB3Z821BU6g9RhR6NhaVobt3L3y/CHiWg2UIbi2w0qkIkqFtGrtUn
         FgXf7Yi2+aX6InDx28AXg2m68o3RELhHE9XZ/3lmPgiQtr5QQshBi9jOLMZh117/Qm
         Lqr2bH9CHVBtfvdSQkxTZkQCMGtEUMhwkxQb0j2wlhrMBvNJIv8vU69fjl4Utztfsl
         lYgJlMKZBN3PvZzOsUOv1FIzcAGnUhpx7wnke+W7zUxhZEbbPKf+wKWXTFrAR+3w4t
         7O/qfp2F0fHtFbGnOPPsw6Ds/DqWkz+sdK31hoKWLDqXt4wLpMRujxDrner/QLROep
         uCe9GBfZGC6yQ==
Date:   Mon, 26 Dec 2022 15:06:47 +0100
From:   Pratyush Yadav <pratyush@kernel.org>
To:     tkuw584924@gmail.com
Cc:     linux-mtd@lists.infradead.org, tudor.ambarus@linaro.org,
        michael@walle.cc, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mtd: spi-nor: sfdp: Fix index value for SCCR
 dwords
Message-ID: <20221226140647.ahnw4ag55ctp3kal@yadavpratyush.com>
References: <cover.1672026365.git.Takahiro.Kuwano@infineon.com>
 <d8a2a77c2c95cf776e7dcae6392d29fdcf5d6307.1672026365.git.Takahiro.Kuwano@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8a2a77c2c95cf776e7dcae6392d29fdcf5d6307.1672026365.git.Takahiro.Kuwano@infineon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/12/22 01:01PM, tkuw584924@gmail.com wrote:
> From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> 
> Array index for SCCR 22th DOWRD should be 21.
> 
> Fixes: 981a8d60e01f ("mtd: spi-nor: Parse SFDP SCCR Map")
> Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> Reviewed-by: Michael Walle <michael@walle.cc>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav
