Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2045EC30A
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 14:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiI0MlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiI0Mk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 08:40:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CB8B4E9D;
        Tue, 27 Sep 2022 05:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BCE3B81B99;
        Tue, 27 Sep 2022 12:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9862DC433B5;
        Tue, 27 Sep 2022 12:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664282449;
        bh=f86Tzo1UuxVuSvOOrHf3105xrwBWh9OVOPklQbr/1kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Meeehbd1zhdJrnk7mOp1xsNBDgYIsjfSE+SjXNxG5fpaMIp/8NjQ3CwcmbM0PDUGk
         wB/Djbi5E1N0+d2RaYls0d3H+H2wTZkfBlJSG/uJT5OqtfobAszM2WK9L9J4+J++C6
         +D0TDNwSHhDiHS3dTzc4OQpkq8LEiQnuFJI2zhh8=
Date:   Tue, 27 Sep 2022 14:40:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wayne Chang <waynec@nvidia.com>
Cc:     heikki.krogerus@linux.intel.com, quic_linyyuan@quicinc.com,
        quic_jackp@quicinc.com, saranya.gopal@intel.com, tiwai@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] usb: typec: ucsi: Don't warn on probe deferral
Message-ID: <YzLvTgzMce9TDzDA@kroah.com>
References: <20220927122913.2642497-1-waynec@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927122913.2642497-1-waynec@nvidia.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 08:29:13PM +0800, Wayne Chang wrote:
> Deferred probe is an expected return value for fwnode_usb_role_switch_get().
> Given that the driver deals with it properly, there's no need to output a
> warning that may potentially confuse users.
> 
> Fixes: 3c162511530c ("usb: typec: ucsi: Wait for the USB role switches")
> Cc: stable@vger.kernel.org

Why is this a bugfix that needs to be backported?  The current code
works the same as what you are changing it to be, there's no functional
difference, right?

thanks,

greg k-h
