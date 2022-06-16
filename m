Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2972954E818
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 18:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiFPQuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 12:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiFPQu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 12:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030A8B8A;
        Thu, 16 Jun 2022 09:50:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A67618E2;
        Thu, 16 Jun 2022 16:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81786C34114;
        Thu, 16 Jun 2022 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655398224;
        bh=nrWEs5bX9koH2hbDBLN4Y++lqBDsc4UB8RElh/iu8KE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpi5uYBvyI4IsRvDChMBe2TAv95fBpQn/wo3zWlxbjxqEHHTG94wbMv9jtJVJsHXZ
         3o4dLOAsHm+Ll8+GNour55u1Bwd0fn592TM3jtVcEBKPnWDcA8nkqqWLQR/7C4nY2M
         wHT57L0LNBVQ/vaila5qy+abD7zYaKzJvzqMTRsM=
Date:   Thu, 16 Jun 2022 18:50:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: validate buddy page before using
Message-ID: <YqtfTavoMNxQeFlg@kroah.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <b08725b1-2f4b-cea0-43fc-1ce0a2a7e8f4@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b08725b1-2f4b-cea0-43fc-1ce0a2a7e8f4@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 12:20:19AM +0800, Xianting Tian wrote:
> Sorry, please ignore this one.

Which "one"?  This was a series :(
