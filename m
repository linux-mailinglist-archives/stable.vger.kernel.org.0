Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DD7102526
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfKSNFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:05:43 -0500
Received: from mail.itouring.de ([188.40.134.68]:56902 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbfKSNFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 08:05:43 -0500
Received: from tux.wizards.de (p5DDD7172.dip0.t-ipconnect.de [93.221.113.114])
        by mail.itouring.de (Postfix) with ESMTPSA id E2210416E30B;
        Tue, 19 Nov 2019 14:05:41 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 5700AEEBBE6;
        Tue, 19 Nov 2019 14:05:41 +0100 (CET)
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20191119050946.745015350@linuxfoundation.org>
 <0ca5da93-b597-acb7-169c-a75421ecbd34@applied-asynchrony.com>
 <20191119124518.GD1975017@kroah.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <e29c219f-74bb-a66a-fd70-7121459a8354@applied-asynchrony.com>
Date:   Tue, 19 Nov 2019 14:05:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191119124518.GD1975017@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/19 1:45 PM, Greg Kroah-Hartman wrote:
> On Tue, Nov 19, 2019 at 01:35:26PM +0100, Holger Hoffstätte wrote:
>> Hi Greg,
>>
>> On 11/19/19 6:19 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.3.12 release.
>>> There are 48 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
>>
>> That patch has not shown up after 7 hours - is the mirroring stuck?
> 
> No idea.  What mirror are you using?

Whatever DNS is giving me:

$wget https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
--2019-11-19 13:58:54--  https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
Resolving www.kernel.org... 2604:1380:40b0:1a00::1, 136.144.49.103
Connecting to www.kernel.org|2604:1380:40b0:1a00::1|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz [following]
--2019-11-19 13:58:54--  https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
Resolving mirrors.edge.kernel.org... 2604:1380:2001:3900::1, 147.75.101.1
Connecting to mirrors.edge.kernel.org|2604:1380:2001:3900::1|:443... connected.
HTTP request sent, awaiting response... 404 Not Found
2019-11-19 13:58:54 ERROR 404: Not Found.

147.75.101.1 seems to be ams.edge.kernel.org in Amsterdam, which has always
worked in the past and makes sense since I'm in Germany.

thanks,
Holger
