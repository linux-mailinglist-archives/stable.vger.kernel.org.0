Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139237D7EC
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfHAIoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:44:01 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:53939 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728922AbfHAIoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:44:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4A0D12B22;
        Thu,  1 Aug 2019 04:44:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 01 Aug 2019 04:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6WafO7cI6r8VaJJsdXC/ys704rY
        XUFHR38NTVXOrVBI=; b=JJwGdkRI9foxSc48bXUp94Bx81Ro7lRFO9/F/+73h10
        gUO01O36cL23W8Vqv/IbKQ2vxscypeeUpyQMgZnRvqHBHteUSvaQE+DuRDI5rQro
        0cNmuvsDDCjySzqVgmP0B+kPxf+IeH7TTWg70h3KIwV1aob0yU9WiK8Kt2jQ2dfq
        gCfUYevOeA+xPkOLY9WA/Aw/tRLY2PbwYeZ2ywfwi4NOPpxBvKf5LYAZn7u+d+kS
        OXOcUWCT1jY9oxkZEQIPDRTrxFlW6vuX0SDuCIW+rD1ky6ojcsQr3JNX9fG2T22o
        b/4z0cCV+OWPkbab0sJYgXwvDyrFuukPm/6UntcXjng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6WafO7
        cI6r8VaJJsdXC/ys704rYXUFHR38NTVXOrVBI=; b=hcxj3NJM2t2lvrpzzqmqhm
        rhDP/nC3yP7CZv4ZSMp8b/KYE/XULqB4Xo7o1+u3UNE81tqyRRQDYjF5aDBINKoJ
        D7RkmgONAZ9EJ+tM9Klz20nfIjr+jwwZ1kVNKxRuYUekkRaSM/YGzU+N3TubUy/R
        BJqupysIFdohrrhUe1HBioqMb5rewfEdqpqh6JuUZOKAgJc6lZ45xJiVaJjs+Pwz
        N+kadhJDfbVKV2KRh0qLvR+3Wd4cBb6NSC6D8p5leWJDu44y6Y+7zSCSGzb/Mw9s
        Q+4pX555L30fHgwPt+/SkmfrsdNHqGwsCMtAlzwg+5z3C4YxWYcX3DGD8zyO9IDQ
        ==
X-ME-Sender: <xms:T6ZCXaqAt1vJJfSKbM7OtO6r-dAnV9hImAnlpZFKOEjLgjLmDje8-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleejgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepvddufedruddvjedrvdehud
    drvdduieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:T6ZCXbuPt_p8Uw_hw2ddN3lLbdMdLcl18a5nRpaBpS8mu5SLAQ3XWw>
    <xmx:T6ZCXdRYykirXSMpHWhFZOgww4Ddq7EOjHN_BNbCnLkh6ZZWjOhE9g>
    <xmx:T6ZCXdWKrivdTKnYnGvJiWUIjVYDIXTCwQ4ENcYy2AnlttVHYe8uvA>
    <xmx:UKZCXSoIRyETvlUltgulbRJpK_tFwBa1rPZCJ4cT3rkN04zUCu0AeA>
Received: from localhost (ip-213-127-251-216.ip.prioritytelecom.net [213.127.251.216])
        by mail.messagingengine.com (Postfix) with ESMTPA id 922928005A;
        Thu,  1 Aug 2019 04:43:58 -0400 (EDT)
Date:   Thu, 1 Aug 2019 10:43:54 +0200
From:   Greg KH <greg@kroah.com>
To:     Will Deacon <will@kernel.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
Message-ID: <20190801084354.GA1085@kroah.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
 <20190801063544.ruw444isj5uojjdx@vireshk-i7>
 <20190801065700.GA17391@kroah.com>
 <20190801070541.hpmadulgp45txfem@vireshk-i7>
 <20190801073444.4n45h6kcbmejvzte@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801073444.4n45h6kcbmejvzte@willie-the-truck>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 08:34:45AM +0100, Will Deacon wrote:
> On Thu, Aug 01, 2019 at 12:35:41PM +0530, Viresh Kumar wrote:
> > On 01-08-19, 08:57, Greg KH wrote:
> > > On Thu, Aug 01, 2019 at 12:05:44PM +0530, Viresh Kumar wrote:
> > > > On 01-08-19, 07:30, Julien Thierry wrote:
> > > > > I must admit I am not familiar with backport/stable process enough. But
> > > > > personally I think the your suggestion seems more sensible than
> > > > > backporting 4 patches.
> > > > > 
> > > > > Or you can maybe ignore patch 25 and say in patch 24 that among the
> > > > > changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
> > > > > was moved from post_ttbr_update_workaround as it doesn't exist and
> > > > > placed in check_and_switch_context() as it is its final destination.
> > > > 
> > > > Done that and dropped the other two patches.
> > > > 
> > > > > However, I really don't know what's the best way to proceed according to
> > > > > existing practices. So input from someone else would be welcome.
> > > > 
> > > > Lets see if someone comes up and ask me to do something else :)
> > > 
> > > Keeping the same patches that upstream has is almost always the better
> > > thing to do in the long-run.
> > 
> > That would require two additional patches to be backported, 22 and 23
> > from this series. From your suggestion it seems that keeping them is
> > better here ?
> 
> Yes. Backporting individual patches as they appear upstream is definitely
> the preferred method for -stable. It makes the relationship to mainline
> crystal clear, as well as any dependencies between patches that have been
> backported. Everytime we tweak something unecessarily in a stable backport,
> it just creates the potential for confusion and additional conflicts in
> future backports, so it's best to follow the shape of upstream as closely as
> possible, even if it results in additional patches.
> 
> So I wouldn't worry about total number of patches. I'd worry more about
> things like conflicts, deviation from mainline and overall testing coverage.

That is exactly correct, thanks for saying it better than I could :)

greg k-h
