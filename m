Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3624CB4B6
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 03:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiCCCIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 21:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiCCCIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 21:08:06 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8955C13F93;
        Wed,  2 Mar 2022 18:07:22 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.41.243])
        by gnuweeb.org (Postfix) with ESMTPSA id 332EA7E216;
        Thu,  3 Mar 2022 02:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646273241;
        bh=6hdPeUDTpFCH5tm6GIDzeefZQ1DijYbUe34dlL4yiHc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UIH3FdIHhEtHk9207mgmSkpczcVJySwwhRd+ngT+WnK2kIMqnXD+y1/jr1F7gCnOI
         Oytv61vKSH1RjRiybyD9OcV+fXo992onmw6sDyNjdO5v/4FBiBI3SCdRzJcsZhVvLs
         GqQzJXlA1qa8vPLNHn9VYvzGX0EOGde+wd4MB2KB5AnfLJBZx+Ue1NwZgJlk3VDLMf
         +CGFGCi6A2gjPDAJyGhUDIWNwZbxgJyLXh4rMia+u4hw1rtEaDCWWBTKp+NsblZxgk
         Q8OXX7WXFf/recNzBhiPcnCYbycBihpDoTwZX7VNTRBkDj3J6TBM0xQFitYIb9/xLC
         kyje9KbfxM6Tg==
Message-ID: <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
Date:   Thu, 3 Mar 2022 09:07:12 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
 <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
 <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
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

On 3/3/22 8:58 AM, Alviro Iskandar Setiawan wrote:
> hi sir, i think this can be improved again, we can avoid calling
> this_cpu_read(mce_num_banks) twice if we pass the numbanks as an
> argument, plz review the changes below

OK, nice improvement. I will fold this in...

-- 
Ammar Faizi
