Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C833E24BD
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbhHFIIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:08:04 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:55863 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236751AbhHFIIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 04:08:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 59A31580109;
        Fri,  6 Aug 2021 04:07:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 06 Aug 2021 04:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Z4+mRWREBPLpUH7u1/TqVHSfNkL
        vwQYhR1MaKBMAwGM=; b=zdQY+4UMhEltPLYJHhnQQ0DYhTEEreN2tTwqpzQg/zl
        dUsznVotV32fNIu/D3RZOjkybXinbQJmfIdBbHaTv7y5Q+SlHgM3LProYOV4KM67
        WiXk9/yh8yswt4159fKKv4xFhEMKpE7+4lG7bdYvu+r4Iu76i2GSNNGrBH12opHC
        bblC8eV5Et+klH2sSkIZKdrUICqRrhYCZLzNouCEROQR42rfCfsVSGEKdapjUQKD
        YeHP1MMa00dhlK9+5vr5uB48U5rVx4JdU5onbsm8Stu6lfGzQzVB2XX1wHEoJe2H
        3HGE+7xL2Mofm03Lz7nEZDdVX64PHWzTpVEQLrCzAFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Z4+mRW
        REBPLpUH7u1/TqVHSfNkLvwQYhR1MaKBMAwGM=; b=WMrQMr5pBTM6uJ+vvwPpS/
        L3KGNxibn/iAkKmhQ6uux1iZv8hu4Y1Vj6PARtOcpQvJSngL/PZYfBxccJVWGD4z
        TKr223zBtULvL7fwF4KPyWOLt0dHNSNCnvzZj8bb8OkbEoOkdpvJEb9vsGOxO7Wb
        rFUukJBlz4S19LDp1XdceBt4TZImNo/cy6h1KcEh3Ipigffo87TI16KwAQ5kaX/h
        TyDYsW0ll9K4JhgpMR0zqA2Vq9nh9X1qrC3C02Va9A44vQWtsuv/ElceZzxe2QVZ
        tMF91v4Wdyu8bu4Wz76dY2VPki8SJ2CpIg2fKvBVAgCSrLG2llJkMtzeCjOzwteA
        ==
X-ME-Sender: <xms:0-0MYXjU6HK22HOOPxXB49r2HhDzCPm3tSIQw6m2F1VuP47rJ0uTUg>
    <xme:0-0MYUBjnFIr3R6BgUiHUKgVIAdiLd7tS_Tc6Us92RZDQNiEdRGZU6IA4Y-yqXz05
    _OIFHIQVotagA>
X-ME-Received: <xmr:0-0MYXEaIqQ-xtlfZ0isw8ft-FGmsqbEx3euees2iqrj7ZYXkO1gwjXt-HEBvLAzuUcIqSYstYlgGhU665Lt1OHT8SMY2FgJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjedtgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0-0MYUQ0VimcVK5hVLFR2YPGQgg1J6bqUlKVzL_N4N0RZY6bosmL3w>
    <xmx:0-0MYUwdnW_84Hpo5gltfX2Ygm_j4FCNWBjoqizGQokGbAZ0mvN7RA>
    <xmx:0-0MYa5dLhniN2WSVW-IqfwLQxeNK5fLgiQz3l8EvX81FnpuLi66vA>
    <xmx:1O0MYZINWY6Ek6v998z7teOttoWS4Mtlxkd5XauJkluIpNtOlNI4Vg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Aug 2021 04:07:47 -0400 (EDT)
Date:   Fri, 6 Aug 2021 10:07:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, john.fastabend@gmail.com,
        benedict.schlueter@rub.de, piotras@gmail.com
Subject: Re: [PATCH 5.4 0/6] bpf: backport fixes for CVE-2021-33624
Message-ID: <YQzt0Y8aupj6z+Es@kroah.com>
References: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 06:53:37PM +0300, Ovidiu Panait wrote:
> NOTE: the fixes were manually adjusted to apply to 5.4, so copying bpf@ to see
> if there are any concerns.
> 
> With this patchseries (applied on top of [1], which was not merged yet), all
> bpf verifier selftests pass:
> root@intel-x86-64:~# ./test_verifier
> ...
> #1056/p XDP pkt read, pkt_meta' <= pkt_data, good access OK
> #1057/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
> #1058/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
> #1059/p XDP pkt read, pkt_data <= pkt_meta', good access OK
> #1060/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
> #1061/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
> Summary: 1571 PASSED, 0 SKIPPED, 0 FAILED
> 
> [1] https://lore.kernel.org/stable/20210804172001.3909228-2-ovidiu.panait@windriver.com/T/#u
> 

All now queued up, thanks!

greg k-h
