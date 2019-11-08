Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4BF4D5A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfKHNjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:39:43 -0500
Received: from gecko.sbs.de ([194.138.37.40]:36718 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfKHNjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 08:39:42 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Nov 2019 08:39:41 EST
Received: from thoth.sbs.de (thoth.sbs.de [192.35.17.2])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id xA8DOV5L017509
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <stable@vger.kernel.org>; Fri, 8 Nov 2019 14:24:31 +0100
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id xA8DOP9J019499
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 14:24:26 +0100
Received: from [139.25.68.37] ([139.25.68.37])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id xA8DOPMU025877;
        Fri, 8 Nov 2019 14:24:25 +0100
Subject: Re: [PATCH v1] platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to
 critclk_systems DMI table
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     stable@vger.kernel.org
References: <20191107170530.6115-1-andriy.shevchenko@linux.intel.com>
 <20191108131813.GD761587@kroah.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <e448f04b-ea0c-f0b7-a8fe-f4952144dc09@siemens.com>
Date:   Fri, 8 Nov 2019 14:24:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191108131813.GD761587@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1003
X-purgate-ID: 149902::1573219471-00001F04-03C153FA/0/0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.11.19 14:18, Greg Kroah-Hartman wrote:
> On Thu, Nov 07, 2019 at 07:05:30PM +0200, Andy Shevchenko wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> The SIMATIC IPC227E uses the PMC clock for on-board components and gets
>> stuck during boot if the clock is disabled. Therefore, add this device
>> to the critical systems list.
>>
>> Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>
>> - resend for stable inclusion
> 
> What git id is this in Linus's tree, and what tree(s) is this backport
> for?

Upstream ID ad0d315b4d4e7138f43acf03308192ec00e9614d.

We should target down to 4.14, the last stable kernel that got bothered 
by 648e921888ad as far as I can see.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
