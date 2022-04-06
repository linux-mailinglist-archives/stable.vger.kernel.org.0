Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32344F6215
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiDFOnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 10:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiDFOnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 10:43:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36037536B3B
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 04:09:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1788E1F7AD;
        Wed,  6 Apr 2022 11:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649243358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+k0eFsLPvMaUdTby9N2/MotzYE4sjk1QE3y/1B/rZQ=;
        b=2DLLgf9WkAgTh7zuoS1aUetZeU3F4xMk7OZxwkDcECamY2l1RUvfYG+Vy5CQTt8niJRqLI
        /UFGUdscRmZAx0pFGq+dyO7p/9h5kIgHWYobTD709qMgxwM2DizPgFDDmbGYFIEm+YJK+p
        MWvnQXp1yPDSQbCVBPV+SPN4fHO8Ao8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649243358;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+k0eFsLPvMaUdTby9N2/MotzYE4sjk1QE3y/1B/rZQ=;
        b=0yR0DzXkuacPSpLeKoxZ8RDXaYZKwxcSZfOnOuYAQRxNkKTu1slaphzXv3k5/tAddO/0hz
        lRXx6fFcvT5BQrCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B728139F5;
        Wed,  6 Apr 2022 11:09:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2t2+At50TWLMOQAAMHmgww
        (envelope-from <bp@suse.de>); Wed, 06 Apr 2022 11:09:18 +0000
Date:   Wed, 6 Apr 2022 13:09:16 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jroedel@suse.de, stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: Re: FAILED: patch "[PATCH] x86/sev: Unroll string mmio with" failed
 to apply to 5.16-stable tree
Message-ID: <Yk103F0EzAU2GkEd@zn.tnic>
References: <1649058222102139@kroah.com>
 <Ykx8XWViJCKf3nGQ@zn.tnic>
 <Yk0yBIMXQ5OCf6M1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yk0yBIMXQ5OCf6M1@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 08:24:04AM +0200, Greg KH wrote:
> make[1]: *** [scripts/Makefile.build:287: arch/x86/lib/iomem.o] Error 1

Bah, building is overrated.

I guess you need

  8260b9820f70 ("x86/sev: Use CC_ATTR attribute to generalize string I/O unroll")

before that.

> I only have one "FAILED" email template, do I need another one for when
> the patch applies yet breaks the build?

I guess you could change that first sentence to

"The patch below does not apply (or build) to the X.XX-stable tree."

It seems I took it literally to mean it only doesn't apply.

:-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
