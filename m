Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4314BF067
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiBVDW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:22:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiBVDUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:20:20 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51088140F7;
        Mon, 21 Feb 2022 19:19:43 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 10E28580183;
        Mon, 21 Feb 2022 22:19:40 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 21 Feb 2022 22:19:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=eCDJze6QD00/gH
        YfYhsVR8fpoe1ybo+eYeOBYvXih20=; b=coC5n4U6CSnH7E3DMHZcCPalY+0f/6
        60PiWY9O0g/jH8YMSJluZJP3mZZQRquViWGKuAwJ3tOZdnZA1wNh5izuthO4BjbH
        mgtpOCTUA5hBiAN+w6aijMD9p2A+7G5nCQ7uZW+6DycsAg42S9+4Pa27f9sh/tHp
        SNU/chvwnQdVl5DE5PKF2O0hYcA046VEpS5KQIEe1oSyIPTxk+vtJYRD/wIWKxJk
        xTo5opdBPYrTgUD/L+E2qJSLPShtqu5aEhu3iUdJ57aqq9z7MfVOEIkUn6XnB6CH
        NqBSBMiDclaH03CQJsLPhtGipW3BlGxL8QV+0+jHgd0pZ/2xvYlHXusw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eCDJze6QD00/gHYfY
        hsVR8fpoe1ybo+eYeOBYvXih20=; b=HFYgkx0X6CO1XWycJOSLhLto0CNc8pinD
        nKa9THYUkYJRffDJJR5tDs59GZoot3hXZ5NYK6Bqv5xDOlSMhtL6TgZB5gr0qA/D
        dCoyXDYJ+i9ozd7MhgYKnHO4CSyLvNaAWqzGxeTJOSFpi1DQ4+O3V1xWcV1O1Xfu
        5TbSAAEtzOhC+L5JjxMKS7RN9h5T0KYCJImFhROrM6nz+3TgSD2cYC/BHm0dSS2X
        cooqAZgGrSLFWKFHWJ/R2P8x70q0KYm02avry954WuiOfGd6oV+n6nE3hIsnZWhu
        JBWRZFyM01EG0Hs/UQkjM1YVlabgFycD+00V5BTPfhSdnMhwipu5Q==
X-ME-Sender: <xms:S1YUYkM6C_TFb-qwVNRKohg25PuDCO4RTrYuDvkicMKC4zFGadTJcQ>
    <xme:S1YUYq8c2hbiqS8evB0cDUx0dnl6y1eoyMMvcGlpwE_HromuTc_7gFrTAKwVqBpI8
    08gr4NDIiPM6GJDFgk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeejgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:S1YUYrTIV9vmYe77AqoLEtgpAfKERWriEBrjSOTuLXnhQpAjcYxf-w>
    <xmx:S1YUYsuYhaVormwtWiOMrE6akjxqzikaKAljtHvuXlEGxC5YZJjVIw>
    <xmx:S1YUYsc0kKLdMkXrNuEhCPFzxDm4RfpbeWginXkEnmJt_tWrG97UrA>
    <xmx:S1YUYtWGmYEQj5TH5aAUqsJ5BxgfEnKZeWVxZMAGKKly-u9hSYnd4PGyrf4>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1D0EFF6007E; Mon, 21 Feb 2022 22:19:39 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <b5930805-fc05-4fde-a91b-a8c7e3eee1c0@www.fastmail.com>
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 22:19:38 -0500
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
Subject: Re: [PATCH 5.4 00/80] 5.4.181-rc1 review
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

On Mon, Feb 21, 2022, at 3:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.181 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

5.4.181-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
