Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4338E6629A2
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbjAIPP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbjAIPOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:14:49 -0500
Received: from mail1.perex.cz (mail1.perex.cz [77.48.224.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E4DE0CB
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 07:13:50 -0800 (PST)
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id C912DA0042;
        Mon,  9 Jan 2023 16:13:48 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz C912DA0042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1673277228; bh=JOgV0HrPLnwj9pZW17Xj5Dva1AUOBQ8aiY9pRGXMYWw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=5tWLPAcwwe/BjcGo1DrBO+lem97FpWvDkV3Zoe4pPZBVI7dRtnF/MPNhClhMSwcnP
         z9ES9+6IezcH4pGykZGx3VEsLsmEjY/Q76gVRRu4uT5iFRRu+JA4kfAVsA8pJ1MnaT
         cA2pAXwobzHCNw5WaYveGjurVwMSKAJBvYUqiTUo=
Received: from [192.168.100.98] (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Mon,  9 Jan 2023 16:13:44 +0100 (CET)
Message-ID: <c117caee-cd9e-02a1-d38b-489d8611b340@perex.cz>
Date:   Mon, 9 Jan 2023 16:13:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] ALSA: control-led: use strscpy in set_led_id()
Content-Language: en-US
To:     Takashi Iwai <tiwai@suse.de>
Cc:     ALSA development <alsa-devel@alsa-project.org>,
        yang.yang29@zte.com.cn, stable@vger.kernel.org
References: <20230109150119.342771-1-perex@perex.cz>
 <87h6wzg35b.wl-tiwai@suse.de>
From:   Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <87h6wzg35b.wl-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09. 01. 23 16:04, Takashi Iwai wrote:
> On Mon, 09 Jan 2023 16:01:18 +0100,
> Jaroslav Kysela wrote:
>>
>> The use of strncpy() in the set_led_id() was incorrect.
>> The len variable should use 'min(sizeof(buf2) - 1, count)'
>> expression.
>>
>> Use strscpy() function to simplify things and handle the error gracefully.
>>
>> Reported-by: yang.yang29@zte.com.cn
>> BugLink: https://lore.kernel.org/alsa-devel/202301091945513559977@zte.com.cn/
> 
> Let's use the normal Link tag instead of BugLink.  The former is
> preferred.
> 
> Also, it'd be great if you can put the Fixes tag, too.

Done. Sent v3.

			Thanks,
				Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
