Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6B4E527A
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 13:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbiCWMvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 08:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbiCWMvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 08:51:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C9F78934
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 05:49:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 42940210E9;
        Wed, 23 Mar 2022 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648039774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T8uwGreJ5rpCwyCqmqHsNtnNBq1OLQ/YsPQ42WiJNIw=;
        b=aZ/8NADblAQFtaZcbknfIU+wFOYtTuwJdac/L2E3XcrqUzS82/HpKm1hSj99tQyE34oIns
        BLEGVGVMhTh5NJfDSN8cWDDQgbdh8S4Nzaxb+eQ4dtZLjKVoUHI9sl0nIr+BqbmRNXJdAJ
        iDhe4VJ/bYnTKZNFLmCJE/nqIQkqoeU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E652132BA;
        Wed, 23 Mar 2022 12:49:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id T+8yBl4XO2KcFgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 23 Mar 2022 12:49:34 +0000
Date:   Wed, 23 Mar 2022 13:49:32 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     gregkh@linuxfoundation.org
Cc:     masami.ichikawa@cybertrust.co.jp, tj@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cgroup-v1: Correct privileges check in
 release_agent writes" failed to apply to 5.10-stable tree
Message-ID: <20220323124932.GA27232@blackbody.suse.cz>
References: <1645639632780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1645639632780@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On Wed, Feb 23, 2022 at 07:07:12PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.10-stable tree.

What do you mean does not apply?

> HEAD is now at 9940314ebfc6 Linux 5.10.108
> $ git format-patch -o /tmp/ 467a726b754f474936980da793b4ff2ec3e382a7 -1
> /tmp/0001-cgroup-v1-Correct-privileges-check-in-release_agent-.patch
> $ git am /tmp/0001-cgroup-v1-Correct-privileges-check-in-release_agent-.patch
> Applying: cgroup-v1: Correct privileges check in release_agent writes
> $

Thanks,
Michal
