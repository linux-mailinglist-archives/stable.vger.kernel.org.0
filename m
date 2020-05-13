Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B946E1D03E9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 02:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgEMAt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 20:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgEMAt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 20:49:29 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1DC423129;
        Wed, 13 May 2020 00:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589330969;
        bh=B1OkxXG1x4esFw/jkPPkkifx1CyFiCisAaqCIpPJ+QI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=sNKqoSXN1thgYLzLVtTnbgTk6VU0oVMsV+vAHb5qUBh+a+RCrOGQE3b9FFbhbm957
         qPOWVyfHVHwCaSRca8HS39Id8/qGvgsn1V23tkg48mx4+P5nUQaJuxs04Flfy5vmY1
         CjJN8IHTgRZcDY7MWHeNWdxhdrlY64S6hbr0u9fo=
Date:   Wed, 13 May 2020 00:49:28 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 40/62] mtd: rawnand: pasemi: Fix the probe error path
In-Reply-To: <20200510121220.18042-41-miquel.raynal@bootlin.com>
References: <20200510121220.18042-41-miquel.raynal@bootlin.com>
Message-Id: <20200513004928.C1DC423129@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources").

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Build OK!
v4.14.179: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.222: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
