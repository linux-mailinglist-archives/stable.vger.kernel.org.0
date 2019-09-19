Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60E3B827F
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 22:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404653AbfISUcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 16:32:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41777 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404652AbfISUcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 16:32:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8521221540;
        Thu, 19 Sep 2019 16:32:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 19 Sep 2019 16:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=QVZuPpLZDFPUAlPHytjLzeeKOPT
        w+aQXrwObSDFNyV4=; b=gwJKQwE46zOxbvT2l8ZQaklTJtfvaATINc9hO+cLi89
        I2KnC9M99+blmfWCd0HFRbINI9Masn7MclrcK4Hq0DG87hnvittTY/GVRs93cD8e
        ojEDQbIINsdOketpmOPQRt9jzyOF4IC3Y1JS7MTXFLK23IBU9ZLDX4rzCLJUqYP+
        oU6fjWAZpz5N9mz22OZgmjGZIMk7V9nLhXqTtBY+eAR7k+5PJ4knEyZ0jYc8B9rm
        2ob4OmrjdKgYZYb0WawUUTmkZDHfzRZfSAUMVZQ8+2rSH935lWU+92WiqImMqj37
        M6S6bbXJkx27EZCGpuWP0y36rG4JibB9oNhbfhxVWgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QVZuPp
        LZDFPUAlPHytjLzeeKOPTw+aQXrwObSDFNyV4=; b=c7ot5wMqZH4AvoBZM9fSXG
        abXoZ7vexmzKsxbVn8Qq+vAb26Q9s7EnfJCtDeqRNNAfQZFgYQlsRyH4Qcp7nQWY
        a/F2ld3q97OiShPCZqP64FEuSdDfR9w02Knp0uP2Y8S1+Eq1MfZvv5NGGQ9dGSLh
        wYdmG0TW4y2+5sL4XUsDMv7Ny+c8pcMLIKRrPMTkrJ9pV/yiRl4mVGro4dNkJBtW
        lkqrw5x2k5wYfqPCApRDLJKsYsEXwS+7XauoFMZ8lz1vmsJlykUay1DJQ/HW+HKr
        O7VRdUVLzhz7JN9UK5pknFfdACo18bPxeNfs4KK59ULWGBznqjQhp0yjpefvOXgQ
        ==
X-ME-Sender: <xms:8uWDXdaltbjY-GaKspmygvp4PVzDMiWWlDDOlJ1b6nZrqE3urSUADQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtgdduhedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:8uWDXZXyG0jH7jRgRe4su6wakIgzRWqOeKpxsSx5KhmcZCZHNlz6RA>
    <xmx:8uWDXYE6OEFARVQjMEXrdc5h4dV77Q-rM9gtyqFmb-7nRAVtVbnK0w>
    <xmx:8uWDXcFEJmDFvn7HD4GD0lPngYlMJLih0lTH8Cam3UKWGL59znrPPA>
    <xmx:8uWDXUzhatF90BvysA-TUAchq5hcMYw5J3zs6_a5qrdMyP0mnwKrIA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EAF03D6005E;
        Thu, 19 Sep 2019 16:32:49 -0400 (EDT)
Date:   Thu, 19 Sep 2019 22:32:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     stable@vger.kernel.org, will.deacon@arm.com
Subject: Re: stable backport request, add cortex-a cpus to whitelist
Message-ID: <20190919203247.GA258783@kroah.com>
References: <20190909124501.GA14378@centauri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909124501.GA14378@centauri>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 09, 2019 at 02:45:01PM +0200, Niklas Cassel wrote:
> Hello,
> 
> I would like to request
> 2a355ec25729 ("arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field")
> 
> to be backported to 4.19 stable.
> 
> These CPUs are not susceptible to Meltdown, so enabling the mitigations
> for Meltdown (kpti) should be redundant, especially since we know that
> it can have a huge performance penalty for certain workloads.
> 
> kpti will still be automatically enabled if KASLR is enabled.

Now queued up, thanks.

greg k-h
