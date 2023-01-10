Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4888966451C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbjAJPnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbjAJPnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:43:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE79CE7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 07:43:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CBDCB80DD1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 15:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96A4C433EF;
        Tue, 10 Jan 2023 15:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673365386;
        bh=QNOMgMCCoCjkIw3bBJDiNn5KMbD5sNtHer+r5sKY1UQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KaI/Y8+qSg+RaKS+BhX7Xi0AKNzOZd5Iiu1RuUUKMPbanh4kdiHdZgzwWQv4NuuNR
         rCUqjXUnrw2DbXQkm8INv9dtTklgmAUmlclpnm+wS1H7A4vhkFE5jXQEBo0wU5mJ95
         SHECyPLscasMFkvohT27/z/FDKddQOuC1YXsEHfQ=
Date:   Tue, 10 Jan 2023 16:42:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [6.1 BACKPORT 0/2] drm/i915/dsi: two stable backports for 6.1
Message-ID: <Y72He1edpOlffu7F@kroah.com>
References: <20230105105227.689222-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105105227.689222-1-jani.nikula@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 12:52:25PM +0200, Jani Nikula wrote:
> Stable team, please pick up these two manual backports for 6.1 that
> failed to apply [1][2].
> 
> Thanks,
> Jani.
> 
> 
> [1] https://lore.kernel.org/r/167284704812263@kroah.com
> [2] https://lore.kernel.org/r/1672847059102181@kroah.com
> 
> 
> Jani Nikula (2):
>   drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence
>   drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index
> 
>  drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 94 +++++++++++++++++++-
>  drivers/gpu/drm/i915/i915_irq.c              |  3 +
>  drivers/gpu/drm/i915/i915_reg.h              |  1 +
>  3 files changed, 95 insertions(+), 3 deletions(-)
> 
> -- 
> 2.34.1
> 

Now queued up, thanks.

greg k-h
