Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ED51EB339
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 04:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgFBCGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 22:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgFBCGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 22:06:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D63206A4;
        Tue,  2 Jun 2020 02:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591063613;
        bh=ixQj61t9M6UFWzofL346HRs/7Q0M66ni67NkvMxa3tQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jSWFBH5xzm2H7Ufja5sLY9VvtdYow/nehiLNySa4dVJm/y/8IWnDrTjoVEEzouISn
         jBFBJ/hJ0FuQ5q0fO2FYbHP6FfKgWwEyk4DuTUVhiRdo0pp5qMCGkxIDYsHSteyyEd
         rA7PmU0YHmqCto+/AT1EAXYkwW7ByTZW9TujfUyo=
Date:   Mon, 1 Jun 2020 22:06:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/48] 4.4.226-rc1 review
Message-ID: <20200602020651.GM1407771@sasha-vm>
References: <20200601173952.175939894@linuxfoundation.org>
 <OSAPR01MB23858265B59669B78394A94CB78A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <OSAPR01MB23858265B59669B78394A94CB78A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 10:14:20PM +0000, Chris Paterson wrote:
>Hi Greg,
>
>> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
>> Behalf Of Greg Kroah-Hartman
>> Sent: 01 June 2020 18:53
>>
>> This is the start of the stable review cycle for the 4.4.226 release.
>> There are 48 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>
>I'm seeing some issues with Linux 4.4.226-rc1 (dc230329b026).
>
>We have 4 configurations that fail, 2x Armv7 and 2x x86, whilst building the modules.
>
>Error message:
>  ERROR: "pptp_msg_name" [net/netfilter/nf_conntrack_pptp.ko] undefined!
>  ERROR: "pptp_msg_name" [net/ipv4/netfilter/nf_nat_pptp.ko] undefined!
>
>Relevant patches are:
>  69969e0f7e37 ("netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code")
>  3441cc75e4d1 ("netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build")
>
>I haven't had a chance to dig deeper yet but will do in the morning.
>
>Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/151700917
>GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.4.y.yml
>Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=dc2303#table

Thats and interesting one... I've queued fe22cd9b7c98 ("printk: help
pr_debug and pr_devel to optimize out arguments") for 4.4 to address
this.

Thanks for the report Chris!

-- 
Thanks,
Sasha
