Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB79C35E825
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhDMVU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 17:20:56 -0400
Received: from mleia.com ([178.79.152.223]:50282 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348398AbhDMVUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 17:20:55 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 17:20:55 EDT
Received: from mail.mleia.com (localhost [127.0.0.1])
        by mail.mleia.com (Postfix) with ESMTP id A5CBD4775D2;
        Tue, 13 Apr 2021 21:13:08 +0000 (UTC)
Subject: Re: [PATCH v3 3/7] mtd: rawnand: lpc32xx_slc: Fix external use of SW
 Hamming ECC helper
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org, Trevor Woerner <twoerner@gmail.com>
References: <20210413161840.345208-1-miquel.raynal@bootlin.com>
 <20210413161840.345208-4-miquel.raynal@bootlin.com>
From:   Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <776fbfb9-526e-c66b-f6fa-bf7a258c4bd6@mleia.com>
Date:   Wed, 14 Apr 2021 00:13:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210413161840.345208-4-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20210413_211308_702609_23D3E18B 
X-CRM114-Status: UNSURE (   9.32  )
X-CRM114-Notice: Please train this message. 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/13/21 7:18 PM, Miquel Raynal wrote:
> Since the Hamming software ECC engine has been updated to become a
> proper and independent ECC engine, it is now mandatory to either
> initialize the engine before using any one of his functions or use one
> of the bare helpers which only perform the calculations. As there is no
> actual need for a proper ECC initialization, let's just use the bare
> helper instead of the rawnand one.
> 
> Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
> Cc: stable@vger.kernel.org
> Cc: Vladimir Zapolskiy <vz@mleia.com>
> Reported-by: Trevor Woerner <twoerner@gmail.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Tested-by: Trevor Woerner <twoerner@gmail.com>

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
Best wishes,
Vladimir
