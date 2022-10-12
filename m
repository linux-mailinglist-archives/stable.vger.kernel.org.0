Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37AC5FC31B
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 11:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJLJbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 05:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJLJbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 05:31:52 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E052BC45D;
        Wed, 12 Oct 2022 02:31:52 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oiY5c-00DtFL-5h; Wed, 12 Oct 2022 20:31:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Oct 2022 17:31:48 +0800
Date:   Wed, 12 Oct 2022 17:31:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Allen, John" <John.Allen@amd.com>
Subject: Re: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Message-ID: <Y0aJhAmgF1mpxqNL@gondor.apana.org.au>
References: <20220928184506.13981-1-mario.limonciello@amd.com>
 <MN0PR12MB61017C926551A7F6D908F6ADE25F9@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61017C926551A7F6D908F6ADE25F9@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 08:24:06PM +0000, Limonciello, Mario wrote:
>
> I noticed you sent out the 6.1 PR already.  So I Just wanted to make sure this
> didn't get overlooked as it's already got a T-b/A-b.

Hi Mario:

This didn't make the deadline for inclusion in my 6.1 PR.  Is there
any reason why it has to go in this merge window rather than the next?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
