Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127125AA74C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 07:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIBFhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 01:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBFhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 01:37:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3CD167ED
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 22:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38174B829D6
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 05:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8997DC433D6;
        Fri,  2 Sep 2022 05:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662097058;
        bh=kCnRa6hY2dPoI3voWLONHSDn8127BeOvYxWfAdH4Eck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncpNOBDhvA27jzXvNNLGtXoYHXpNkVbulb3hM5SCAnmtdZw0oxLIsn7x32OAPiCIs
         V/+VkaHq2VL4q7K5joF3D6cI+x8siCGx3K7VondEthwilDBaam13l9gJ6UvGh69ufF
         YrEUv6qZgRlGbHUf1Ju17vKQMCJvv9fNRUFZsYDQ=
Date:   Fri, 2 Sep 2022 07:37:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com,
        ayudutta@amazon.com, davem@davemloft.net, kuni1840@gmail.com,
        mhiramat@kernel.org, naveen.n.rao@linux.ibm.com,
        stable@vger.kernel.org, wangnan0@huawei.com
Subject: Re: [PATCH stable 5.4 5.10 5.15] kprobes: don't call disarm_kprobe()
 for disabled kprobes
Message-ID: <YxGWn0sEZliiLT0E@kroah.com>
References: <20220901223205.11648-1-kuniyu@amazon.com>
 <20220901230844.18015-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901230844.18015-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 04:08:44PM -0700, Kuniyuki Iwashima wrote:
> This can be applied to 4.19 too.
> Could you queue this up for 4.19 as well?

Yes, all now queued up, thanks.

greg k-h
