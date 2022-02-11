Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD64B1E39
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 07:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343495AbiBKGNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 01:13:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiBKGNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 01:13:11 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D543B25CC;
        Thu, 10 Feb 2022 22:13:10 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id EBB865801CE;
        Fri, 11 Feb 2022 01:13:09 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Fri, 11 Feb 2022 01:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=hw8XwxUa3faDPm
        MGDrpUyGNrmixSLr/NruIMilhhvks=; b=Zp1KTUo2UhGSqJl4hU3I4HwDC/9OA7
        v39wkw8ZkjA3pOjLfgklDlMG2O2Fz3sPPqaxDzL3H/X7t/YfLsXmOUpOtVhcreyz
        1LHZncbepuarcCWvnRgEo6cHtRz0By45eGlG6fEYAKkbS9ftG0xFFBgSpwPf7Q0L
        xFR1Q24hYgZzbBUd4uOtebhyBQ3qISaLTvscEZmVnqijo4HMpDwiBk78PEvk1zbk
        yyUk8/Xeto8YaMdrO1Z1lQItCsfg8thL5WrKgceRWH/Gs+3R5UYZ8joO+VAoQD2s
        0AtsAblVZjcSwXhJxWYdxYUh0LBBCHagXVC3IK6TQ4tKr10yoSLnPEGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hw8XwxUa3faDPmMGD
        rpUyGNrmixSLr/NruIMilhhvks=; b=fCSMWrNGQOrWZFyHY5yPEADcRluciTsxD
        mjATn1o6uWuDMEg6qw/Wq23dpahaCSVPxoD//PbH5VAuJLd4pXiBI8qJXCM9cGvH
        wv+YVvjNHMHHJlbF0G/dxTqpbax4ou7w3yNoR/G+2Zw0YegRboImf7SZLFX9ZvJ9
        AShIPenn7p4/AZSi+kxqgBDf36Vx9KjDZXq+KbC35t5WPlwiJwvttS4k80nDjgAI
        X/G9sjjljbsoqS3R06yAN/a0kAGIc15/L8VrIo5+rXhcRGoRew+6GkrQEoSCIT62
        fbZ8mM+WyyuJjNMZ0K7lkLVWur5ofMPS3BNcIvuKxx2/Ii4ECQbaQ==
X-ME-Sender: <xms:df4FYjyZh97A6Qv9-a7-w-ghdXIbRv2WG1Dj4hTI26lcMgquJPSZzw>
    <xme:df4FYrRCriZQORvGyXx-uLA6eUipsGpM0sVvW34oChFy61z-huvTqidcQCE4pWWFq
    YwFQbgLrP5E2G_RKeE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedvgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:df4FYtV2cJVHovnmE5E2oBW71vbw8FwFgcPE1_VDMoGsi6YvrN_Irw>
    <xmx:df4FYthi5TJuvABz04O44R0Krp3hR4uwZ5ck0J2T6GeqAnIxGppCdA>
    <xmx:df4FYlDq3G2npx0CQplopqcKPG0rGlRasRVbvZwDaLfKBkSIYSwlGQ>
    <xmx:df4FYp6wkltfoJlQC-TyCCYAJQVqOCFG1kSDoKiqVJvKpmhTDgkwJwPcEg0>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A8058F6007E; Fri, 11 Feb 2022 01:13:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <81f1a5c7-1080-40f7-9716-3111debf7d7a@www.fastmail.com>
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
References: <20220209191249.887150036@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 01:13:07 -0500
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
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
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
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.16.9-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
