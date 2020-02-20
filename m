Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA5B166096
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 16:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgBTPMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 10:12:44 -0500
Received: from mail.itouring.de ([188.40.134.68]:59174 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgBTPMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 10:12:44 -0500
Received: from tux.applied-asynchrony.com (p5B07E2B3.dip0.t-ipconnect.de [91.7.226.179])
        by mail.itouring.de (Postfix) with ESMTPSA id A07634161A41;
        Thu, 20 Feb 2020 16:12:42 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 5A069F01606;
        Thu, 20 Feb 2020 16:12:24 +0100 (CET)
Subject: Re: 5.4-stable request: 52e29e331070cd ('btrfs: don't set
 path->leave_spinning for truncate')
To:     Sasha Levin <sashal@kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <e56ac6c0-2bae-62a1-a22d-d7374a98ab43@applied-asynchrony.com>
 <20200218161426.GM1734@sasha-vm>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <b7e8d6da-087a-b7e4-7be2-8a9a6ef1e9a1@applied-asynchrony.com>
Date:   Thu, 20 Feb 2020 16:12:24 +0100
MIME-Version: 1.0
In-Reply-To: <20200218161426.GM1734@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Sasha,

On 2/18/20 5:14 PM, Sasha Levin wrote:
> On Tue, Feb 18, 2020 at 01:01:40PM +0100, Holger Hoffstätte wrote:
>> Hi,
>>
>> I was just looking throught the current 5.4-stable queue and saw that
>> 28553fa992cb28 ('Btrfs: fix race between shrinking truncate and fiemap')
>> is queued. Upstream has a follow-up fix for this: 52e29e331070cd aka
>> 'btrfs: don't set path->leave_spinning for truncate'.
>>
>> Would be nice to get those in together. I only looked at 5.4, don't
>> know about other queues.
> 
> Since that fix just hit upstream, I'm going to remove 28553fa992cb28
> from the queue now and work on getting both patches in the next release.

Thanks, but maybe wait until [1] has also hit mainline? It's another fix
for 28553fa992cb28.

thanks,
Holger

[1] https://patchwork.kernel.org/patch/11394171/
