Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4EAF1A48
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfKFPni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 10:43:38 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60673 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbfKFPni (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 10:43:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 839C16B6;
        Wed,  6 Nov 2019 10:43:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 06 Nov 2019 10:43:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=XTco63vYvi0rKseyvIEx1bm2gce
        3caZq5efNJS+FCZg=; b=c4vVgtURVr08n/s/e/5dBSD+23dtFjgiIQCMEVOmtzi
        vxoa3JFny8zawdOpg0NxVvxWint+cAnvq3E6cINtlCgwjcOF2L76F7De6PI4dmCf
        KMFyAu6uPersJGBcooKzJkf5eKhMynN2MPL+Ykj+iIYK72bi85JFBhIIAZd+PWdq
        5Ce3klt/EuqR0/ZNGFhsBqku1J8uhb/ONtlnXQuQxH49jtQCOt5yK/Dirs5Cn0R5
        ZM3QM1VAFHFfX+2Q8tNV3glpX34w8mPT3AwIunbtth//oJHRhqYtS9R74P2blaY9
        P9j7XKg77XvH5fQAdjA6UdK3Nt2A6rQNE2W33VCcifA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XTco63
        vYvi0rKseyvIEx1bm2gce3caZq5efNJS+FCZg=; b=cb2TVrQo5g+skB8wUxcOxf
        /01QZuGkSJc50cm8BTyZtQ9OaT9M/DMN7o+NZ4RKgQt6kCBeIYTp/aE57PLzXvCv
        PX9X//ku/ic1YR0vBh1fzQhkv/Fuf+LHspDY0cE/gbd89QIQhbj6xKO7s/9sKIL2
        jgfjzr7DktyG3RP3qiCX53E8UDGSQ7RPRGqfualjUyTpWsh9z8//2j3+NWsXKt25
        uOfHTykZF2fdsur/tBHzo9GVnr8aijDIoSmawdAH8kJcW/ef+lIIkk4iDOCSGyWc
        0vZo4CUNgkQqv6IErqANItE91hNWL1h4XKr0dlKN9PVQXY84PbDYWjYzyz9oQcqA
        ==
X-ME-Sender: <xms:KOrCXbAr546xPIHtO47bLPNGP6fpTSQqXfkjePq8NRHX9wQLfi1bow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddujedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:KOrCXXT_E1vmZYx99NuA0HQJUu2Tff3RKG_Bks0uNQGOnEMHU5zW7A>
    <xmx:KOrCXdadJEvDfk710Jyp6LmHeKs3xi3B5FRMKkPvlzFVnSxqX1nt7A>
    <xmx:KOrCXU8PPrXeTr_mdvO7qg3GL7MUr9XNoF9X-fdSuI35KoQpm_ksjw>
    <xmx:KerCXT6BvrZr6btBoybHIBaZJo0Kq1UoKv2gil7Sm0lggsjra42P0g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DA0B8006A;
        Wed,  6 Nov 2019 10:43:36 -0500 (EST)
Date:   Wed, 6 Nov 2019 16:43:35 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20191106154335.GA3786685@kroah.com>
References: <20191104.175159.1731030684200028707.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104.175159.1731030684200028707.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 05:51:59PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and
> v5.3 -stable, respectively.

All now queued up, thanks!

greg k-h
