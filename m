Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EAC6E4D69
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjDQPkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDQPkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:40:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB591CD
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681745973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXcTmTaoWGkcZRbk9UXlQ9B8noHUYPUHPBlEA4Q+gQ8=;
        b=fUunqHD/mXnXtURMoS8trIE0P5FjfdbHzXQzIfYR94oxTGVJ0nDmUhsim0oEWCz7d9lHBG
        z0NxzAy2AhOIEgII/GGRJio22H2QRVV6tKViirQl53JW3ToP4Pa2pNyp6MxhAk5s3E036v
        oM4RBh65/7ay3JEmKDbWoGlnYBMEtIA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-RjRCVxmrPYK-LzwXrjETmg-1; Mon, 17 Apr 2023 11:39:25 -0400
X-MC-Unique: RjRCVxmrPYK-LzwXrjETmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AC1A3855563;
        Mon, 17 Apr 2023 15:39:25 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 493872027044;
        Mon, 17 Apr 2023 15:39:25 +0000 (UTC)
Message-ID: <613b46a0-f9e1-cca4-92de-a7f21d509aaa@redhat.com>
Date:   Mon, 17 Apr 2023 11:39:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: FAILED: patch "[PATCH] cgroup/cpuset: Add cpuset_can_fork() and
 cpuset_cancel_fork()" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, mkoutny@suse.com, tj@kernel.org
Cc:     stable@vger.kernel.org
References: <2023041703-wildland-privacy-e6d6@gregkh>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <2023041703-wildland-privacy-e6d6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/17/23 04:04, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> To reproduce the conflict and resubmit, you may use the following commands:
>
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
> git checkout FETCH_HEAD
> git cherry-pick -x eee87853794187f6adbe19533ed79c8b44b36a91
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041703-wildland-privacy-e6d6@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..
>
> Possible dependencies:
>
> eee878537941 ("cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods")
> 42a11bf5c543 ("cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly")
> 18f9a4d47527 ("cgroup/cpuset: Skip spread flags update on v2")
> e2d59900d936 ("cgroup/cpuset: Allow no-task partition to have empty cpuset.cpus.effective")
> 18065ebe9b33 ("cgroup/cpuset: Miscellaneous cleanups & add helper functions")
> f9da322e864e ("cgroup: cleanup comments")
> 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and bail out early")
I have posted a patch series that also include commit 18f9a4d47527 
("cgroup/cpuset: Skip spread flags update on v2") which is not 
technically a fix but is relative simple and low risk.  I have also 
twist the last patch a bit to fit 5.15. Compile, boot and sanity tests 
were done to verify its correctness.

Cheers,
Longman

