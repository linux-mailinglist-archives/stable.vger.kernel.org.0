Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F6C54E183
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbiFPNLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiFPNLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:11:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5132D26113
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 06:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D418A61BD4
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D721BC34114;
        Thu, 16 Jun 2022 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655385058;
        bh=hnZSziAZ6En32znBq3fvsw9+LUpeKSQ2z2jYgRJvYKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q740XyX74DgKfswDqWwdriejG4O7UPkXiMBdtSPDOiMfyQZN4fn2uqvWFEO0gsKaJ
         SHChQJUNs/8yVPuoVHYNm2KFTdoeML2oeyhOW6RF+Bqn8VB2puPhyOMtPOBMHirCNm
         9C1bpsm86Z4RIoL3zgz+GrWubIZSBlW9WHhkIEIA=
Date:   Thu, 16 Jun 2022 15:10:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3
Message-ID: <Yqsr2jluBHsREWAv@kroah.com>
References: <CAHCN7x+XOObNu=Hemz+B3gP8c5-sGu28goSw-=yPH1b5B_KwUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7x+XOObNu=Hemz+B3gP8c5-sGu28goSw-=yPH1b5B_KwUQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 08:57:44AM -0500, Adam Ford wrote:
> Please port 4ce01ce36d77 ("arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3")
> to 5.10+
> 
> This fixes an issue where attempting to use hardware handshaking on
> the DB9 port fails.

Now queued up, thanks.

greg k-h
