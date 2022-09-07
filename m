Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02515AFEA9
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 10:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiIGINb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 04:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiIGINa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 04:13:30 -0400
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AC3AA347
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 01:13:26 -0700 (PDT)
Received: from alt-proxy28.mail.unifiedlayer.com (unknown [74.220.216.123])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 66CF2802BD69
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 08:13:25 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 910501003FCF9
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 08:13:09 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id VqBIoYxmbCokGVqBJoXE2v; Wed, 07 Sep 2022 08:13:09 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=c8Nu/Txl c=1 sm=1 tr=0 ts=63185295
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=xOM3xZuef0cA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=VkIJ4bYSlH-4ozLDUtgA:9
 a=QEXdDO2ut3YA:10:nop_charset_2 a=AjGcO6oz07-iQ99wixmX:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4A2rtVgDrZ2UAOz6av2oGnGqktMAjZu+FGdqVMPZNZA=; b=AKnIV45ZuZrQC2HvY7AvkOVz8b
        AApYo48dmJNuIvQpDgzt+wmtDaJEXk0I/q2y76KiqzxwyQPj5aVBcmnaDDFgmqMhrxbSmwuB3STA+
        xFziOW3z9eH3GKMYGk+RkgAJaKRm4z/794yo1iAnOTR2kh7gkbFM5OVJWQFyUVy9Aa/15MJT0rRez
        sX0ESO1ClI/Fup5YlMdXo+HnesT/WgLdcTPLvke0AIB6E1iapn0+OcZ4GzyrDG4/Z3VGuPSUsgcc+
        jkUBXbWLXZktP49OBHMYjcomoKneVPm+hO8kipwWKEyRzybEJ0Q6YpwXSfaFee34g51Yzawi1CCd7
        /dflb/yw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:43504 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oVqBI-0046de-Jn;
        Wed, 07 Sep 2022 02:13:08 -0600
Subject: Re: [PATCH 5.15 101/107] kbuild: Unify options for BTF generation for
 vmlinux and modules
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.130642856@linuxfoundation.org>
 <291d739c-752f-ead3-1974-a136b986afb7@gmail.com> <YxguwCpBEKAJJDU6@kroah.com>
In-Reply-To: <YxguwCpBEKAJJDU6@kroah.com>
From:   Ron Economos <re@w6rz.net>
Message-ID: <06ea51d3-6f7f-c5c7-0b77-0d4b31ef9a52@w6rz.net>
Date:   Wed, 7 Sep 2022 01:13:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1oVqBI-0046de-Jn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:43504
X-Source-Auth: re@w6rz.net
X-Email-Count: 4
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/22 10:40 PM, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 11:45:00AM -0700, Florian Fainelli wrote:
>>
>> On 9/6/2022 6:31 AM, Greg Kroah-Hartman wrote:
>>> From: Jiri Olsa <jolsa@redhat.com>
>>>
>>> commit e27f05147bff21408c1b8410ad8e90cd286e7952 upstream.
>>>
>>> Using new PAHOLE_FLAGS variable to pass extra arguments to
>>> pahole for both vmlinux and modules BTF data generation.
>>>
>>> Adding new scripts/pahole-flags.sh script that detect and
>>> prints pahole options.
>>>
>>> [ fixed issues found by kernel test robot ]
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>>> Link: https://lore.kernel.org/bpf/20211029125729.70002-1-jolsa@kernel.org
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>    Makefile                  |    3 +++
>>>    scripts/Makefile.modfinal |    2 +-
>>>    scripts/link-vmlinux.sh   |   11 +----------
>>>    scripts/pahole-flags.sh   |   20 ++++++++++++++++++++
>>>    4 files changed, 25 insertions(+), 11 deletions(-)
>>>    create mode 100755 scripts/pahole-flags.sh
>> My linux-stable-rc/linux-5.15.y checkout shows that scripts/pahole-flags.sh
>> does not have an executable permission and commit
>> 128e3cc0beffc92154d9af6bd8c107f46e830000 ("kbuild: Unify options for BTF
>> generation for vmlinux and modules") does have:
>>
>> diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
>> new file mode 100644
>> index 000000000000..e6093adf4c06
>>
>> whereas your email does have the proper 100755 permission set on the file,
>> any idea what happened here?
> Yeah, quilt does not like dealing with file permissions at all :(
>
> We have over time, not required executable permissions on kernel files
> because of this issue.  Is it required here?  If so, I'll try to
> remember to fix it up "by hand".
>
> thanks,
>
> greg k-h

I'm seeing this on my RISC-V build also. The error message (repeated 
many times) is:

/bin/sh: 1: ./scripts/pahole-flags.sh: Permission denied

So the script isn't running.

