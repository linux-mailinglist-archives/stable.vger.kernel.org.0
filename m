Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E64858D0
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 20:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbiAETEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 14:04:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42830 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243276AbiAETEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 14:04:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43914B81D4A;
        Wed,  5 Jan 2022 19:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9732C36AE9;
        Wed,  5 Jan 2022 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641409445;
        bh=pGRPte+Er2nuQO21nFn1x6nWU817XWuElsOpLVUPi2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Kd/YAvgh9X8Ij0UPxhp/WR/arZkYVUtt70KzXWHkIG3CfpkJ36QeMtqVx/oEC0kXa
         zQSSz1HDDyhYD+ZX+nsDr/GQOodZlvUffcqvTh7Bu0Kr29ALuRS5GaJQuBA3jPbZ4/
         QcRlsDDNew9ChVCw4TPzB9QOdO0U0zWP65f14aNwEd0NMAA9MNnqyWOj9Hz1uaqEls
         5MMCZlkYuHjFTNy7UOIr2I6w8huajC+m7x8h/WtuDvRDFoTXK/VF2RSpKDm99zWYnn
         W6m2ZmiTlDgFcf7ZGD2qQiBAXlFnu8NdVOwdllbfMWtgjM8mH7sA8ysUdv4OKsw8RC
         gDL/u1teq3BwQ==
Date:   Wed, 5 Jan 2022 13:04:04 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Richard Zhu <hongxing.zhu@nxp.com>
Cc:     l.stach@pengutronix.de, bhelgaas@google.com, broonie@kernel.org,
        lorenzo.pieralisi@arm.com, jingoohan1@gmail.com,
        festevam@gmail.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v5 3/6] PCI: imx6: PCI: imx6: Move
 imx6_pcie_clk_disable() earlier
Message-ID: <20220105190404.GA213307@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641368602-20401-4-git-send-email-hongxing.zhu@nxp.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove repeated words from subject line.

On Wed, Jan 05, 2022 at 03:43:19PM +0800, Richard Zhu wrote:
> Just move the imx6_pcie_clk_disable() to an earlier place without function
> changes, since it wouldn't be only used in imx6_pcie_suspend_noirq() later.
