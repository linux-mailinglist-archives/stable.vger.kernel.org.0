Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DCC56AA29
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 20:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiGGR76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235872AbiGGR75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 13:59:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA63023BFE
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 10:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98C78B8201A
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 17:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6395C341C0;
        Thu,  7 Jul 2022 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657216794;
        bh=qoAEDe2EnkuPJnKh8m0RV5KWfF4Byq3pEaJriKimIt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mj65aBEyN7+hNhTHviQfbcya7Cz9jI96H45Z6XP8epQLxPYm855AHYkoLvKDG5UFP
         7Pt1lP/ccCnAzTKKS9SRbIfl0ruQUMNEPfifgwMVgwD153RviI4yzIMMfBCV7xKXGI
         VljRDLbf+t51H2ddQWeadCjCPQu6M+uKRVF8Qtrs=
Date:   Thu, 7 Jul 2022 19:59:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>, linux-mm@kvack.org
Subject: Re: [PATCH 4.9-stable] mm/slub: add missing TID updates on slab
 deactivation
Message-ID: <YscfFzp2dLR9ApGE@kroah.com>
References: <20220707153224.24260-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707153224.24260-1-vbabka@suse.cz>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 07, 2022 at 05:32:24PM +0200, Vlastimil Babka wrote:
> From: Jann Horn <jannh@google.com>
> 
> commit eeaa345e128515135ccb864c04482180c08e3259 upstream.

All backports now queued up, thanks.

greg k-h
