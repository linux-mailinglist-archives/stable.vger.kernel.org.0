Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F76675081
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 10:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjATJRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 04:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjATJRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 04:17:03 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E5B8F6F3;
        Fri, 20 Jan 2023 01:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674206203; x=1705742203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r/1tiYxPstme1YYSjB4HLjWOG3ITg0Qj8zbeObqH0Nw=;
  b=cI8SJdEklAc5w1ocZNAYUZZ40CbNq6rRfoEjV2ZpR5vQY/xN8F9kSQMW
   noEDj77o2JeegfEd1Rd71M1X/AO1us5dnkURHJ/WERFp52vp8xE5DBkMu
   LDsabtCs2iDfs9IgbkOYcoPpF9nOEiKB537S/TrnFh+z+37ycqi1leBfE
   Yj7FRl3XFTzPC+A24NbDOJ6uvsY9/GRaFw3aiSZoCUUgAPlb9YwHSue+D
   GzsNVPihFht93NNfNU55W3N7dKrwLN79bsIAVQUbQ1Mmh0e/MYYM/fTMX
   9oXG2A3/fFkU/c4lFYcPwIcRfAD6Ylb3/aCxmtvE9sDAzt0woi5V9NU4/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305214952"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="305214952"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 01:16:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="803014429"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="803014429"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 20 Jan 2023 01:16:41 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 20 Jan 2023 11:16:40 +0200
Date:   Fri, 20 Jan 2023 11:16:40 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Update active state
Message-ID: <Y8pb+BTd7VJqwLzq@kuha.fi.intel.com>
References: <20230118031514.1278139-1-pmalani@chromium.org>
 <Y8e+YlKiC6FHdQ5s@kuha.fi.intel.com>
 <CACeCKafPzxYWh5a4xmeggc+4zRou73kHnwV-G5xMfQDheGgGdg@mail.gmail.com>
 <Y8kMsw/wT35KN7VK@kuha.fi.intel.com>
 <CACeCKaceu1KCPtpavBn23qyM29Eacxhm6L9SN78ZQxdzRCOk6Q@mail.gmail.com>
 <CACeCKaea_ZtzUZNAHMaDU9ff_BBs6sF_DqqMnkFcW_=_txVL4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACeCKaea_ZtzUZNAHMaDU9ff_BBs6sF_DqqMnkFcW_=_txVL4w@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 02:12:20AM -0800, Prashant Malani wrote:
> On Thu, Jan 19, 2023 at 1:55 AM Prashant Malani <pmalani@chromium.org> wrote:
> >
> > On Thu, Jan 19, 2023 at 1:26 AM Heikki Krogerus
> > <heikki.krogerus@linux.intel.com> wrote:
> > >
> > > Hi Prashant,
> > >
> > > On Wed, Jan 18, 2023 at 10:26:21AM -0800, Prashant Malani wrote:
> > > > Hi Heikki,
> > > >
> > > > Thanks for reviewing the patch.
> > > >
> > > > On Wed, Jan 18, 2023 at 1:39 AM Heikki Krogerus
> > > > <heikki.krogerus@linux.intel.com> wrote:
> > > > >
> > > > > On Wed, Jan 18, 2023 at 03:15:15AM +0000, Prashant Malani wrote:
> > > > FWIW, I think we can make the typec_altmode_update_active() calls from
> > > > our (cros-ec-typec) port driver too, but displayport.c is parsing the header
> > > > anyway, so it seemed repetitive. Just wanted to clarify the intention here.
> > >
> > > The alt modes may have been entered even if there are no drivers for
> > > them, if for example the PD controller handles the mode entry. In
> > > those cases the port driver needs to update the active state of the
> > > partner alt mode.
> >
> > Ack. Thanks for explaining the rationale here.
> >
> > >
> > > Since the port drivers have to handle that in some cases, for the sake
> > > of consistency I thought that they might as well take care of it in
> > > every case.
> > >
> > > On the other hand, it should be safe to do it in both the port driver
> > > and the altmode driver.
> > >
> > > If you prefer that the altmode drivers always do this, I'm not against
> > > it. But in that case could you patch tcpm.c while at it - in the same
> > > series:
> >
> > Sure, I will send out a v2 with the below diff as Patch 2/2 (I will mark you as
> > "Suggested-by" but as always LMK if you prefer another way to
> > denote attribution).
> >
> > >
> > > diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> > > index 904c7b4ce2f0c..0f5a9d4db105a 100644
> > > --- a/drivers/usb/typec/tcpm/tcpm.c
> > > +++ b/drivers/usb/typec/tcpm/tcpm.c
> > > @@ -1693,14 +1693,11 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
> > >                         }
> > >                         break;
> > >                 case CMD_ENTER_MODE:
> > > -                       if (adev && pdev) {
> > > -                               typec_altmode_update_active(pdev, true);
> > > +                       if (adev && pdev)
> > >                                 *adev_action = ADEV_QUEUE_VDM_SEND_EXIT_MODE_ON_FAIL;
> > > -                       }
> > >                         return 0;
> > >                 case CMD_EXIT_MODE:
> > >                         if (adev && pdev) {
> > > -                               typec_altmode_update_active(pdev, false);
> > >                                 /* Back to USB Operation */
> > >                                 *adev_action = ADEV_NOTIFY_USB_AND_QUEUE_VDM;
> > >                                 return 0;
> > >
> > > That's the only driver that will definitely always requires the
> > > altmode drivers, so perhaps it would be good to drop the calls
> > > from it at the same time.
> 
> On 2nd thought, would it be safe to drop the calls in tcpm.c ? Following
> on from your PD controller example above, TCPM might be updating
> the active state for an altmode which doesn't have an altmode driver
> registered? Or does it only send out ENTER_MODE for alt modes
> which have an altmode driver?
> 
> (Sorry if this is obvious to TCPM users, but I wanted to confirm before
> proceeding with a v2).

It's not be possible to enter a mode with tcpm.c unless there is
a driver for the altmode currently. Something has to take care of the
altmode, and if that something is not the altmode driver it would need
to be the user space. Right now we don't have an interface for that.

In any case, if there's no driver for the altmode, then the partner
altmode "active" file should not be visible.

thanks,

-- 
heikki
