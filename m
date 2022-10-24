Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FBC60BD7E
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiJXWfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiJXWez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E42639C;
        Mon, 24 Oct 2022 13:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3987B80EE6;
        Mon, 24 Oct 2022 20:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2635CC433D6;
        Mon, 24 Oct 2022 20:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666644918;
        bh=RWfZq76bLUqotXvQc5HEgnCzF0wr9PgH34Km4oTHX/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kUovkUWW6eyht23YSZg79tA07RjZ/xitXa1op+hJPEZjIsaiZD9E1TmtRG1amr5/0
         6RF2OruMIlDda5pIxLC/hxP2yPNPkeQicdaa8G3jL7LFaIu8STDNWN5ePDvVoTQoSE
         gMAyJW3bAmMR7nXCxHAaeXinA2lWMSQ3GYsL1Wcw=
Date:   Mon, 24 Oct 2022 13:55:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jeff Layton <jlayton@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: prevent file time rollover after year 2038
Message-Id: <20221024135517.7d40b96a206020eca03e3802@linux-foundation.org>
In-Reply-To: <20221024145121.2dj6sdeqvxndbhpt@quack3>
References: <20221020160037.4002270-1-arnd@kernel.org>
        <20221024122614.bkcehqr7gi3f23ca@quack3>
        <20221024145121.2dj6sdeqvxndbhpt@quack3>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 16:51:21 +0200 Jan Kara <jack@suse.cz> wrote:

> > Thanks! I've added the patch to my tree and will push it to Linus.
> 
> Oh, I have noticed Andrew has merged the patch already into his tree. So
> dropped from mine.

You could have just added it and I'd drop my copy when Stephen tells
us of the duplicate.  But whatever.

Maybe you owe us an ISOFS MAINTAINERS entry ;)
