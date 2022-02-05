Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A374B4AA786
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 09:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379629AbiBEIDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 03:03:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36814 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiBEIDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 03:03:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3F88B83860
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 08:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5057C340E8;
        Sat,  5 Feb 2022 08:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644048217;
        bh=fntDn3PAxIUJzjMJnnB0Ax28OxZ90wk3YaiLfyNQ2F4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HU0qo4RHKkDNezq3yApa2IVFviTVAwzPT9Nvs2oU4uReyKBf+P+G4JGF8/ybs1+dK
         Z0lV75Ffy43T5fpb85D9xwID+nHyDiEWSXNv3UYlgRLDriNdRSbIwGuh32WqzOabVc
         ECtKnyZAfKE2QujZIylzb+GbdIWPqX9IXHCvNiP8=
Date:   Sat, 5 Feb 2022 09:03:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     kuba@kernel.org,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: ipa: request IPA register values be
 retained" failed to apply to 5.15-stable tree
Message-ID: <Yf4vTqtKLQ71O77S@kroah.com>
References: <1643964634201142@kroah.com>
 <b4a3db1e-9bee-5075-9b45-1e1dcc06869e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4a3db1e-9bee-5075-9b45-1e1dcc06869e@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 03:41:20PM -0600, Alex Elder wrote:
> On 2/4/22 2:50 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I just tried to apply this patch on v5.15.19 and it applied
> cleanly for me.
> 
> ----------------
> 
> {2314} elder@presto-> git checkout -b test
> Switched to a new branch 'test'
> {2315} elder@presto-> git reset --hard v5.15.19
> HEAD is now at 47cccb1eb2fec Linux 5.15.19
> {2316} elder@presto-> git cherry-pick -x
> 34a081761e4e3c35381cbfad609ebae2962fe2f8
> [test 71a06f5acbb05] net: ipa: request IPA register values be retained
>  Date: Tue Feb 1 09:02:05 2022 -0600
>  3 files changed, 64 insertions(+)
> {2317} elder@presto-> git log --oneline -2
> 71a06f5acbb05 (HEAD -> test) net: ipa: request IPA register values be
> retained
> 47cccb1eb2fec (tag: v5.15.19, stable/linux-5.15.y) Linux 5.15.19
> {2318} elder@presto->
> 
> ----------------
> 
> I don't understand.  If you know that I'm doing something wrong,
> can you let me know what it might be?

It fails to build :)

> While I have your attention on this, there is another commit
> that should be back-ported with this.  It did not have the
> "Fixes" tag, unfortunately.
> 
> Bjorn has committed it in the "arm64-for-5.18" branch in the
> Qualcomm repository:
>   git://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git
>   73419e4d2fd1b arm64: dts: qcom: add IPA qcom,qmp property
> 
> He says he has no plans to rebase this branch before it gets
> pulled.
> 
> I can send a followup message when that commit lands in v5.18-rc1,
> but it might be simplest to take care of it now.

According to the stable rules, I have to wait until it hits Linus's tree
before I can add it to a stable release.

So if this is a bugfix that everyone needs, it should go to Linus before
5.17-final is out.

thanks,

greg k-h
