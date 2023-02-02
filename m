Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5EE6873A2
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 04:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjBBDHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 22:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjBBDHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 22:07:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F55423313;
        Wed,  1 Feb 2023 19:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 741ABB823CC;
        Thu,  2 Feb 2023 03:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E480CC433EF;
        Thu,  2 Feb 2023 03:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675307215;
        bh=eYXPWTFHiITpeJo1JorY94S7/wJqa2OPdSmqFY0OjmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UeAU1mihRu9aA6MfUsFebJHMkhg6V6mcHhf3ObtxeuNnDUkdDZDzsQhPQh30VIoHn
         t74m71wlE9Ezn4/0AckUtCb/vx63BtHgbZ0Pvrt0E9hLdNIlYtdgyqxmLtmmm4cC7J
         8+tgRjIwO3NST750hTgDug+ehw5trhNGRvgR4e9C9hsuIuR+tMrLFGxXLNMf+zxnwP
         tgZVMmf02D8LueMaR1Piu54eL9nx1kb1glzPfzcKW+IlpMcFi6wxOoxptv2nwL1D1Q
         HsznnHa7rxnYJ05HiTnt7otBFO25+W3ojkRMwKIfK5ouLrJSozXm6YpLbrkcjKj5H1
         uvmNVEQe+1vRQ==
Date:   Wed, 1 Feb 2023 22:06:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: Patch "gpiolib: acpi: Allow ignoring wake capability on pins
 that aren't in _AEI" has been added to the 6.1-stable tree
Message-ID: <Y9sozVJN7/7ltSCq@sashalap>
References: <20230201164307.1305059-1-sashal@kernel.org>
 <MN0PR12MB6101CA1D078964276862BBAAE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101CA1D078964276862BBAAE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 07:39:29PM +0000, Limonciello, Mario wrote:
>[Public]
>
>
>
>> -----Original Message-----
>> From: Sasha Levin <sashal@kernel.org>
>> Sent: Wednesday, February 1, 2023 10:43
>> To: stable-commits@vger.kernel.org; Limonciello, Mario
>> <Mario.Limonciello@amd.com>
>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>; Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com>; Linus Walleij
>> <linus.walleij@linaro.org>; Bartosz Golaszewski <brgl@bgdev.pl>
>> Subject: Patch "gpiolib: acpi: Allow ignoring wake capability on pins that aren't
>> in _AEI" has been added to the 6.1-stable tree
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     gpiolib: acpi: Allow ignoring wake capability on pins that aren't in _AEI
>>
>> to the 6.1-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-
>> queue.git;a=summary
>>
>> The filename of the patch is:
>>      gpiolib-acpi-allow-ignoring-wake-capability-on-pins-.patch
>> and it can be found in the queue-6.1 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Hi Sasha,
>
>I suggest you also pick up two other fixes to go with this one.
>
>1) this fix which was in the same series:
>
>4cb786180dfb ("gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xRU")

This commit has a fixes tag which points to a commit we don't have in
the 6.1 tree: 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting
wakeup_capable"), could you confirm?

>2) This fix which is tangentially related (fixes something from the same original
>series that exposed the regressions).
>
>d63f11c02b8d ("gpiolib-acpi: Don't set GPIOs for wakeup in S3 mode")

Same as above.

-- 
Thanks,
Sasha
