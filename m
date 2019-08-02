Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E617FDDF
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388008AbfHBP4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:56:33 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49467 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731112AbfHBP4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:56:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BB5AC3FF;
        Fri,  2 Aug 2019 11:56:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 02 Aug 2019 11:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=PkUXgLQlD09oEzY3GdKpU9DI7Cs
        MAGiCOb8Se7FDCdY=; b=MLt9L/b5dqdmde++l8o2G+ndFrHypcTz4RppB8rwMfU
        GEOWaaDwwa+a1FVZZxzg+pDotPj/XIUdJ3zuE5KNvFUwVXgix6HaotHMP5KhkR7+
        Aac1+Wyj7shlLrppkQtMRkecZc+oxQz62S4oO2uLp6buXdApRs9EEiq7BC7srswr
        ca6C4J30mWfscXE3Ee42Fv5HRXUbn5MTgKNK39B5iUdX1XjlBUi7P4ZVMvrzXBcY
        N+Ix34b1dtDyBFzrB1iJ07QW6uoiv7mdJ1IFNCZkGLCx2qIJWX6rjZWQBM2EySGe
        0GI3xWjZoMSh1jvw1H43hA6OWPvnGR42da0MjvXgRUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PkUXgL
        QlD09oEzY3GdKpU9DI7CsMAGiCOb8Se7FDCdY=; b=gsMrauo6lYuY2qD/y9+Egx
        QRBYdd9MvaXevZ5u57X3sHRgP8DxhGfb9zN8EmsWsM1POHqga0md7st3o2p8rhX0
        oHzh+U54mu6Ydo0tAfMuHmARi8z5s/fHsFjo3iOB2Hktbk4if0ZOO9LGWGMrR/Ee
        1OYSlWwrVO1YxeYpAwzqLYj83yH2jjVYw40XgMT4p+DTS2dmGZlL82KAPFxhvKwu
        d710wRMxXPCaiV8jf5NevS8AxePIFIOQMIB9/iJrf3CootHApUOOigemxvm+Z7vT
        VSYL5Kpa+lShQ03dap2y16Nstz6qNZ/ek3k6o+OgsDPmcQYmEAgv/0W0yxM6eOmg
        ==
X-ME-Sender: <xms:Ll1EXQo6PUzXfBFGQ5f6I9gAnNm9m757ZGuFn1XRNX346Tes5WTa2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleelgdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Ll1EXa6nk0Y0q_xchL-usSYU9y4yjmGJIt9mgZK5CD01yElgtoeFDA>
    <xmx:Ll1EXQOml-_Y3sD7gZH7IKuPBz6OLDbi-mcMJudG5GK6OgjgRAzDQQ>
    <xmx:Ll1EXcNqe_ZlJOQwDO-Rg2PG-bYmVoh4YWKATGVx-ZFwks6Fw0SX5Q>
    <xmx:L11EXR51v3XObDe4qDp4W_hQlF3XKAmBI9jCiDEatzLqr4QV4DOArw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E381380085;
        Fri,  2 Aug 2019 11:56:30 -0400 (EDT)
Date:   Fri, 2 Aug 2019 17:56:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190802155627.GB28398@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35>
 <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com>
 <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
 <20190802112542.GA29534@kroah.com>
 <CANiq72mSLmP-EaOgY0m2qgTMVsAnyE6iuW5Kjdw5mSy1ZH0y-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72mSLmP-EaOgY0m2qgTMVsAnyE6iuW5Kjdw5mSy1ZH0y-A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 03:01:13PM +0200, Miguel Ojeda wrote:
> On Fri, Aug 2, 2019 at 1:25 PM Greg KH <greg@kroah.com> wrote:
> >
> > But it still doesn't work for 4.14.y and 4.19.y, so we are probably
> > missing something there.  So if you want to fix that up, I'd appreciate
> > patches to do so :)
> 
> Hm... For 4.19.y and 4.14.y, I cannot see the init/exit_module
> warnings under GCC 9.1.1. What do you mean it does not work?

I see a ton of warnings on those kernels today.  I'll look into it next
week after I apply your patches to see what's missing.

thanks,

greg k-h
