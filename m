Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFC25AE998
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbiIFNa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiIFNa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8981CFC8;
        Tue,  6 Sep 2022 06:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC03EB818AB;
        Tue,  6 Sep 2022 13:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ECCC433D6;
        Tue,  6 Sep 2022 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662471024;
        bh=7eEgVDMZLNR6G6VmStcoVsh/iJpTFk3ehYtScCsCrw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dWM5YXUgbT/tz1+8OoHbqf8MKVdUfCY14PnTMEBRppTxbA42tCSYjop3KvsL7772x
         nF5RdfTGIu965Z/sD67khkRIM05O7zpoR3sQZ2AMrAdYz6fmqC7QHLXApqY2G17dvn
         S6RrXVuCstRxSPLBEKks+a6pg3tU0v32x1L3ECm81GL+lf6ySbYXCtImjYXbY0XiKV
         ZYKVti1/aHnsvf1UcvbKEhHqD4yZtQWoHPIG/IG/IbtV7taNe/sEup87qGTa1Ir0FI
         GNfS6ngEJJb5MhZ/nctIEGCl/rNqG8G0T5KdzTfOQ3vWU53b2Owy1qqXx09NvSC88b
         1DBLqkDcH+H5Q==
Date:   Tue, 6 Sep 2022 09:30:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: Re: Patch "clk: bcm: rpi: Use correct order for the parameters of
 devm_kcalloc()" has been added to the 5.15-stable tree
Message-ID: <YxdLb8XNCPriT9W9@sashalap>
References: <20220906032831.1115256-1-sashal@kernel.org>
 <11d7fc32-000f-68a2-99a0-68b0cb3bc4a0@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11d7fc32-000f-68a2-99a0-68b0cb3bc4a0@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 07:01:16AM +0200, Marion & Christophe JAILLET wrote:
>
>Le 06/09/2022 à 05:28, Sasha Levin a écrit :
>>This is a note to let you know that I've just added the patch titled
>>
>>     clk: bcm: rpi: Use correct order for the parameters of devm_kcalloc()
>>
>>to the 5.15-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>>The filename of the patch is:
>>      clk-bcm-rpi-use-correct-order-for-the-parameters-of-.patch
>>and it can be found in the queue-5.15 subdirectory.
>>
>>If you, or anyone else, feels it should not be added to the stable tree,
>>please let <stable@vger.kernel.org> know about it.
>
>Hi,
>
>I'm not sure that such a patch deserve a backport.
>
>It is correct, but it is just a clean-up that will be a no-op at runtime.
>Should it help future potential backport, why not, but otherwise, 
>IMHO, it could be dropped.
>
>It is also in the 5.10 backport queue.

You're very much correct, it's only there for the benefit of
bc163555603e ("clk: bcm: rpi: Prevent out-of-bounds access") which
follows it :)

-- 
Thanks,
Sasha
