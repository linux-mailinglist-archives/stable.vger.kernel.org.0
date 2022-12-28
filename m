Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB229658624
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 19:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiL1S72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 13:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiL1S71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 13:59:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AB617074
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 10:59:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 053B220D0D;
        Wed, 28 Dec 2022 18:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1672253965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kCrn5en4tFPBX3fjyg9XafMGXrY58F+PiUL7QmORXPk=;
        b=lT8DnzUBpClIC/Mw58gbswyxYd+nnCKzOSK+qxkBJSkWLo363lwNU24eBE2Zp0DFdsSAvq
        lZKdyIDLhiZFIsda9QOB2Y+aJXru0SvSbacAYRupQ0SwN+ZHfhr3lfKjcel1bZ/m0c1DWo
        th5Lc2nhEX33u+Ga0NrZcqPWjb2bXBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1672253965;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kCrn5en4tFPBX3fjyg9XafMGXrY58F+PiUL7QmORXPk=;
        b=Id7ci9zhMu9mafPatBKEQ02vjRKknttqbSX0BMUpT/MR4+p1R2h4adSNoFG/DmroSUPyKY
        yFAarFUHc2/rljAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDE2B138F9;
        Wed, 28 Dec 2022 18:59:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bAlWNQySrGPlJgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 28 Dec 2022 18:59:24 +0000
Message-ID: <d5534922-0b33-268d-cfad-c175ff4f676e@suse.cz>
Date:   Wed, 28 Dec 2022 19:57:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
References: <20221228144330.180012208@linuxfoundation.org>
 <2bf086f8-aa9d-b576-ba8b-1fcfbc9a4ff1@applied-asynchrony.com>
 <Y6xkpmqxRQwDyLAb@kroah.com>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y6xkpmqxRQwDyLAb@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/22 16:45, Greg Kroah-Hartman wrote:
> On Wed, Dec 28, 2022 at 04:02:57PM +0100, Holger Hoffstätte wrote:
>> On 2022-12-28 15:25, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.2 release.
>>> There are 1146 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> I know this is already a large set of updates, but it would be great if
>> commit 6f12be792fde994ed934168f93c2a0d2a0cf0bc5 ("mm, mremap: fix mremap()
>> expanding vma with addr inside vma") could be added as well; it applies and
>> works fine on top of 6.1.1.
>> This fixes quite a few annoying mmap-related out-of-memory failures.
> 
> It's set up for future releases.  If this was such a big issue for
> 6.1-final, why wasn't it sent to Linus before 6.2-rc1?

Thorsten did question its upstreaming speed elsewhere. But it actually
is in 6.2-rc1. Andrew sent the PR on 22th and Linus merged on 23th [1].
I didn't try to accelerate it to stable as IIRC people already pointed
it out and you acknowledged it's on your radar, and it was a tracked
regression. Sucks that it didn't make it to 6.1.2.

[1]
https://lore.kernel.org/all/20221222144648.db034ee4087ea4bb126545ec@linux-foundation.org/

> thanks,
> 
> greg k-h
> 

