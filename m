Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238895A4235
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 07:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiH2F1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 01:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2F1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 01:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EAF1261D;
        Sun, 28 Aug 2022 22:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF0FA6101C;
        Mon, 29 Aug 2022 05:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AAAC433D6;
        Mon, 29 Aug 2022 05:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661750826;
        bh=MEOxEOT9ztsDNjDrVt5QFWD/hcd0m/UInam7Q38BBEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lechmRmGrGq262+cnOTNYLd/uUO6SzkMIje/6aEkheUMqoMk5UQz/4pMs5JEzGsHu
         M2jaSRtcVH0EEN+rE/13i8Tt5P7DmEkVMEdWRa9pdTVSSQsRct9L3uaBU3Oi00wGT6
         Zd7m5F3EZjFIhqzW4GkvTFgkMePGe3QYiUktda20=
Date:   Mon, 29 Aug 2022 07:27:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Li Hua <hucool.lihua@huawei.com>
Cc:     peterz@infradead.org, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, juri.lelli@redhat.com,
        linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com,
        rostedt@goodmis.org, stable@vger.kernel.org,
        vincent.guittot@linaro.org, vschneid@redhat.com
Subject: Re: [PATCH -next] sched/cputime: Fix the bug of reading time
 backward from /proc/stat
Message-ID: <YwxOOFKGIl51uCNp@kroah.com>
References: <20220817004445.43216-1-hucool.lihua@huawei.com>
 <20220829155724.53581-1-hucool.lihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829155724.53581-1-hucool.lihua@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 11:57:24PM +0800, Li Hua wrote:
> ping...

There is no context here at all for what anyone should do :(
