Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F7522648
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 23:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiEJV1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 17:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiEJV1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 17:27:53 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C752C3B2AB;
        Tue, 10 May 2022 14:27:51 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C24F85C00DB;
        Tue, 10 May 2022 17:27:48 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 10 May 2022 17:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1652218068; x=
        1652304468; bh=iPH87hUx+k6+RmWYMcc12E6OvGEBg4023VF/BHWQFsU=; b=C
        5u1f0LZMUFHUCkcyUCr/dvczmYyYOxENm1gxHYhi65Td2o6bsCLzqPXxmqhnaEKi
        7nn3ulp1YtLpaMAuRL2wdGqyMmQ3ZOt+Sm5bjeUiBoY865ObaPDkP4P5sni/IVgm
        1HnrQPI8/C5Lfz1KhfPfsiVJMX6UGTdLiwneVCscGZYOtDqHDIYgoqyOKlQ+Ke56
        9K2bkiW4NM2wWuG3cQuXaoa2x28b3rEqNaBbpnDiJaTqYyH68UMw1ce/p7OBK0C/
        78selmVyla3kBQfz/9tOZC99EYOXUssfpn9nfJ26/ab5vT0z6pDLuK6b4WD6KKp0
        yEqJSQST2yS6A76tw+5yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652218068; x=
        1652304468; bh=iPH87hUx+k6+RmWYMcc12E6OvGEBg4023VF/BHWQFsU=; b=R
        1qRYkdO5gJlxPOfAJUigWWwbysm3TtvvvztL7loiQRD/83hgI1ZiOltHFfVVfsTP
        lZFoZZVcD8tBLHAB5hhrCBzKwirnwMufKsPs73rH5SZ7smIIRB8VUfcTkHAvzjra
        8leS9esTqt4kV5SxSETsrgnUHjZzPHZr7TZPtD0wZkMAzPtVNzHPVixSkofSccsy
        2Z93URT73Fp4h5KpkNJTHx98JH34XKXcgYb4wpoZ6sIHI8EhmHWp3BiYJFkxIRHx
        +S12Dmg0541OUt5pvqvqcXMLeK4RNMXmquG19UKaQi1Gc4JpQrZAMyAexAD5tijo
        1SUhMPV9DI7Lrqlv7bAcQ==
X-ME-Sender: <xms:1Nh6YhIcrCS_YYn_z-JUhkdBwe7YiRDjp3An5TyRdZ_CTCxj0KgKAA>
    <xme:1Nh6YtI7DgPym2yg81M70_z88E4roK_pR2lLniqY2QEyle-mrMW2KrCMC3HTnbplB
    96P_t0j0zIqLvj26xQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeefgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepjedtjeffgeekueegteefudegfeekteetvdegudfhuefg
    hfdtteeigfeggfelteeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:1Nh6Ypt8xk92VxeS_Xe21xVY4T4f9EjFWEmpaufwgEckTAJpVWuG5Q>
    <xmx:1Nh6Yia8PdkmSAj_geJSYiUyY4oA3qv_P_Bf9HHXO9e1f0J_1kD05A>
    <xmx:1Nh6YoYEn5lUVEfe2ubjjW_xV6VjqIHGs_SPTjEKNB_BzI12YPo9Gw>
    <xmx:1Nh6YlTEhxyKnnZ89oi9fQIapOSDdmfOIyS_uDQ0H51phhe4asDV9w>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5AC9615A0080; Tue, 10 May 2022 17:27:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-591-gfe6c3a2700-fm-20220427.001-gfe6c3a27
Mime-Version: 1.0
Message-Id: <4e8d8969-7515-4724-a1f8-d1ee49629a86@www.fastmail.com>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
Date:   Tue, 10 May 2022 17:27:48 -0400
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
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022, at 9:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

5.17.7-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 

-srw
