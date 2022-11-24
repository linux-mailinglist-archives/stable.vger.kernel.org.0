Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB81D637DC4
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 17:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiKXQx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 11:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiKXQxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 11:53:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADC95E3F1;
        Thu, 24 Nov 2022 08:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77BC06207E;
        Thu, 24 Nov 2022 16:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B17C433D7;
        Thu, 24 Nov 2022 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669308801;
        bh=g6NeFvud15/0+OnV0ttnB60XtdbfBvv24IwjA9WOb+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZtEMOF6k29YIgkvZov74KQaz1V0y9zEL5wfYu12HK0ipae6IJ1Rx1ysz0Ercpd6Ot
         09TmEEx62crnottaJx/UknPvQ5Jk7Dkq3GNJh5/PZZNo+QLGCu2WfIziiqf5fuPZns
         QPwP5yew0i8W+GRkfPCU8+MIbIwi68GdZOlbpndH1mfObfrBTNw0CS7hU105yfvgOW
         wEUt3EnnR3MmkD+hlK6PK6/tzC8pEna6w0KoMcXZxMsb9Di93+qRHunyBnKRTTHhnf
         FfC7SHv348El1IomIhz2aphWhkOtBWwr+FSRNMFlf2hJHXKkGLDxpSSoYUltNOKBKp
         oH7oD8GU+OycQ==
Date:   Thu, 24 Nov 2022 11:53:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Dadap <ddadap@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Iris <pawel.js@protonmail.com>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 13/27] ACPI: video: Add backlight=native DMI
 quirk for Dell G15 5515
Message-ID: <Y3+hgHCRcX4KQC4f@sashalap>
References: <20221119021352.1774592-1-sashal@kernel.org>
 <20221119021352.1774592-13-sashal@kernel.org>
 <Y3jYFP3lBrbHAUO7@lenny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y3jYFP3lBrbHAUO7@lenny>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 19, 2022 at 07:20:20AM -0600, Daniel Dadap wrote:
>NACK for 5.15 (and earlier) - the nvidia-wmi-ec-backlight driver is not
>present in the older LTS branches.
>
>I suppose this patch could be useful for distro kernels which have
>backported that driver, but I'm not sure if it's then supposed to be the
>distro's responsibility to also backport quirks that affect other code
>they have backported. If the intention is to relieve distros of that
>responsibility, I suppose this is harmless enough.

I'll drop it on 5.15 and earlier, thanks!

-- 
Thanks,
Sasha
