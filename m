Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658BF6071DC
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 10:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJUIQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 04:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJUIQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 04:16:46 -0400
X-Greylist: delayed 124 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Oct 2022 01:16:39 PDT
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 011B31A5252
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 01:16:37 -0700 (PDT)
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 21 Oct 2022 17:13:16 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id A9D992059027;
        Fri, 21 Oct 2022 17:13:16 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Fri, 21 Oct 2022 17:13:16 +0900
Received: from [10.212.242.61] (unknown [10.212.242.61])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 1063DB62A4;
        Fri, 21 Oct 2022 17:13:16 +0900 (JST)
Subject: Re: [PATCH AUTOSEL 4.19 10/11] arm64: dts: uniphier: Add USB-device
 support for PXs3 reference board
To:     Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20221011145358.1624959-1-sashal@kernel.org>
 <20221011145358.1624959-10-sashal@kernel.org>
 <20221017112315.GA23442@duo.ucw.cz>
 <cc2cef78-52e1-4da5-8739-375dd7bfe499@app.fastmail.com>
 <Y1JCPp4yW43/eGhH@kroah.com>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <405af811-4113-45ad-d380-6b73d5bd0cf1@socionext.com>
Date:   Fri, 21 Oct 2022 17:13:16 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <Y1JCPp4yW43/eGhH@kroah.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/10/21 15:54, Greg KH wrote:
> On Fri, Oct 21, 2022 at 08:29:30AM +0200, Arnd Bergmann wrote:
>> On Mon, Oct 17, 2022, at 13:23, Pavel Machek wrote:
>>> Hi!
>>>
>>>> From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>>>>
>>>> [ Upstream commit 19fee1a1096d21ab1f1e712148b5417bda2939a2 ]
>>>>
>>>> PXs3 reference board can change each USB port 0 and 1 to device mode
>>>> with jumpers. Prepare devicetree sources for USB port 0 and 1.
>>>>
>>>> This specifies dr_mode, pinctrl, and some quirks and removes nodes
> for
>>>> unused phys and vbus-supply properties.
>>>
>>> Why was this autoselected? It is a new feature, not a bugfix.
>>
>> It also caused a regression now according to the build bots. I
>> have not checked, but I assume there are some other patches that
>> this depends on.
> 
> Ok, let me go drop this from all trees now, thanks.
Sorry for late.
Right, this is not a "fixes" patch, so please drop it from stable.

Thank you,

---
Best Regards
Kunihiko Hayashi
