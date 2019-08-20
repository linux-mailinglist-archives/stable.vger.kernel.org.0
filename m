Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6B96988
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 21:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfHTThQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 15:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbfHTThQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 15:37:16 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6C722DA9;
        Tue, 20 Aug 2019 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566329835;
        bh=RmECbaNa3+52m57uCHzk4qd03apbfpEeYOhYHoEObHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FpS8E67bLdjPaMQSox/JOP6ZOgrbg7mSgaaSgXDuqTcG4ZCXH2MRrVVeb0QWnlxb5
         etRr0edlFI+g0EYxE0AkGJ6mUMSuCW3NrtAAlW64f/21Zo1QvyEAYI5/S8h2Qfw5QL
         k8YOtrLwWlkRP9gicYe4XF8hJ/k32cZS/6DWAoU0=
Date:   Tue, 20 Aug 2019 15:37:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 4.19 07/27] intel_th: Use the correct style for
 SPDX License Identifier
Message-ID: <20190820193715.GR30205@sasha-vm>
References: <20190820134213.11279-1-sashal@kernel.org>
 <20190820134213.11279-7-sashal@kernel.org>
 <f155ad1a9490bd273fa9c31a9745e328b346920a.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f155ad1a9490bd273fa9c31a9745e328b346920a.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 06:47:53AM -0700, Joe Perches wrote:
>On Tue, 2019-08-20 at 09:41 -0400, Sasha Levin wrote:
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
>
>Is there a reason to backport license header changes?
>
>I believe there is not.

There is not, I must have missed this one.

--
Thanks,
Sasha
