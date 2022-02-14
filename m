Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9FA4B3F02
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 02:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiBNBtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 20:49:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239078AbiBNBtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 20:49:39 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC54532FA
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 17:49:31 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id B52A058020F;
        Sun, 13 Feb 2022 20:49:28 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Sun, 13 Feb 2022 20:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=dDLZQpJOqVpzhD
        nNXDxBrBWv2tOpPWzzAYXA5O1UtqU=; b=f1eAt4xs0QhmSIo+WsV1eGduek3Dg4
        gsnklClemAszo8PL/AlobZHQlTPC0EWuGnYz6CdwqX7lZauyfaFClrCM3YnFR2ib
        w8RoMbC6VRm8PBWZnU2m4Rb+ec8XtbFadhSCABu2lkvrqcxxL/0V6HF/CQJFeYgG
        /599rnS4pCsbAA+k13C9CbYca8Hqx68Hh5AoqeLkl02QanIDF64iifdXxdXYrn4c
        8wCq3rYcigiTwJTA/FPzNKD4cHvHlsShOpVWzWsGrGEpmuRrTfEquxMixllLtOv7
        iIKjlpN2BSKHr6/GDR+9i7moRUeJLPRX/AtNO3k7Y+TYoqibjoYaboXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dDLZQpJOqVpzhDnNX
        DxBrBWv2tOpPWzzAYXA5O1UtqU=; b=ejPUuV29VRHnjzijZriGzPLsIMIjGHJxx
        P4fCRL8uvr0BLrD31BUrVYOgDSvpySfbpylhNvACOCEFEkQJocOCH2Y3tjXA6wgA
        SW2lCooFoR5GzPs6e0nrUa4MisdAxrQBnUnQ+J6eERS6kWsN5gN84eXJlqf0KQqd
        Eg9jxJKPx26qfjX68Nsq0UQaf4MgsXxWgZyCAtZWScwRqaSUSRgF1KG3gwXu/u/z
        JjrRIvGNLwJYyM0Zelw/G5cZEA5FxfpL5vLxwHGZs6cF1jPhYk84D1c+OOzbwul6
        15hUids1kaOXvIuVbfZQ82TNfsnx9+wCgSRXp9yQqNNPFwC8Bi2hg==
X-ME-Sender: <xms:KLUJYmu3EZHS7tynUym1YUrabeAjNxOw82WvonKiS63p2VI7VbAkKA>
    <xme:KLUJYrdW79dy4hCB1A1mD48GIfS_SN1zt4t-5ZJsP__PUegBbu7uBjvzOQxCRUSO6
    ewZ8v_NmCHYFpDvRmk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedugdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:KLUJYhyu5JL1PRafww0chRv4_j0jCPW58M-aZBraZeokqO1X0Ai9AQ>
    <xmx:KLUJYhO2fg6I0_VLcnfshJw9HsWTPLAc7cujYkEI_HYGABAzNFyLkw>
    <xmx:KLUJYm9cUJO1qBEWAinq-eKjb5BBQ8gijEh3D6QAsJZyzUWYsvp0SA>
    <xmx:KLUJYnIJ7R3rN3MNNy4Fx0AIZV_hHUhyVOql3yClI___taYMRcgRnw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 56768F6007E; Sun, 13 Feb 2022 20:49:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <9a42a479-0326-4d9b-975f-e13cde092ad9@www.fastmail.com>
In-Reply-To: <20220213115928.4f3cab59@valencia>
References: <20220213115928.4f3cab59@valencia>
Date:   Sun, 13 Feb 2022 20:49:28 -0500
From:   "Slade Watkins" <slade@sladewatkins.com>
To:     "Jason Self" <jason@bluehome.net>, stable@vger.kernel.org
Subject: Re: m68k: ERROR: "usb_hid_driver" [drivers/hid/wacom.ko] undefined
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

On Sun, Feb 13, 2022, at 2:59 PM, Jason Self wrote:
> Since version 4.9.293 I have been getting this USB error when building
> the kernel. m68k is too old to have USB.

Just so I understand correctly: m68k is too old for USB, so is it really necessary to have these USB patches on m68k then if this is the outcome? 

> Version 4.9.292 works. Running git bisect tells me:
>
> 1309eb2ef1001c4cc7e07b867ad9576d2cfeab47 is the first bad commit
> commit 1309eb2ef1001c4cc7e07b867ad9576d2cfeab47
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Wed Dec 1 19:35:02 2021 +0100
>
>     HID: wacom: fix problems when device is not a valid USB device
>    
>     commit 720ac467204a70308bd687927ed475afb904e11b upstream.

(If I'm understanding this incorrectly, let me know. I've only had a small number of run-ins with m68k issues in the past.)

Thanks,
Slade
