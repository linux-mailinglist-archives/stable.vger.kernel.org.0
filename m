Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27C5650B65
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiLSMY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiLSMY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:24:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04749DEC1;
        Mon, 19 Dec 2022 04:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A679DB80DE4;
        Mon, 19 Dec 2022 12:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C98C433EF;
        Mon, 19 Dec 2022 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671452664;
        bh=dk34mIwMnjmOYJz/bupoxQ5Y5lvZMXF9wAcZW7E5mEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YOkFHXwIFG3zUM9rPJX31J5pCbzfDMh6jXQ1Q/V0AtAeCt3va+sOpAMWhwwcIvn8O
         b+x6qoUrV4j4V6wNO/altXY0PZc6TP5K+2WWTmyaP1BjxaUl1RLOZfCMA/F7Nw5ysX
         4iBpkDZA6Faa6KjCkOLumSeED+0W+S6imzA0K/Xk=
Date:   Mon, 19 Dec 2022 13:24:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>
Subject: Re: [PATCH stable 6.0 0/8] bpf: Fix kprobe_multi link attachment to
 kernel modules
Message-ID: <Y6BX5Jna0XhjeD1P@kroah.com>
References: <20221216125628.1622505-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216125628.1622505-1-jolsa@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 01:56:20PM +0100, Jiri Olsa wrote:
> hi,
> sending fixes for attaching bpf kprobe_multi link to kernel
> modules for stable 6.0. It all applies cleanly. 

All now queued up, thanks.

greg k-h
