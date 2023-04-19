Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FEC6E73F9
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjDSH1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjDSH1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1606E80
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 00:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C82B63BDC
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 07:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272FEC433EF;
        Wed, 19 Apr 2023 07:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681889227;
        bh=qBPs4oC4w1WBDc+Fi9gvrTzgv2/ZIaVa9SwRIdvOPhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BuAcu3n9XOrGnzRT0bX584PCwyZp/zQ30+wKAKeYUVBWytmUaBpNEqznDbbn2n5aw
         deew7TbcrNO2FHjJT9bqm7gaNdyxBbygDnB6OAlSSFx843ZEviojksrFL+PJo3b5FX
         EauNbMP9ASd5UZ0hhq766K+dP3AS7yPHfdc/iVU0=
Date:   Wed, 19 Apr 2023 09:27:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <2023041948-overthrow-debtor-289d@gregkh>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418-tactile-cocoa-4242e87bf994@wendy>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 02:10:54PM +0100, Conor Dooley wrote:
> On Tue, Apr 18, 2023 at 02:23:05PM +0200, Greg Kroah-Hartman wrote:
> > From: Alexandre Ghiti <alexghiti@rivosinc.com>
> > 
> > [ Upstream commit ef69d2559fe91f23d27a3d6fd640b5641787d22e ]
> 
> Hey Greg,
> 
> Please check out <e3a6656c-0ec4-9d54-b262-1af08c292ed5@microchip.com>
> (I can't find a lore link for stable-commit@vger stuff)
> as I am not sure whether it is okay to backport this in isolation.

I'm confused, what is needed to be done here?

thanks,

greg "drowning in email" k-h
