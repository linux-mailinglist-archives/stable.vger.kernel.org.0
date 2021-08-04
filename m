Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC3A3DF8C3
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 02:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhHDAMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 20:12:33 -0400
Received: from 2098.x.rootbsd.net ([208.79.82.66]:55009 "EHLO pilot.trilug.org"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S233118AbhHDAMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 20:12:33 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2021 20:12:32 EDT
Received: by pilot.trilug.org (Postfix, from userid 8)
        id 52AC95979A; Tue,  3 Aug 2021 20:04:10 -0400 (EDT)
Received: from michaelmarley.com (unknown [IPv6:2605:a600:1d05:afa8::1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilot.trilug.org (Postfix) with ESMTPSA id 1B5005838B;
        Tue,  3 Aug 2021 20:04:07 -0400 (EDT)
Received: from michaelmarley.com (localhost [IPv6:::1])
        by michaelmarley.com (Postfix) with ESMTP id 5478C18010B;
        Tue,  3 Aug 2021 20:04:06 -0400 (EDT)
Received: from [IPv6:fdda:5f29:421b:3:99bb:f97:ec80:f7a6] ([fdda:5f29:421b:3:99bb:f97:ec80:f7a6])
        by michaelmarley.com with ESMTPSA
        id NqdiFHbZCWH5PQAAnAHMIA
        (envelope-from <michael@michaelmarley.com>); Tue, 03 Aug 2021 20:04:06 -0400
Subject: Re: Faulty commit "watchdog: iTCO_wdt: Account for rebooting on
 second timeout"
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Jean Delvare <jdelvare@suse.de>,
        linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
References: <20210803165108.4154cd52@endymion>
 <e13f45c4-70e2-e2c2-9513-ce38c8235b4f@siemens.com>
From:   Michael Marley <michael@michaelmarley.com>
Message-ID: <934e0af4-3c4c-3ac5-30e2-958f0725a21d@michaelmarley.com>
Date:   Tue, 3 Aug 2021 20:04:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e13f45c4-70e2-e2c2-9513-ce38c8235b4f@siemens.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/21 10:59 AM, Jan Kiszka wrote:

> https://lkml.org/lkml/2021/7/26/349

It fixes the problem for me (the person who opened the Bugzilla report) 
too, thanks!

Tested-by: Michael Marley <michael@michaelmarley.com>

