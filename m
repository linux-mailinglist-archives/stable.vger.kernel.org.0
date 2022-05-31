Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F053944E
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 17:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345888AbiEaPwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiEaPwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 11:52:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86DF4EDF3;
        Tue, 31 May 2022 08:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=LpXPAneCugbQKHFScwdaqR/e+kKcx/ImtDg7Wq8zAWA=; b=icH4vRbWpozE50sycTIIOtua87
        YO+86QBJ38xanxRX9luKNWYPuGhPGvCuhU0yDUCTTTBxPrQZTyack11k5kZ6ZfU/SpJ3eHIFqwjjv
        c6Xnz2kH/yQSELj5WtLrMQdho7kslht3v1Rw/r6XbIzCqT/t2Mpj6jmmUYVd40q0acNUtY9KYNhJ7
        x0BbhLLahoffzlV5BEUS62JmYJeXcFhI2IAK0pwKnRgRp9seqQbPnwvv8IDYgc9dk+kSNgm9kq72J
        +0tTawagakssCe4R/8uNHcUsoDgKC3LjTsTRa00S+RwYbF/iAgZmdhWnZwMggAGomjwPwCQukRv2Q
        zqNp6vWQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw4Ab-005UoH-R7; Tue, 31 May 2022 15:52:34 +0000
Message-ID: <3995c3d8-395a-bd39-eebc-370bd1fca09c@infradead.org>
Date:   Tue, 31 May 2022 08:52:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220531092817.13894-1-bagasdotme@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220531092817.13894-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/31/22 02:28, Bagas Sanjaya wrote:
> Running kernel-doc script on drivers/hid/hid-uclogic-params.c, it found
> 6 warnings for hid_dbg() wrapper functions below:
> 
> drivers/hid/hid-uclogic-params.c:48: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
> drivers/hid/hid-uclogic-params.c:48: warning: missing initial short description on line:
>  * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
> drivers/hid/hid-uclogic-params.c:48: info: Scanning doc for function Dump
> drivers/hid/hid-uclogic-params.c:80: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Dump tablet interface frame parameters with hid_dbg(), indented with two
> drivers/hid/hid-uclogic-params.c:80: warning: missing initial short description on line:
>  * Dump tablet interface frame parameters with hid_dbg(), indented with two
> drivers/hid/hid-uclogic-params.c:80: info: Scanning doc for function Dump
> drivers/hid/hid-uclogic-params.c:105: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Dump tablet interface parameters with hid_dbg().
> drivers/hid/hid-uclogic-params.c:105: warning: missing initial short description on line:
>  * Dump tablet interface parameters with hid_dbg().
> 
> One of them is reported by kernel test robot.
> 
> Fix these warnings by properly format kernel-doc comment for these
> functions.
> 
> Link: https://lore.kernel.org/linux-doc/202205272033.XFYlYj8k-lkp@intel.com/
> Fixes: a228809fa6f39c ("HID: uclogic: Move param printing to a function")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Nikolai Kondrashov <spbnick@gmail.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: "José Expósito" <jose.exposito89@gmail.com>
> Cc: llvm@lists.linux.dev
> Cc: stable@vger.kernel.org # v5.18
> Cc: linux-input@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Changes since v1 [1]:
>    - Approach the warning by fixing kernel-doc comments formatting
>      (suggested by Jonathan Corbet)
> 
>  [1]: https://lore.kernel.org/linux-doc/20220528091403.160169-1-bagasdotme@gmail.com/

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

One note (nit) below:

>  drivers/hid/hid-uclogic-params.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
> index db838f16282d64..647bbd3e000e2f 100644
> --- a/drivers/hid/hid-uclogic-params.c
> +++ b/drivers/hid/hid-uclogic-params.c
> @@ -23,11 +23,11 @@
>  /**
>   * uclogic_params_pen_inrange_to_str() - Convert a pen in-range reporting type
>   *                                       to a string.
> - *
>   * @inrange:	The in-range reporting type to convert.
>   *
> - * Returns:
> - *	The string representing the type, or NULL if the type is unknown.
> + * Return:
> + * * The string representing the type, or
> + * * NULL if the type is unknown.

        %NULL
would be better here, but not required.

>   */
>  static const char *uclogic_params_pen_inrange_to_str(
>  				enum uclogic_params_pen_inrange inrange)


Thanks.
-- 
~Randy
