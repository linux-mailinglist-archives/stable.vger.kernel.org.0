Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35405EF3C
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 00:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfGCWpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 18:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfGCWpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 18:45:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 005FC21882;
        Wed,  3 Jul 2019 22:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562193932;
        bh=roUPOwnfv8OnIk/SPlgOJqDs/8VdDdiWpv+VltJNB4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l1c9iahUAHDTdjeP2SKf0hsTb6yO5g72zyVOEUkRUNxu0eCA9d4TuERYImpetO+M5
         OOxMOF8+AmWxyKUsaXJWD6naAcp2ysIreLboSTUszUoq4oTQU/GeTx+QC51BCwa6fy
         BcUbGzu4BFWBZLA3eV/K20NV7/xIv9DtIf2zYElw=
Date:   Wed, 3 Jul 2019 18:45:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "4.4.y backports" <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [STABLE-4.9] proposed backports
Message-ID: <20190703224530.GC10104@sasha-vm>
References: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
 <CAK8P3a3M7cuxPeoZrNKaQGayg-Q6-UH+JEN4gsMDNxa9SWBpUw@mail.gmail.com>
 <CAK8P3a11WpSu8qzyHme9vDZdmv-ZgdFhc1-3rw8LeygbdYER8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK8P3a11WpSu8qzyHme9vDZdmv-ZgdFhc1-3rw8LeygbdYER8Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 10:43:40PM +0200, Arnd Bergmann wrote:
>On Wed, Jul 3, 2019 at 10:31 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> Here is a similar list for 4.9, from
>> https://kernelci.org/build/stable-rc/branch/linux-4.9.y/kernel/v4.9.184-66-g79155cd391a8/
>
>On 4.14, I can only see one missing patch in
>https://kernelci.org/build/stable-rc/branch/linux-4.14.y/kernel/v4.14.132-2-g69aa9e7d0127/
>
>02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()")

Queued this up, thanks!

--
Thanks,
Sasha
