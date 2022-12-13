Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A042964ADFD
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 03:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiLMC6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 21:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiLMC6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 21:58:39 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18256140B8;
        Mon, 12 Dec 2022 18:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HpZ9jX3u4847/+62/XiO19y9qAcrk3g+ILqUmJpDZtY=; b=veZwu5/Eb8m4aS4Crkb0P1/wsj
        YwFyUxJIwfc2OqEiXDFLmJA8cFBdMJqRuNev+HB8RKnzra5xMT6eJLcEZ6eePLlqpzWZ2xsld4jal
        5fqZn1xhl9wrhVl231xMS0ycXCdwNfpPVOC93J/d9cQBUix9ODwvoOkpo4az+hEolyTZtToMVojY6
        pq0mJHfJAAfaaHdcnwMkuptqDPF3k0YGBnPBwGoK/+i6GP5BORIkaTZjCAyaidOU7IWUE6UvEz+Q/
        c81Lk0bOtzmThZITeObp4DSLwpdT+A69GP1S4aNYrv9MP+pEtDwCzEpLagcIbveKniTxAKwALLzSl
        9Spt2ozw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p4vV5-00A3qb-71; Tue, 13 Dec 2022 02:58:35 +0000
Date:   Mon, 12 Dec 2022 18:58:35 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     david@redhat.com, Petr Mladek <pmladek@suse.com>,
        prarit@redhat.com, mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y5fqW7hQy+WbTh3R@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y45MXVrGNkY/bGSl@alley>
 <d528111b-4caa-e292-59f4-4ce1eab1f27c@suse.com>
 <Y5CuCVe02W5Ni/Fc@alley>
 <Y5FPkEgEbDlVXkRK@bombadil.infradead.org>
 <0017c9ce-7e92-6010-7bc9-716131a25ec5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0017c9ce-7e92-6010-7bc9-716131a25ec5@suse.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 12:29:02PM +0100, Petr Pavlu wrote:
> On 12/8/22 03:44, Luis Chamberlain wrote:
> > On Wed, Dec 07, 2022 at 04:15:21PM +0100, Petr Mladek wrote:
> >> Reviewed-by: Petr Mladek <pmladek@suse.com>
> > 
> > Queued onto modules-next.
> 
> Thanks both.

I'm **terribly sorry** for dropping this to Linus' pull request late
but I kept trying to justify a few things and I couldn't do it, and
so I'll reply to this patch with my last minute observations soon.

I figured it was better to be safe than sorry and the potential for
yet *more* regressions was *real* and I really wanted to avoid us
having to crunch / race for a fix over the holidays.

I will leave the fix as-is now in modules-next though, so it can get
more testing, but indeed, I don't feel quite ready for the masses
specially before the holidays.

  Luis
