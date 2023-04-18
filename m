Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053AC6E5FB0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 13:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDRLTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 07:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjDRLTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 07:19:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3880A246
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 04:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15A9463025
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 11:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46211C433EF;
        Tue, 18 Apr 2023 11:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681816704;
        bh=OmqhRwY3UFjrvnRWpZnDDlEDbd8B1Ds5PWqXOFp4xbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SPplbBXke9NyoXNn7kL1THWYqjeYiEIEg/O5oNTKrIsyZzYv9NZE/b2qW2qhrfQl+
         21FNE98wcyEKbyG7mssB3CN7Q0f1+vee8s8baxBYeyY05Rq62IhYCX2LvS8CZ1JYLS
         mS1gCCUSKC/DPf38T/KOBho9qCcrbTtkbKQyYh+vMaNdKP8WNueqohRlUIXKC8D7BD
         0co/kNW5z6x9I+NCWJBXeRzGRamIf0VHdQ5euQVJg7cV7Bvqfq3mmYcLJJ13TFbJgY
         uHaiiscuWSKq0OU0+TVbLg3/B7KVrU1igBCluyr5qSPtG7e/EAgW39TQHijKw/+6uq
         svJmCw9dCRQvw==
Date:   Tue, 18 Apr 2023 07:18:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: Patch "purgatory: fix disabling debug info" has been added to
 the 5.15-stable tree
Message-ID: <ZD58fs/+C8q075KS@sashalap>
References: <20230418012722.330253-1-sashal@kernel.org>
 <20230418103951.2b7kia6nb2zdeqje@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230418103951.2b7kia6nb2zdeqje@x220>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 10:39:51AM +0000, Alyssa Ross wrote:
>On Mon, Apr 17, 2023 at 09:27:22PM -0400, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     purgatory: fix disabling debug info
>>
>> to the 5.15-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      purgatory-fix-disabling-debug-info.patch
>> and it can be found in the queue-5.15 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>There's no need for this patch on 5.15, as the regression it fixes was
>only introduced in 6.0.  It won't do any harm though — is it considered
>good practice to keep the code in sync between stable kernels to make
>backports of other patches easier?  If so, it would make sense to
>backport after all.

It went into 5.15 because the patch in question says:

>>     Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")

In the 5.15 tree, we have 0ee2f0567a56 ("Makefile.debug: re-enable debug
info for .S files") and so I've also added this patch into 5.15.

-- 
Thanks,
Sasha
