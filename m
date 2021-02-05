Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC8310C65
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhBEOBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 09:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhBEN7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 08:59:51 -0500
X-Greylist: delayed 123 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Feb 2021 05:59:11 PST
Received: from mail.as201155.net (mail.as201155.net [IPv6:2a05:a1c0:f001::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5431DC061786
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 05:59:11 -0800 (PST)
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:54916 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1l81ck-000691-2q; Fri, 05 Feb 2021 14:58:14 +0100
X-CTCH-RefID: str=0001.0A782F1C.601D4EF6.00E5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID; bh=Xixvwm2i+y3j29SalwtpRA5OrD4PHh/yUtdWXtO8qwc=;
        b=Zr7WXQ5WjOATqDZTIev5Xt/o57kQC8TeMgr4+1XYy7+T5eGBlMZr8YKcLm1tKGnyWe+HTtECDamL8wcv/CQ73EGuCWIe+7Mlgd1wrmMfs7BkQ14fqfN+jO69zwF4pAFWdaqLejRY6WxGTXg5EqS9NgUIDxsMiNdkiwaz/1mZaE8=;
Message-ID: <e6eb9fd7-2555-ef9d-ba6c-42ca7d6313a1@dd-wrt.com>
Date:   Fri, 5 Feb 2021 14:58:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101
 Thunderbird/86.0
Subject: Re: [PATCH 4.4 00/12] Futex back-port from v4.9
To:     Greg KH <greg@kroah.com>, Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
References: <20210201151214.2193508-1-lee.jones@linaro.org>
 <YBgdRJxWt8Y1Oog2@kroah.com>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
In-Reply-To: <YBgdRJxWt8Y1Oog2@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [81.201.155.134] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1l81ck-0000RF-9q; Fri, 05 Feb 2021 14:58:14 +0100
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

forget the last email. my fault while merging

Am 01.02.2021 um 16:24 schrieb Greg KH:
> On Mon, Feb 01, 2021 at 03:12:02PM +0000, Lee Jones wrote:
>> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/pending/futex_issues.txt
>>
>> This set required 1 additional patch dragged back from v4.14 to avoid build errors.
>>
> Many thanks for these, now all queued up!
>
> greg k-h
>
