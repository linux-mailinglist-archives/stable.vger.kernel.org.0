Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4272D6176B2
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 07:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKCGXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 02:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKCGXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 02:23:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D78BC31;
        Wed,  2 Nov 2022 23:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=wWklh3V04M7tRN5I4El4kisW58/wtA96fy+VCrOUxBg=; b=BWCQyjGl9in3cyS9TZ/MJrSuc3
        3BvAw0RvXXckw2UNM2jkZr7cupD+lmvsDdE7Wf6lgez5WQ+DDzUuaVKP/8jE93/kD4zN68pzCLKFh
        XZoIoh53y7Sr4+DdyN8mtPkTMNZAdl/4o1kqIQAyz2wYjqmsP04LbHxmwiD1WohnxF8pQYVu/Xbah
        ZGMlFV7wUVuAnbbKiAry0pBUSpNsxBhV7Hpm7j6CuFq7Akb941E6BYwjfwQeW5YOeMVjYxLJcyOYi
        04qd1bHuwot5iBGcL0yt7X4sBB8tHDTVkpUKxhOF0mI/itU8qUMvsAZ/V7p99ZQBUpboAJKlmXaQz
        GeJBZ59Q==;
Received: from [2601:1c2:d80:3110:e65e:37ff:febd:ee53]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqTdA-00GHXh-L0; Thu, 03 Nov 2022 06:23:12 +0000
Message-ID: <ccefc0b7-528d-32a5-328c-e166b4821f76@infradead.org>
Date:   Wed, 2 Nov 2022 23:23:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] virt: sev-guest: fix kconfig warnings
Content-Language: en-US
To:     linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paul Gazzillo <paul@pgazz.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
References: <20220828195234.6604-1-rdunlap@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220828195234.6604-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping. I have verified (on linux-next-20221103) that this
patch is still needed.
Thanks.

On 8/28/22 12:52, Randy Dunlap wrote:
> Fix the SEV_GUEST Kconfig block to eliminate kconfig unmet
> dependency warnings:
> 
> WARNING: unmet direct dependencies detected for CRYPTO_GCM
>   Depends on [n]: CRYPTO [=n]
>   Selected by [y]:
>   - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]
> 
> WARNING: unmet direct dependencies detected for CRYPTO_AEAD2
>   Depends on [n]: CRYPTO [=n]
>   Selected by [y]:
>   - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]
> 
> Fixes: fce96cf04430 ("virt: Add SEV-SNP guest driver")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: stable@vger.kernel.org
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Paul Gazzillo <paul@pgazz.com>
> Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> ---
>  drivers/virt/coco/sev-guest/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/virt/coco/sev-guest/Kconfig
> +++ b/drivers/virt/coco/sev-guest/Kconfig
> @@ -2,6 +2,7 @@ config SEV_GUEST
>  	tristate "AMD SEV Guest driver"
>  	default m
>  	depends on AMD_MEM_ENCRYPT
> +	select CRYPTO
>  	select CRYPTO_AEAD2
>  	select CRYPTO_GCM
>  	help

-- 
~Randy
