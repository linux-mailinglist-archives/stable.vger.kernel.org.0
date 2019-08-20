Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C57E969ED
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 22:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfHTUDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 16:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTUDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 16:03:06 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01BA7216F4;
        Tue, 20 Aug 2019 20:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566331385;
        bh=lMA/WhU6XkQ8Xuoxb/NcCXxVQa9ffCVE+aF9sF1WIhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zHPGaRQGFnQ3otoseriAVz7qcD49P7TzY5I+EXVJGZqaAmNhexBfjD4iOUGmD66Iw
         YfHxPI6x6RdzCUtyeCwSQuptYd93Gzpnx/69DFpXuK1ikAO7GKtT/8R5R/Zta9XA7F
         ozX0jzu+g8qtKTYtd+2jUjZ1UVSYhCxSQXOgVg9Q=
Date:   Tue, 20 Aug 2019 16:03:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH AUTOSEL 5.2 09/44] intel_th: Use the correct style for
 SPDX License Identifier
Message-ID: <20190820200304.GS30205@sasha-vm>
References: <20190820134028.10829-1-sashal@kernel.org>
 <20190820134028.10829-9-sashal@kernel.org>
 <20190820142722.GA816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190820142722.GA816@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 07:27:22AM -0700, Greg Kroah-Hartman wrote:
>On Tue, Aug 20, 2019 at 09:39:53AM -0400, Sasha Levin wrote:
>> From: Nishad Kamdar <nishadkamdar@gmail.com>
>>
>> [ Upstream commit fac7b714c514fcc555541e1d6450c694b0a5f8d3 ]
>>
>> This patch corrects the SPDX License Identifier style
>> in header files related to Drivers for Intel(R) Trace Hub
>> controller.
>> For C header files Documentation/process/license-rules.rst
>> mandates C-like comments (opposed to C source files where
>> C++ style should be used)
>>
>> Changes made by using a script provided by Joe Perches here:
>> https://lkml.org/lkml/2019/2/7/46
>>
>> Suggested-by: Joe Perches <joe@perches.com>
>> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/hwtracing/intel_th/msu.h | 2 +-
>>  drivers/hwtracing/intel_th/pti.h | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>
>Not really a stable patch at all, unless you want to start backporting
>all SPDX changes (hint, NO we do not!)  :)
>
>please drop this from everywhere.
>
>And what triggered this?  It's just comment changes, shouldn't the
>autobot know to ignore those?

It got a score just above my cutoff, and I missed it during review :(

FWIW, there's no explicit rule to ignore documentation, AUTOSEL sort of
learned to do it on it's own, but here it seems that the content of the
commit message outweighed the code change metrics.

--
Thanks,
Sasha
