Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BEB647112
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLHNy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiLHNy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:54:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DAB37F89
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 05:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF988B822EF
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 13:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA964C433D6;
        Thu,  8 Dec 2022 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670507665;
        bh=hScpJA7YLMI3aTHWwIGWewFbgeUHHRsF5Zuk7NojfEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iUIRvTtPUOywXbE1AxRwR9RrGV5BoqPNiTnAHzynNoQLKIaHlF1rupEW3jiuBV6fX
         Hes80ekQkbzxoNjIV7QG3wQm0umqjhB8aHLSYfbKjnttA6R+3j7RJU7WcPos6/0XTW
         MJdGUl//7nNG2L7iGKx6RGMO6mWf9/Q4gniQX72iY7FVyTQfiAkG7LVFCICO9bo4q8
         pqlwXHrdzK9OZIkqWTLTdi9kcZfRScFu8oOChRHYoeCdwgynvWTbnmx5PheDgUDDbR
         Vmh75GdG5pBKGopPRicndUwAXOlFPzkO3wzGD7tCpavE3FeX0sznWwfsQwWpo6G/k9
         6fevRhD0l2K4Q==
Date:   Thu, 8 Dec 2022 08:54:22 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     stable@vger.kernel.org, paulmck@kernel.org
Subject: Re: Please apply 8f15c682ac5a (rcutorture: Automatically create
 initrd directory) to 4.19
Message-ID: <Y5Hsjl6rU/zHMOtd@sashalap>
References: <Y5GLgvhNpGe1V/RI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y5GLgvhNpGe1V/RI@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 07:00:18AM +0000, Joel Fernandes wrote:
>Hello,
>
>Could you please apply 8f15c682ac5a ("rcutorture: Automatically create initrd
>directory") to 4.19 stable kernels. The patch made it in 5.0.

Queued up, thanks!

-- 
Thanks,
Sasha
