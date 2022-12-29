Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC51658CD0
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 13:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiL2MrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 07:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiL2Mqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 07:46:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F5B6329;
        Thu, 29 Dec 2022 04:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FAD1617A3;
        Thu, 29 Dec 2022 12:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8414DC433EF;
        Thu, 29 Dec 2022 12:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672317991;
        bh=NhzEzL3mH/Ln9H0QZ9QYf9gpWknVUIsofL72rq0A1eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SbVFfEg6hwrgE/e8xFDNnzLyjoQSdK1h/tmbBkyD5QitfpoMnpxWZJYbD5YoqRgis
         DXh3++cWNX8srarLqpz9TkJ4CVY7Sj51Yo9bBG7moghdq/kUM/iYf8mZlw9kd6uc6m
         7LaUBIuKLPjYOhDlcmr6Pq4azqYTTj1SDmoojNSi6vFYELGUIvRLW/YPsfK5nDCmEN
         T24AVG1RhShJeBjohncNaoCnkSZsgOodM0cPoMgxYXDRHB1iivm9KHBXOCPehg8aoR
         5hql/4FW6yImlc1ezwh9dWbVWe9+Sme0HWdd++YNW7aM7/IppYisomBVsMBpNrqDpc
         JgKy+GyWw9bOw==
Date:   Thu, 29 Dec 2022 07:46:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y62MJrWiVB6tgdR7@sashalap>
References: <20221228144330.180012208@linuxfoundation.org>
 <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>
 <20221228213123.GA2229529@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221228213123.GA2229529@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 01:31:23PM -0800, Guenter Roeck wrote:
>On Wed, Dec 28, 2022 at 03:15:01PM -0600, Daniel Díaz wrote:
>> Hello!
>>
>>
>> On 28/12/22 08:25, Greg Kroah-Hartman wrote:
>> > This is the start of the stable review cycle for the 6.1.2 release.
>> > There are 1146 patches in this series, all will be posted as a response
>> > to this one.  If anyone has any issues with these being applied, please
>> > let me know.
>> >
>> > Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
>> > Anything received after that time might be too late.
>> >
>> > The whole patch series can be found in one patch at:
>> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
>> > or in the git tree and branch at:
>> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> > and the diffstat can be found below.
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>> We're seeing the already reported problem with the unused variable 'rpm', but also seeing this on Arm, i386, MIPS, PA-RISC:
>>
>I see this as well if I try to build with gcc 9.4, but not with gcc 11.3.
>Interesting.
>
>Anyway, the problem is fixed upstream with commit dd1f1da4ada5
>("pwm: tegra: Fix 32 bit build").

I'll queue up dd1f1da4ada5, thanks!

-- 
Thanks,
Sasha
