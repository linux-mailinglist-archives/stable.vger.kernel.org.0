Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F55B56D1
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 10:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiILI50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 04:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiILI5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 04:57:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A57186EF;
        Mon, 12 Sep 2022 01:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE74761139;
        Mon, 12 Sep 2022 08:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DDFC433D7;
        Mon, 12 Sep 2022 08:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662973043;
        bh=21I2cvt+FSkNR1EKp9qxYNQQC+FLj7h0IWmzsnwMRtk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KpWPE2rbyU5uadmCrbC4U2k/b7CtiKMLG/11PSTkYBZB3ZbCZhJ/H2YeDCgWllszv
         uAWj4sWVhwGkDZcPdom7CKwU2EqD1uD89jMX34AHuP07OlFIn/9dghreizOQs7HvYl
         +LFJnQuhXNSmzb9v+YGxdCgVsl0OZgwLZ0hvyfmyXXxlPhv+bKfq8Di2F77ZXETBrb
         QRxEcX6Dz62Y9S0DbjNQnCyZCZrD54O+vm9zpBgu+Am0hGDqkaBBgvkRxt77J9wdHG
         z9H5JrxN/t8yZxfnLYzu9UiQhHnozICf9RaGXcE+rCpgLxkkZi98yWZb9ymB0SUE/J
         1EXGnsDmyakTQ==
Date:   Mon, 12 Sep 2022 04:57:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        srinivas.kandagatla@linaro.org, amahesh@qti.qualcomm.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 33/38] misc: fastrpc: increase maximum
 session count
Message-ID: <Yx70cb2fgbWtlqXN@sashalap>
References: <20220910211623.69825-1-sashal@kernel.org>
 <20220910211623.69825-33-sashal@kernel.org>
 <Yx2q6zgypevyXEto@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yx2q6zgypevyXEto@hovoldconsulting.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 11, 2022 at 11:31:23AM +0200, Johan Hovold wrote:
>On Sat, Sep 10, 2022 at 05:16:18PM -0400, Sasha Levin wrote:
>> From: Johan Hovold <johan+linaro@kernel.org>
>>
>> [ Upstream commit 689a2d9f9332a27b1379ef230396e944f949a72b ]
>>
>> The SC8280XP platform uses 14 sessions for the compute DSP so increment
>> the maximum session count.
>>
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> Link: https://lore.kernel.org/r/20220829080531.29681-4-johan+linaro@kernel.org
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>SC8280XP was not added until 6.0 so the stable tag was left out on
>purpose (as usual).
>
>Please drop.

Will do, thanks!

-- 
Thanks,
Sasha
