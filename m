Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E857A65361E
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiLUSXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 13:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiLUSXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 13:23:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655BF24BC9;
        Wed, 21 Dec 2022 10:23:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A391B81C02;
        Wed, 21 Dec 2022 18:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A74C433EF;
        Wed, 21 Dec 2022 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671646980;
        bh=F64A/qpXOjPUowsd6ty5hNI2IPTcA1Np9drd9jOwbIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chB0iutCFkMUGjjLXUPRS3vHKqVULKaKfd4lmfKRJ/AAy8iW0D5oYu3gXoQXdJDjh
         brUJFPdU2fVA83etQUg3+Kk7nRMKbp4dbafk/aAz6FcfOvFOzMwD/zgeOW6Ig0gmov
         K3zVVGN8gqdWo5eFwPS5YECigriD/qi3nMR/VJSU=
Date:   Wed, 21 Dec 2022 19:22:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     stable@vger.kernel.org,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "Guozihua (Scott)" <guozihua@huawei.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Subject: Re: Stable backport request
Message-ID: <Y6NPAr7mFTZ9hhCZ@kroah.com>
References: <c946a51ca8b059d1526af1078473e62c58edc357.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c946a51ca8b059d1526af1078473e62c58edc357.camel@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 09:50:09AM -0500, Mimi Zohar wrote:
> Stable team,
> 
> Please backport these upstream commits to stable kernels:
> - c7423dbdbc9e ("ima: Handle -ESTALE returned by
> ima_filter_rule_match()"
> 
> Dependency on:
> - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
> 
> Known minor merge conflicts:
> - Commit: 65603435599f ("ima: Fix trivial typos in the comments") fixed
> "refrences" spelling, causes a merge conflict.
> - Commit 28073eb09c5a ("ima: Fix fall-through warnings for Clang") adds
> a "break;" before "default:", causes a merge conflict.
> 
> Simplifies backporting to linux-5.4.y:
> - 465aee77aae8 ("ima: Free the entire rule when deleting a list of
> rules")
>   except for the line "kfree(entry->keyrings);" - introduced in 5.6.y.
> - 39e5993d0d45 ("ima: Shallow copy the args_p member of
> ima_rule_entry.lsm elements")
> - b8867eedcf76 ("ima: Rename internal filter rule functions")
> - f60c826d0318 ("ima: Use kmemdup rather than kmalloc+memcpy")

I'm sorry, but I'm confused.

What exact commits are needed in what order for which stable trees?

> A patch for kernels prior to commit b16942455193 ("ima: use the lsm
> policy
> update notifier") will be posted separately.

But that commit has been backported to 4.19.y and newer stable trees,
right?

confused,

greg k-h
