Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221A34B3454
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 11:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiBLKuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 05:50:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiBLKuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 05:50:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB2326562
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 02:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2462BB80522
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 10:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34617C340E7;
        Sat, 12 Feb 2022 10:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644662997;
        bh=kHvFRm8n/2QL/qiQUZ6DxyWsr1WGQhgwvI2P8QH6LPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y7+RxUu6ZQMz3K6+t7/1o9oqUzOdcAdPn9Xaz81AGLtpaAG+NlgBF2Nkm9wPOO01E
         kvUpfsXZiJ4pH29PtRXE9u5K/o0roFgEwrRtKOX1fqJm2CGwfOlWWUqCkduCm4Jmyl
         WbheAQzllhsg7uq3BMMFVx+1JBbDhvriSGDKudwk=
Date:   Sat, 12 Feb 2022 11:49:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     chenzechuan1@huawei.com, Jianlin.Lv@arm.com, acme@redhat.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        mark.rutland@arm.com, mhiramat@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, namhyung@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, peterz@infradead.org,
        ravi.bangoria@linux.ibm.com, yangjihong1@huawei.com,
        yao.jin@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] perf probe: Fix ppc64 'perf probe add
 events failed' case" failed to apply to 5.4-stable tree
Message-ID: <YgeQ03bMcNQHOzg+@kroah.com>
References: <1643031189224222@kroah.com>
 <Ygaz0wOtMGQnSQVD@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygaz0wOtMGQnSQVD@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 07:06:59PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 24, 2022 at 02:33:09PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.19-stable tree.
> 

Now queued up, thanks.

greg k-h
