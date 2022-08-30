Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03155A6F2D
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiH3Vcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 17:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiH3Vcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 17:32:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9D189CCC;
        Tue, 30 Aug 2022 14:32:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B808421D95;
        Tue, 30 Aug 2022 21:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661895158; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3perT1+wYBFzimt6PoAuQXJOi1UiBFbwqJ4dPzW82w=;
        b=Ui5uyccbAyMenyeCJNV9CZh8INAK2XGYUdZXbl1x9FVimqaE44fHUM7skTfanB3I+UKk9Z
        OEbOrnvAM9K5ufTyvpy17Eix+jxjJP6JRCV0ltnSU34bZJ9gnV60kUt415OX0TS2THithE
        P/EgovYEzUe+XcN0QvU4dIz7Gj6u77I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661895158;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3perT1+wYBFzimt6PoAuQXJOi1UiBFbwqJ4dPzW82w=;
        b=1x1EhlhLnklmr9OfhRAa5rCd3w5b8/oP4g6kapHLbvHODvivdzeuRwixuJ+sndIHfyFELz
        Kd79p5xo+ubGd1BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8305C13ACF;
        Tue, 30 Aug 2022 21:32:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eWJjHvaBDmMUWgAAMHmgww
        (envelope-from <jdelvare@suse.de>); Tue, 30 Aug 2022 21:32:38 +0000
Date:   Tue, 30 Aug 2022 23:32:37 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 5.19 01/33] firmware: dmi: Use the proper
 accessor for the version field
Message-ID: <20220830233237.0c08cc7e@endymion.delvare>
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, 30 Aug 2022 13:17:52 -0400, Sasha Levin wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [ Upstream commit d2139dfca361a1f5bfc4d4a23455b1a409a69cd4 ]
> 
> The byte at offset 6 represents length. Don't take it and drop it
> immediately by using proper accessor, i.e. get_unaligned_be24().
> 
> [JD: Change the subject to something less frightening]

Nack. This is NOT a bug fix, there's simply no reason to backport
this to stable kernel trees.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
