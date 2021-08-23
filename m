Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29BC3F4C66
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 16:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhHWOc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 10:32:58 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:53956 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230004AbhHWOc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 10:32:57 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.203])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 58BE41C007B;
        Mon, 23 Aug 2021 14:32:13 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D808CAC008D;
        Mon, 23 Aug 2021 14:32:12 +0000 (UTC)
Received: from [192.168.254.6] (unknown [50.34.183.227])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1290D13C2B1;
        Mon, 23 Aug 2021 07:32:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1290D13C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1629729132;
        bh=Suph8N33Dg8q+AI7Tnijg0maK1o1PGLl3M1l8TWgnFE=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=iUEZTDkai8YgJvEdW+V0HXyDhBVf05/zAwJK5RV4ojS4zy2dRhmflkfaZN0omUVQQ
         Wfr26vsExitvKf7FdMlf/X+p7mmbnlAf6jmR5KuBWB4BUYiB7WTMP20L9NMr7MdUYa
         f6+DddzaRex8U1gD9BIVpwlEhWWHL1vzUn5B067E=
Subject: Re: Drivers for Qualcomm wifi chips (ath*k) and security issues
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <20210823140844.q3kx6ruedho7jen5@pali>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <18c5a8be-66d7-0dd8-b158-0931335f7ac5@candelatech.com>
Date:   Mon, 23 Aug 2021 07:32:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210823140844.q3kx6ruedho7jen5@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
X-MDID: 1629729133-krNcDAnYg5xC
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/21 7:08 AM, Pali Rohár wrote:
> Hello Sasha and Greg!
> 
> Last week I sent request for backporting ath9k wifi fixes for security
> issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintainers
> did not it for more months... details are in email:
> https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t/#u

For one thing, almost everyone using these radios is using openwrt or
similar which has its own patch sets.

So, it is good to have the patches backported to real kernels,
but also, for actual users of these, it matters more what openwrt
has done...

Thanks,
Ben

> 
> And now I got reports that in stable LTS kernels (4.14, 4.19) are
> missing also other fixes for other Qualcomm wifi security issues,
> covered by FragAttacks codename: CVE-2020-26145 CVE-2020-26139
> CVE-2020-26141
> 
> People have already asked if somebody is already doing backports to 4.19
> of patches for these security issues, but there was no response, see email:
> https://lore.kernel.org/linux-wireless/704e1c77-6c48-79f7-043a-b2d03fbfef8b@candelatech.com/
> 
> I got information that issues for ath10k are again going to be (or are
> already?) fixed in some vendor custom/fork kernels, but not in official
> stable tree 4.14/4.19 (yet).
> 
> This situation is really bad because lot of times I hear to use mainline
> kernel versions or official stable LTS tree (which are maintained by
> you), but due to such security issues in LTS trees which stays unfixed
> and others say to use rather vendor custom/fork kernels where it is
> claimed that issues are fixed.
> 
> And because there is no statement for end users (end users do not
> communicate with vendors and so they do not have information what is
> supported and what not), end users just use what Linux open source
> distributions have in their kernels (which lot of times match official
> LTS kernel trees). And users think that everything is OK and security
> issues are fixed.
> 
> So there is really a need for public statement from you or Qualcomm
> side, if stable LTS kernel trees are going to include security fixes for
> drivers used by Qualcomm wifi chips (ath*k) or not or under which
> conditions. And what should users / Linux distributions use if they do
> not want to have years-old unpatched drivers with security issues. Such
> information is really important also for distributions which include
> unmodified (or slightly modified) kernel LTS trees into their own
> packages. As they also need to know from which source should take
> (e.g. Qualcomm wifi) drivers for their systems to ensure that have
> security patches applied.
> 
> I can understand that you or other people or volunteers do not have time
> to track or maintain some parts of drivers. So nothing wrong if official
> statement is that stable trees X and Y do not receive security updates
> for driver A and B anymore. Also I can understand that it takes some
> time to include required fixes, so expect fixes for A and B in X and Y
> versions with one month delay. But it is needed to know what should
> people expect from LTS trees for particular drivers. Because I think it
> is not currently clear...
> 
> Do not take me wrong, I just wanted to show that this is hidden problem
> which needs some discussion.
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
