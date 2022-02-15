Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957D64B5FBE
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiBOBEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:04:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiBOBEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:04:21 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B99B1A98;
        Mon, 14 Feb 2022 17:04:13 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A7AA6580667;
        Mon, 14 Feb 2022 20:04:10 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 20:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=ApqcJV6HP092h+
        3acC9Hhy34t2sesmOkc4F5WsCNn2M=; b=nasGTWXn879CwSKMn2nC61zJaBaAn9
        ZAeTk/qOIXGaAPElYcE8bg2OFi3/OQry0eWO4+FxL3Ktd4WHU+3ZRvv1fSdrNAcP
        cprPcGLn7Z/KUAS1H8LtUvLp19Rv9OJqWCQiDrZzvrmwucY0wO7kBvq9uMGgSLld
        bYiHRd1aUm5o9vjiA1acKS2AQn5jquIUrqt2iOgeU5zssbFs9+WWdpSsWdLm9H50
        4nZoemA0LBJT3At5qR4U/8UYfEm8jGdlGtfQp74lDzuXgxr4LHDRjJ7bl0ZuOiXb
        pMSQBHFKGbPPta5RqOjDbmB+ZCXuLDKD3P9xOMdtixxieNoTelaLvkww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ApqcJV6HP092h+3ac
        C9Hhy34t2sesmOkc4F5WsCNn2M=; b=XlUrkvIJ55K+Yq1Vq8FCwr/i7FsIR8ZT6
        i77YOuo5Wc/XZ1UQQnN6sRJIKY0tqrdJR/51T0mNN0IA+jIQbwMluE+kgtR35CjP
        i4ZkWIAlyPf0ubgsdWafctUPyPB2r9eyA4JlkJfkO/iMjW1CFD8Zm2VF25usY+MQ
        IWznqMvhnBUf3znR2hAKFfYMs03reocriwV/cAXLtDUme9SttYJquzkLDgZEFVkt
        kYncIJb4mEdo0r0RqB2XVXZm4ybdea/cDsxGnC9NrczwyMx09aUQX0zLlhRTRtuA
        bK08OJ44flqgV5ghj0qlxqGpw7ASVmdtxZPzWkjxaqHeE11X18mDw==
X-ME-Sender: <xms:CfwKYmLaX4FgSSTcuIzCugdGHzm5_YimMe5ZwCptSGaoK7PHvbdaFg>
    <xme:CfwKYuIjUspGPDwhk68f1pr81WB0WpKvdEJiyQRsd6b3b46vWFv-o0dJ1MocQKvUV
    XVtBeFOzEWwVTbSoRM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:CfwKYmur7vg-2kG8xw1qeMQlsFFrNHyraO3Dp6mk0z4JMiTJXXD_TA>
    <xmx:CfwKYraKKIF2dVtYfi8KopkUR_FFu1s-aCcb8XdxovJ2_0rAnOQmwA>
    <xmx:CfwKYtZX7loBMYMppLazhWy5aCBAKqiyvHjqXTmyQCB0OJpt7Pm-lw>
    <xmx:CvwKYqSLkpDZyfXz1EBkZbcwpMATVV_s1KUo1VjzHo3mV8QBmig8LvEdF2k>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 95083F60083; Mon, 14 Feb 2022 20:04:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <315450ef-3234-4272-8b1f-dcefd1251977@www.fastmail.com>
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 20:04:09 -0500
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
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022, at 4:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

5.15.24-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
