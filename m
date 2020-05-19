Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7A61D95A7
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgESLtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgESLtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:17 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01CA8207FB;
        Tue, 19 May 2020 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888957;
        bh=Zg0fm03wcjKEa/XH4/pyy9pfGFNPScEZ1d/+5wI5plo=;
        h=Date:From:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=rAzJ+p0vGXrXWldM5l3BpaJPEVUCkmKGtDtvcy7R/frY7iic6v/61Zi2aQ2ayKRjd
         29fWj6V9oWxLXWP9ONSvyoyjishw98fFwNEQzaua2h4cgetM6+q4sFF7pzLOUgVB9R
         9kvWaANx9rAQAJ4HJgtbtgQxYZICZPHVXUHpCOMQ=
Date:   Tue, 19 May 2020 11:49:16 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     computersforpeace@gmail.com, kdasu.kdev@gmail.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mtd: rawnand: brcmnand: fix hamming oob layout
In-Reply-To: <20200512075733.745374-2-noltari@gmail.com>
References: <20200512075733.745374-2-noltari@gmail.com>
Message-Id: <20200519114917.01CA8207FB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ef5eeea6e911 ("mtd: nand: brcm: switch to mtd_ooblayout_ops").

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
