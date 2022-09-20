Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C0A5BDC85
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 07:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiITFpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 01:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiITFpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 01:45:04 -0400
X-Greylist: delayed 139 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Sep 2022 22:45:02 PDT
Received: from mail.as201155.net (mail.as201155.net [185.84.6.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EF219C28
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 22:45:01 -0700 (PDT)
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:52170 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps  (TLS1) tls TLS_DHE_RSA_WITH_AES_256_CBC_SHA
        (Exim 4.95)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1oaW1l-00068B-2A;
        Tue, 20 Sep 2022 07:42:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID; bh=cSPxfDNULS8335PqZiOl1xMpOB11dQ6WXoJ1j1PJL5Y=;
        b=uy/m6mQqJVtsVXkHC6lmDz9LI4quYrHKCRxsO7V6QobXqk3RwA34WCr6GDTgTxZ5tolHKTyENWIfoDjJPh0sGfVhPZYWgPuWyWvRStKUxW/g3Cy5zBSy0rmmjN1ZkZBfkreACk2CX0fGoqaxOJ9MdDS5XLM6iEKIzGLFB8eubuQ=;
Message-ID: <c9904373-7e20-64b6-8900-69d38f2cdef4@newmedia-net.de>
Date:   Tue, 20 Sep 2022 07:42:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101
 Thunderbird/105.0
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory
 domain"
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Cale Collins <ccollins@gateworks.com>, kvalo@kernel.org,
        Patrick Steinhardt <ps@pks.im>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Stephen McCarthy <stephen.mccarthy@pctel.com>
References: <20200527165718.129307-1-briannorris@chromium.org>
 <YmPadTu8CfEARfWs@xps>
 <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
 <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com>
 <CAG2Q2vXFcSVwF4CbU5o3VP1MWwrdqrZjTHgfBj_Q0t3nNipJRw@mail.gmail.com>
 <CA+ASDXNx30A3=BA9b-tiAQzYHP=nV_eLw1QFpJij=F=JgWZ5sg@mail.gmail.com>
 <CAJ+vNU38WyC=FFZVgqyKunEnjXid6vXqkorv8a8+ywjJBk_0NA@mail.gmail.com>
 <CAHNKnsTEBr4m1SpZxnfFPWiSgxBg5HhqYCdWwm=9gp7qHXg=Pg@mail.gmail.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
In-Reply-To: <CAHNKnsTEBr4m1SpZxnfFPWiSgxBg5HhqYCdWwm=9gp7qHXg=Pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:d4:df03:78ee:bd3f:9dfc:a067:ec5]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1oaW1l-0007RI-Ev; Tue, 20 Sep 2022 07:42:37 +0200
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 20.09.2022 um 01:42 schrieb Sergey Ryazanov:

> Hello,
>
> I would like to add my 2c.
>
> On Mon, Sep 19, 2022 at 8:25 PM Tim Harvey <tharvey@gateworks.com> wrote:
>> I'm not clear if
>> there are many other cards that have this same issue.
> The list of cards with unprogrammed regdomain can be extended with
> several relatively modern models:
>    * MikroTik R11e-5HacD (QCA9882 based)
>    * MikroTik R11e-5HacT (QCA9880 based)
>    * QNAP QWA-AC2600 (QCA9984 based) [1]
>
> As you can see these are powerful and massive cards for WISPs. Or at
> least to run as an AP. I also know a bunch of .11a/b/g/n cards with
> zero regdomain and the same target audience. Except maybe for the
> legacy Wistorn CM9, which is a relatively compact card.
>
> Also, a huge number of wireless routers and access points have
> unprogrammed regdomain. But probably this is not the case, since they
> anyway can not run a stock kernel.
>
> 1. https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1895333
let me add my 2c. the regdomain 0 is very common and defacto a standard 
for all non oem cards on the market. i have only seen real programmed cards
as buildin cards in laptops.
beside of these zero cards there are other special regdomains available 
for ath cards

>
