Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD87923C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfG2Reb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbfG2Reb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 13:34:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F307206DD;
        Mon, 29 Jul 2019 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564421670;
        bh=39evUAcSrSvfKfe9/QD/pwrA0wKQ04OygmMi8FdjU/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eBMSma+Rrtk44+AQg+TLQcURMHDT8sg+zEX7DXluY+gHtERMXTJX3AC4FzU8jD3nx
         dCzlwU8nERvDJidx/TY1RkOHt/FjrqxHjAYUXAksZQIuEai8ch1lXXnzKbca2r9nM9
         slkRBHhBKiE6NUW76HJ7R+rZeh1VfdtutuNHQoXw=
Date:   Mon, 29 Jul 2019 19:34:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saranya Gopal <saranya.gopal@intel.com>
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        fei.yang@intel.com, john.stultz@linaro.org
Subject: Re: [PATCH 4.19.y 0/3] usb: dwc3: Prevent requests from being queued
 twice
Message-ID: <20190729173427.GA19326@kroah.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 07:13:36PM +0530, Saranya Gopal wrote:
> With recent changes in AOSP, adb is now using asynchronous I/O.
> While adb works good for the most part, there have been issues with
> adb root/unroot commands which cause adb hang. The issue is caused
> by a request being queued twice. A series of 3 patches from
> Felipe Balbi in upstream tree fixes this issue.
> 
> Felipe Balbi (3):
>   usb: dwc3: gadget: add dwc3_request status tracking
>   usb: dwc3: gadget: prevent dwc3_request from being queued twice
>   usb: dwc3: gadget: remove req->started flag

I would like to get an ack from Felipe before I take these.

thanks,

greg k-h
