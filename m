Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069184AAAE6
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357978AbiBESay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:30:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57814 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbiBESay (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:30:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7727AB80CE6
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 18:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE95C340E8;
        Sat,  5 Feb 2022 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644085852;
        bh=fKkQpeqC+AV03SZaiUsl81P8aocS4YbPaiwo9q0Cj04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eUPYuToznG7FrNAnUCNR41fGEpew+T/GMavzTFZU0SMFxfZRAzYkn5qQC2vPXg453
         pkutN3BiTHrWq9isbwuWlBaaaVhmBzrE6bs8wKteMPFoRBR6/aYhTgF8S8LahKOlhT
         D74mXF+O0E71ZVaSGW6f2829+8C37z0venO78mEs=
Date:   Sat, 5 Feb 2022 19:30:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     kuba@kernel.org,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: ipa: request IPA register values be
 retained" failed to apply to 5.15-stable tree
Message-ID: <Yf7CWW+kGnH86KtE@kroah.com>
References: <1643964634201142@kroah.com>
 <b4a3db1e-9bee-5075-9b45-1e1dcc06869e@linaro.org>
 <Yf4vTqtKLQ71O77S@kroah.com>
 <d66a5ce0-acb1-d2c4-b6a5-c4783abc1482@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d66a5ce0-acb1-d2c4-b6a5-c4783abc1482@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 08:32:30AM -0600, Alex Elder wrote:
> On 2/5/22 2:03 AM, Greg KH wrote:
> > On Fri, Feb 04, 2022 at 03:41:20PM -0600, Alex Elder wrote:
> > > On 2/4/22 2:50 AM, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 5.15-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > I just tried to apply this patch on v5.15.19 and it applied
> > > cleanly for me.
> > > 
> > > ----------------
> > > 
> > > {2314} elder@presto-> git checkout -b test
> > > Switched to a new branch 'test'
> > > {2315} elder@presto-> git reset --hard v5.15.19
> > > HEAD is now at 47cccb1eb2fec Linux 5.15.19
> > > {2316} elder@presto-> git cherry-pick -x
> > > 34a081761e4e3c35381cbfad609ebae2962fe2f8
> > > [test 71a06f5acbb05] net: ipa: request IPA register values be retained
> > >   Date: Tue Feb 1 09:02:05 2022 -0600
> > >   3 files changed, 64 insertions(+)
> > > {2317} elder@presto-> git log --oneline -2
> > > 71a06f5acbb05 (HEAD -> test) net: ipa: request IPA register values be
> > > retained
> > > 47cccb1eb2fec (tag: v5.15.19, stable/linux-5.15.y) Linux 5.15.19
> > > {2318} elder@presto->
> > > 
> > > ----------------
> > > 
> > > I don't understand.  If you know that I'm doing something wrong,
> > > can you let me know what it might be?
> > 
> > It fails to build :)
> 
> Oh!  Well that's different!  Sorry about that, I'll spend
> a little more time on this I guess...

It was a "include file not found" type of error if I remember correctly.
