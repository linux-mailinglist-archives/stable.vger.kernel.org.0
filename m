Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941DF1B4633
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgDVN1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 09:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgDVN1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 09:27:03 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCAA7206EC;
        Wed, 22 Apr 2020 13:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587562023;
        bh=JLf9A1fh556fkriozXuPCidn3cLkxT9H6lt+7ipIfNg=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=pHyhO1NklgBwW1E+5i+z+pwVmeyBNK/hZRwvJqb2tUxrdxK2CSC2hx0VRjUW2Rqp5
         CSRqcJq8WIf7k4/ST05bn9Fyd7epamJSnK5gRdcom8NR3+XaEPpsH67cJFzXIqVK9d
         ULDn9kDGHhNR/g/KC7+CsKNr2CibN3VP42tQ+dik=
Date:   Wed, 22 Apr 2020 13:27:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] padata: add separate cpuhp node for CPUHP_PADATA_DEAD
In-Reply-To: <20200421163455.2177998-1-daniel.m.jordan@oracle.com>
References: <20200421163455.2177998-1-daniel.m.jordan@oracle.com>
Message-Id: <20200422132702.DCAA7206EC@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 894c9ef9780c ("padata: validate cpumask without removed CPU during offline").

The bot has tested the following trees: v5.6.5, v5.4.33.

v5.6.5: Build OK!
v5.4.33: Failed to apply! Possible dependencies:
    bfcdcef8c8e3 ("padata: update documentation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
