Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268A367A634
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 23:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjAXW5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 17:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjAXW5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 17:57:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2143B4390A
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 14:57:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B30D061383
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 22:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5E5C433EF;
        Tue, 24 Jan 2023 22:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674601053;
        bh=qEfW8SFsR5VpsdW/mo/3jp5lIkgbjWAtoMje6YRcmcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nViP+VUhWhYmYsbZaWf/zSzuYdyuJUgD5fx90VhFwJGi536h1XJEIU4QitWtn76mU
         zfcYcvsrhTH/lsLlboY6sHvdvxoeBEGa8Gz+jfVvqAu6fovo+l7/cU3gORNjKLj9OP
         9vvlmZKt99I8HBuAp1HuTPVty/6trKMmfGqgD4fSjNuylXdZTR3Fgx6xTuVrC+Cuy2
         Js4r4EXf8NlCPAw4XQ85qSWdyl9Ak2Hq0630oYkG+4DQLaRR0QTsyhReDJTchSf6i+
         0r/UJVpZQJU2O7MLbFQxX5ZHH5eGXbhZ9vK2tXvKAYbBBSps1WVYlRZwc8raFxIpqM
         rHxVoWAqUlG+Q==
Date:   Tue, 24 Jan 2023 17:57:31 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Nobel Barakat <nobelbarakat@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: 5.10 and 5.4 Backport Request: netfilter: conntrack: do not
 renew entry stuck in tcp SYN_SENT state
Message-ID: <Y9BiW426+wM0FmZw@sashalap>
References: <CANZXNgMiuk=YwZCFO_u-L+20qKZT2xCGWfO7onou4XT+xQNUsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANZXNgMiuk=YwZCFO_u-L+20qKZT2xCGWfO7onou4XT+xQNUsA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 11:01:47AM -0800, Nobel Barakat wrote:
>PATCH_SUBJECT: netfilter: conntrack: do not renew entry stuck in tcp
>SYN_SENT state
>PATCH_COMMIT:  e15d4cdf27cb0c1e977270270b2cea12e0955edd
>
>Reason for backport request:
>
>We've had a few customers experience issues with dnat such that their
>kubernetes processes are now unreachable. Because dnat rules fail to
>update, kubernetes pod IPs won't resolve and traffic gets blackholed
>causing any healthcheck service to kill and restart the pod. This
>commit has been verified to fix the issue and the ask here is to
>backport it to kernel versions v5.4 and v5.10.

Queued up, thanks for the report!

-- 
Thanks,
Sasha
