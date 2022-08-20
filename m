Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A72159AE5F
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346835AbiHTNJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 09:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346133AbiHTNJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 09:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266E38036A;
        Sat, 20 Aug 2022 06:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE4FDB80926;
        Sat, 20 Aug 2022 13:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FCDC433D6;
        Sat, 20 Aug 2022 13:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661000964;
        bh=sp99sUzgkILEPP/YDQXCRkcywL/uR9HD3jT759NLxtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nmPVQ//Rd9brf92XpKprO1qPa5jN8zOwfaeZzV1Btd2By9m39V3yAWQ3irv9+DeW8
         kfUtf820HZ+JeX0lNVngUdsh8XSyJAmzXPSiz08lQNWCDdI7Wl8SWFcWPXocKG7lgW
         xT+AnB/83LAYZAkP8JNfCDLkDnyVpDi1xkYvYfUTTcsanFfR+J53UmvbF37MqPVtLu
         3TLDCUecR39WUBE4wjHTOhkjDMYqL/b6wiQdp8y8TceF7c2oJFs3r/tLxE+P4ORQIb
         NVbJGeaegm4i+RQfEdf2pAKWvcfq/simzWI3fKKQKnl8e004Cx4K1d1hM8FC2nYVee
         ih1/k3BDhc3nA==
Date:   Sat, 20 Aug 2022 22:09:20 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing/eprobes: Do not hardcode $comm as a string
Message-Id: <20220820220920.e42fa32b70505b1904f0a0ad@kernel.org>
In-Reply-To: <20220820090038.591e3b32@gandalf.local.home>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.035925907@goodmis.org>
        <20220820201824.5637c4feff4a7674aebde60a@kernel.org>
        <20220820084837.4d6a95e4@gandalf.local.home>
        <20220820090038.591e3b32@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 20 Aug 2022 09:00:38 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 20 Aug 2022 08:48:37 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  I should probably make "$common_comm" used too.
> 
> 
> My mistake. It was "common_cpu" not "common_comm". The filter and histogram
> just use "comm" or "COMM". I'll leave this as it.

Yeah, this is a bit confusing me. histogram allows common_cpu but filter allows
only CPU. Shouldn't we unify those?

Thanks,

> 
> -- Steve
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
