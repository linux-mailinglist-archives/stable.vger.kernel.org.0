Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F03911915
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 14:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfEBMc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 08:32:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:26643 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBMc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 08:32:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 05:32:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147544813"
Received: from mylly.fi.intel.com (HELO [10.237.72.57]) ([10.237.72.57])
  by orsmga003.jf.intel.com with ESMTP; 02 May 2019 05:32:24 -0700
Subject: Re: [PATCH] i2c: Prevent runtime suspend of adapter when Host Notify
 is required
To:     Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa@the-dreams.de>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>
References: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
 <20190430155637.1B45E21743@mail.kernel.org>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <7f989564-e994-5be6-02da-2838639efe59@linux.intel.com>
Date:   Thu, 2 May 2019 15:32:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430155637.1B45E21743@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/30/19 6:56 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: c5eb1190074c PCI / PM: Allow runtime PM without callback functions.
> 
> The bot has tested the following trees: v5.0.10, v4.19.37.
> 
> v5.0.10: Build OK!
> v4.19.37: Failed to apply! Possible dependencies:
>      6f108dd70d30 ("i2c: Clear client->irq in i2c_device_remove")
>      93b6604c5a66 ("i2c: Allow recovery of the initial IRQ by an I2C client device.")
> 
> 
> How should we proceed with this patch?
> 
There's also dependency to commit
b9bb3fdf4e87 ("i2c: Remove unnecessary call to irq_find_mapping")

Without it 93b6604c5a66 doesn't apply.

Otherwise my patch don't have dependency into these so I can have 
another version for 4.19 if needed.

I got impression from the mail thread for 6f108dd70d30 that it could be 
also stable material but cannot really judge.

Charles: does your commits b9bb3fdf4e87 and 6f108dd70d30 with the fix 
93b6604c5a66 qualify for 4.19? (background: my fix doesn't apply without 
them but doesn't depend on them).

-- 
Jarkko
