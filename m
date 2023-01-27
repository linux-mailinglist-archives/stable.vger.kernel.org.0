Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE867DC30
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjA0CKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 21:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbjA0CKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 21:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937BC1737
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 18:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FF36B81F6F
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9C7C433EF;
        Fri, 27 Jan 2023 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674785411;
        bh=e/JI6a5Meu+wMQ0KnN+CcVMio0tHGoMiAeWyaWS+pYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9wdp7jDXsINxtJdnG0jnsRW1FqkaclWl8ZvKrKg31VLzbPI2NYldFycK9XEx0lk+
         ypTUSgMAnpgPQzCo7Vz3tcN67XXKDc6VqB+BuTv56ppusXK2/wM7xOROwAgLmTqPAH
         U4NbjLWj3nq07sDGKpOJ6ldztEY8o4F/wxSTfliPObRzZ9ieGtjUkkpixCX6AmcPWg
         XZ5LM9kaY2dP763wDgL39m5Gyd0u9kEgpQ5o12cJUQSnnzs2hbBpBmaQM0S7otz9Ir
         U/qGIbbmQUuLf5x+tHjMJ0ITzWUxpGPTh4/8Qv6TOGFvu8dYnxsNMkiWxmsLOU4+FA
         VmphAAxMe4TBg==
Date:   Thu, 26 Jan 2023 21:10:09 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org
Subject: Re: v6.1 stable backport request
Message-ID: <Y9MygXR2Z112ttJ2@sashalap>
References: <878rhs6ij9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <878rhs6ij9.fsf@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 05:47:54PM +0200, Jani Nikula wrote:
>
>Stable team, please backport these two commits to v6.1:
>
>2bd0db4b3f0b ("drm/i915: Allow panel fixed modes to have differing sync polarities")
>55cfeecc2197 ("drm/i915: Allow alternate fixed modes always for eDP")
>
>Reference for posterity: https://gitlab.freedesktop.org/drm/intel/-/issues/7841

Queued up, thanks!

-- 
Thanks,
Sasha
