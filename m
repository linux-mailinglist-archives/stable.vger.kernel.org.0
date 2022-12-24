Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCCA6556BF
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 01:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiLXAfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 19:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiLXAfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 19:35:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87F21B9D3;
        Fri, 23 Dec 2022 16:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F56EB821B4;
        Sat, 24 Dec 2022 00:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D04C433EF;
        Sat, 24 Dec 2022 00:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671842126;
        bh=LLpp2PZGZ3P0jsNiT1jPH0C8VaOxHKoP9r3oMSLo0UI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jSbHXPTiElo1NJ6miNJKdAE8sMAVnHpWLd4GYXOeyP5OpxT0c9oTR0lS16/W2czmd
         zmZo8NfSvM8hcBWVWa+rglOsD+2QwrQ3yrtCeOQ3+aChhjfqj4b1kH3/UVA37zLfUV
         SUTA++yRFAc9yYQsi9jQ6DqpnpbrFV0BXqSjH9vAJ2+r4TjncZLZg23UiKXQWnoxKs
         mcdYg9MLfz7U5L7z6Jt3vu//BXWS4qlN7IvIgBdWz8Q9q+i0Yy9tInKed8Qjtu/me7
         EAuPLXWx4Q8QkE7uAoPziijjcLEOEtF9MDPijOd5R79hOeNIFj6x0I+l2WvxpkrbEe
         n5rlHZWvgoyDA==
Date:   Fri, 23 Dec 2022 19:35:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     ChiYuan Huang <u0084500@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>, djrscally@gmail.com,
        hdegoede@redhat.com, markgross@kernel.org, lgirdwood@gmail.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        platform-driver-x86@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.0 70/73] regulator: core: Use different devices
 for resource allocation and DT lookup
Message-ID: <Y6ZJTXFod+4agKiR@sashalap>
References: <20221218160741.927862-1-sashal@kernel.org>
 <20221218160741.927862-70-sashal@kernel.org>
 <20221219010656.GA6977@cyhuang-hp-elitebook-840-g3.rt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221219010656.GA6977@cyhuang-hp-elitebook-840-g3.rt>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 09:07:01AM +0800, ChiYuan Huang wrote:
>On Sun, Dec 18, 2022 at 11:07:38AM -0500, Sasha Levin wrote:
>Hi,
>  Thanks, but there's one more case not considered.
>  It may cause a unexpected regulator shutdown by regulator core.
>
>  Here's the discussion link that reported from Marek Szyprowski.
>  https://lore.kernel.org/lkml/dd329b51-f11a-2af6-9549-c8a014fd5a71@samsung.com/
>
>  I have post a patch to fix it.
>  You may need to cherry-pick the below patch also.
>  0debed5b117d ("regulator: core: Fix resolve supply lookup issue")

I'll take it too, thanks!

-- 
Thanks,
Sasha
