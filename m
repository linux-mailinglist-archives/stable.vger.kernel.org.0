Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9749A4FBD36
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346513AbiDKNgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346531AbiDKNgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:36:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD162A180;
        Mon, 11 Apr 2022 06:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70EF960B9C;
        Mon, 11 Apr 2022 13:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B146C385AA;
        Mon, 11 Apr 2022 13:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649684076;
        bh=T15d2lZIS7swr10X+ACZq35v4lVQuqNfhmMmHgFlVEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fxmI5vEYYGnZz+aTsqRn57VN3tuLDQmmAyMmtcX7SdQiH8i6Q2n+Y1c5j9tpfIhQB
         3zGtY7Gm4oHSlKlsMhFZ93w5VIuXOQG74WifgOtVxSJF11/lmHbiYPQaotDACMtKMP
         +i05rnnYY0+oNsCFhFS+Zt8+mMEQMBoKCiZoTfoD1GO/gK/DazWCr8FP6FAAYWuQOY
         K2GtGBpIT0er7smCTtzg9FjNLDv4GIJQ783svxSVro7e4NskBw/a1UbfoxYcKb6ILa
         yHuTrMjtMglM68iK1JeQlQUYneRRhrgPLB5/bsEyIj52vENWWisyO3BTxb4ifCdaFS
         vlSRyr/kIG2TQ==
Date:   Mon, 11 Apr 2022 19:04:32 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     ludovic.desroches@microchip.com, tudor.ambarus@microchip.com,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dma: at_xdmac: fix a missing check on list iterator
Message-ID: <YlQuaFjt9TxlutRH@matsya>
References: <20220327061154.4867-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327061154.4867-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27-03-22, 14:11, Xiaomeng Tong wrote:
> The bug is here:
> 	__func__, desc, &desc->tx_dma_desc.phys, ret, cookie, residue);
> 
> The list iterator 'desc' will point to a bogus position containing
> HEAD if the list is empty or no element is found. To avoid dev_dbg()
> prints a invalid address, use a new variable 'iter' as the list
> iterator, while use the origin variable 'desc' as a dedicated
> pointer to point to the found element.

Applied, thanks

-- 
~Vinod
