Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCBB20A150
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405539AbgFYOx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405309AbgFYOx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:53:56 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4377E20781;
        Thu, 25 Jun 2020 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096836;
        bh=tSukE+pGd92HibxqVh52aunmma7UaYeRd847tScQspY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=RjghYL4ZQ8L61aMlHtlWDbKFG35FvVR3/oakG3M1c80VKoBpcM7paTNnlgp9qehtS
         /vbePEaAu0s80aBThK6+p8ZKMefINBMDy++hRNYar8QZyB0GsdQaqOToRzQ9RRQEwL
         sdT3q+wj4eNw1OtIluDN3FYIytHFdscSG3UJlDmM=
Date:   Thu, 25 Jun 2020 14:53:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     John Allen <john.allen@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Fix use of merged scatterlists
In-Reply-To: <20200622202402.360064-1-john.allen@amd.com>
References: <20200622202402.360064-1-john.allen@amd.com>
Message-Id: <20200625145356.4377E20781@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 63b945091a07 ("crypto: ccp - CCP device driver and interface support").

The bot has tested the following trees: v5.7.5, v5.4.48, v4.19.129, v4.14.185, v4.9.228, v4.4.228.

v5.7.5: Build OK!
v5.4.48: Build OK!
v4.19.129: Build OK!
v4.14.185: Build OK!
v4.9.228: Build OK!
v4.4.228: Failed to apply! Possible dependencies:
    3f19ce2054541 ("crypto: ccp - Remove check for x86 family and model")
    553d2374db0bb ("crypto: ccp - Support for multiple CCPs")
    c7019c4d739e7 ("crypto: ccp - CCP versioning support")
    ea0375afa1728 ("crypto: ccp - Add abstraction for device-specific calls")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
