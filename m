Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38B59D1A5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbiHWHBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiHWHBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:01:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99E61B19
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 00:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A3EBB8101C
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 07:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F182C433C1;
        Tue, 23 Aug 2022 07:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661238084;
        bh=h15JQJ7VQtB6YM1lu9xGHBUkjFoOe1f/1QTxk4GIlQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0tO1X7GzDTdoo2IxA6QUkgCdBnA8F1KlkoaY784rwdrrXGTR243lTeR1nGj70Z+9
         fiDzJAVf0pBSccxkUTwLhQVC9D8ZiNQROSEgZqR1vV0Vwx25+pXYvdZMg3+KOzX1UG
         J0nByTlFpbc+yUJ1TdTzCzQvoqod0jlXSLCLg0C8=
Date:   Tue, 23 Aug 2022 09:01:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        tz.stoyanov@gmail.com, zanussi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing/probes: Have kprobes and uprobes
 use $COMM too" failed to apply to 4.19-stable tree
Message-ID: <YwR7OnwVj2mAfsGH@kroah.com>
References: <16611533562143@kroah.com>
 <20220822123727.4345d71c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822123727.4345d71c@gandalf.local.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 12:37:27PM -0400, Steven Rostedt wrote:
> 
> This is the backport for 4.19.

All backports now queued up, thanks.

greg k-h
