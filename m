Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA01B4637
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 15:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgDVN1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 09:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgDVN1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 09:27:05 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23272077D;
        Wed, 22 Apr 2020 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587562024;
        bh=EStC+e224USPml60fEuabjPmVmE23vZuJdCyYb6bp6U=;
        h=Date:From:To:To:To:Cc:Cc:cc:Cc:Subject:In-Reply-To:References:
         From;
        b=m/2kehT1L2uLP8M9Xh+P2Hj40NBBWfHn7zd9WtiaW6mqq290LZzkLK9y7qpPLfbPM
         7jy+kQkj870lXmHbkRfABlQ8wVLAwaks+1vcUp6HH1KSCBy9eA1P55Hp+MA/vn3/r0
         vhTyGnTE679W/YIB4IfyYYgL6ApQagvCyuezfAto=
Date:   Wed, 22 Apr 2020 13:27:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>
Cc:     <stable@vger.kernel.org>
cc:     Jeremy Compostella <jeremy.compostella@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] xhci: Fix handling halted endpoint even if endpoint ring appears empty
In-Reply-To: <20200421140822.28233-2-mathias.nyman@linux.intel.com>
References: <20200421140822.28233-2-mathias.nyman@linux.intel.com>
Message-Id: <20200422132703.F23272077D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.5, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.

v5.6.5: Build OK!
v5.4.33: Build OK!
v4.19.116: Failed to apply! Possible dependencies:
    ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")

v4.14.176: Failed to apply! Possible dependencies:
    15febf5eede9 ("xhci: refactor xhci_urb_enqueue a bit with minor changes")
    66a4550308b8 ("xhci: Convert timers to use timer_setup()")
    ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
    f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")

v4.9.219: Failed to apply! Possible dependencies:
    0b6c324c8b60 ("xhci: cleanup and refactor process_ctrl_td()")
    0ce5749959c6 ("xhci: add trb_is_noop() helper function")
    217491487c43 ("xhci: Add support for endpoint soft reset")
    30a65b45bfb1 ("xhci: cleanup and refactor process_bulk_intr_td()")
    3495e451d137 ("xhci: use trb helper functions when possible")
    52ab86852f74 ("xhci: remove extra URB_SHORT_NOT_OK checks in xhci, core handles most cases")
    5eee4b6b4f57 ("xhci: support calling cleanup_halted_endpoint with soft retry")
    a37c3f76e6a6 ("usb: host: xhci: make a generic TRB tracer")
    d36374fdfb25 ("xhci: cleanup virtual endoint structure, remove stopped_stream")
    f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
    f97c08ae329b ("xhci: rename endpoint related trb variables")

v4.4.219: Failed to apply! Possible dependencies:
    0b6c324c8b60 ("xhci: cleanup and refactor process_ctrl_td()")
    0ce5749959c6 ("xhci: add trb_is_noop() helper function")
    2251198bef42 ("xhci: clean up event ring checks from inc_enq()")
    2d98ef406f17 ("xhci: use and add separate function for checking for link trbs")
    30a65b45bfb1 ("xhci: cleanup and refactor process_bulk_intr_td()")
    3495e451d137 ("xhci: use trb helper functions when possible")
    474ed23a6257 ("xhci: align the last trb before link if it is easily splittable.")
    52ab86852f74 ("xhci: remove extra URB_SHORT_NOT_OK checks in xhci, core handles most cases")
    5eee4b6b4f57 ("xhci: support calling cleanup_halted_endpoint with soft retry")
    d2510342fe93 ("usb: xhci: merge xhci_queue_bulk_tx and queue_bulk_sg_tx functions")
    d36374fdfb25 ("xhci: cleanup virtual endoint structure, remove stopped_stream")
    f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
    f97c08ae329b ("xhci: rename endpoint related trb variables")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
