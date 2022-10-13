Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988325FDF4D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiJMRvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJMRvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5F242D4E;
        Thu, 13 Oct 2022 10:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B30BBB82023;
        Thu, 13 Oct 2022 17:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33931C433C1;
        Thu, 13 Oct 2022 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683501;
        bh=C33+LlavBGIJeLnJsO26c1VUqKQk7toM8RgmzE7CYd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gagAuEIaaioD+JOxT7F2hUelfoHx2a+rIZEllRw8Mq2+2NGDAwin3/k7npYRG8WBU
         tFZZzloH7qVArPFLj6I/WFoNOW+i1J8k0md2xKjMRAaqwhAWWLMDpESl0Z5768SYeL
         2RKFWdHjDnoVg5jvx0ic+Td6fdUScjTpaszRylKw3UHN8exlIkACRK2hrcHvkybeP4
         BJCBpySmv8EFDIteLuZbXlckm0eZke6R7eBdNrrgQenSFECa2IWiLE2d2yryliqByi
         9wBEZw4mp/dnyoXajoEeP9AKC1QV6CFDmg+Opn2q3lkP586b8WBQep/ATWDEZKLZ69
         k+nnEubSAxevw==
Date:   Thu, 13 Oct 2022 13:51:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        GUO Zihua <guozihua@huawei.com>, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, fmdefrancesco@gmail.com,
        skumark1902@gmail.com, asif.kgauri@gmail.com,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.4 06/27] staging: rtl8712: Fix return type for
 implementation of ndo_start_xmit
Message-ID: <Y0hQLEXtrz542h2m@sashalap>
References: <20221013002501.1895204-1-sashal@kernel.org>
 <20221013002501.1895204-6-sashal@kernel.org>
 <Y0eoWDmylWzZjcNA@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0eoWDmylWzZjcNA@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:55:36AM +0200, Greg Kroah-Hartman wrote:
>On Wed, Oct 12, 2022 at 08:24:38PM -0400, Sasha Levin wrote:
>> From: GUO Zihua <guozihua@huawei.com>
>>
>> [ Upstream commit 307d343620e1fc7a6a2b7a1cdadb705532c9b6a5 ]
>>
>> CFI (Control Flow Integrity) is a safety feature allowing the system to
>> detect and react should a potential control flow hijacking occurs. In
>> particular, the Forward-Edge CFI protects indirect function calls by
>> ensuring the prototype of function that is actually called matches the
>> definition of the function hook.
>>
>> Since Linux now supports CFI, it will be a good idea to fix mismatched
>> return type for implementation of hooks. Otherwise this would get
>> cought out by CFI and cause a panic.
>
>And another that should be dropped from all stable branches, thanks.

Ack, I'll drop this and the rest of the staging patches you've pointed
out.

-- 
Thanks,
Sasha
