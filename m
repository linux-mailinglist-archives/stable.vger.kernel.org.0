Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D983A7886
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 09:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFOHzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 03:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhFOHzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 03:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D004861419;
        Tue, 15 Jun 2021 07:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623743579;
        bh=hR3i6WsZ4T5X2Tz2TzIiE15s3WyK8FTVskdsaWZbG6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbzGT52B4GScwZCC1azCtp9lOfIrVy+nUxFWT9tV5xV/ZW8n274gHwSzWnQkDWGU8
         jP+xRKellkrcYOmxwVJvKRjZ47pmUtZZBXntICSnjwkWbHq50RrE9zJkdeKzhQD86y
         LSa+u9njZC+Oa4UEeJrtBQLGbxG+oT3n6sMGOFf/DcMNYX923aqXMExWDQJOFGLird
         BS+ThgBeMUtb9tbJ7LhsMYwKT0DNhR3dqlMbQwG5teMriphkE+W7mhEryMbTbENJ9Y
         ZsalG8CXZpt3C/U1svxNZn9vDDPabaHPP4ErrI92zqAQweEB5G+h5QfZdJ8BH3BaKD
         a5gY8jf4Qghrg==
Date:   Tue, 15 Jun 2021 13:22:55 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Moritz Fischer <mdf@kernel.org>, maz@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: [PATCH] usb: renesas-xhci: Fix handling of unknown ROM state
Message-ID: <YMhcV39CtSx0F45o@vkoul-mobl>
References: <20210615022514.245274-1-mdf@kernel.org>
 <YMhTddYjJwDcNau/@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMhTddYjJwDcNau/@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15-06-21, 09:15, Greg KH wrote:
> On Mon, Jun 14, 2021 at 07:25:14PM -0700, Moritz Fischer wrote:
> > If the ROM status returned is unknown (RENESAS_ROM_STATUS_NO_RESULT)
> > we need to attempt loading the firmware rather than just skipping
> > it all together.
> 
> How can this happen?  Can you provide more information here?

Sometimes ROM load seems to return unknown status, this helps in those
cases by doing attempting RAM load. The status should be success of
fail, here it is neither :(

I have tested this on 96 boards RB3 on a loaded ROM device as well as
ROM erased one. Works good and is improvement in the cases where ROM
status is 'unknown'


Tested-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
