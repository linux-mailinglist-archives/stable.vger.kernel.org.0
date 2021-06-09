Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9966C3A1D5A
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhFITAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 15:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhFIS74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F0C613AC;
        Wed,  9 Jun 2021 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623265081;
        bh=P+QABQYjPRkSiYEChLz+GW9EQTDElNgOh+61zoofl4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbcQhdLxGUHTitqFgvxTWNXnnV4sK+gBW3MQo+RBKr+RYUR+PEcJ60uOs4ZfNXUoU
         K4IvpiNPVXkjbN3QEql9QA8Rw1jXRuqwV50twLuxENSa1yJuKoY8lKZbHk5inPoyPh
         ohbYu513I2lE7/LS+9QfyisuBaip5wjTxN38VQ7w=
Date:   Wed, 9 Jun 2021 20:57:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     linux-clk@vger.kernel.org, sboyd@kernel.org,
        mturquette@baylibre.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] clk: agilex/stratix10: remove noc_clk
Message-ID: <YMEPN1cMjLZxfNJ6@kroah.com>
References: <20210609185008.36056-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609185008.36056-1-dinguyen@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 01:50:05PM -0500, Dinh Nguyen wrote:
> Early documentation had a noc_clk, but in reality, it's just the
> noc_free_clk. Remove the noc_clk clock and just use the noc_free_clk.
> 
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
