Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3AE4C09B8
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbiBWCzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiBWCzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:55:04 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C3453B53;
        Tue, 22 Feb 2022 18:54:37 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 002C05802AA;
        Tue, 22 Feb 2022 21:54:34 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 22 Feb 2022 21:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=Wd3MXApIeLNjLf
        1QQkbJFUEf8WF3Qp0qGU7yMxIKIiM=; b=NheQuMJIdGy8XN7j8j306FTRsqfidG
        wJ/nzKJjBUDfdYWpkqo98hRSsm1Gz/eUDNE6VH3p5UzGdXJ0vmXjaJZMIJEljoMC
        qELwrSyLMolSuZmNX8IG9OL3H3WWCvb0bXwEoacG/gknPGEfv89EGDL2tu6GXPRL
        rhpiTmr4tW5EgVqpZ7Lcjb9hFcECGNdre2kqwqb/L2w1upbol1Vb3qjSlqM2iGpE
        cqqwAb37x4ehnmQrNonJ+blHn8GqYrsF3jLTHdkGLKoRpzh8KKM+ZjuKApMx13r7
        cmF7TyRycLbu8/6ATTSoZyj0Cx87b88A0vk1+jHctdVuzZlphsdjXoXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Wd3MXApIeLNjLf1QQ
        kbJFUEf8WF3Qp0qGU7yMxIKIiM=; b=Kfz3ZlaEWKD577qSQShNr3Wi+3aJGsGoD
        yV+b4F9yYzzEmsUm7JIKTM7zvTAPgxp00X+8Z7h9e6Po437MSQt7sjGiEq3m9U37
        es8G/fmuSkFmiR5W9CsBVguBEHHwvmv6WPKnmVdqWMvor1b5PGTDvjED6ni+Fcpo
        SZhZT5Zax9A4/JB7Yt1dP5CB4nLzgnEGWuyt5pXyj+XldgYZuww8ModuBHVq5ZQR
        kiww4CcCKUEE63Q53NkbHH85B1lwjfc9zo+VpO/fa7SqmLtAWaZNj19m3KgMwL3M
        kq+jzfvpZE/wY7CTS7KgDS6EWpKNZLk0yzOCZaiHLrLzN97CPZilA==
X-ME-Sender: <xms:6aEVYnEpjI70-rBYLRBFK0sSuwrG2UsWjr5ppwK_hpkNuqsS2HfVTA>
    <xme:6aEVYkVHCxnCJbpEmKqFysodMjsaNtlDJwF4873nvf4UaqWbyFVokfRJfZPjzF140
    X8SvAk_51vCGkIyovg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeelgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:6aEVYpKu0UzUExzjl7eQySdbKuDzQPQ7SHXy163hHLejxVyXp3lHiA>
    <xmx:6aEVYlHsmee5xKBBqEkhSo1j6K-QZ2G3-ySlCOHD8oN8wLH_qQ31aQ>
    <xmx:6aEVYtUoyjss8z6Sgvl7Jk0z68bBTmifrvlAVSN0UnHdZmq0VadJxg>
    <xmx:6qEVYmOakLO9o7tCkuJlN6Yn3cKTemwFfz_Oz8aDtcpRROEm1GPqtBFkOI4>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 532CDF6007E; Tue, 22 Feb 2022 21:54:33 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <015c9645-e177-4f9f-8c3a-c58c5446c92d@www.fastmail.com>
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
Date:   Tue, 22 Feb 2022 21:54:32 -0500
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
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
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

On Mon, Feb 21, 2022, at 3:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

5.15.25-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
