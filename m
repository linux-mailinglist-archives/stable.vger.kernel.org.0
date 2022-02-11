Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB814B1E3A
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 07:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiBKGMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 01:12:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiBKGMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 01:12:43 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A989DBE4;
        Thu, 10 Feb 2022 22:12:43 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id C303B580151;
        Fri, 11 Feb 2022 01:12:42 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Fri, 11 Feb 2022 01:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=xsSTeaHpM9YFFq
        U6y6uqJ8AjtheEyxvj6uUgxbNJlAY=; b=bK3RhqNVq2Lh/QXbC403JpH9CUmRdH
        2iY2G0f5MtYFb4W9ZrpUPQN3sTHGn06AKlMQgYjkPCK42LzR+dyttCPLhLd5HVTr
        IheZlCPUwjXM45W5feFOosgq4PHOxtmYHLfsuD+oI7PUkBXqkKPrB87phFIGTvn2
        h+OSXY4uXWQgI5bgCXMfsj1692PU4j6mD3DOmbAWLnVokk+Buw80woOAwgC20fnU
        xtBEPdYxjqVArN7BCBkrF1ED99GfV9AQLC1TQOLGunn8pvarobXa1HIXUtoZcZmQ
        vRekBqbl0sxrCOcchTJCQ4+CzFUlvTNg2BtprrU5NBj9kFBTVy47axLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xsSTeaHpM9YFFqU6y
        6uqJ8AjtheEyxvj6uUgxbNJlAY=; b=H5FmCKpoXz8bUW0NQXR4rvb8FVQlZKWrQ
        TVK1Cp+zHfvpXrAJShFzt24lym5B05FMQOgJ/7+2JTmhiCyhE+Br0Bmr5tDPI+U8
        3FxZC+VYqyFZWQE3DZwM96Gv/Rq6+Avf0olVUttFqDl5tp6iv9lF+hRNkRvi883A
        eJ8S9gBzWtGPeDAwx8Glsq1JKsL5q1cEvhcQxoX/MhqUVbA0YvBsTE+PhcZYTPqC
        H4ajaMiOf9JGLYyfRSUPjSSgzseOqZigJHzSXE49Q8NDBjG02bRmaDhfkDlV4RmC
        rNa6WOzNM4hshfT2PxnyMDU/NOOMoPOLT9/WOWU/Ojn5UUHKqQhpg==
X-ME-Sender: <xms:Wv4FYnE1oBnRdYaSX1z1ckw_-2HK0rr_TI7LrdhPYwOPRgCN9Sj9DA>
    <xme:Wv4FYkVjXGMvZ3LS2HowkFsNRxcC-DWfI9yd5233l8YpNTlMwio6ISCFMu0gtr17H
    MUBOaO080XSidzeFbc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedvgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:Wv4FYpKagqBHQ_Qq_D8oYfipQXY-_lKQ6e0fCEq8Ughob9GoenkCXg>
    <xmx:Wv4FYlFo9g3OMFa3sWUnNziBcRp1XOFbAkLr9z7FcwUJoZt66EyhCg>
    <xmx:Wv4FYtX0kvgB4OJZ8NJ6Q_Tbhv-XVs1cBItSZrugSfa7tPqlGyfUdw>
    <xmx:Wv4FYmNmJKR77MiMs6kkQO1PM2Wcg_2zg668J6-k73OYn9NNoTNZNj4FINQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9072EF6007E; Fri, 11 Feb 2022 01:12:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <2a4cb652-937b-46ce-b335-93722afe50f3@www.fastmail.com>
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
References: <20220209191249.980911721@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 01:12:39 -0500
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
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
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

On Wed, Feb 9, 2022, at 2:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.15.23-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
