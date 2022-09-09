Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552775B2E8D
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 08:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIIGMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 02:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiIIGMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 02:12:47 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAE410B7C4;
        Thu,  8 Sep 2022 23:12:45 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id pj10so607225pjb.2;
        Thu, 08 Sep 2022 23:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=oMO8E8WioqSrjSvqs0LdV6+WX609nz7ap9OEkoEofD8=;
        b=c2jLijwgSZuhl5W6jcD/WlungqA9VojWpPE0zN/RBoOsLLjQVGfjGe8u7+2SgTckbY
         +AIWzL6M+q6/lE/9kX3twZe9CGclm9LQZp/Ru5/EH4yvSYHnquuw85NEOFgbZtTvptq7
         GRCrsDyx8FrhdSOwIWL8kawPa/rLa5TsDkeSVh40Iei81otzT3iXckN7Kga0BzCeBDI2
         DVYmYAP5Nn+YGRXu9OiCW0ogXPqEooqAtsI9wVPnR0glmKsgawQJkvcAi+2ZgnJVk8o+
         ngSC6phTwhwmgpiUbmnDd9TG37ljMvjXWozw/u58Lk7pauBn3eTczwX0aMNKVzgQHhaN
         +Paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=oMO8E8WioqSrjSvqs0LdV6+WX609nz7ap9OEkoEofD8=;
        b=N3/ASi6A8ILPdumRIbKJHNMbByU5y7K13cA6KpH4YaJNPsP2kkmUKeOwS7dCKWccy3
         EK5h+fT9jl086UeKIIuRbzMobLYEZ4ckc5gi/9RQidXUgukfci7QK5283i6LQH1ffNWb
         vzqFbrv6ejUGbduhcIAFcaCp+uk4sRYGdqRUu6SZkaSwyYjxcCHK/ZKxXwCA8TC8a0PT
         bkpzggoJZxS26qEB9rI2xqpxpxDT7XqnTC8ViV0795uwfDWFyUKDVnFPvQFjDJh23p0k
         6QwGSbpF0jL6Rjc6E0TGjykSfDlgXqpCDZIINcKYwev28adFcO4+QCY7fyIYVAKQjVmX
         iN9Q==
X-Gm-Message-State: ACgBeo1CodmYigsX4R6+FHavTpDEK+Ol+wEKEZr7paWn/hhLpTpnv/sj
        5kc9XihbTIqHBnJ+rwjbyMU=
X-Google-Smtp-Source: AA6agR5jiiHXbQfbCdZmXJEU+eOB7boiyGsm7BWVu2949uBVopyh5SJvY0wci/uBDHMymYlNCNFXRA==
X-Received: by 2002:a17:902:db06:b0:16f:16b7:69d0 with SMTP id m6-20020a170902db0600b0016f16b769d0mr12088593plx.145.1662703964937;
        Thu, 08 Sep 2022 23:12:44 -0700 (PDT)
Received: from localhost ([2406:7400:63:83c4:f166:555c:90a1:a48d])
        by smtp.gmail.com with ESMTPSA id d6-20020a655ac6000000b0042b87fd1081sm486823pgt.46.2022.09.08.23.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 23:12:44 -0700 (PDT)
Date:   Fri, 9 Sep 2022 11:42:39 +0530
From:   "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5/5] ext4: Use buckets for cr 1 block scan instead of
 rbtree
Message-ID: <20220909061239.unsikxp655mdt6wz@riteshh-domain>
References: <20220908091301.147-1-jack@suse.cz>
 <20220908092136.11770-5-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908092136.11770-5-jack@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/09/08 11:21AM, Jan Kara wrote:
> Using rbtree for sorting groups by average fragment size is relatively
> expensive (needs rbtree update on every block freeing or allocation) and
> leads to wide spreading of allocations because selection of block group
> is very sentitive both to changes in free space and amount of blocks
> allocated. Furthermore selecting group with the best matching average
> fragment size is not necessary anyway, even more so because the
> variability of fragment sizes within a group is likely large so average
> is not telling much. We just need a group with large enough average
> fragment size so that we have high probability of finding large enough
> free extent and we don't want average fragment size to be too big so
> that we are likely to find free extent only somewhat larger than what we
> need.
> 
> So instead of maintaing rbtree of groups sorted by fragment size keep
> bins (lists) or groups where average fragment size is in the interval
> [2^i, 2^(i+1)). This structure requires less updates on block allocation
> / freeing, generally avoids chaotic spreading of allocations into block
> groups, and still is able to quickly (even faster that the rbtree)
> provide a block group which is likely to have a suitably sized free
> space extent.
> 
> This patch reduces number of block groups used when untarring archive
> with medium sized files (size somewhat above 64k which is default
> mballoc limit for avoiding locality group preallocation) to about half
> and thus improves write speeds for eMMC flash significantly.
> 
> Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
> CC: stable@vger.kernel.org
> Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h    |  10 +-
>  fs/ext4/mballoc.c | 249 ++++++++++++++++++++--------------------------
>  fs/ext4/mballoc.h |   1 -
>  3 files changed, 111 insertions(+), 149 deletions(-)

Hello Jan, 

I have reviewed the patch and also verified bb_fragments. That indeed will 
atleast be 1 (ext4_mb_generate_buddy()) as you had mentioned.

The patch looks good to me. Please feel free to add: 
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

