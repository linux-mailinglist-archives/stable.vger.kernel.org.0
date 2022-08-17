Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC235596916
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 08:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbiHQGBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 02:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiHQGBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 02:01:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42777E814;
        Tue, 16 Aug 2022 23:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C20B81AD3;
        Wed, 17 Aug 2022 06:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935ACC433C1;
        Wed, 17 Aug 2022 06:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660716057;
        bh=gWyhQ2vSiY3PQDsc2PdJGtbgVKekpF295CaCysh1iv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2M9o6st8sa8fcPWhiVAkDuaEij9ALqXx9OFeqZBqBS5Za/mjTseMg24nLfeoNBayl
         fcR4MlMOgs0uX1kLl47wU8sCHO5VCdQeVnSbzxAkbJQTdAHrICXlNMtSh055bJYc3a
         L7pry/xmwZlFbeWtG+VM77DcRazJmFKgKm/9em/o=
Date:   Wed, 17 Aug 2022 08:00:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: typec: tcpm: Return ENOTSUPP for power supply
 prop writes
Message-ID: <YvyEFgh7oITvGB/n@kroah.com>
References: <20220816191150.1432166-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816191150.1432166-1-badhri@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 12:11:50PM -0700, Badhri Jagan Sridharan wrote:
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
> Fixes: e9e6e164ed8f6 ("usb: typec: tcpm: Support non-PD mode")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
> Changes since v1:
> - Add Fixes tag.
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 7 +++++++
>  1 file changed, 7 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
