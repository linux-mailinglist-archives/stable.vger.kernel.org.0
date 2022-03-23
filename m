Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC0E4E55EF
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 17:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245367AbiCWQHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 12:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbiCWQHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 12:07:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AC57C791
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:06:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1BCA3210E6;
        Wed, 23 Mar 2022 16:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648051569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q6uoIDd20Xdiz6EGvjlqlGVWs969cO/WsoeHOvcWNns=;
        b=bhAXvqLWhHOsbQ2WPYYr3UkzPS+Wmyeky6+4+WR3SK4jpCzQNv2nSfFWjlS0aEnwGCz7cE
        PiCWDCJfycL2xvLz2Iti3cbpcSoKkRNrFjOmmRez90pkIh4lYZEzWFjG0MHxB6HBpOIAjD
        6dH9esA1kePr1rvewldaYSHEwMgs6B8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA94312FC5;
        Wed, 23 Mar 2022 16:06:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /+gBOHBFO2KsfAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 23 Mar 2022 16:06:08 +0000
Date:   Wed, 23 Mar 2022 17:06:07 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     masami.ichikawa@cybertrust.co.jp, tj@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cgroup-v1: Correct privileges check in
 release_agent writes" failed to apply to 5.10-stable tree
Message-ID: <20220323160607.GA2828@blackbody.suse.cz>
References: <1645639632780@kroah.com>
 <20220323124932.GA27232@blackbody.suse.cz>
 <YjseqrSJQd9412So@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjseqrSJQd9412So@kroah.com>
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

On Wed, Mar 23, 2022 at 02:20:42PM +0100, Greg KH <gregkh@linuxfoundation.org> wrote:
> Sorry, yes, it applies, but it breaks the build.  Try typing 'make' now :)

Ah, you're right. There're the prerequisites from the other series. I've
sent a group of patches for v5.10 to accomodate for "cgroup-v1: Correct
privileges check in release_agent writes" (based on the original
patches, I've not tested those).

HTH,
Michal
