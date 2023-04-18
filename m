Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FD06E6C65
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjDRSrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 14:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjDRSrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 14:47:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDDFA275;
        Tue, 18 Apr 2023 11:47:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 41so46062pjo.0;
        Tue, 18 Apr 2023 11:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681843665; x=1684435665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=qdrElW73CyUlcUQEClO9EDUAz3mThnr1vcZk4xLQL2k=;
        b=MyDX1zU5nDUFfCk7a8bqMnmAoiE+/xQMuOgeWvgr4UbWB9NVcgfTrYc9XIwjtd6eLN
         ekqQEyaGmCmygL7e31av4ogs7r9J+T0icRsx0szp56/AOvQYljJMfKowIcR4qP+5O3va
         ps9my6LUGYeqHl0lm2ML51nFAmQZj/arP5PPQRVSuPvbG/OYpGpDXP2BKSHQS+B6eRWm
         EEVLtnWEHp7TGl/EwnSUVEU/1Rp0KJQmksl2rQ7tse8nxTnYp/jkPuty2sK6ault5/fN
         pOa1f/FV8xRwX1fhI/i3daIgQu8rJ9ZjgGfS7Wze2vmyUhqex8SzxQY+0NpWXUFicvqA
         e+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681843665; x=1684435665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdrElW73CyUlcUQEClO9EDUAz3mThnr1vcZk4xLQL2k=;
        b=Gp+NFrbiw09ezrdzI6ovN7o2+da9rE+JY+pse6iYDZuNVRlNqBB1ysE6gl4uvsHF6E
         26y4I8lwNBrWxu/lUiWYdRNqU98p0SlDhXibIRyY0UvRQklWA3HuTGSUnmxej3Ck929E
         hzI+VAlGjP2XPGtMu8b2cSMoKHHD2ri9nycjuBVxgRjR5Id3/so098NU3rUB7uIr8b0K
         Meje8VXzpH9r9Zd3kw0UbX2OkML3l+aMcJRcpBamKFtY7kikqBtSNDaYAqy09XeLr3lL
         zdj4R35K8gHMkh/d5asa2wc0Ij60lKAHU9ChlxuiH6DeKVocf1TKujhMVvGXuiAJ55nG
         Ek0g==
X-Gm-Message-State: AAQBX9cd5Z/xjlpE135dObdqbb5H1Ge6HuRqCtceZ23hM9hK0irjXkR4
        Km3QE3l4I9jakN/+z5rlXiw=
X-Google-Smtp-Source: AKy350YWAZo62MlxCISzCzTXCWB6HNcLN+rogclsKSl19ZhfESlpqOSpTd+nyaD1f8ff6CcIRE3pqA==
X-Received: by 2002:a05:6a20:938b:b0:ef:e017:c60f with SMTP id x11-20020a056a20938b00b000efe017c60fmr593762pzh.51.1681843665590;
        Tue, 18 Apr 2023 11:47:45 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020a63d703000000b0050bc4ca9024sm9106874pgg.65.2023.04.18.11.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 11:47:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <81e21f0a-a149-7bd7-e37d-741ddce101eb@roeck-us.net>
Date:   Tue, 18 Apr 2023 11:47:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
 <2023041819-canyon-unarmored-38c6@gregkh>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023041819-canyon-unarmored-38c6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/23 08:34, Greg Kroah-Hartman wrote:
> On Tue, Apr 18, 2023 at 08:38:47PM +0530, Naresh Kamboju wrote:
>> On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 5.10.178 release.
>>> There are 124 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Following build errors noticed on 5.15 and 5.10.,
>>
>>
>>> Waiman Long <longman@redhat.com>
>>>      cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
>>
> 
> That's a documentation patch, it can not:
> 
>> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
>> kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
>> (first use in this function); did you mean 'cgroup_put'?
>>   2941 |         lockdep_assert_held(&cgroup_mutex);
> 
> Cause this.
> 
> What arch is failing here?  This builds for x86.
> 
No, it doesn't.

Build reference: v5.10.177-125-g19b9d9b9f62e
Compiler version: x86_64-linux-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building x86_64:defconfig ... failed
--------------
Error log:
In file included from include/linux/rcupdate.h:29,
                  from include/linux/rculist.h:11,
                  from include/linux/pid.h:5,
                  from include/linux/sched.h:14,
                  from include/linux/ratelimit.h:6,
                  from include/linux/dev_printk.h:16,
                  from include/linux/device.h:15,
                  from include/linux/node.h:18,
                  from include/linux/cpu.h:17,
                  from kernel/cgroup/cpuset.c:25:
kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared (first use in this function); did you mean 'cgroup_put'?
  2941 |         lockdep_assert_held(&cgroup_mutex);
       |                              ^~~~~~~~~~~~
include/linux/lockdep.h:393:61: note: in definition of macro 'lockdep_assert_held'
   393 | #define lockdep_assert_held(l)                  do { (void)(l); } while (0)
       |                                                             ^
kernel/cgroup/cpuset.c:2941:30: note: each undeclared identifier is reported only once for each function it appears in
  2941 |         lockdep_assert_held(&cgroup_mutex);
       |                              ^~~~~~~~~~~~
include/linux/lockdep.h:393:61: note: in definition of macro 'lockdep_assert_held'
   393 | #define lockdep_assert_held(l)                  do { (void)(l); } while (0)
       |                                                             ^
make[3]: *** [scripts/Makefile.build:286: kernel/cgroup/cpuset.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:503: kernel/cgroup] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Makefile:1828: kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:192: __sub-make] Error 2
