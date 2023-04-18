Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677D26E6545
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjDRNDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjDRNDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:03:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5726B17924
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:03:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v3so2454403wml.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681822991; x=1684414991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+f5wdpWjh3iIPY3KgDO82le+u9v0rqGfN6aj5PFaO/o=;
        b=deDOSTL/j3dWGe6ohHgrPn1jCEnp2ukP8LXydZuNIZksYlhuAA4uqSBs9XKFc48ESH
         XDK6JouwtftrTZtU0nppVQyaw/DGC4cDLHSJNQa2LMTheHPA1r5lpy2W3adJge9qQLZc
         noxm7B+m/9rpy3MoPxHrKhuEXAwSK8KvttosJLOGQMaeeSOxvLnXie+nOFS7w7uvIFy6
         p8sVZSODTGN1JxSPYKnc7TsRkELXuJwnH96QEI9YXLE3DTCvNAaEk6uM9GqhHFeRLJrl
         un/CGnVtr/zeLxokKaxQ7wUz1oigNOz3xbeJCw5oWsUloSXaA0uL2ILPbqytTzDVJyU4
         wyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681822991; x=1684414991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+f5wdpWjh3iIPY3KgDO82le+u9v0rqGfN6aj5PFaO/o=;
        b=FXXXtYbgXsQQcYb40FSLH0IYqL0pIoxm4BTcK5aJ+z+1qTTCwzq+0nGo4avai/iqjx
         3ad3jSrEeUqesW1iCgXnmogWDE0H/UKAsVl31jIYMgmMWI2JMSSig7r9KDM6drl7FoqV
         /OsUe881Ot1ws9ppnBieBKB6ThgeinfJwE5Ly9HtCeC8fgnQJ0/X2VMHQnG8I2NK5YkW
         TnfXBOiN2qqycMM/Jic9hh5t7PJd82fgQiZvhCd2Pkqvadl6bsq6FOb51oYOAL2LuyCa
         82oqy3E7pkdJfzsMxiptLG++lk/akewe76GrwJGENTydJl4JtvS6xF4QaCjc4YSO19LF
         w+oA==
X-Gm-Message-State: AAQBX9fjF7OyGelVWOI3jljcxth8A0oFq4SEkqrgGavJZOq10bLnBYG8
        7DN83+oa4qb3jmH6aIh/id5rqryiofPFl6pvRao=
X-Google-Smtp-Source: AKy350YkFxpcxK7zQ7NyPhOlxYfV408TPsS7mHtyZRyaapDCmLRiQ8UU4AUupoYPDpTFCySa8YMCGQ==
X-Received: by 2002:a1c:7707:0:b0:3f0:a3cb:c750 with SMTP id t7-20020a1c7707000000b003f0a3cbc750mr12586750wmi.40.1681822991276;
        Tue, 18 Apr 2023 06:03:11 -0700 (PDT)
Received: from airbuntu ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id y1-20020a1c4b01000000b003ef5f77901dsm14885468wma.45.2023.04.18.06.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:03:10 -0700 (PDT)
Date:   Tue, 18 Apr 2023 14:03:09 +0100
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v2 00/10] Backport uclamp vs margin fixes into 5.10.y
Message-ID: <20230418130309.rzk7sqy2dzvgcllx@airbuntu>
References: <20230318173943.3188213-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230318173943.3188213-1-qyousef@layalina.io>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 03/18/23 17:39, Qais Yousef wrote:
> Changes in v2:
> 	* Fix compilation error against patch 7 due to misiplace #endif to
> 	  protect against CONFIG_SMP which doesn't contain the newly added
> 	  field to struct rq.
> 
> Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
> migration margin") was cherry-picked into 5.10 kernels but missed the rest of
> the series.
> 
> This ports the remainder of the fixes.
> 
> Based on 5.10.172.
> 
> NOTE:
> 
> a2e90611b9f4 ("sched/fair: Remove capacity inversion detection") is not
> necessary to backport because it has a dependency on e5ed0550c04c ("sched/fair:
> unlink misfit task from cpu overutilized") which is nice to have but not
> strictly required. It improves the search for best CPU under adverse thermal
> pressure to try harder. And the new search effectively replaces the capacity
> inversion detection, so it is removed afterwards.
> 
> Build tested on (cross compile when necessary; x86_64 otherwise):
> 
> 	1. default ubuntu config which has uclamp + smp
> 	2. default ubuntu config without uclamp + smp
> 	3. default ubunto config without smp (which automatically disables
> 	   uclamp)
> 	4. reported riscv-allnoconfig, mips-randconfig, x86_64-randocnfigs
> 
> Tested on 5.10 Android GKI kernel and android device (with slight modifications
> due to other conflicts on there).

Just checking if this has slipped through the cracks or it's on the queue just
waiting for the right time to be picked up. There's a similar backport for 5.15
too.


Thanks!

--
Qais Yousef
