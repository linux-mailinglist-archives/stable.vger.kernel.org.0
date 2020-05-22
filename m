Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B1F1DDBEA
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgEVAMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgEVAMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:39 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD81C2078B;
        Fri, 22 May 2020 00:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106359;
        bh=Bd+J7l4ozEAKcpKr3XQqKk9VsnlMCH0rOTdDOqvscmQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=FzA4RfVN/fZ63DkRQg5RZsBNqXUEfmXLheKcRZ6y5gmSmJj8Gc2Rv1Vn2rtbEKFE2
         fk4lwIWCZxLmVBLB9bPjqavIg4IXMBJKzk3B4gq7xeqorBabAAUMHJ7u2ZzSgEwHvg
         +qfCOdCAu/4wm+6Xb5O0yF2Rp9WzraJv9zCD1HIw=
Date:   Fri, 22 May 2020 00:12:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
To:     <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 40/62] mtd: rawnand: pasemi: Fix the probe error path
In-Reply-To: <20200519130035.1883-41-miquel.raynal@bootlin.com>
References: <20200519130035.1883-41-miquel.raynal@bootlin.com>
Message-Id: <20200522001238.BD81C2078B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources").

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Build OK!
v4.14.180: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.223: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
