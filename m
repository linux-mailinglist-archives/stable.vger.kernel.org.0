Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BA351450F
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 11:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiD2JJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 05:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352838AbiD2JIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 05:08:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391BF4DF5A;
        Fri, 29 Apr 2022 02:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF99621FC;
        Fri, 29 Apr 2022 09:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CE7C385A4;
        Fri, 29 Apr 2022 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651223131;
        bh=TEUSeY6QOpRIp8RvXU7xeSEczkGUXMIRMG4kLddbXcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TaP5y+lrGaw7OPGPN6F3BUuowAD3MwgoQSdd8Pc28NGb+cgSdIKmo/n2bNHO340n3
         rdN4LdtjoDU2baZ482zVFvOraIZXVaoe7aOcX9BYbNmZqJLImhvVId9/FGT4rFXZ1Y
         yXTZuzeH9jfMsfSpSc6V+6npvYfrVhI8O1NM+XkU=
Date:   Fri, 29 Apr 2022 11:05:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     stable@vger.kernel.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 5.15 0/2] ARM: socfpga: fix broken QuadSPI support
Message-ID: <YmuqWLwyO2s/+FJf@kroah.com>
References: <20220427105407.40167-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427105407.40167-1-abbotti@mev.co.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022 at 11:54:05AM +0100, Ian Abbott wrote:
> Write support on the Cadence QSPI controller on the Intel SoCFPGA
> platform was broken by 9cb2ff111712 ("spi: cadence-quadspi: Disable
> Auto-HW polling) and fixed by 98d948eb8331 ("spi: cadence-quadspi: fix
> write completion support") and 36de991e9390 ("ARM: dts: socfpga: change
> qspi to "intel,socfpga-qspi").
> 
> 1) spi: cadence-quadspi: fix write completion support
> 2) ARM: dts: socfpga: change qspi to "intel,socfpga-qspi"
> 
>  arch/arm/boot/dts/socfpga.dtsi                    |  2 +-
>  arch/arm/boot/dts/socfpga_arria10.dtsi            |  2 +-
>  arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi |  2 +-
>  arch/arm64/boot/dts/intel/socfpga_agilex.dtsi     |  2 +-
>  drivers/spi/spi-cadence-quadspi.c                 | 24 ++++++++++++++++++++---
>  5 files changed, 25 insertions(+), 7 deletions(-)
> 

Both now queued up, thanks.

greg k-h
