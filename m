Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940F71493FC
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 09:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgAYIYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 03:24:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7795 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgAYIYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 03:24:12 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2bfb1a0000>; Sat, 25 Jan 2020 00:23:54 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 25 Jan 2020 00:24:11 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 25 Jan 2020 00:24:11 -0800
Received: from [10.26.11.150] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 25 Jan
 2020 08:24:09 +0000
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>, <stable@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124235537.GB3467@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cd504bb5-44b1-415b-edc7-21ee69e9d1fa@nvidia.com>
Date:   Sat, 25 Jan 2020 08:24:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124235537.GB3467@roeck-us.net>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579940634; bh=RFGgFXrilnKFYndVC0uQoLbr5UyaeLbsayCBYjbl1Qw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=q+Aqx/EYyd5yRyKZYPR974fsAYn6lV7E6uY0aBOfthYeo59sb2H1pYbPvk8uiM19+
         koXBMkGy8E1jdfAG7+xeSbEZ5Y37p7Axyio3pnj25Q00KaMfCB90uvhGU6R0BCEgJJ
         KTDBEQnhrtoHrQWvIP2qI3x4YCZr4+qpiKKH26wxxW84je8/4DfqTbTE13lft8l6Dz
         GBOMq749oDHbl3+OMx7N0cYU1HgCyxdqqIGOVEpKa0+y2Lqwn/yyGybdKsOh56bTEH
         3d7tqnQ/BffgKyPDliQ6IBx6jg8rwYI/3CYRZo/HVzZGYUdm0Q4AsqD6qjW+CYfuy2
         ze1zXdH5QaA3g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On 24/01/2020 23:55, Guenter Roeck wrote:
> On Fri, Jan 24, 2020 at 10:22:50AM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.99 release.
>> There are 639 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
>> Anything received after that time might be too late.
>>
> 
> For v4.19.98-638-g24832ad2c623:

This does not appear to be the correct tag/version for this review.

Cheers
Jon

-- 
nvpublic
