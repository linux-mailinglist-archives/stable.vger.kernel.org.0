Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F775F7430
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 08:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJGGZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 02:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJGGZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 02:25:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDA44DF1E
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 23:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75019B82202
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 06:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C39C433D6;
        Fri,  7 Oct 2022 06:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665123939;
        bh=AtiEfHFzExDXNY8rWlauE1+rbf6bx67D2ewt7G5lR1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wfiJWv7t2/zZ06b1jwVADS8MA50DiJ/F8SNO7jE3WzhHywixbOxxYPh8eeOQ9/PRC
         mpIHguEs75XoKgst6MBOdsMfPyeYvMydUPu1L39KkG5X9b9J/w1Z6z4AVYZqR1i2FC
         xNJvx27ltw2Wm4MRxXa8mQDlXznVw7maPPfQbRn4=
Date:   Fri, 7 Oct 2022 08:26:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH stable 5.4] mm: pagewalk: Fix race between unmap and page
 walker
Message-ID: <Yz/Gi/wN/s7AqSlX@kroah.com>
References: <20221006201541.2004831-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006201541.2004831-1-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 06, 2022 at 10:15:41PM +0200, Jann Horn wrote:
> [ Upstream commit 8782fb61cc848364e1e1599d76d3c9dd58a1cc06 ]

Thanks, now queued up.

gre gk-h
