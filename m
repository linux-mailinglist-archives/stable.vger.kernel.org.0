Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F29D4F47ED
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347855AbiDEVXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572976AbiDERjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 13:39:13 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDC2B8202;
        Tue,  5 Apr 2022 10:37:14 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 002665C01D1;
        Tue,  5 Apr 2022 13:37:14 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 05 Apr 2022 13:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; bh=KuSmYS9TX5fvKT
        WU45hX70KGFcLIlFZpUizrcrs8diU=; b=I3f4NWgYLX4zJmaCk5k2jpJ2j5+RaP
        J+RUGv1C92o2lwro4YHnMnyV/wQLdGZFdh/ukhflQ0B2Z15+zTkfA5uMIEJEcqhb
        QqP1RT2yA+BWQZoDEtxnd3I83wrOiU2gfarbrA1DygPKgRTJrtsTdv4gKIspRdNA
        LhWNMInI1p8MX+G+oJFOmaYJcxSvnGy5WR+3guftfMC2WjJiQWjnPZ8P/JtHJUKV
        QwfHjBUNDbPmJ1wNcvEeT0yNTggE0BKrEVbwKHiLkU+LtcnyExkAWW8TdydNvl5B
        jlRDbnmumxECTI6FUXKchgS//3pNUUjR/L6oAIgmfKJnU8asAbfc6C+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KuSmYS9TX5fvKTWU4
        5hX70KGFcLIlFZpUizrcrs8diU=; b=RxEi0jxhjkB5RtK2k+EQ/DjZiKfCC5or9
        7dtZdRDHUaLSIQNlMS+gB0mpDv1XHLhfBabEWdn9R0leELvn02xUL9GpvVxqV77O
        PEHD6/uCDlWkMSHgLGFpZsMGXgfs+7WKWzwaI+GJ9VHEFkR2OxO4Nvhhju0y0S7r
        0M2H1W9KFM7WcZSRbvdqOf+0rvYTMZE9fQDkoPH5f1ollo+KaGYksIxy7CYmyYaM
        ZaKpg+I6YrRN76gjUkuScoeDS+53qIzhrYZIH0QL4sCA/h5aKjVoGYYxE8P0lQPv
        9oVhB4b++ee7dc5Nx/R3E3aGCjK+OWa92zpx+9E6l5mw8JPR9l2lA==
X-ME-Sender: <xms:SX5MYmQiXzXa-lD88I3Bs5FFKrshX5oWTYIQ6th1QZ8-BmSJJIG11g>
    <xme:SX5MYryYjeYu2XN5BYhFXzr3QVjBTNDxThD-jfkMPqcmCcbzLS51Wsoj-IFLOK9uH
    Jam9aYcn8KrF1RZ9Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhl
    rgguvgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteeh
    tdetleegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:SX5MYj1IMy5Wq4pbYtPcWR4m5U5YrByk0MV67uEq1tVLgH180rocyw>
    <xmx:SX5MYiD824E3Qxt3uposiCcS-epmRrjTZ_KG5dx9vOOC14n3D2lODg>
    <xmx:SX5MYvjd8ljYmyc5ZWaeI4GHvMiHijCDk0tE-V3w_tHEsQGHBJko7w>
    <xmx:SX5MYkbeLKCSOV1kLeWulUHn5XgVqEc_wr1Kn-ptND__mK76YluK8g>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C014915A005D; Tue,  5 Apr 2022 13:37:13 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-385-g3a17909f9e-fm-20220404.001-g3a17909f
Mime-Version: 1.0
Message-Id: <6ec27c63-0496-4b42-97ef-a5d43e2759b1@www.fastmail.com>
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
Date:   Tue, 05 Apr 2022 13:37:11 -0400
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
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
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

On Tue, Apr 5, 2022, at 3:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.

5.15.33-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
