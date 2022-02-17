Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9040A4B9A6D
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 09:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiBQH75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 02:59:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbiBQH7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 02:59:43 -0500
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A18F22604DF;
        Wed, 16 Feb 2022 23:59:24 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id 16B4E1E80D5E;
        Thu, 17 Feb 2022 15:54:59 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lt9QN165Z2-3; Thu, 17 Feb 2022 15:54:56 +0800 (CST)
Received: from [172.30.12.152] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id 8BA321E80CB5;
        Thu, 17 Feb 2022 15:54:56 +0800 (CST)
Subject: Re: [PATCH] mm: fix dereference a null pointer in
 migrate[_huge]_page_move_mapping()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220217063808.42018-1-liqiong@nfschina.com>
 <Yg35UXjB7RpqVCOI@kroah.com>
From:   =?UTF-8?B?5p2O5Yqb55C8?= <liqiong@nfschina.com>
Message-ID: <64157952-22d7-b21b-1b08-c784b8eed1fe@nfschina.com>
Date:   Thu, 17 Feb 2022 15:59:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Yg35UXjB7RpqVCOI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Upstream replaces migrate_page_move_mapping() with folio_migrate_mapping(),
does not use radix tree any more. So, the upstream don't have the null
pointer bug.

We found and fix this bug on '4.19.191'.

在 2022/2/17 下午3:29, Greg KH 写道:
> On Thu, Feb 17, 2022 at 02:38:08PM +0800, liqiong wrote:
>> Upstream has no this bug.
> What do you mean by this?
>
> confused,
>
> greg k-h
