Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC584C9465
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiCATgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiCATgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:36:14 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60FC54FA2;
        Tue,  1 Mar 2022 11:35:32 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 65C4C580265;
        Tue,  1 Mar 2022 14:35:29 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 01 Mar 2022 14:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=16mwQIckypkkqp
        Ecjd2L22L8yuEv2z/uqTwpc3kfpMY=; b=iZ3UGHNDWGSInQqU9onFl8YBofqUYA
        TQAN/zqkfvHlUeoiBWdntO9kt5UhVZY4l3FLWzL0VYIH9rggSLM9rZCGA4aYE7wH
        GFgm52JlUq7cMKKjrvve3WRehCRMzjhdusMEwWhHGK2t5TCU6QAZSYPmxOS9xkV9
        9OmXDqZmUTJvxxrDGgDpPHPh04cVh2B+K9fRbUH7FVtzlf/E/h2Sf2siGm8Fu5nA
        5sAlKKykMLFApl+7PqgQ9X4O5AT4MF3+W0ZnPbUX6ZeInTiG6tmRNE9TCxlmgOMm
        rIB9VLBpTXveId4vA08hdQAyg2PelZgSC1Cn/7ps6MoUvw5XaRUqseUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=16mwQIckypkkqpEcj
        d2L22L8yuEv2z/uqTwpc3kfpMY=; b=gWloxiBXsMqFj612AXala6iNuNwnPbedy
        Kgxae0vj2PdNJ/TwK924OLpUVD/BFj/UTHjzNNiaNSTbxG5lWzuWBfoQKyBE8dQY
        jct+v/eojkOl8TZ48IJ5eBCCIC/cSMa7jVMa5ImZ4PDXU8wSlkxZK64FNjhTi+4q
        XpY45PLiUzKRy1QB+aCdydfF88WuE/1B1afWbL8XtJSyNz+SbRvaxik0uL5PPSfJ
        Mugc7P1488f/8hWDfHraynxnQncK64b0nOhJfmMsn54rQi114hwrX+r9TcYa/K9V
        UjhL2lXlY1E1vJTw8MbnKkGRcb6ZJj85wggJTxUlg92DLBivGPP5A==
X-ME-Sender: <xms:gHUeYj2H99Jy0weNpQTN2xnK0o7VGuIfa4La4kfnYjL3gflzpFWA6w>
    <xme:gHUeYiF_FxGHt4yRrFBsvQ1xu0F1Ex2fQ5wqW3Da3AAEDPl5JYiIsUvsS6OduXq2o
    _DPosxGmAVU24hLF9k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtvddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhl
    rgguvgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteeh
    tdetleegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:gHUeYj4fBSvwechFjCe1_I0Ke1dPJSPVzH7AQCfp-QjSW__3QIBMTA>
    <xmx:gHUeYo1tS8HUHgMw1U5N80mhmY7PjGe6PpUSLG2HkxEYurhwASAMMg>
    <xmx:gHUeYmEXypFvOUwO0xDPxRTyBBz3P2_TraaL6FUt6UadjohCzdur-g>
    <xmx:gXUeYu9D2SC-XZUqFwV23UtE2mR88wp0J0Wt3qFJUS4vSJNg0LWCLlGLZTs>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3E4C0F6007E; Tue,  1 Mar 2022 14:35:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <ccfd6922-560b-4965-be14-cb212e2f7928@www.fastmail.com>
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
Date:   Tue, 01 Mar 2022 14:35:28 -0500
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
Subject: Re: [PATCH 4.9 00/29] 4.9.304-rc1 review
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

On Mon, Feb 28, 2022, at 12:23 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.304 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

4.9.304-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
