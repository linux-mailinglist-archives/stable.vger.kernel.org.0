Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936884C09BA
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiBWCzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiBWCzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:55:24 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1E4506EF;
        Tue, 22 Feb 2022 18:54:58 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id CF3955802AA;
        Tue, 22 Feb 2022 21:54:57 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 22 Feb 2022 21:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=4l1pR4wpQgjhqb
        EXfzxLqudrAA+sm+TlZ2OfbFIBf3I=; b=TKWA8HE+wXTkOp/9BMSD9CKo6iNgru
        vSY4bRdWsJhg2v2GVzzYU7MukIJCs+dxgewLUcAtYYcLInAaWbDhT8Rnc+klWhD4
        xtBTOEHNKi+Sf4wy2QvwQCf0goqFEKlxHQeYCBrcj38CPli6kU5Eo0q3iFG/M65f
        KA1IuvgJX7p++yU0BDQk4r/KnBrtB/Rr8ei7qShFcsl2KjUH6zJgKgsTfcyC/czI
        BpnH6PHmm7b+XJkZgpoLw59N2KvT7RuDc40cZxCpkSC7wFL7et2UvkuzpDDPUZF9
        fIEBM4kw5rHUZsULIhVJkBJj/8I8j9yg5yRQZyl/SZ8XU5tuVObyN5dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4l1pR4wpQgjhqbEXf
        zxLqudrAA+sm+TlZ2OfbFIBf3I=; b=L+tJLAqu+9XO+wnxdCGDxB6512lF7M42d
        +vJ3F6833ua/XvbHLlSnYRcuOb3SYK8oQjWQyr0CbHfVeBzy+LNCSXLZMrk0OfzC
        USDXZSEqgTEJ2Odw2OK3V5+SrQA6pPh7IFkUpCXtNP0dTlsq6WMMJ5BVo31DzMSi
        fJ30T3ECbalOfHBMoAdEQEgM7x3IO9gePSwbyPmdy2qz+wdGCG+1wv0e5HdTIS65
        t7HEPmRKZkNFlJk15X1bSWfLE9Sk4dKpCE2cx+LPmVa3X5INeClCRvljZIfqLeMg
        xN04qAHlPd6ZDuim2T4v6/BPrGcpPiyVkJrEOnjXtmqVc4y4CMieg==
X-ME-Sender: <xms:AaIVYqsjjy6h3s9f_VRGpmz97swCpR-uhRuZ7CAVD0IdWn4anG2MLw>
    <xme:AaIVYvftl-BQeieVa-ETUvY0MctgeE3UWRnDYepDLxytuwjba7oUGuSm-KfyZYUQV
    CTypzh0JFFmstGHUKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeelgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:AaIVYlyUkKkGz89g3G7OjmqaxysyBwICV2poRvogod4JWht2ANa3DQ>
    <xmx:AaIVYlM_jelaZBQGGrFzTE4FiH9m-XY-IdaV4paO3Q84rc1gYG-m5g>
    <xmx:AaIVYq9M0O7DFAftJw8hcGYoazcr39fXDZJokz8skdAbVeTtitxjFw>
    <xmx:AaIVYr1oLzPMDrwmXqZDnmwyrEBcCeEJ4K1c6wVZiGnP5mtbUDpsg6qxlAw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 81262F6007E; Tue, 22 Feb 2022 21:54:57 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <0fa3c93d-4f92-454f-a2cc-b1b989b925c9@www.fastmail.com>
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
Date:   Tue, 22 Feb 2022 21:54:56 -0500
From:   "Slade Watkins" <slade@sladewatkins.com>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022, at 3:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

5.16.11-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
