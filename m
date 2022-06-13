Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA92549E21
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343881AbiFMTxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350670AbiFMTx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:53:27 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CE743AFC;
        Mon, 13 Jun 2022 11:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655144647;
        bh=bVGiDRebCQI8O/oB+gLLRhDE/ot0FVdxkEqKV3VwdKY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=haFr5JwGO5BjdgIWG/Q5knW81ZkuemiBokpiiBPrviHJQbwseERogBpUO5KleX679
         47DGkihfFF+5D79YMPn3efnlIf2D9aYDuWvuPrjbYHT+HWIo2KrR1ePeaSJSlcRMo9
         PLOWzaCfVJWbksLkl7XDyfc5UJ6uMAjLaeU1VIak=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.13]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M7b6l-1o64b40Luv-0082oE; Mon, 13
 Jun 2022 20:24:07 +0200
Message-ID: <c25a1a40-3188-e81b-4e05-7ca379ba78a8@gmx.de>
Date:   Mon, 13 Jun 2022 20:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/339] 5.18.4-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:wbo4RI/n6a8x0XeCXyby9At/vv7kDjXMb0bwQZl0d9yjeP5xT/G
 eSbSOjFgHxB6DJpvofD/mec3NiH8jcPuf6sNMbK77vod2wNwaGy4dhR9mymg3zKdCJdwy4E
 IXhjyAreU0ZDBx+656jVEK1AA4nmVLeSQWGSsB2VyCRnc62vHynrWvBCnx9IQUWdxgAJ2bq
 RwdeA+QjySnETmoNYRJ5w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ixaIEcaD6VI=:Tbkxml3KTJIQ4Pya6+/0lN
 ZDkXGzzgoj49lh4l8GTIfU37CekOfycVPGRqwtNXabuaXJYJ6bDBV26GNtRDgKvFcFsAFDDMN
 AV52sr7pr1GWH9Uzf4TIX0oamhqfTgChr6HXc5bUsXilsb/XJzyyRXNtQxOsuJpEbDjhq56Vh
 XsMA7++OrobZD4JhyKRWLg7hwKQ9IEoMlO0fCB5e7ds5sUTcgJwP5+wES+rEhfJnT7Te1ouk9
 kR6qSTmnE+u894QfO1rwEYg72WEiLuaIDg6wsY9rXAeeXqu9Jysa0wYpFYfFXQ6I7EMBUu3Kv
 AOhjGxdvAckPb+TKqGErl+O2CQ2LgWjC96qSdfssqfVeU1SxFePNPGD6ns7nuFf7WLZmcWmjm
 Mo4qWC4zRj0BZEiMxhut65aqJXKXgkXqc0m6jPFbEfGQ0PLmaoyxoBs6og2cssgf3NnmtifOC
 wvIYPV0k5OmJtUU/XM9p1iZhwaIcd5QxyGgnIqgs8GXHvjwt2WsgJdAS+aCP5CM/NNUiusm5G
 Czi9trulY2CPqtTFihZUYqt8TDAuv2tFbpPNtuZ+HeJ5om1It/zcYXbtQ7a9mvQMym9MSKzUr
 tVx4iluPYU1nA7SBH5Q7yOneDxZigoCSoIsw+ftRjwLF9La1zCx9zyCDCvDFINOVaBpRyxH5O
 gB95+pgLCNMFTYD1hlwMti1M+CFoeLndRrc+6SB4G7vNu0irSfdoCqkaWGnwGdgCP/vaRuTjc
 BlqAOx7h6ZgI4BS+2TvTdyJC0xBF1YiE2x1lUuUnKDgLoyBeJ90sFNzah31p/nstCdJzMPH1q
 RoW/BqdU+Om7mXYpxxYxvtZOGES2SNWFXxiI/lwaAgwGV6B8GUWuTkMi5LwGtxmkppVsMFl3s
 VVZHRAPnwWsBL1QN06slXQNUzMbhGnuqjycbN1QokHPGaPeM010arQP0J+nBXVdQS0nZeIv7A
 GcGMhgr22zaDjnElV5FdI+tdkVz6LV7lc8YSLKK0o54XMgJPL6bVw7Rp0p8IYrlFlECQ2qWwm
 Aw6ztlOsj+LIiXjL/hpBllHAFy1hhM5pyDEsspnb6G7mXVcmyl0VnQh5wmdbWQOcF+MM1IPB5
 tUcKHHalJusTkrzMdQ9It4ktfEmNsVRwWLo
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.4-rc1

compiles (not without warnings), boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Tested-by: Ronald Warsow <rwarsow@gmx.de


Thanks

Ronald

