Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265ED5B77F8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiIMR2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiIMR1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:27:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3310A2DDB
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAEF7B80FEA
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 16:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4BEC433D6;
        Tue, 13 Sep 2022 16:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663085767;
        bh=hFl19zTgAM5/BLTeyCxa8z2MqPXQ+YFzktpzoLhc0eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lSfbxskrRB6mF1AfFMtJcjk76Z3FFz6c4iVgvuCwmAhqfVKm1b46z9f+ASwKKjsOY
         b7r4actKCKId4EnTXpB0Iq4O8EgqDinvmSGPbHzY8PWs7YnYg5WKjnbwf00FGwIJMq
         FEqXOYFz6aUc5zY6jHXhNRu6MuHPfwyBtexTvNUFNoSfvee205ly0JcqiQl52lwA6L
         jhUZWkrYspSDBwmpFNKWS031sOD2KZBG/WVsap4FmQrKsDwLuwo5ZhE7OpkOJ/9Mpi
         Pk3x+i9JvFCq26y+R/D2lrUVQ27nSI0ViCDvgf9qSmSFVn2psv7grBqj8KVsqbroJU
         961XFuqs1o+vQ==
Date:   Tue, 13 Sep 2022 12:16:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Subject: Re: stable-rc: 5.4: cgroup.c:2404:2: error: implicit declaration of
 function 'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
Message-ID: <YyCsxQsGYdDAlFiy@sashalap>
References: <CA+G9fYtro2f2u3Wug7YS7kC=iVGWsee+Vnvm4U20+xXsYVjK5w@mail.gmail.com>
 <YyCMtuuft3Uc4ka7@sashalap>
 <CA+G9fYvnc4q4kFGWEYHounj1a7PdQ8f4AefgjUFqNVn9d6h8kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYvnc4q4kFGWEYHounj1a7PdQ8f4AefgjUFqNVn9d6h8kA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 07:52:38PM +0530, Naresh Kamboju wrote:
>On Tue, 13 Sept 2022 at 19:29, Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Tue, Sep 13, 2022 at 04:48:44PM +0530, Naresh Kamboju wrote:
>> >On stable-rc 5.4 arm and arm64 builds failed due to following errors / warnings.
>> >
>> >kernel/cgroup/cgroup.c:2404:2: error: implicit declaration of function
>> >'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
>> >        cpus_read_lock();
>> >        ^
>> >kernel/cgroup/cgroup.c:2404:2: note: did you mean 'cpuset_read_lock'?
>> >include/linux/cpuset.h:58:13: note: 'cpuset_read_lock' declared here
>> >extern void cpuset_read_lock(void);
>> >            ^
>> >kernel/cgroup/cgroup.c:2417:2: error: implicit declaration of function
>> >'cpus_read_unlock' [-Werror,-Wimplicit-function-declaration]
>> >        cpus_read_unlock();
>> >        ^
>> >kernel/cgroup/cgroup.c:2417:2: note: did you mean 'cpuset_read_unlock'?
>> >include/linux/cpuset.h:59:13: note: 'cpuset_read_unlock' declared here
>> >extern void cpuset_read_unlock(void);
>> >            ^
>> >2 errors generated.
>> >
>> >drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation;
>> >statement is not part of the previous 'if' [-Wmisleading-indentation]
>> >         */     mutex_lock(&dev->struct_mutex);
>> >                ^
>> >drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
>> >        if (!drm_core_check_feature(dev, DRIVER_LEGACY))
>> >        ^
>> >1 warning generated.
>> >
>> >Build link:
>> > - https://builds.tuxbuild.com/2EfrNYbejRQczhhqndawRkHARHZ/
>> >
>> >
>> >Steps to reproduce:
>> >-------------------
>> ># To install tuxmake on your system globally:
>> ># sudo pip3 install -U tuxmake
>> >#
>> >
>> >tuxmake --runtime podman --target-arch arm64 --toolchain clang-nightly
>> >--kconfig defconfig LLVM=1 LLVM_IAS=1
>>
>> Hm, I can't reproduce this one, (and can't install tuxmake on the work
>> machine). What's the actual config that you end up using here?
>
>The "defconfig" for arm64 with clang nightly.

Greg actually ended up fixing it up and I haven't noticed, thanks both
:)

-- 
Thanks,
Sasha
