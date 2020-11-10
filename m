Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7842AD5D3
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 13:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKJMD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 07:03:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:44164 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJMD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 07:03:59 -0500
IronPort-SDR: vnxBIKF0S4L7GIHG3/DB9U90M5R1c6vq21nChHVPj0HdTnrMtyxn/klrTGaigzS+z+2dMH6kLT
 cpFlBYkQQuww==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170070520"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="170070520"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 04:03:58 -0800
IronPort-SDR: KmulQIJO9DK9/Y32VxVYGiIymlL4Z4udLKzKDUQA8Vr2BUZaEBI7qBs96iz6wt6hh0bnkj3jCA
 zmMmld2hezog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="428345800"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 10 Nov 2020 04:03:55 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 10 Nov 2020 14:03:55 +0200
Date:   Tue, 10 Nov 2020 14:03:55 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Benjamin Berg <bberg@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, Vladimir Yerilov <openmindead@gmail.com>
Subject: Re: [PATCH] usb: typec: ucsi: Report power supply changes
Message-ID: <20201110120355.GJ1224435@kuha.fi.intel.com>
References: <20201110103350.16397-1-heikki.krogerus@linux.intel.com>
 <X6p47IJA7T1RlENp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X6p47IJA7T1RlENp@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 12:26:36PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 10, 2020 at 01:33:50PM +0300, Heikki Krogerus wrote:
> > When the ucsi power supply goes online/offline, and when the
> > power levels change, the power supply class needs to be
> > notified so it can inform the user space.
> > 
> > Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
> > Cc: stable@vger.kernel.org
> > Reported-by: Vladimir Yerilov <openmindead@gmail.com>
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> No tested-by tags?

Sorry Greg. I'll resend.

-- 
heikki
