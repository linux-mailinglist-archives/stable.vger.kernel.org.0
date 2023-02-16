Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C024969997B
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBPQHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBPQHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:07:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02FE4E5EC;
        Thu, 16 Feb 2023 08:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nIUA6+j7jWZlJkPMJJ4R/ia1XJ80Nye7Zx4eY9PyS5E=; b=NGwUtQYwNghVg/+5e/Q0g2zE3T
        BTH/PIxSnpsAq047BUUQ8/IZmSnUN7SRuwiwzjNOrh4iu/RhSlgyiadrauH3hVBkTLF5S2X3MzdQo
        Rh+NQ0oLj2kWdiKXJHEJ4TQI5HowIiJmRi0SeAhOvFxzf7cOrlcVudGA/UWYpVeAQTuMo96VG9UZx
        v7gH2RtvcI3A6cbJUPYW2Sk0mDJO8qP2EvTMF2IK/o8KX81Inxn/3EF6YDvAyipwxO73N+Nnld2Da
        swWAiTuEibQBpC/eMjrW9adVMdFYsY2uzgzhnErIaR7g7QGUif2iPkNjxmauidIfeoNAUE97ch1kQ
        dygAR47g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSgmn-00B41a-Jp; Thu, 16 Feb 2023 16:07:05 +0000
Date:   Thu, 16 Feb 2023 08:07:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/4] brd: only preload radix tree if we're using a
 blocking gfp mask
Message-ID: <Y+5Uqc2FxZT8W8mF@infradead.org>
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216151918.319585-4-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This should probably go into the previous patch, as that's the
one creating the warning.
