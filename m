Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5E20229F
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgFTI3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:29:51 -0400
Received: from mail.itouring.de ([188.40.134.68]:44772 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgFTI3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 04:29:51 -0400
Received: from tux.applied-asynchrony.com (p5ddd79e0.dip0.t-ipconnect.de [93.221.121.224])
        by mail.itouring.de (Postfix) with ESMTPSA id CDD7F4160EC1;
        Sat, 20 Jun 2020 10:29:49 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id DB1B6F01605;
        Sat, 20 Jun 2020 10:29:48 +0200 (CEST)
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20200619141710.350494719@linuxfoundation.org>
 <1b6c9c26-04af-eb91-ef06-23d09bd31d91@applied-asynchrony.com>
 <1797f3d4-d3b6-00ac-30fc-a10f584acae9@applied-asynchrony.com>
 <20200620072236.GB66401@kroah.com>
 <44a85676-c69d-3dd1-80c6-82cc7b0a6c60@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <c54fe354-4059-071c-7660-8975542f2a52@applied-asynchrony.com>
Date:   Sat, 20 Jun 2020 10:29:48 +0200
MIME-Version: 1.0
In-Reply-To: <44a85676-c69d-3dd1-80c6-82cc7b0a6c60@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-20 09:43, Holger Hoffstätte wrote:
> On 2020-06-20 09:22, Greg Kroah-Hartman wrote:
>> On Sat, Jun 20, 2020 at 03:18:30AM +0200, Holger Hoffstätte wrote:
>>> On 2020-06-19 21:31, Holger Hoffstätte wrote:
>>>> On 2020-06-19 16:28, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.7.5 release.
>>>>> There are 376 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>
>>>> Applied to 5.7.4 and running fine on two different systems (server, desktop)
>>>> without problems.
>>>
>>> Uh-oh: I have to take the above back. This release no longer suspends to RAM;
>>> display and NIC shut down (box is no longer remotely accessible) but the power
>>> stays on and I have to power-cycle.
>>> Will try to revert a bunch of things tomorrow..
>>
>> Is this a new problem?  Or is it a regression?
> 
> 5.7.(0,1,2,3,4) all suspended & woke up without problem, every night.
> Just a moment ago I also got a GPU lockup out of the blue, probably caused by
> something else (looks like mm/THP/memory mapping/userfault related)

OK, nevermind - my bad, just noticed that I had a bunch of custom patches in
that tree that should not have been in there for testing (yet).
Extra-virgin 5.7.4 + 5.7.5-rc1 on top works & suspends/resumes fine, and so far
no new GPU lockups either.

-h
