Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2815FD309
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJMBzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJMBzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:55:47 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F67122BF3;
        Wed, 12 Oct 2022 18:55:44 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oinRj-00E9zE-RJ; Thu, 13 Oct 2022 12:55:40 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Oct 2022 09:55:39 +0800
Date:   Thu, 13 Oct 2022 09:55:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Allen, John" <John.Allen@amd.com>
Subject: Re: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Message-ID: <Y0dwG90y3VrVtc8w@gondor.apana.org.au>
References: <20220928184506.13981-1-mario.limonciello@amd.com>
 <MN0PR12MB61017C926551A7F6D908F6ADE25F9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <Y0aJhAmgF1mpxqNL@gondor.apana.org.au>
 <4e1bfb2e-cd9a-6b41-520e-dbf3746a2af8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e1bfb2e-cd9a-6b41-520e-dbf3746a2af8@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 07:42:32AM -0500, Mario Limonciello wrote:
>
> Some other maintainers take new IDs as fixes.  Particularly when they're
> good candidates for cc stable.
> 
> The main reason I wanted to see it sooner is so that it has more time to
> percolate to the various downstream distros so that errors stemming from the
> lack of this ID declaration aren't prevalent when using this SOC.

Sorry but this is not persuasive enough for me.  If you want a patch
to make a particular merge window, make sure that you get it in early
enough.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
