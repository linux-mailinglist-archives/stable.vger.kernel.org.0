Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44B453286
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 13:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbhKPNCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:02:24 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:35560 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbhKPNCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 08:02:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 97BB11FCA1;
        Tue, 16 Nov 2021 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637067566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=USkrmAURQ8zHz1I+HBS0s1ktoikEFlGYqXjcD72lULk=;
        b=sx4CsBZ0xfs9kJj6pe1X/nrz+UnQz6hopGC6KKEdQAnHV9XNbYnOGHTT5lVLhfQjIWnmFc
        hallQ6iipzuddscRfvJw0hyUtJW9G7QP+33LlMwsufUZ27AFOF6C5iyDXMizvdw4lj0sec
        lu9U6LSV7lSmdNl2/RiQaH+e2VC1fng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637067566;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=USkrmAURQ8zHz1I+HBS0s1ktoikEFlGYqXjcD72lULk=;
        b=OgYWLzqBaZ9iqevwbplMvG8PzdARxAUgwthBHO8vfcL38Z3ZjflpRmu4pnPpI4irDi0Uy4
        n0MoSfBMRQdi4zBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 87AA913BA3;
        Tue, 16 Nov 2021 12:59:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZYeYIC6rk2GMbgAAMHmgww
        (envelope-from <bp@suse.de>); Tue, 16 Nov 2021 12:59:26 +0000
Date:   Tue, 16 Nov 2021 13:59:18 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/sev: Make the #VC exception stacks
 part of the default" failed to apply to 5.15-stable tree
Message-ID: <YZOrJoYHEnTicUii@zn.tnic>
References: <1637060086211132@kroah.com>
 <YZORuI1FLTO39Xt7@zn.tnic>
 <YZOU0ViYGD24/Al0@kroah.com>
 <YZObjPyuhsHmREd7@zn.tnic>
 <YZOpBS+oASQVB4ae@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZOpBS+oASQVB4ae@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 01:50:13PM +0100, Greg KH wrote:
> Ok, sounds good, I'll go queue them up now and see how the builds go to
> save you the trouble of backporting into SLE...

Thanks but Joerg has already backported them. :-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
