Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C7689420
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 10:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjBCJjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 04:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjBCJjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 04:39:15 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D272943B;
        Fri,  3 Feb 2023 01:39:12 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pNsX9-0076FK-Q1; Fri, 03 Feb 2023 17:39:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Feb 2023 17:39:03 +0800
Date:   Fri, 3 Feb 2023 17:39:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
Message-ID: <Y9zWN6CyFcoKbt8Z@gondor.apana.org.au>
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
 <Y9xduyjbaxFdaCUT@gondor.apana.org.au>
 <Y9yrZk9KnICxqkZp@gcabiddu-mobl1.ger.corp.intel.com>
 <Y9zKTHFvYHrmfqdW@gondor.apana.org.au>
 <Y9zPn9hgTjG1k9Qc@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9zPn9hgTjG1k9Qc@gcabiddu-mobl1.ger.corp.intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 09:10:55AM +0000, Giovanni Cabiddu wrote:
>
> dma_alloc_coherent() returns zero'd memory.
> When implemented originally that code used dma_zalloc_coherent(). This
> was phased out in Kernel 5.0 by 750afb08ca71.

OK thanks for digging this up.  It wasn't obvious.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
