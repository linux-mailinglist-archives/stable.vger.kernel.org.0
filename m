Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0FF51009E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347184AbiDZOlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiDZOlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:41:44 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D50D17E237
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=YPlBzACKUB8wXraJXLmwAPmmIpbYGIOYqXxfVUBevLo=; b=a1sPbYoHIqKOhbOPaAASsIHvek
        QfxRrxj5H77TojuJY/d3l4j81/EuJbrFwoqxZ4jSLn/IIHP7TA5Y+FZ6j2mY5MwSYv2JB4BGS8SbD
        hWPv/aF9ZuQB2NhsXgt9HNlxdwxmSz+HpHRXu5Vdj4ynj+MUwVMDezPZQm2bcpIb0U3BDeItdpxEB
        HrQzN6AYBS+h+e3AIKp64MMs2TTBlg7UDv4ZEj8n5+GVHSUUk8Nkdb44J7k7SwbgFea0LIkOdYfqK
        UbuUq9qfsirhhqG30dmKQ+H9jTcBHn7FFCe/YpglCscITkWe9TagRtN4LbkOsKgWWFYCXcaPyJESO
        ICNqB9Cw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1njMKj-008oVR-1n; Tue, 26 Apr 2022 14:38:29 +0000
Message-ID: <ca1c377b-339e-d8a1-899e-32928b21c54d@infradead.org>
Date:   Tue, 26 Apr 2022 07:38:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] Revert "net: micrel: fix KS8851_MLL Kconfig"
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, Marek Vasut <marex@denx.de>
Cc:     stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220425214859.256650-1-marex@denx.de>
 <YmeTKshiEUDB2hN0@kroah.com> <Ymeawd480IRlLFRT@kroah.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <Ymeawd480IRlLFRT@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/26/22 00:09, Greg KH wrote:
> On Tue, Apr 26, 2022 at 08:37:30AM +0200, Greg KH wrote:
>> On Mon, Apr 25, 2022 at 11:48:59PM +0200, Marek Vasut wrote:
>>> This reverts commit 1ff5359afa5ec0dd09fe76183dc4fa24b50e4125.
>>>
>>> The upstream commit c3efcedd272a ("net: micrel: fix KS8851_MLL Kconfig")
>>> depends on e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
>>> which is not part of Linux 5.10.y . Revert the aforementioned commit to
>>> prevent breakage in 5.10.y .
>>
>> As the original change went into 4.9.311, 4.14.276, 4.19.239, and
>> 5.4.190, is this change also needed in those branches?
> 
> The answer to that seems yes, so I'll go queue this up everywhere.

Yes, agreed.

-- 
~Randy
