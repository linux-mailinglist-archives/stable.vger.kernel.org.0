Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2044BEBD2
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 21:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbiBUU1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 15:27:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiBUU1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 15:27:41 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07975237C0;
        Mon, 21 Feb 2022 12:27:17 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1A47158028F;
        Mon, 21 Feb 2022 15:27:15 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 21 Feb 2022 15:27:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=zyDP3Ytwoluhyv
        5Ay213DJcMU+zq0aazOe15rgZ/UnY=; b=tmP5JE/xUg97mOwctjNAphTcigdeLI
        nCDaPEA0wSfQj3sPkjMGR/ZuR6gShy4hnINUKicvZB1/uYEvXLln8QzTWA9nkkZr
        8PZ3hrMV36Xp4hIIUJo1Q38yK7UOxHcKNz5WvN53KjdNdbGkOzAa1zFD8LhTFpld
        Q/Es+9zUJujRpazjoIumfW7JOIy/ZZUT2R3I/0IqdYhSLP4xFfaUyg0hgepIR1tr
        U73oXEL5DIahz68PoZ53H+xOGcMRPsi+wVzDvA1fevtQz+EsjbaWn7DT+6AEt9fA
        zpWsD3jaTaU7wmwv3BLjbvwa0pXnjgbZHnBsQJ4sK+xJwl6SoEIz4NIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zyDP3Ytwoluhyv5Ay
        213DJcMU+zq0aazOe15rgZ/UnY=; b=npE5/sHJCZfKO+R+OYY/UYgFKyuNh63jj
        s0RchXXrERHVbKiBwbw1/INnqBNdQhkK8j9XWybyBKko0q/Lq5w631I2Me16Kqei
        21G7wluC98cRe8y5BQJtzwkzMJCAAsABNAfaE79twuYato4wG6BS9w0OVeMlriLx
        HuYMvMLA7jTxDvmVcSuMIiTxTBSGlkU0+QstdpacbcncuGXfqPff8GM+zPWTwGBm
        052oQ5yxxdiQn5GZAUwmO1zoBkLpfsQ3LaE4knNe7XRyfctgXRdNoEu7wil7sriJ
        bwXwGSy2Hk2ujM+ov8/pT6lwZj92iT4o3gmyq+MW/I39xXuxYU7eA==
X-ME-Sender: <xms:ovUTYhNU2iF7IJYDW3zoEN3ek2NjJgMFFV6HHzQjGKQT0ttoZfvPFA>
    <xme:ovUTYj_6-NQaVScxUcFle1P5YZgoiBl452_iYOazNo4d5IflZf8--siRd9S-dsoZM
    bIuaV-TtbVdUfPrIxc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeigddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:ovUTYgR_S6r4cy-qNZF4LjO-hZ3bfWJDb7fDYVs6Hmx1SNvgOiOcFg>
    <xmx:ovUTYtsY1iondXAX8XDXox7_x1FENA7_nU40KdyHAazjHBJIra_IQA>
    <xmx:ovUTYpcbpacsfkgsSiayeZrkGtUBWvlMdd7Ihgat7iIhzcPUQILGUA>
    <xmx:ovUTYqXB9Yt9MrO8D1VH6hLBzjleIU3x0qblwdfzT2E5oGPwkfIgZ6mndBY>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2B1ACF6007E; Mon, 21 Feb 2022 15:27:14 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <d3afad27-4a1b-4f29-82da-a43618e2d743@www.fastmail.com>
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 15:27:14 -0500
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
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022, at 3:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

4.4.303-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
