Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30494D3F0A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 02:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiCJB6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 20:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbiCJB55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 20:57:57 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B2128652;
        Wed,  9 Mar 2022 17:56:58 -0800 (PST)
Received: from [192.168.43.69] (unknown [114.10.7.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 95EB37E2CF;
        Thu, 10 Mar 2022 01:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646877417;
        bh=S24z/t0QvOEntOijnJinUqvbbvEQPEekxjzJptrBJeE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UbgY3rrFyFXJ/ibKUs7htmEdqCjrbw9WZEtiv/C1zfOOIurJqnvsu3ksOzcVltmLc
         BpTQmvmUKMBDmH8yRtW2KnSfnvvhAt57669e3cqNigGB11tua8eE6LrnSq2nQWnN3w
         l0VwWFMN5wRQygja9COGAxzHPgOquxXuu2v7jvrPixz0XvIfTgDG+iXRr0uUsIFwf2
         /ID4a/Fv4af7n1hMddxfx1qmKcfYtuRVUBxYMkMasRM4JHiMPKHdnUea8zpLCdhntC
         70/1CxeDetnnZk9/Il0Azr18Eogxnz6zB81Ox8s455pn6BEf85HToK4FPbXJx4Chrs
         8LaReuVb4ty0Q==
Message-ID: <2530ff9c-4861-2295-6156-356da33f9565@gnuweeb.org>
Date:   Thu, 10 Mar 2022 08:56:37 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Content-Language: en-US
To:     Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
 <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
 <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
 <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
 <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
 <b18bac61-a27f-8de5-8aa5-10bda9309ac5@gnuweeb.org>
 <YikUW0i4hSh7t74c@yaz-ubuntu>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <YikUW0i4hSh7t74c@yaz-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 3:55 AM, Yazen Ghannam wrote:
> The commit message should use passive voice: no "I" or "we".
> 
> Otherwise, I think the patch looks good.

Fixed in the v5 revision, thanks!

Link: https://lore.kernel.org/lkml/20220310015306.445359-1-ammarfaizi2@gnuweeb.org/

-- 
Ammar Faizi
