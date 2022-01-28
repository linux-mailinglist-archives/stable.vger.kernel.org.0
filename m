Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201D04A011D
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 20:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350996AbiA1Trj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 14:47:39 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:44716 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239494AbiA1Tri (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 14:47:38 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 9999C20A2BDF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] edac: altera: fix deferred probing
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     Borislav Petkov <bp@alien8.de>, stable <stable@vger.kernel.org>
CC:     Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>, <linux-edac@vger.kernel.org>
References: <20220124185503.6720-1-s.shtylyov@omp.ru>
 <20220124185503.6720-2-s.shtylyov@omp.ru>
 <7b964ac0-6356-9330-a745-b43e620d051b@kernel.org> <YfQ3xUpLOPvDu5W+@zn.tnic>
 <ba83ca78-6a15-caf5-71ba-76d5b2b1b41d@omp.ru>
 <9f28d2de-5119-a7a6-9da7-08b2ce13f1a0@omp.ru> <YfRBCPRPkf+gD18/@zn.tnic>
 <5bd9cbc1-12d2-aedc-6d64-ac9eaa2460b1@omp.ru> <YfRB8SSugBDHAcwH@zn.tnic>
 <cddf702d-376b-0f83-7a0c-170e5581a696@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b8105b28-8498-784e-2065-a5f089b3e9a1@omp.ru>
Date:   Fri, 28 Jan 2022 22:47:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cddf702d-376b-0f83-7a0c-170e5581a696@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/22 10:35 PM, Sergey Shtylyov wrote:

[...]
>>>    See my other mail...
>>
>> Which other mail?
> 
> https://lore.kernel.org/all/9f28d2de-5119-a7a6-9da7-08b2ce13f1a0@omp.ru/

   Ah, you've already replied to that! Sorry, I'm in a little bit of haste,
so didn't always read your replies attentively enough. :-/

MBR, Sergey
