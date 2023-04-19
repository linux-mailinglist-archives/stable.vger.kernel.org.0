Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C606E7C1F
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 16:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDSOQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 10:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjDSOP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 10:15:56 -0400
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E3616F9B
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 07:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PwVq/qutJNHYdGyaN2pFZpUUGRnNT+OajhbfjI6fupE=; b=JZD7OMRk62qwBM4VOvDjO+3RlN
        dG32QY6u50xWg5HL9O92ZtTSv6IT4OlHw4RzHMTJVoKaZunJBk9GCl1WpgpaRA2TDSPYxcmOJvksL
        uXUVppUWH/2L6E20giQPjgswCASUstOeXEYYsXTMJ2uxM8oNsxc2AKPfFCGCF7ifP+LuBHo7n0DGw
        TgFDevFu2JzhUZNhrPqdiFrx33XouA8GZT3aoDe0/Yl0l88lUP8+99pJK79jzTC10aGJEWPdKMc2Z
        qmgBjnEfez4MixEvwVXcaPAvH/VxEp7XZd9sy4pouieeCfsXeDF0S+U3ghHWoscV3zH0hDpNMP02+
        8GT0xFvA==;
Received: from 201-92-79-199.dsl.telesp.net.br ([201.92.79.199] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1pp8aN-005PWp-TI; Wed, 19 Apr 2023 16:15:04 +0200
Message-ID: <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
Date:   Wed, 19 Apr 2023 11:14:58 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Content-Language: en-US
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
 <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/04/2023 10:16, Deucher, Alexander wrote:
> [...]
>> This is quite strange for me, we have 2 commit hashes pointing to the
>> *same* commit, and each one is present..in a different release !!?!
>> Since I've marked this patch as fixing 82132ecc5432 originally, 6.1.y stable
>> misses it, since it only contains 9a8cc8cabc1e (which is the same patch!).
>>
>> Alex, do you have an idea why sometimes commits from the AMD tree
>> appear duplicate in mainline? Specially in different releases, this could cause
>> some confusion I guess.
> 
> This is pretty common in the drm.  The problem is there is not a good way to get bug fixes into both -next and -fixes without constant back merges.  So the patches end up in -next and if they are important for stable, they go to -fixes too.  We don't want -next to be broken, but we can't wait until the next kernel cycle to get the bug fixes into the current kernel and stable.  I don't know of a good way to make this smoother.
> 
> Alex

Thanks Alex, seems quite complicated indeed.

So, let me check if I understood properly: there are 2 trees (-fixes and
-next), and the problem is that their merge onto mainline happens apart
and there are kind of duplicate commits, that were first merged on
-fixes, then "re-merged" on -next, right?

Would be possible to clean the -next tree right before the merge, using
some script to find commits there that are going to be merged but are
already present? Then you'd have a -next-to-merge tree that is clean and
doesn't present dups, avoiding this.

Disclaimer: I'm not a maintainer, maybe there are smart ways of doing
that or perhaps my suggestion is silly and unfeasible heh
But seems likely that other maintainers face this problem as well and
came up with some solution - avoiding the dups would be a good thing,
IMO, if possible.

Cheers,


Guilherme


