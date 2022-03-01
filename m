Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843B54C9469
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiCATgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiCATgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:36:47 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C3D6AA6A;
        Tue,  1 Mar 2022 11:36:06 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 625E55801D9;
        Tue,  1 Mar 2022 14:36:05 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 01 Mar 2022 14:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=djy3FSIgjWgk6u
        Qp8oGemluAFFOUKmtv+rqQ2OOqfbI=; b=O/uNAMPK5rrCQcjaYovDA0kGFl1XAV
        1zhbcT3OLGibsbhMqQt9aF60gGgUiwSrkMpY6N/NtEYgGoMvks1PpmdxsmFEAz32
        dKEGRQ/l653YrbGNcPvmGAUKXOngbFM4deob6sI9WdA7+sK74bk8ZIV4w+Qhxidj
        XnUPfYcFz9zkppOSBk5gGPp9+mwH5gX63scmc2BXz8dcqmN5KPcLMnbAM8mH1huh
        2ojMD852PEb9znFbHN/1FsjaXQOFfPK3MKIG6fvsntv+pGGiu8gfEnTa+TruYRUa
        3ISmhezmNVc7nFZ/mOsN30R0epSl3xShc8d0Qs3AUlGduuxvpvW8IZ2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=djy3FSIgjWgk6uQp8
        oGemluAFFOUKmtv+rqQ2OOqfbI=; b=on14u6QB9ZKnQPxE9GDsck0AO95NorCb9
        p3W23ak94LrAEVqjaFwl0rervirvWqGMawUJ0wR6p5CJH1X0R/oPa5+8KIAHoLS4
        EDwCScMwKXhLfhHS+bgG3y1XuDaJQM0LRzHLHtcBXhN8nPo3KMsRsYU2eIu/FpRU
        rglsI/KgfffsR5URnzee+r/CXGaQa/CTcs2mEjQRTvtY2gtTYApeqcV6sarhrTGE
        2oAQstXXEUomr2C99FVdVlCxf8VI/riQk7IlljrqO0sQkWSjexW4UjoZboBT5GL1
        9nLi1MGOKHvtq7DAwnWfCZk2CtKp4aNOdLbbUDgfVgQ1FvJPCOk3g==
X-ME-Sender: <xms:pXUeYvPGoZiyOCK928MvFdOiXl92Wf6UZI3TCBvc-onFXExR32BpMw>
    <xme:pXUeYp8jmr-RLo6_RUaLvUVzGG-ohvUqjnQg3oWG2lsYeF16QAkMA5Vk-9iQJmoDt
    achD3c-OpdPIpH27Yk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtvddguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhl
    rgguvgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteeh
    tdetleegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:pXUeYuRclsAG0DHzPP0HZEd-AijBjFFxFPguU1wNGDQTebX23W5Hyg>
    <xmx:pXUeYjvRjbaURrKVV6gs_n_OGaUP7pVDBowYDgxbtx-Kn2_k4Z_D9w>
    <xmx:pXUeYnfcBG0wENLJVQWgwdcIM3E8Nf8UOSE3TuZMqpF02Gl-IUpxyQ>
    <xmx:pXUeYoV6R87P0agazwzJUduGM3IFPPBh2XQSxpgSunyNuZzu315Gox0ZggU>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 13448F6007E; Tue,  1 Mar 2022 14:36:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <1e64938a-4f49-47fe-91e3-438e7d37c5c9@www.fastmail.com>
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
Date:   Tue, 01 Mar 2022 14:36:05 -0500
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
Subject: Re: [PATCH 4.19 00/34] 4.19.232-rc1 review
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

On Mon, Feb 28, 2022, at 12:24 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.232 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

4.19.232-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
