Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7337E1D95A1
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgESLtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgESLtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:14 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FFB207E8;
        Tue, 19 May 2020 11:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888953;
        bh=Zg0fm03wcjKEa/XH4/pyy9pfGFNPScEZ1d/+5wI5plo=;
        h=Date:From:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=gPVvN+vuY48JBRfwIKnCk5m6vWVA8ZnTlBR4bKuiWS8pK7cbVT2JYWCXVwibluA3t
         C7pHRlsfSYtmvY14x2nbw0VM5seMUQYLhdQBNdfLnDv1qDfisDBjF1ZE3LkHKclro3
         p87TB837mHDUV6wpM2mr2YAexIlZFqDigixDU/PY=
Date:   Tue, 19 May 2020 11:49:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     computersforpeace@gmail.com, kdasu.kdev@gmail.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mtd: rawnand: brcmnand: fix hamming oob layout
In-Reply-To: <20200512060023.684871-2-noltari@gmail.com>
References: <20200512060023.684871-2-noltari@gmail.com>
Message-Id: <20200519114913.92FFB207E8@mail.kernel.org>
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
