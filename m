Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC3714B0A9
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgA1IHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgA1IHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 03:07:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94432467B;
        Tue, 28 Jan 2020 08:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580198839;
        bh=nU4lEuUiMhsaoSdrPHpbKTB6ZDcVseieaAM3PPe4GBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZJ39q0pBe2Y5DEumGKCu+Fo+Dtf0XCgks1AZf1KjyfSzV3INRpJpdZFwwcT42Qau
         kIgzYpmuJHT/2RqGJolqLcQPbYB4D6jYKWBEyrPQwM8mqj2F5zKOLFY01dNlhzfjtW
         GPfhXdjU/eCjeiC9E00kmIwAhlhOJ2W/K/Ps2YjU=
Date:   Tue, 28 Jan 2020 09:07:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Bezdeka <florian@bezdeka.de>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH stable 4.19] crypto: geode-aes - switch to skcipher for
 cbc(aes) fallback
Message-ID: <20200128080715.GI2105706@kroah.com>
References: <20200125114250.588589-1-florian@bezdeka.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125114250.588589-1-florian@bezdeka.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 25, 2020 at 12:42:50PM +0100, Florian Bezdeka wrote:
> commit 504582e8e40b90b8f8c58783e2d1e4f6a2b71a3a upstream.
> 
> [Why]
> This is the backport of the upstream commit for the 4.19 stable tree.

Now applied, thanks.

greg k-h
