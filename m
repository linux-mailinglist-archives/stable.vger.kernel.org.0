Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F814AE0A5
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384542AbiBHSWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 13:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbiBHSWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 13:22:30 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A4EC061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 10:22:29 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nHV8E-0006rv-9m; Tue, 08 Feb 2022 19:22:26 +0100
Message-ID: <df18cc2e-fa46-b088-85c6-959d8b6ea4ea@leemhuis.info>
Date:   Tue, 8 Feb 2022 19:22:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-BS
To:     Jason Self <jason@bluehome.net>, Stefan Agner <stefan@agner.ch>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220203161959.3edf1d6e@valencia>
 <00b41f5de94fca5ef995ab2c95def4aa@agner.ch>
 <20220208100529.41d1b4d7@valencia>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: Regression/boot failure on 5.16.3
In-Reply-To: <20220208100529.41d1b4d7@valencia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1644344549;6d1cfed6;
X-HE-SMSGID: 1nHV8E-0006rv-9m
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.02.22 19:05, Jason Self wrote:
> On Tue, 08 Feb 2022 09:50:59 +0100
> Stefan Agner <stefan@agner.ch> wrote:
> 
>> On 2022-02-04 01:19, Jason Self wrote:
>>  [...]  
>>
>> I have several reports of Intel NUC 10th/11th gen not booting/crashing
>> during boot after updating to 5.10.96 (from 5.10.91). At least one
>> stack trace shows iwl_dealloc_ucode in the call path. The below
>> commit is part of 5.10.96 So this regression seems to not only affect
>> 5.16 series.
>>
>> Link:
>> https://github.com/home-assistant/operating-system/issues/1739#issuecomment-1032013069
> 
> Yes, it does appear to affect multiple versions; at least 5.17-rc2,
> 5.16, 5.15, and as you say 5.10.
> 
> I can confirm that this patch addresses it on 5.16:
> https://lore.kernel.org/stable/YgJSEEmRDKKG+3lT@mail-itl/T/#t

Thx for pointing to the thread!

#regzbot monitor: https://lore.kernel.org/stable/YgJSEEmRDKKG+3lT@mail-itl/

> It appears desirable to apply the patch to all of the stable versions
> that need it, after it's gone into Linus's tree to also address the
> matter with the upcoming 5.17 series.

FWIW, the patch is marked for backporting already, it just needs to get
merged to mainline first.

Ciao, Thorsten
