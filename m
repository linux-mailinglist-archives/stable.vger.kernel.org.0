Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77D37973C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 20:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhEJSzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 14:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhEJSzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 14:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDCFE6146E;
        Mon, 10 May 2021 18:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620672872;
        bh=hcJj9wI94n+fh4b9JbfuXG4ZZ/M25oCQZhPJRFVwtQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cf24HuOvhTgV7T2HoPgEkn/khWVueR50PDxSmE/S/RjcbYTp/PK1H1EwN0gw8T7Yx
         ePml+I4K5Ii1G4hUfEMcgm4Rxndi05wNyxO61pzjCasLgDlljOslUoC4uP/C1C08hn
         p2bn6XgBpCFV6Umwn8KYOdsKHZtTKQlb7rsOXdzw1GNgf2Y8GBhzQNhiRAOfYXo+ib
         +QJv79RpM87t/hGu1eBNNSizDqM1P5lYZPjtatumLfZT2ohsN3WteuIXwYqoQJiLft
         eByTetnOaiWjIR1YwJJ/uARJTNu8VlNssiPbUx2KgeEcGbQrPU9WbyAwO+qnR6oyLy
         4gWkz8T3n26fw==
Date:   Mon, 10 May 2021 13:54:30 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Jim Quinlan <jim2101024@gmail.com>,
        Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        linux-pci@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        bcm-kernel-feedback-list@broadcom.com, james.quinlan@broadcom.com,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/3] reset: add missing empty function
 reset_control_rearm()
Message-ID: <20210510185430.GA2291123@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b163b400b046d74967d5e773fc6959281a376d68.camel@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 09:45:54AM +0200, Philipp Zabel wrote:
> On Mon, 2021-05-03 at 13:56 -0500, Bjorn Helgaas wrote:
> > On Fri, Apr 30, 2021 at 11:21:54AM -0400, Jim Quinlan wrote:
> > > All other functions are defined for when CONFIG_RESET_CONTROLLER
> > > is not set.
> > > 
> > > Fixes: 557acb3d2cd9 ("reset: make shared pulsed reset controls re-triggerable")
> > > CC: stable@vger.kernel.org # v5.11+
> > > Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
> > 
> > Philipp, I'd like to merge this via the PCI tree since the brcmstb
> > patch depends on it.  It looks correct to me, but I'd really like to
> > have your ack before merging it.
> 
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks a lot!  I wanted to include this for v5.13, so I took the
liberty of including it without your ack, so I'm glad you agree ;)
Sorry for the late ack request.

https://git.kernel.org/linus/48582b2e3b87
