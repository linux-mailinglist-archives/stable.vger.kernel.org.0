Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60525AA67
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 13:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfF2Lb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 07:31:28 -0400
Received: from ozlabs.org ([203.11.71.1]:33429 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfF2Lb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jun 2019 07:31:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45bWg127zJz9s3l;
        Sat, 29 Jun 2019 21:31:25 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Haren Myneni <haren@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] crypto/NX: Set receive window credits to max number of CRBs in RxFIFO
In-Reply-To: <20190628020715.6qopmtm4q63lsdxm@gondor.apana.org.au>
References: <20190627062610.olw3ojckkwil4jlk@gondor.apana.org.au> <87tvcascwb.fsf@concordia.ellerman.id.au> <20190628020715.6qopmtm4q63lsdxm@gondor.apana.org.au>
Date:   Sat, 29 Jun 2019 21:31:25 +1000
Message-ID: <877e94k4qa.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Fri, Jun 28, 2019 at 11:43:16AM +1000, Michael Ellerman wrote:
>>
>> No. I assumed you'd take it because it's in drivers/crypto.
>> 
>> If you want me to take it that's fine, just let me know.
>
> No that's fine Michael.  I'll pick it up.

Thanks.

cheers
