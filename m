Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD64ED766
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiCaKAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 06:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiCaKAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 06:00:12 -0400
Received: from iris.vrvis.at (iris.vrvis.at [92.60.8.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBDD1F89F8;
        Thu, 31 Mar 2022 02:58:24 -0700 (PDT)
Received: from [10.43.0.42]
        by iris.vrvis.at with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <valentin@vrvis.at>)
        id 1nZrZL-0006L7-4E; Thu, 31 Mar 2022 11:58:19 +0200
Message-ID: <b19953f8-2097-6962-eceb-5d41f4639ce4@vrvis.at>
Date:   Thu, 31 Mar 2022 11:58:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Valentin Kleibel <valentin@vrvis.at>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com> <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
 <YinufgnQtSeTA18w@kroah.com> <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
 <Yi8jO3Q+xbPx0JwF@kroah.com>
Content-Language: en-US
In-Reply-To: <Yi8jO3Q+xbPx0JwF@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: [PATCH v2 0/2] block: aoe: fix page fault in freedev()
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I do not know, sorry.  But we prefer the upstream commits as much as
> possible as one-off changes like this are almost always buggy and wrong
> in the end.
> 
> Try doing the backports and see what that looks like please.

I did the backports now but Christoph Hellwig already pointed out:
> No idea what is hidden in bugzilla, but the blk_mq_alloc_disk changes
> aren't easily backportable.
[https://lore.kernel.org/all/20220308060916.GB23629@lst.de/]

Therefore I cherry-picked only the changes for blk_cleanup_disk as they 
are much simpler than the changes to blk_mq_alloc_disk.

I kept the original commit messages, please tell me if you feel they 
should be changed or do so yourself.

Please apply to 5.4 and 5.10.

Cheers,
Valentin

changelog:
v2:
* cherry pick from upstream commits instead of creating a new patch
