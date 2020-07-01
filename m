Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084DF21139D
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgGATdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgGATdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:20 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1D12085B;
        Wed,  1 Jul 2020 19:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593632000;
        bh=2IXAFo59MJ47afW6i+NbbncOL27qP2xIrtvL4hL8DrE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=xQTs4J7v4mUM+EdbXtSB795DPwnMlvfEJW70IKieAGm+237tiPqILrhUDRjCw3D+s
         wWaxoepdFk9ZAfwTNQbCSGsy6pxFl2jeyK3mwGLNGiRAQQ4uALkC3GuxltIgKYJ46K
         pg6hAAaZAvjoXDXsdzHXWwLBA8+4h0WPT1lFtLeA=
Date:   Wed, 01 Jul 2020 19:33:19 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
In-Reply-To: <20200624195811.435857-8-maz@kernel.org>
References: <20200624195811.435857-8-maz@kernel.org>
Message-Id: <20200701193319.BE1D12085B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature").

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Build OK!
v4.14.186: Build OK!
v4.9.228: Failed to apply! Possible dependencies:
    0c9e498286ef9 ("irqchip/gic: Report that effective affinity is a single target")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
