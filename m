Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC1C4EDF4A
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 19:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbiCaRBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiCaRBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:01:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3819B58812;
        Thu, 31 Mar 2022 09:59:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4E1061671;
        Thu, 31 Mar 2022 16:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA7EC340ED;
        Thu, 31 Mar 2022 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648745997;
        bh=3Lxk2SqXdNDNt8zS+/WdEpo8t64Mjrw+i7gcdbSgCPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFYEepWNblLhO6r+X6AUc424pdogl5JoMA2gMuUcl8+1Yi1GKTJPE+7GFFhezPuYl
         JznySsebkHi/iU4Lxbe9MmmEvs59xnmMvu8m6sc8/ahEqR4IcZ+Uox89L+terIQPg2
         WjaFgN0N8u3tJjUSR/lfLJ3GtZpQ05YnJ9V9Iv56s1IZTXpYf06Ir7gqZqKxkN7JKD
         XHEelOSSUQrzNMSIimO6WUsc7bsgi3voV7/iqPLwmcuvqPAQqWmZV1R3fpPIC5VHO/
         cmFlnDtEK9EY/h6m1Z2sNoVePRxrDCqLNQD9IANQD6d240bCin+asz4SS/gVvgOVl4
         ZGMzTPqqCpkwA==
Date:   Thu, 31 Mar 2022 12:59:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, luto@kernel.org, frederic@kernel.org,
        mark.rutland@arm.com, valentin.schneider@arm.com,
        keescook@chromium.org, elver@google.com, legion@kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 29/43] signal, x86: Delay calling signals in
 atomic on RT enabled kernels
Message-ID: <YkXeC3LUeWkQmwWs@sashalap>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-29-sashal@kernel.org>
 <87r16mw3l4.fsf@email.froward.int.ebiederm.org>
 <YkHjtMX9s/bA83OT@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkHjtMX9s/bA83OT@linutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 06:35:00PM +0200, Sebastian Andrzej Siewior wrote:
>On 2022-03-28 09:31:51 [-0500], Eric W. Biederman wrote:
>>
>> Thank you for cc'ing me.  You probably want to hold off on back-porting
>> this patch.  The appropriate fix requires some more conversation.
>>
>> At a mininum this patch should not be using TIF_NOTIFY_RESUME.
>
>Sasha,
>
>could you please drop this patch from the stable backports (5.15, 5.16, 5.17).

Will do, thanks.

-- 
Thanks,
Sasha
