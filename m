Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD80541059
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355282AbiFGTXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355509AbiFGTUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009F019B6A6;
        Tue,  7 Jun 2022 11:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6D8B61680;
        Tue,  7 Jun 2022 18:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771F0C3411C;
        Tue,  7 Jun 2022 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654625324;
        bh=TufR2JasVwmyRktAgIN8fByOEdr60ClrqBrRNzcpTAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZDuJG1X1eO28gb7CjS1trfx+vq2ihuIYi10L1pzypW2DIxl7QFeN6/qAqMh1+W6v
         0I9bKMM7q84NE+tJ4EFqCj6/dGIHdgE8D9JyVg7h5CuSqQs75+RfiqHtE2BMn8OgGN
         DzJRAmWABIT4lGTHuRQ8mPrQktsZ7OnSbsrqMjMCqK1VucQd6cUtFBrUdDK2JX2Idx
         mK7w6Waf8d+YhkWVtL8vqYNfuhqlSiRXuchqdIY1jdIfiyI55VmxmP5sdDynUFtQ06
         md9l9OwAvTBfUvQ5SWjsNhnSCCcmfDNbJH8Oq7qLF6o7Ob4Wx8VumRVlH6vB5z4crK
         3/XuKkUGhSNZA==
Date:   Tue, 7 Jun 2022 20:08:39 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     amir73il@gmail.com, gscrivan@redhat.com, hch@lst.de,
        linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] exportfs: support idmapped mounts" failed
 to apply to 5.4-stable tree
Message-ID: <20220607180839.6m2husdulgeyhf5w@wittgenstein>
References: <165451866750136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <165451866750136@kroah.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 02:31:07PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Just fyi, this doesn't need to be backported to anything prior to 5.12.

Christian
