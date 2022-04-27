Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8B511374
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 10:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351635AbiD0Iaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 04:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359384AbiD0Iae (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 04:30:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BE54B1EF
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:27:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BD75B210E3;
        Wed, 27 Apr 2022 08:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651048042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S0UQlbgjXNDJ7EvM8tqpA7N344uhd9adHDYGVtsKvr8=;
        b=LwfPZ6LdFgNfmToFQcVUXYouAeA5k5IxGY0DHvMgC6Q0NrT3zlLZnEHYJu+DgZIOEWhoAd
        BmF3+uRiIwQYPFDBq6GMoX0idxqENssGrW5vSyh9cWUgTCj/PRyADVsMqBIA9wSkUCDBwF
        OH7Kf3zxk/eSYIp7lBauJRXGh2eeSrQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651048042;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S0UQlbgjXNDJ7EvM8tqpA7N344uhd9adHDYGVtsKvr8=;
        b=hCz21ytEVKDasEIRq2QbWey8IKossUzxcNtizuTJLW5cyx6JpaomijYxYT6xE2TyEYEvkG
        8oTyd0NYwNQZLiDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E82A1323E;
        Wed, 27 Apr 2022 08:27:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Dsj6IGr+aGI9RAAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 27 Apr 2022 08:27:22 +0000
Date:   Wed, 27 Apr 2022 10:27:21 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        thomas.lendacky@amd.com
Subject: Re: FAILED: patch "[PATCH] x86/sev: Unroll string mmio with" failed
 to apply to 5.16-stable tree
Message-ID: <Ymj+abCIaXcMKQtX@suse.de>
References: <1649058222102139@kroah.com>
 <Ykx8XWViJCKf3nGQ@zn.tnic>
 <Yk0yBIMXQ5OCf6M1@kroah.com>
 <Yk103F0EzAU2GkEd@zn.tnic>
 <Yl1S//YPDMMzyepO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yl1S//YPDMMzyepO@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 02:01:03PM +0200, Greg KH wrote:
> So can you, or anyone else that cares, provide a set of backported
> patches for this issue that we can apply to the stable trees?

Yes, I will provide backports for older stable kernels. It is on my todo
list for next week :)

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

