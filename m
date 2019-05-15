Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526C21F8FC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 18:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfEOQxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 12:53:13 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:47852 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfEOQxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 12:53:13 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4FGr8GT017796;
        Wed, 15 May 2019 11:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557939188;
        bh=MBUGSwtcGNVv+kUWmNhLbcATs6MA1bSJk8Q1+Wfqq28=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=d+yK8UiALG3lfRJQOeT7/COaQh3mlcaTdYWpWH/yYFm/Of46oSqP0siT7+5pY/rS0
         NsjySLFZllLNHTGoSK9mFMeCTolt6W3Mvss3949syJCWFpOuK/n1W58iyj7QgnoHXn
         6gqJ4iAj9M/bjeLpnLRtwf8m/LdqxWRLEdIhbFHI=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4FGr8eZ074139
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 May 2019 11:53:08 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 15
 May 2019 11:53:08 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 15 May 2019 11:53:08 -0500
Received: from [10.247.19.177] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4FGr89s094977;
        Wed, 15 May 2019 11:53:08 -0500
Subject: Re: [PATCH 4.14 053/115] i2c: omap: Enable for ARCH_K3
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <alexander.levin@microsoft.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515090703.440094029@linuxfoundation.org>
 <b97de7c6-fb95-33a9-3ac6-4df45eec82c5@ti.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <a6eecb36-a0ae-753a-6582-0afdac04c4b5@ti.com>
Date:   Wed, 15 May 2019 11:53:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b97de7c6-fb95-33a9-3ac6-4df45eec82c5@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 15/05/19 6:28 AM, Grygorii Strashko wrote:
> Hi Greg,
> 
> On 15.05.19 13:55, Greg Kroah-Hartman wrote:
>> [ Upstream commit 5b277402deac0691226a947df71c581686bd4020 ]
>>
>> Allow I2C_OMAP to be built for K3 platforms.
>>
>> Signed-off-by: Vignesh R <vigneshr@ti.com>
>> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> 
> This is not v4.14 material as there no support for ARCH_K3.
> Could you drop it pls.
> 

Yes, I had informed not to backport this patch before during other
stable reviews as well:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1811579.html

Please drop the patch.
