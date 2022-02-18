Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E484BB699
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiBRKQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 05:16:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiBRKQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:16:10 -0500
Received: from web-bm.overkiz.com (web-bm.overkiz.com [92.222.103.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB24C2AC909
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 02:15:52 -0800 (PST)
Received: from [192.168.1.59] (4.106.24.93.rev.sfr.net [93.24.106.4])
        (Authenticated sender: m.gardet@overkiz.com)
        by web-bm.overkiz.com (Postfix) with ESMTPSA id 2A3901BF29E;
        Fri, 18 Feb 2022 11:15:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=overkiz.com;
        s=202003; t=1645179351;
        bh=eRiETnOr/M6qR/wrSfvSRG1O+iImqUdrjznI7QONxi0=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=VuUfkvt1aJYu7Bi57sGoyNgb79xKJKTE0iRR41HOLqNycb+zpV6JGS5Tt4tLvwr2t
         RyKIxaOkBT99gLOPkJvNQQXSctSN/DR9Mg+kPj9WdCuCTFH7TjY1WFxLMqqvEY1/Fr
         SoReaU8qkXmCHedOubqv+u1ecmPoG+xxarEImN6zXaBzKZGH6/d7bfawWDx/jjeINz
         NbjpPQwhbJmRmm36GRbUnHg/2XBxAtEI11WFNpaSPC53Qnb3eYaHeoYDvP59YCxWvI
         /C+kq5ojuVB4jmqrFHS/02HfPX9sKJkvWGqJqWg85SfRFb1B5BeUVWFuK9hqcnhq2P
         DO6ZYAh/ESvIg==
Message-ID: <f716c21f-f59a-a52d-3154-e72577a6f1f1@overkiz.com>
Date:   Fri, 18 Feb 2022 11:15:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.0
Content-Language: fr
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        =?UTF-8?Q?K=c3=a9vin_Raymond?= <k.raymond@overkiz.com>,
        Tudor.Ambarus@microchip.com
References: <b8147153-5bcc-8a6d-7aac-5c0abbd43379@overkiz.com>
 <Yg9dAZI3hSbD9Epl@kroah.com>
 <1ed07d2b-ab56-4b55-bb7d-e858e0f1cf92@overkiz.com>
 <Yg9puicPxjhUimMa@kroah.com>
From:   Mickael GARDET <m.gardet@overkiz.com>
Subject: Re: Atmel UART with dma enabled does not work on branch 5.4.Y from
 version 5.4.174.
In-Reply-To: <Yg9puicPxjhUimMa@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: f125012e-72d2-4729-b87c-a5ab9341072c
X-Bm-Transport-Timestamp: 1645179351334
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks y'all for your help.

Mick G

Le 18/02/2022 à 10:41, Greg KH a écrit :
> On Fri, Feb 18, 2022 at 09:59:34AM +0100, Mickael GARDET wrote:
>> Yes sorry,
>>
>> enclosed signed patch.
> 
> That worked, now queued up, thanks!
> 
> greg k-h
