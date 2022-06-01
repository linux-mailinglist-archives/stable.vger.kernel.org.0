Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB253A4BC
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 14:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352102AbiFAMTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 08:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352226AbiFAMTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 08:19:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBC85D5F2;
        Wed,  1 Jun 2022 05:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=E0ASuyIt3D/v/vJP2nisxwtwS8OQ6l/WjEuhFtT6iTA=; b=NYl34IC7oQjJCRRq3a7dZ1MxBy
        tA+6kILU8H4IQgKhQHo4jhzTTnPWy2z5cPt6qPbyBRyDd6MScbewtKsOjBKFfO0B4KGgULeNwBtkw
        mwpm/rezTymMsj8M+K4l6tTKCLrlpdzUU9IpjReeFfOUt4/AwBdmqtOKYs/nSfL5vP/eUBbnPoV6j
        uAyN+gVAcWSVQKP1TCAF3bselOe4k3bc0nKIlz0nsLV10TsASyKZWSYJSb6VKB9jQmiAzp9VPm2jB
        DF3pCzCDTxSLDkcmtMFYK7i4P6XrqWJ1nAehm9M60WkBvJ0yNVufVIR7XDNB0+LAcsqKS8lZnmNAr
        Pnf0YJqg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwNJS-006GXo-Fj; Wed, 01 Jun 2022 12:18:59 +0000
Message-ID: <053f756b-fafa-e07a-4308-0a5de8dda595@infradead.org>
Date:   Wed, 1 Jun 2022 05:18:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220531092817.13894-1-bagasdotme@gmail.com>
 <3995c3d8-395a-bd39-eebc-370bd1fca09c@infradead.org>
 <YpcU7qeOtShFx8xR@debian.me>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <YpcU7qeOtShFx8xR@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/1/22 00:27, Bagas Sanjaya wrote:
>> One note (nit) below:
>>
>>>  drivers/hid/hid-uclogic-params.c | 24 ++++++++++++++----------
>>>  1 file changed, 14 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
>>> index db838f16282d64..647bbd3e000e2f 100644
>>> --- a/drivers/hid/hid-uclogic-params.c
>>> +++ b/drivers/hid/hid-uclogic-params.c
>>> @@ -23,11 +23,11 @@
>>>  /**
>>>   * uclogic_params_pen_inrange_to_str() - Convert a pen in-range reporting type
>>>   *                                       to a string.
>>> - *
>>>   * @inrange:	The in-range reporting type to convert.
>>>   *
>>> - * Returns:
>>> - *	The string representing the type, or NULL if the type is unknown.
>>> + * Return:
>>> + * * The string representing the type, or
>>> + * * NULL if the type is unknown.
>>
>>         %NULL
>> would be better here, but not required.
>>
> 
> Hi Randy,
> 
> I don't see %NULL in Documentation/ (I git-grep-ed it but none found).
> What should I do when I have to explain NULL in Return: section of
> kernel-doc comment?

In Documentation/doc-guide/kernel-doc.rst, section Highlights and cross-references:

``%CONST``
  Name of a constant. (No cross-referencing, just formatting.)

So '%' before a constant value just helps with the generated formatting
of the output. It's just "prettier." No big deal.

-- 
~Randy
