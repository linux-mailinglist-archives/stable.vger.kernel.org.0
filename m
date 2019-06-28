Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228D958FD1
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 03:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF1BnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 21:43:19 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54515 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfF1BnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 21:43:19 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Zffr6p0rz9s3Z;
        Fri, 28 Jun 2019 11:43:16 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Haren Myneni <haren@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] crypto/NX: Set receive window credits to max number of CRBs in RxFIFO
In-Reply-To: <20190627062610.olw3ojckkwil4jlk@gondor.apana.org.au>
References: <20190627062610.olw3ojckkwil4jlk@gondor.apana.org.au>
Date:   Fri, 28 Jun 2019 11:43:16 +1000
Message-ID: <87tvcascwb.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> Haren Myneni <haren@linux.vnet.ibm.com> wrote:
>>    
>> System gets checkstop if RxFIFO overruns with more requests than the
>> maximum possible number of CRBs in FIFO at the same time. The max number
>> of requests per window is controlled by window credits. So find max
>> CRBs from FIFO size and set it to receive window credits.
>> 
>> Fixes: b0d6c9bab5e4 ("crypto/nx: Add P9 NX support for 842 compression engine")
>> CC: stable@vger.kernel.org # v4.14+   
>> Signed-off-by:Haren Myneni <haren@us.ibm.com>
>
> I presume this is being picked up by the powerpc tree?

No. I assumed you'd take it because it's in drivers/crypto.

If you want me to take it that's fine, just let me know.

cheers
