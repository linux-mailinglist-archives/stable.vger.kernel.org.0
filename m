Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1524595399
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiHPHTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiHPHT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:19:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD9A312F5E;
        Mon, 15 Aug 2022 21:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 112E76123B;
        Tue, 16 Aug 2022 04:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884CEC433D7;
        Tue, 16 Aug 2022 04:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660625554;
        bh=GE52hG4m2Wbk4kwiM1hwpls8Mi0EjJtP8LLC42lj3Rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVrqc6ohjA38jANmJ6jP0l1mlldINfu8EUQr842wVtm01mYuGm119krD5gh6un0uV
         Qh0jM2BHrfiQM0mUWRn5zmz0Me+9xD0aoUbZJpxp8jVCkyeIMngQsD9ndpvxGx2cQG
         EJAqVbu8QQodyBP5A6ZGzy8y0DEAuhxBblUU4J4c=
Date:   Tue, 16 Aug 2022 06:52:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpm: Return ENOTSUPP for power supply
 prop writes
Message-ID: <YvsijinxfEllAo41@kroah.com>
References: <20220816033355.1259400-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816033355.1259400-1-badhri@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 08:33:55PM -0700, Badhri Jagan Sridharan wrote:
> When the port does not support USB PD, prevent transition to PD
> only states when power supply property is written. In this case,
> TCPM transitions to SNK_NEGOTIATE_CAPABILITIES
> which should not be the case given that the port is not pd_capable.
> 
> [   84.308251] state change SNK_READY -> SNK_NEGOTIATE_CAPABILITIES [rev3 NONE_AMS]
> [   84.308335] Setting usb_comm capable false
> [   84.323367] set_auto_vbus_discharge_threshold mode:3 pps_active:n vbus:5000 ret:0
> [   84.323376] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_WAIT_CAPABILITIES [rev3 NONE_AMS]
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
