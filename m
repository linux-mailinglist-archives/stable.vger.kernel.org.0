Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76095FFFA0
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJPN2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJPN20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:28:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4C73F1E9;
        Sun, 16 Oct 2022 06:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A7AFB80CC0;
        Sun, 16 Oct 2022 13:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB0FC433C1;
        Sun, 16 Oct 2022 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665926879;
        bh=BLlob7SHUpruAi1BQqz6CpLZq1PD5IlI3db/6R/GyA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bs+Pd/2sF2NT7mDeDPfBSJcubgRHNDQXi7Zjaff8kj5CXlzW4lZEaOb9FHxgLdMtn
         r7IZkeV7EGjNafUVhogKlNtM+YnnWaWIIfJ9V75ABHe94uXqjt29iNlJsr/S/VAM93
         MkpdwR611t6j4EzJvPDmGdpLLuqJcjiOe0DNhPDyGOiIu5U6X8KUfGxnRB/tgYca8q
         Khjp6Bh6wO49OKDzzToYWmLzcT3+7mJJNgS5/PTZrLNZVXeLA+FYK8WCG6xIna9aXt
         vXSPt50v4+HS+Qf5VhYK7AuwQSVuWWWEZfd9sotgoiYduaFVMNw5Mqs2V7jVigw1s+
         dnhpBrgCeGgjQ==
Date:   Sun, 16 Oct 2022 09:27:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.15 34/47] tty: n_gsm: replace use of
 gsm_read_ea() with gsm_read_ea_val()
Message-ID: <Y0wG3VNU/Fw40OLn@sashalap>
References: <20221013002124.1894077-1-sashal@kernel.org>
 <20221013002124.1894077-34-sashal@kernel.org>
 <df8b824a-5479-0593-4f87-7ac8317584fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <df8b824a-5479-0593-4f87-7ac8317584fa@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 08:21:37AM +0200, Jiri Slaby wrote:
>On 13. 10. 22, 2:21, Sasha Levin wrote:
>>From: Daniel Starke <daniel.starke@siemens.com>
>>
>>[ Upstream commit 669609cea1d294f43efdd8d57ab65927df90e6df ]
>>
>>Replace the use of gsm_read_ea() with gsm_read_ea_val() where applicable to
>>improve code readability and avoid errors like in the past. See first link
>>below for reference.
>
>I don't think this warrants for stable. It's only a cleanup, not a 
>fix. And it's quite intrusive.

I'll drop it, thanks!

-- 
Thanks,
Sasha
