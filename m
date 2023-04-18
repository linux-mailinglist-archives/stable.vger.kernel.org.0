Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7E6E6ADA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 19:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjDRRZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 13:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRRZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 13:25:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F5A7ED7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 10:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681838659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jn5RPEGr1DTajVAXu1piR4pVm7hgdJHjJ9pFrb3qnus=;
        b=YEYJA6k+322di1W+LkWzLobgm8fjQYxjjjtnnXF8SQeOy5Cbwdi3J/6quDNmtPTneCI1qV
        edPV3B5ZLmEmhB8pU7cdOQF4OygF+lnX2/k5B8QQ4UvR4D6fUgS0UuUQplN+NoCMpxofkZ
        3Q8DYVl2H9CuOYeH7VpL333VI6yje88=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-vrkqTGiTMBSQePpWxYnGUw-1; Tue, 18 Apr 2023 13:24:14 -0400
X-MC-Unique: vrkqTGiTMBSQePpWxYnGUw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8283C85C6E0;
        Tue, 18 Apr 2023 17:24:13 +0000 (UTC)
Received: from [10.22.34.98] (unknown [10.22.34.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C643492B04;
        Tue, 18 Apr 2023 17:24:12 +0000 (UTC)
Message-ID: <76d8bf7a-20ec-481e-2c21-e456a29e731e@redhat.com>
Date:   Tue, 18 Apr 2023 13:24:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/18/23 11:08, Naresh Kamboju wrote:
> On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 5.10.178 release.
>> There are 124 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> Following build errors noticed on 5.15 and 5.10.,
>
>
>> Waiman Long <longman@redhat.com>
>>      cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
> (first use in this function); did you mean 'cgroup_put'?
>   2941 |         lockdep_assert_held(&cgroup_mutex);
>        |                              ^~~~~~~~~~~~
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Suspected commit,
> cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.

Oh, cgroup_mutex needs the recent commit 354ed59744295 ("mm: multi-gen 
LRU: kill switch") to make it available in include/linux/cgroup.h. I did 
my testing with a debug Kconfig and so didn't catch that. This line can 
be safely removed.

Regards,
Longman

