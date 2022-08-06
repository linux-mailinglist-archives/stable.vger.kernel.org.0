Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3AF58B610
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 16:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiHFOYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 10:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiHFOYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 10:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F2912609;
        Sat,  6 Aug 2022 07:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1099261058;
        Sat,  6 Aug 2022 14:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4671EC433D6;
        Sat,  6 Aug 2022 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659795879;
        bh=BFbPwwKn7jJpZYRVtHC7w5Hhe/UhTItT3pE+vqWA25Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fl035q6bzqpJ7mBg5IjhuOpFf/GOS2QvcxMx92Ex3orRX7ELIa83oTSgwK9uo0D6F
         4gpli9O+zLwuuhhiRjrF6t2NHmda9+h3dPPQZ52I94ntrDpXuuxXTf+buYJIzQ1VI4
         /bveeUZhQrwUuB3FtV80nBSL1oSv9ZbfFdikC/x+NKqo/c/Q9HIrHCowmzJ5RAgGJW
         cCSgr25JdjfF0AKaGqANYjhJKdMoY84BkbZOk4jCMvgvU9bEJ9nC58eIXGSwk8t1gN
         /BLunE5LBx9NbynTwxYblmKW7M246Ciz44VgnUHgYmOHmFl5s476d/B8VnNQUlbmy8
         Lx9J/oPeSQH0Q==
Date:   Sat, 6 Aug 2022 10:24:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jann Horn <jannh@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.18 1/6] KVM: x86: do not report a vCPU as
 preempted outside instruction boundaries
Message-ID: <Yu55ptmZrehGHKTl@sashalap>
References: <20220614021116.1101331-1-sashal@kernel.org>
 <YrI25yOy7WMqr+x3@sashalap>
 <e7468f00-5d1a-5d9d-ae14-060cdf0f9558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e7468f00-5d1a-5d9d-ae14-060cdf0f9558@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 03, 2022 at 06:50:25PM +0200, Paolo Bonzini wrote:
>On 6/21/22 23:23, Sasha Levin wrote:
>>Paolo, ping?
>
>Sorry I missed the whole bunch of MANUALSEL patches.
>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>
>for all six.

Thanks Paolo! I'll queue up these and the missing ones as pointed out by
Jann.

-- 
Thanks,
Sasha
