Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054114931BC
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350393AbiASASb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244782AbiASASb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:18:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB8CC061574;
        Tue, 18 Jan 2022 16:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CE2614B8;
        Wed, 19 Jan 2022 00:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7523C340E0;
        Wed, 19 Jan 2022 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642551510;
        bh=5Tf0l9OJlBOiQqmblg2h3eakocTe+K3hVsNuIhBqNYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jllIWL0W2wQPKirORuD/sk36gzXNdYkYUVI2mXkyCIOy9smwLK99vfbHEi3f02BWq
         1M5RYeBYqp7lvH1YFsfuUXly0teYfHiMQW5nYUh7I/bAiKbL/W3Jph9cLahs1OLxXE
         89gwHvEHzc17bL0ufzN6W4owSco5cvPYk6NdkD1QIwu5hDHoT8BW2/ricNd7KgqqG0
         0etF9QHnoxbc3N4bIFdW/X2TicG3yEB2Mn0pKe8wOKY66V/1D7M+Ptu9iRukbA8BaG
         R7kRSjhHCNKrPFFDPZpsi75BbIug31QzF5jzXots+ACQj3a5dm6OmB2yBBwHW67qv+
         +oiyAw8uMU4LA==
Date:   Tue, 18 Jan 2022 16:18:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ima: fix reference leak in asymmetric_verify()
Message-ID: <YedY1BCKSKXn2Dcc@sol.localdomain>
References: <20220113194438.69202-1-ebiggers@kernel.org>
 <55c5576db2bb0f8a2b9d509f4d1160911388fa41.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c5576db2bb0f8a2b9d509f4d1160911388fa41.camel@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 08:52:59PM -0500, Mimi Zohar wrote:
> Hi Eric,
> 
> On Thu, 2022-01-13 at 11:44 -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Don't leak a reference to the key if its algorithm is unknown.
> > 
> > Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
> > Cc: <stable@vger.kernel.org> # v5.13+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> 

Thanks.  You're intending to apply this patch, right?  Or are you expecting
someone else to?  get_maintainer.pl didn't associate this file with IMA, but I
see you sent out a patch to fix that
(https://lore.kernel.org/linux-integrity/20220117230229.16475-1-zohar@linux.ibm.com/T/#u).

- Eric
