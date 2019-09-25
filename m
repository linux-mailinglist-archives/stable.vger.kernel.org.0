Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1326BD77C
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 06:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406179AbfIYErU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 00:47:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45091 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406158AbfIYErT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 00:47:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E81122372;
        Wed, 25 Sep 2019 00:47:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 25 Sep 2019 00:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=N0tzkpmxHl59dG/mswilaF1/VCw
        ADZy00xn7QRbp6eQ=; b=HFo7zRQv3ERkZAl/FRfBjKLgUO+XgqvBZ+0fhyayrtV
        R1tL3bg29binIp0BVxLlgFgcNP5A/WhiL1OocChqhYJfaNSCl5m7QIGw34Vj8RRK
        mRLS8sK8srR5PKwCWUXD/OxRVI170NFDyEB+g4gmCir86d+YNStAkUQeIL6+KzX3
        2ukVks85xyjmMIMhUUtBVA/aAly0kmQ6JnNSUcthPHcZg+AC3pBcLC4oTZqFqEfU
        QdQ9I6mHrM6zjt/600b9wrfo+Frq6q29s/+VVsUSJpPzXCv7a/3rq6yjT43woRU1
        o6dbzcIOTA/e9vTRuQ0M1IymPY8e7YlW1vGPKvvxGkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N0tzkp
        mxHl59dG/mswilaF1/VCwADZy00xn7QRbp6eQ=; b=V0V50dCS4mmYwMM4soKoth
        CM9Bp373nlBM5Dd/m9T9Gan1QsI2RbvrL25BoMsDfhy2Cx60u7D3m61K3939GnqE
        6/Eo8KCVuC7wiQXVcw3ra5J91SLvGovFNqYnPXPFM6HkV2cpoYrvWw5BXrWPo5Fh
        iOFb2I6lYAVR5VV8LiX3GrfpovAR8R77gmaWCMkF/AITBi8t8znqqvdS6jrQ2Cgr
        nfffOyk6v4yx/aova/lao2Z7+shinLOiKM7k0/QlyGWf9l8yykvv6i+Qt2Pjjr9E
        AOkKQRMTOH7DfLZw0N+KkYHGIPhNwiUJQ+W0ub/jjAxRVQiDB8JeKsh8HekGS77w
        ==
X-ME-Sender: <xms:VvGKXdaqCUm6BW9SiTCo2X3HsWosQZDWPH4BK3RIKuZi_EWIfuap5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:VvGKXQvujJtOJ712ynqtWYJ_JEMWR70-rixewTfSffQ6NYWIClyEsQ>
    <xmx:VvGKXStGAuRM4T9r0W_RUqqU2ZFUaxN1hqawABc0pzs87-gHgDVb6w>
    <xmx:VvGKXdchOvJRtLvksBw42ikdGjsN9PWc490qHOi6co7cKLnInlImsA>
    <xmx:VvGKXSa2QlmAMwoZMo0q9OJKUz5d8wGdNMC6lbldE5tY9oaePBLlZw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8E078005A;
        Wed, 25 Sep 2019 00:47:17 -0400 (EDT)
Date:   Wed, 25 Sep 2019 06:47:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     stable@vger.kernel.org, will.deacon@arm.com
Subject: Re: stable backport request, add cortex-a cpus to whitelist
Message-ID: <20190925044716.GA1245978@kroah.com>
References: <20190909124501.GA14378@centauri>
 <20190919203247.GA258783@kroah.com>
 <20190924231724.GA7380@centauri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924231724.GA7380@centauri>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 01:17:24AM +0200, Niklas Cassel wrote:
> On Thu, Sep 19, 2019 at 10:32:47PM +0200, Greg KH wrote:
> > On Mon, Sep 09, 2019 at 02:45:01PM +0200, Niklas Cassel wrote:
> > > Hello,
> > > 
> > > I would like to request
> > > 2a355ec25729 ("arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field")
> > > 
> > > to be backported to 4.19 stable.
> > > 
> > > These CPUs are not susceptible to Meltdown, so enabling the mitigations
> > > for Meltdown (kpti) should be redundant, especially since we know that
> > > it can have a huge performance penalty for certain workloads.
> > > 
> > > kpti will still be automatically enabled if KASLR is enabled.
> > 
> > Now queued up, thanks.
> > 
> 
> Hello Greg, Will,
> 
> How about applying this also to v4.14 stable?
> (Since kpti is also enabled on Cortex-A CPUs in v4.14.)
> 
> 2a355ec25729 does not apply cleanly on v4.14.y,
> since a LOT of things have changed in the file.
> 
> git log --oneline 2a355ec25729053bb9a1a89b6c1d1cdd6c3b3fb1 --not linux-stable/linux-4.14.y arch/arm64/kernel/cpufeature.c | wc -l
> 72
> 
> However, I've attached a simple backport of the commit.

Thanks for the backport, now queued up.

greg k-h
