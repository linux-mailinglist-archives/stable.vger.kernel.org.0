Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2FC4B5B63
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 21:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiBNUs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 15:48:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiBNUsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 15:48:55 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06872160FEB;
        Mon, 14 Feb 2022 12:48:36 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id BC43B58058C;
        Mon, 14 Feb 2022 15:38:10 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 15:38:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=Q01pPK0RylOLz/
        loIWRd4huP7JsmsQKOr0+rNPvHdas=; b=Kv0nQMfRd/2+oEcXzhLECdnq4yPzPb
        xrQa2w5Z2LSVjV6P3WEdjK7Rd/YJDlwzjCEMyxxwgilUML8Tx5Von6cw16TRGlBV
        k8PXoOOYBT1W9Vmr8bbyOEIp4Poqd6LlcmhUCQNQBf+dNyK+s1Wy809abZ2UlSrX
        knnH27O+7JcO6J5PKPEcnOoS1jA5BzXVB+QNkKuTb5XBOXy46eIvReKykdVBUrcZ
        +Yu5s0WSqUTSCUIHLALQyVycZG3+qns+xbHvKpVYXnPFT/6WD1OYCWWqW6HEKuku
        FjHn+OFCX1gAE04cLpuQ2a4K0TITb2cjfYxtO3hp/ZM2ncKebOMT1Cag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q01pPK0RylOLz/loI
        WRd4huP7JsmsQKOr0+rNPvHdas=; b=cEE5hKrIJbLCnIZIfUCO0MYmcRFNIH6ew
        xnyNihCymEkoPpWS36u087tzsjQHZqJ0DxVRBWBU/LPcEI/S5PrW9aTt/eC59R1x
        GwCXu6nc0MB4IYv93miuCDCYrQCKuN4nbZQ/idCO+ellzkDGvTgyoArCyequ7cqN
        CycfTx6HJEfM0Y274ORKSs261plKHJwX8fFDu3/c4zImHlqTsVJM6P58DpHt23IJ
        cqyMa1ru7ZKDZhnr+GC32+G8dQyozEeeylSzO0Yb7wzcsWQLgeT/1t1WuSljqM9Y
        5HQlqNghPE88N2jVx2BZ/nZxPAsy/ndL3efnhxHMDSpRuqOWRfbcg==
X-ME-Sender: <xms:sr0KYru2Uq7-MRcA4XTDSa3mF8NaheUPN1AYkYQ-Bk1US4C6e_0u8g>
    <xme:sr0KYsfrvW-Mo2o70Y9WO1t5ptIF1uMqIEOwLp2qlH7p5mU-Fa986ro78oNhdbwYX
    oNzAG5sVPqVWGPc6wU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:sr0KYuyFhhpREV_CPAyQEUT_UoOKhTE2vSFSa1L9IPaJrQChiJavJA>
    <xmx:sr0KYqN5DIq5Y9POrixdlUsWJVfLJTNF77Gp1bAVYl76oTfcAsvA-g>
    <xmx:sr0KYr8AILUh5vQ0pt9Dk1RGy1jiH85DiKW0Yg2eVGeperf8JK6DeQ>
    <xmx:sr0KYs1AFMSnIg8gUtZnzE3TNyChdUIQUM-LUR-pnj5vYdhOxs-V5On3emo>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5120EF6007E; Mon, 14 Feb 2022 15:38:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <2ddda243-0c1c-4150-8981-dc06ab4b55f8@www.fastmail.com>
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:38:09 -0500
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
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
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

On Mon, Feb 14, 2022, at 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

4.19.230-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
