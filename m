Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D3D1AAB45
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390350AbgDOPC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 11:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390381AbgDOPC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 11:02:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A05C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 08:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Axi6AT6aCvirkJrhzoox7kD+ANJ8s9+B9vOIrooJo9Y=; b=tiV4Z5G0HDjk1Yky1AIkluLmac
        GA/pd1adSi0F1Y0wp5J56IbFw+qp+uekt6PZ0MXpuZPXhuKkWZRlZkETHZ5A8Kwk6ECdS9MzF+zTv
        HZWvUantnYEceXaBaNzwO42BOFFs9U+J2UacGrOMqXBUuRlqk3Q6DYqGJbalTuGtAZXt+tXpZxaYS
        azsp2Xhjf4M54EUrUTYA3i/wsIZPcZMFeJ2ROgm59PwAI2INa5fZm2OwpqGypAlHbwZ4c5wIHa3nq
        e5VYOaag05Pw2rfDGtG7bzaueGl42Q3kLEjROiVgupIjXSDgwRJTYyHmd0SOTG/HMFWmbmBa37nhH
        0WyFl+mg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOjYU-0006IG-KX; Wed, 15 Apr 2020 15:02:22 +0000
Date:   Wed, 15 Apr 2020 08:02:22 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     gregkh@linuxfoundation.org
Cc:     bhelgaas@google.com, keescook@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] XArray: Fix xa_find_next for large
 multi-index entries" failed to apply to 5.4-stable tree
Message-ID: <20200415150222.GD5820@bombadil.infradead.org>
References: <1586948677159164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586948677159164@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:04:37PM +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From bd40b17ca49d7d110adf456e647701ce74de2241 Mon Sep 17 00:00:00 2001

Seems like it's already there as commit
16696ee7b58101c90bf21c3ab2443c57df4af24e
