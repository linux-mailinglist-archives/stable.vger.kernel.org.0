Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BA253DB0
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 08:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgH0G1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 02:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgH0G1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 02:27:10 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0DDC061260;
        Wed, 26 Aug 2020 23:27:09 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BcXnj6RYlz9sRK;
        Thu, 27 Aug 2020 16:27:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1598509627; bh=0jnmw3HItILjj9al39tdUW1/oczaOCF9us3o3EFIRyE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sYG/O8pKqds8ULQ32y2auj0Zciks1xfx3dVbQeRTF7cjRTkoSIt1zXXstER+ujk6a
         TmlvFvJLcUp/AthOhwI63LKUOZ7Z4c9KjCqCAzx5EXXjYisZrCbCxLm7opDRwyydol
         jz3awI+osTZzEzcDSO34es+ULJ3tNylQXHZBH9i6zGKh+BjVvUCrqZxezP1y7FlObA
         6AZgRQXoGoRuiMRQefnnknFjYKV/KcPi41Y9DlyxBesT0YV6t8h+LCtnPVp+85eAP9
         l5w1VZSJTKATH3C9+ZZxG5Rnkcd7aFHJpob7FekhwGO1F6uIFthS0arUnbhvWECEkU
         p+vJp0SSpEf7w==
Message-ID: <1e56af7945b93a22e31ba6d81da82cbdb1b237b6.camel@ozlabs.org>
Subject: Re: [PATCH] ARM: aspeed: g5: Do not set sirq polarity
From:   Jeremy Kerr <jk@ozlabs.org>
To:     Joel Stanley <joel@jms.id.au>, Oskar Senft <osk@google.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Thu, 27 Aug 2020 14:27:02 +0800
In-Reply-To: <20200812112400.2406734-1-joel@jms.id.au>
References: <20200812112400.2406734-1-joel@jms.id.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joel,

> A feature was added to the aspeed vuart driver to configure the vuart
> interrupt (sirq) polarity according to the LPC/eSPI strapping register.
> 
> Systems that depend on a active low behaviour (sirq_polarity set to 0)
> such as OpenPower boxes also use LPC, so this relationship does not
> hold.
> 
> The property was added for a Tyan S7106 system which is not supported
> in the kernel tree. Should this or other systems wish to use this
> feature of the driver they should add it to the machine specific device
> tree.
> 
> Fixes: c791fc76bc72 ("arm: dts: aspeed: Add vuart aspeed,sirq-polarity-sense...")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joel Stanley <joel@jms.id.au>

LGTM. I've tested this on the s2600st, which is strapped for eSPI. All
good there too, as expected.

Tested-by: Jeremy Kerr <jk@ozlabs.org>

and/or:

Reviewed-by: Jeremy Kerr <jk@ozlabs.org>

Cheers,


Jeremy

