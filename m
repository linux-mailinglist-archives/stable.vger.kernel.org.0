Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79548603A30
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 08:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJSG4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 02:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJSGz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 02:55:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E27774CD8;
        Tue, 18 Oct 2022 23:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F9261770;
        Wed, 19 Oct 2022 06:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FAFC433D6;
        Wed, 19 Oct 2022 06:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666162558;
        bh=60gEc3RgEwOlMqkL2MQmnLX+69yH4/JmuY0w5uGeb2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IHnFJTia4HWiYFoYeyMCXsdfR9ZTil/XnvHMZR6opKb/xENge1mcrLXB+BW+8I5zY
         ucZZh5k4lgS5kwFVPKasvtGjUB0EUioQ6Ew/zoMeXyt0YEhlsi7J2TkNzt1x6tTqbS
         to0lakJx/A3cacNQz1ZYy8bEIsBJ0caGCH83Y2Xc=
Date:   Wed, 19 Oct 2022 08:55:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        ville.syrjala@linux.intel.com
Subject: Re: v5.19 & v6.0 stable backport request
Message-ID: <Y0+fex0i0vmBL6QX@kroah.com>
References: <87k04xiedr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k04xiedr.fsf@intel.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 02:02:08PM +0300, Jani Nikula wrote:
> 
> Hello stable team, please backport these two commits to stable kernels
> v5.19 and v6.0:
> 
> 4e78d6023c15 ("drm/i915/bios: Validate fp_timing terminator presence")

Does not apply to 5.19.y, can you provide a working backport?

> d3a7051841f0 ("drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers")

Queued up to both trees now, thanks.

greg k-h
