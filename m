Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB1066B9E1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 10:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjAPJIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 04:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjAPJIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 04:08:01 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4634618A9F;
        Mon, 16 Jan 2023 01:06:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pHLRS-000QpO-3u; Mon, 16 Jan 2023 17:06:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jan 2023 17:06:10 +0800
Date:   Mon, 16 Jan 2023 17:06:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Message-ID: <Y8UTghm0Y8U4ndmH@gondor.apana.org.au>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
 <Y7g7sp6UJJrYKihK@gondor.apana.org.au>
 <755e1dc9c777fa657ccd948f65f5f33240226c43.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <755e1dc9c777fa657ccd948f65f5f33240226c43.camel@huaweicloud.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 09:57:57AM +0100, Roberto Sassu wrote:
>
> Hi Herbert
> 
> will you take also the second patch?

That's part of David Howells' tree so hopefully he will pick
it up soon.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
