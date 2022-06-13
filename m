Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5912A548450
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 12:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiFMJq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiFMJq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:46:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA3B13CF5
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19F6ECE10F0
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B27C34114;
        Mon, 13 Jun 2022 09:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655113582;
        bh=Lg3zxzlZE0/qghdpf8yNle8U3Db8ywDQ1oflatyLNJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UmzkRmXO81A9K7saw/1MYsXXqWvnL12JwqXnvkrkiira486jJnYvAKeIRWLkIo+pk
         P4jhzM2IBqXEkkyjDXeRjfd5zKCATcpWHG0C6uFnz5ibJ5cIz1qJQJEXmpjjPmREww
         sAKHAlO2imIDcA14sSdomsAOeqEW12i/Od/Tp23o=
Date:   Mon, 13 Jun 2022 11:46:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     hch@lst.de, johannes.thumshirn@wdc.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] zonefs: fix handling of explicit_open
 option on mount" failed to apply to 5.18-stable tree
Message-ID: <YqcHa2ncRlV6vtQN@kroah.com>
References: <165510578298165@kroah.com>
 <29a5f5c5-54a8-a77a-a3d2-2585fe411c44@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a5f5c5-54a8-a77a-a3d2-2585fe411c44@opensource.wdc.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 06:29:13PM +0900, Damien Le Moal wrote:
> On 6/13/22 16:36, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.18-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> I sent you the fixed backported patch in reply to this email. The same
> patch also applies as-is to 5.17, 5.15 and 5.10.

Thanks, now queued up.

greg k-h
