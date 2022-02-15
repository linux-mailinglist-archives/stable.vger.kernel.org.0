Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D514B5FC2
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiBOBEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:04:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiBOBEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:04:40 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819FEBF50D;
        Mon, 14 Feb 2022 17:04:32 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id E1D30580667;
        Mon, 14 Feb 2022 20:04:31 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 20:04:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=Q0sxgpStpmxjZA
        PqBIFuX2bNHraNzWHvjaGpsiZ57XE=; b=LRkKWvtWUoiCX6OCQa87wSFlfr0HJQ
        uH7KruQ4huaE/AnDZE1HxoMfyNE61fE+PbbaWp23veaXfMF0pUefObFlWwMsAshy
        8RLt3vyWvWSDMQiKELhRMSHfjg6cRVhu3dICiBRAuCLhRybdHPbHquqFArbOtRy0
        arydrWmCbBp0LOJ5HbNvttilCrF4YGfA9s1PzM138+iIJMCJSW1Oq5W/VbgqV+4c
        hqEr2nD+HnXJYSoya6vHM7qNH6PAE1nSJfUn21hl6+LeT+IaVx6AVtLx22+8wsC1
        vA14Jksj6RzjVMokO39Z9vKpMK54QX71mHg/3v3et3mcsyAhvaZsYpfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q0sxgpStpmxjZAPqB
        IFuX2bNHraNzWHvjaGpsiZ57XE=; b=QHd6IVdeqapFBt/7/WDRvbGavAitwhVqS
        C5b+H4ltEBlE8nlMPYqL+i0d6diefZPjm5HlezPRR39Lkz98cm6SamL/lWjE5Vt+
        1SqcWbazUXXaILnVQdU4/Uquv/VLcku9DgaDAp2/yc/QOSl0eqazDQmc9LC496zy
        nwOohZ91MeCULClnMirhoKqtWX1NZnT39UmEjevqoMS5e1zercKR1U0Kd9Ypn62L
        7NmJvUNS3g+3vAv9VYW3wnorxs3b8gUvLZmbawG1B2RXwIXlWU6Y0JIp+XwCSy3p
        SgfhFBj2EjV9eIl0QP7fBhCT+jde+gANMNfRAg6CnwzLChgWtT9gg==
X-ME-Sender: <xms:H_wKYoOmGgctJpRaxxS9ZmbZ_OAcEup4woURpIlE8nVnOCWspIU_mw>
    <xme:H_wKYu-zrFotsWq33X70Xmffw6fwOUwz6p27glwubS0-Gq8lrCD_bpIIhnSVjtMLl
    VOLuMyj0cd36idwWVk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:H_wKYvSu5d4fwNAHWvKgWw42APbO_qBIb0svmuc4l_SkNvhPpCTH6Q>
    <xmx:H_wKYgsizmhhymEm9YeTHyRQRdtGH83WKw3IuN5PiybcYKLTxb3lwQ>
    <xmx:H_wKYgclwvpVuQx-3p08nf0vNKEfYl5HVnjA5ey9cMCuHvs5VTLFAw>
    <xmx:H_wKYhUHKCekSSQBontH6iFInzg1EaPAWqYijPZMYbaCSKc-EdwkihSV-I0>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id AD9C8F6007E; Mon, 14 Feb 2022 20:04:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <c9a4c923-a46d-4182-9c08-a533b5b4d98a@www.fastmail.com>
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 20:04:31 -0500
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
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
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
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

5.16.10-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
