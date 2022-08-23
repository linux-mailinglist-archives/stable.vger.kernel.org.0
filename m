Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE659D199
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbiHWG7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 02:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbiHWG7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 02:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3372252A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 23:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A1E614D2
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 06:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E0FC433C1;
        Tue, 23 Aug 2022 06:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661237934;
        bh=aN4vmOVVGpyf/d6JMGr4bhHkhg7Ym1prcEAh/SEAVP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1igUBMPJal7JLNX0Ol1kRtCVsaK7RF12EUr4dKk9MBIdXGJvPy0AonV9zJsGcm5MA
         MiA2PyOWm8ZPbnmDdtis5PQ5hFH6gF07V2woVIUMAkF13iQ1VKQSdYi+QZeYXc8B9h
         KBIJK/nV2bwS9JqqI5NO+XKfm40QZXJri7s0hTFc=
Date:   Tue, 23 Aug 2022 08:58:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        tz.stoyanov@gmail.com, zanussi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing/eprobes: Fix reading of string
 fields" failed to apply to 5.15-stable tree
Message-ID: <YwR6q6fc87BcERdN@kroah.com>
References: <166115387728250@kroah.com>
 <20220822140650.20c9f5db@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822140650.20c9f5db@gandalf.local.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 02:06:50PM -0400, Steven Rostedt wrote:
> 
> This is the backport to 5.15.

Now queued up, thanks.

greg k-h
